import 'package:floor/floor.dart';
import '../entity/category.dart';

@dao
abstract class CategoryDao {
  CategoryDao();

  @Query('SELECT * FROM Category')
  Future<List<Category>> findAll();

  @Query('SELECT * FROM Category WHERE id = :id')
  Stream<Category?> findById(int id);

  @insert
  Future<int> add(Category cat);

  @insert
  Future<List<int>> adds(List<Category> cats );

  @update
  Future<int> save(Category cat);

  @update
  Future<int> saves(List<Category> cats);


  @delete
  Future<int> remove(Category cat);
}