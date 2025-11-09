import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';

abstract class CrudRepository<T, TRequest, PatchedRequest, FindAllOptions> {
  CrudApi<T, TRequest, PatchedRequest, FindAllOptions> get api;

  String get queryKey;

  int extractId(T item);

  Future<void> initialize() async {
    getAllQuery.fetch();
  }

  Query<List<T>> get getAllQuery =>
      Query<List<T>>(key: queryKey, queryFn: () => api.getAll());

  Mutation<T, TRequest> get createMutation {
    return Mutation<T, TRequest>(
      mutationFn: api.create,
      refetchQueries: [queryKey],
    );
  }

  Mutation<T, (int, TRequest)> get updateMutation {
    return Mutation<T, (int, TRequest)>(
      mutationFn: (args) => api.put(args.$1, args.$2),
      onSuccess: (res, arg) async {
        final query = CachedQuery.instance.getQuery<Query<List<T>>>(queryKey);
        if (query == null) return;
        query.update(
          (old) =>
              old
                  ?.map((e) => extractId(e) == extractId(res) ? res : e)
                  .toList() ??
              [],
        );
      },
      invalidateQueries: [queryKey],
    );
  }

  Mutation<int, int> get deleteMutation {
    return Mutation<int, int>(
      mutationFn: api.delete,
      onSuccess: (res, arg) {
        final query = CachedQuery.instance.getQuery<Query<List<T>>>(queryKey);
        if (query == null) return;
        query.update((old) {
          return old?.where((e) => extractId(e) != res).toList() ?? [];
        });
      },
      invalidateQueries: [queryKey],
    );
  }
}
