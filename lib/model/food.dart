import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../data/entity/category.dart';
import '../data/entity/item.dart';

class FoodMenu {
  FoodMenu({required this.category, required this.list});
  List<Item> list;
  List<Category> category;
  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemJsonArray = json["list"].toList();
    List<dynamic> categoryItemJsonArray = json["category"].toList();
    List<Item> items = [];
    List<Category> categoryItems = [];
    for (var e in itemJsonArray) {
      var item = Item.fromJson(e);
      items.add(item);
    }
    for (var e in categoryItemJsonArray) {
      var c = Category.fromJson(e);
      categoryItems.add(c);
    }
    return FoodMenu(list: items, category: categoryItems);

  }
  Map toJson() {
    return {"list": list, "category": category};
  }




}

Future<FoodMenu> loadFood(XFile xFile) async {
  String content = await xFile.readAsString();
  FoodMenu f = FoodMenu.fromJson(jsonDecode(content));
  return f;
}

Future<Directory?> getPath() async {
  Directory? path=await getExternalStorageDirectory();
  return path;
}

void saveFood(FoodMenu menu) async {
  String content = jsonEncode(menu);
  Directory? path=await getPath();
  File f = new File("${path?.path}/food.json");
  var writer = f.openWrite();
  writer.write(content);
  await writer.close();
}

Future<FoodMenu> getFood() async {
  try {
    Directory? path=await getPath();
    XFile file =
        XFile("${path?.path}/food.json");
    FoodMenu menu = await loadFood(file);
    return menu;
  } catch (e) {
    String content = await rootBundle.loadString('assets/images/food.json');
    return FoodMenu.fromJson(jsonDecode(content));
  }
}
