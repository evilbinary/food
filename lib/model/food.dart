import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import "dart:io";
import '../mock/food.dart' as defaultFood;

class Food {
  Food({this.category, this.list});
  List<FoodItem> list;
  List<CategoryItem> category;
}

class FoodItem {
  FoodItem({this.title, this.price, this.catId, this.id});
  String title;
  double price;
  int catId;
  int id;
}

class CategoryItem {
  CategoryItem({this.name, this.id});
  String name;
  int id;
}

Future<Food> loadFood(XFile xFile) async {
  String content = await xFile.readAsString();
  Food f = null;
  f = jsonDecode(content);
  return f;
}

SaveFood(Food food) async {
  String content = jsonEncode(food);
  File f = new File('/tmp/config.json');
  var writer = f.openWrite();
  writer.write(content);
  await writer.close();
}

Future<Food> getFood() async {
  try {
    XFile file = XFile("/tmp/config.json");
    Food food = await loadFood(file);
    return food;
  } catch (e) {
    return Food(category: defaultFood.category, list: defaultFood.list);
  }
}
