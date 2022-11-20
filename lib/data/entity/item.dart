import 'package:floor/floor.dart';

@entity
class Item {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String title;
  int catId;
  double price;
  int count;
  int createTime;
  String widget;
  String content;

  Item(this.title, this.catId, this.price,
      {this.count = 0,
      this.id,
      this.widget = '',
      this.content = '',
      this.createTime = 0});

  factory Item.fromJson(Map<String, dynamic> obj) {
    return Item(
        obj['title'] as String,
        obj['catId'] as int,
        obj['price'].toDouble(),
        count: obj['count']!= null? obj['count']:0,
        id: obj['id'],
        widget: obj['widget']!=null ? obj['widget'] : '');
  }

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "catId": catId,
      "count": count,
      "content": content
    };
  }
}
