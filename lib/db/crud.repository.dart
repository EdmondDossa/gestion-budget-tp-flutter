abstract class CrudRepository<T> {
  Future<List<T>> findAll();
  Future<List<T>> findAllDeleted();
  Future<T?> findById(String id);
  Future<int> create(T item);
  Future<int> update(T item);
  Future<int> delete(T item);
  Future<int> softDelete(T item);
  Future<int> restore(T item);
}
