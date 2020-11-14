import 'package:floor/floor.dart';

@entity
class Order {
  @PrimaryKey(autoGenerate: true)
  int id;
  final int count;
  final double total;

  Order(this.id,this.count,this.total);
}
