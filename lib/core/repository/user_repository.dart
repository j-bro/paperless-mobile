import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';

class UserRepository {
  final PaperlessUserApi _userApi;

  UserRepository(this._userApi);

  Query<List<User>> getAllQuery([UserFilterOptions? options]) {
    final normalizedOptions = options?.copyWith(page: 1).toJson();
    final queryString = Uri(queryParameters: normalizedOptions).toString();
    final queryKey = normalizedOptions == null ? 'users' : 'users/$queryString';
    return Query<List<User>>(
      key: queryKey,
      queryFn: () => _userApi.getAll(options),
    );
  }

  Query<User?> getByIdQuery(int id) {
    final queryKey = 'user/$id';
    return Query<User?>(key: queryKey, queryFn: () => _userApi.get(id));
  }
}
