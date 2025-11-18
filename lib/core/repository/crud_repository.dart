import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';

abstract class CrudRepository<T, TRequest, TPatchedRequest, FindAllOptions> {
  CrudApi<T, TRequest, TPatchedRequest, FindAllOptions> get api;

  String get queryKey;
  final Set<String> _cachedGetAllQueries = {};

  int extractId(T item);
  String? variableHash(FindAllOptions? options);

  Query<T?> getByIdQuery(int id) {
    final queryKey = '${this.queryKey}/$id';
    return Query<T?>(key: queryKey, queryFn: () => api.get(id));
  }

  Query<List<T>> getAllQuery({FindAllOptions? filter, String? overrideKey}) {
    final variables = variableHash(filter);
    final queryKey =
        overrideKey ??
        (variables == null ? this.queryKey : '${this.queryKey}/$variables');
    return Query<List<T>>(
      key: queryKey,
      queryFn: () => api.getAll(filter),
      onSuccess: (_) {
        _cachedGetAllQueries.add(queryKey);
      },
    );
  }

  Mutation<T, TRequest> get createMutation {
    return Mutation<T, TRequest>(
      mutationFn: api.create,
      onSuccess: (res, arg) {
        final query = CachedQuery.instance.getQuery<Query<List<T>>>(queryKey);
        if (query == null) return;
        query.update((old) => [res, ...?old]);
      },
      invalidateQueries: [..._cachedGetAllQueries],
    );
  }

  Mutation<T, (int, TRequest)> get putMutation {
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
      invalidateQueries: [..._cachedGetAllQueries],
    );
  }

  Mutation<T, (int, TPatchedRequest)> get patchMutation {
    return Mutation<T, (int, TPatchedRequest)>(
      mutationFn: (args) => api.patch(args.$1, args.$2),
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
      invalidateQueries: [..._cachedGetAllQueries],
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
      invalidateQueries: [..._cachedGetAllQueries],
    );
  }
}
