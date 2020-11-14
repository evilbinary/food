import 'package:floor/floor.dart';
import '../entity/order.dart';

@dao
abstract class OrderDao {
  OrderDao();

  @Query('SELECT * FROM Order')
  Future<List<Order>> findAll();

  @Query('SELECT * FROM Order WHERE id = :id')
  Stream<Order> findById(int id);

  @insert
  Future<void> add(Order order);

}