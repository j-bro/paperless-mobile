abstract class CrudApi<T, TRequest, TPatchedRequest, TGetOptions> {
  Future<T> create(TRequest item);
  Future<T?> get(int id, {bool? fullPerms});
  Future<List<T>> getAll([TGetOptions? options]);
  Future<T> put(int id, TRequest item);
  Future<T> patch(int id, TPatchedRequest item);
  Future<int> delete(int id);
}
