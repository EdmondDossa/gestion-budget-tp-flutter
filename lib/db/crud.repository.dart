abstract class CrudRepository<K, T> {
  Future<List<T>> getAll();
  Future<T?> getById(K id);
  Future<void> create(T item);
  Future<void> update(K id, T item);
  Future<void> delete(K id);
  Future<void> deleteAll();
  Future<void> save(T item);
}
