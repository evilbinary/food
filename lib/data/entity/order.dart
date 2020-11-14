import 'package:floor/floor.dart';

@entity
class Order {
  @PrimaryKey(autoGenerate: true)
  int id;
  final int count;
  final double total;
  final String goods;
  final int createTime;

  Order(this.id,this.count,this.total,this.goods,this.createTime);
}
