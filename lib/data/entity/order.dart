import 'package:floor/floor.dart';

@entity
class Order {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String title;
  int count;
  double total;
  String goods;
  int createTime;
  String content;

  Order(this.title,this.count,this.total,this.goods,{this.content='',this.createTime=0 });
}
