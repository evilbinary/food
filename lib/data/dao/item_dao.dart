import 'package:floor/floor.dart';
import '../entity/item.dart';

@dao
abstract class ItemDao {
  ItemDao();

  @Query('SELECT * FROM Item')
  Future<List<Item>> findAll();

  @Query('SELECT * FROM Item WHERE id = :id')
  Stream<Item?> findById(int id);

  @insert
  Future<void> add(Item item);

  @insert
  Future<void> adds(List<Item> items);

  @update
  Future<int> save(Item item);


  @delete
  Future<int> remove(Item item);

  @update
  Future<int> saves(List<Item> items);

}