import 'package:floor/floor.dart';

@entity
class Category {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String name;
  int createTime;

  Category(this.name,{this.id,this.createTime=0});


  factory Category.fromJson(Map<String, dynamic> obj) {
    var cat= Category(obj['name']);
    cat.id=obj['id'] as int;
    cat.createTime =new DateTime.now().millisecondsSinceEpoch;
    return cat;
  }

  Map toJson() {
    return {
      "id": id,
      "title": name,
    };
  }

}