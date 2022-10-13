import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'package:flutter/services.dart' show rootBundle;

class FoodMenu {
  FoodMenu({this.category, this.list});
  List<Item> list;
  List<CategoryItem> category;
  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemJsonArray = json["list"].toList();
    List<dynamic> categoryItemJsonArray = json["category"].toList();
    List<Item> items = [];
    List<CategoryItem> categoryItems = [];
    for (var e in itemJsonArray) {
      var item = Item.fromJson(e);
      items.add(item);
    }
    for (var e in categoryItemJsonArray) {
      var c = CategoryItem.fromJson(e);
      categoryItems.add(c);
    }
    return FoodMenu(list: items, category: categoryItems);
  }
  Map toJson() {
    return {"list": list, "category": category};
  }
}

class Item {
  Item(
      {this.title, this.price, this.catId, this.id, this.widget, this.content});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json["id"] as int,
        price: json["price"].toDouble(),
        catId: json["catId"] as int,
        title: json["title"] as String,
        content: json["content"] != null ? json["content"] : "",
        widget: json["widget"] != null ? json["widget"] : "");
  }
  Map toJson() {
    return {
      "id": id,
      "widget": widget == null ? "" : widget,
      "title": title,
      "price": price,
      "catId": catId,
      "content": content == null ? "" : content
    };
  }

  String title;
  double price;
  int catId;
  int id;
  String widget;
  String content;
}

class CategoryItem {
  CategoryItem({this.name, this.id});
  factory CategoryItem.fromJson(Map<String, dynamic> e) {
    return CategoryItem(id: e["id"] as int, name: e["name"] as String);
  }
  Map toJson() {
    return {"name": name, "id": id};
  }

  String name;
  int id;
}

Future<FoodMenu> loadFood(XFile xFile) async {
  String content = await xFile.readAsString();
  FoodMenu f = FoodMenu.fromJson(jsonDecode(content));
  return f;
}

void saveFood(FoodMenu menu) async {
  String content = jsonEncode(menu);
  File f = new File("${Platform.environment['HOME']}/.config/food/config.json");
  var writer = f.openWrite();
  writer.write(content);
  await writer.close();
}

Future<FoodMenu> getFood() async {
  try {
    XFile file =
        XFile("${Platform.environment['HOME']}/.config/food/config.json");
    FoodMenu menu = await loadFood(file);
    return menu;
  } catch (e) {
    String content = await rootBundle.loadString('assets/images/food.json');
    return FoodMenu.fromJson(jsonDecode(content));
  }
}

class OrderFood extends Item {
  OrderFood({id, title, this.count, price, widget, content})
      : super(
            id: id,
            title: title,
            price: price,
            widget: widget,
            content: content);

  int count;
}

class FoodValueNotifierData extends ValueNotifier<FoodMenu> {
  FoodValueNotifierData(value) : super(value);
  reload(FoodMenu menu) {
    value = menu;
  }

  addCategory(String name) {
    List<int> ids = value.category.map((e) => e.id).toList();
    int n = 0;
    // 找到一个能用的 ID
    for (; true; n++) {
      if (ids.indexOf(n) < 0) {
        break;
      }
    }
    value.category.add(CategoryItem(id: n, name: name));
  }

  removeCategory(id) {
    value.category =
        value.category.where((element) => element.id != id).toList();
  }

  updateCategory(int id, String cat) {
    for (var i = 0; i < value.category.length; i++) {
      if (id == value.category[i].id) {
        value.category[i].name = cat;
        break;
      }
    }
  }

  removeFood(int id) {
    value.list = value.list.where((element) => element.id != id).toList();
  }

  addFood(String title, int catID, double price) {
    List<int> ids = value.list.map((e) => e.id).toList();
    int n = 0;
    // 找到一个能用的 ID
    for (; true; n++) {
      if (ids.indexOf(n) < 0) {
        break;
      }
    }
    value.list.add(Item(title: title, price: price, catId: catID, id: n));
  }

  updateFood(Item food) {
    for (var i = 0; i < value.list.length; i++) {
      if (value.list[i].id == food.id) {
        value.list[i] = food;
      }
    }
  }

  int findFoodCatID(Item food) {
    if (food == null) {
      return null;
    }
    for (var i = 0; i < value.list.length; i++) {
      if (food.id == value.list[i].id) {
        return value.list[i].catId;
      }
    }
    return null;
  }
}
