import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

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
          return await api.getAll(filter);
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying to get all ${queryKey}s in CrudRepository.',
            className: runtimeType.toString(),
            methodName: 'getAllQuery',
            error: error,
            stackTrace: stackTrace,
          );
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
      mutationFn: (request) async {
        try {
          return await api.create(request);
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying to create a $T in CrudRepository.',
            className: runtimeType.toString(),
            methodName: 'createMutation',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      },
      onSuccess: (res, arg) {
        for (final getAllQuery in _cachedGetAllQueries) {
          final query = CachedQuery.instance.getQuery<Query<List<T>>>(
            getAllQuery,
          );
          if (query == null) continue;
          query.update((old) => [...old ?? [], res]);
        }
      },
      refetchQueries: [..._cachedGetAllQueries],
    );
  }

  Mutation<T, TRequest> putMutation(int id) {
    return Mutation<T, TRequest>(
      key: 'put_$queryKey/$id',
      mutationFn: (request) async {
        try {
          return await api.put(id, request);
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying to update (PUT) a $T in CrudRepository.',
            className: runtimeType.toString(),
            methodName: 'putMutation',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      },
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
      mutationFn: (request) async {
        try {
          return await api.patch(id, request);
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying update (PATCH) a $T in CrudRepository.',
            className: runtimeType.toString(),
            methodName: 'createMutation',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      },
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
      mutationFn: (_) async {
        try {
          return await api.delete(id);
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying to delete a $T in CrudRepository.',
            className: runtimeType.toString(),
            methodName: 'deleteMutation',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      },
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
