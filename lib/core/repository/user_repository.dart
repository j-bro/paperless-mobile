import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/generated/lib/src/model/user.dart';
import 'package:paperless_api/paperless_api.dart';

class UserRepository {
  final PaperlessUserApi _userApi;

  UserRepository(this._userApi);

  Future<void> initialize() async {
    findAll().fetch();
  }

  Query<List<User>> findAll() {
    return Query<List<User>>(key: 'users', queryFn: _userApi.getAll);
  }
}
