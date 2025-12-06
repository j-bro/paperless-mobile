import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';

abstract class CrudRepository<T, TRequest, TPatchedRequest, FindAllOptions> {
  CrudApi<T, TRequest, TPatchedRequest, FindAllOptions> get api;

  CrudRepository() {
    getAllQuery().fetch();
  }

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
      queryFn: () async {
        try {
          final data = await api.getAll(filter);
          return data;
        } catch (e) {
          rethrow;
        }
      },
      onSuccess: (_) {
        _cachedGetAllQueries.add(queryKey);
      },
    );
  }

  Mutation<T, TRequest> get createMutation {
    return Mutation<T, TRequest>(
      mutationFn: api.create,
      onSuccess: (res, arg) {
        for (final getAllQuery in _cachedGetAllQueries) {
          final query = CachedQuery.instance.getQuery<Query<List<T>>>(
            getAllQuery,
          );
          if (query == null) continue;
          query.update((old) => [...old ?? [], res]);
        }
      },
    );
  }

  Mutation<T, TRequest> putMutation(int id) {
    return Mutation<T, TRequest>(
      key: 'put_$queryKey/$id',
      mutationFn: (request) => api.put(id, request),
      onSuccess: (res, arg) async {
        for (final getAllQuery in _cachedGetAllQueries) {
          final query = CachedQuery.instance.getQuery<Query<List<T>>>(
            getAllQuery,
          );
          if (query == null) continue;
          query.update(
            (old) =>
                old
                    ?.map((e) => extractId(e) == extractId(res) ? res : e)
                    .toList() ??
                [],
          );
        }
      },
    );
  }

  Mutation<T, TPatchedRequest> patchMutation(int id) {
    return Mutation<T, TPatchedRequest>(
      key: 'patch_$queryKey/$id',
      mutationFn: (request) => api.patch(id, request),
      onSuccess: (res, arg) async {
        for (final getAllQuery in _cachedGetAllQueries) {
          final query = CachedQuery.instance.getQuery<Query<List<T>>>(
            getAllQuery,
          );
          if (query == null) continue;
          query.update(
            (old) =>
                old
                    ?.map((e) => extractId(e) == extractId(res) ? res : e)
                    .toList() ??
                [],
          );
        }
      },
    );
  }

  Mutation<int, void> deleteMutation(int id) {
    return Mutation<int, void>(
      key: 'delete_$queryKey/$id',
      mutationFn: (_) => api.delete(id),
      onSuccess: (res, arg) {
        for (final getAllQuery in _cachedGetAllQueries) {
          final query = CachedQuery.instance.getQuery<Query<List<T>>>(
            getAllQuery,
          );
          if (query == null) continue;
          query.update(
            (old) => old?.where((e) => extractId(e) != res).toList() ?? [],
          );
        }
      },
    );
  }
}
