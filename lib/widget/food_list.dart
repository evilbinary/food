import 'package:flutter/cupertino.dart';
import 'package:food/data/database.dart';
import 'package:food/data/entity/item.dart';
import 'package:food/data/entity/order.dart';
import 'package:food/model/food.dart';
import '../data/entity/category.dart';
import '../main.dart';
import 'food_item.dart';
// 引入 mock 数据

class CatSelectValueNotifierData extends ValueNotifier<int> {
  CatSelectValueNotifierData(value) : super(value);
}

class CatValueNotifierData extends ValueNotifier<List<Category>> {
  CatValueNotifierData(value) : super(value);

  addCategory(String name) async {
    Category cat = Category(name);
    // int id=await appDb.categoryDao.save(cat);
    // cat.id=id;
    // value.add(cat);
    // notifyListeners();
    List<int?> ids = value.map((e) => e.id).toList();
    int n = 0;
    // 找到一个能用的 ID
    for (; true; n++) {
      if (ids.indexOf(n) < 0) {
        break;
      }
    }
    // cat.id = n;
    value.add(cat);
  }

  removeCategory(id) async {
    value = value.where((element) => element.id != id).toList();
  }

  updateCategory(int id, String name) async {
    for (var i = 0; i < value.length; i++) {
      if (id == value[i].id) {
        value[i].name = name;
        break;
      }
    }
  }

  saveAll() async {
    for (var cat in value) {
      if (cat.id == 0 ||cat.id==null) {
        cat.id = await appDb.categoryDao.add(cat);
      } else {
        await appDb.categoryDao.save(cat);
      }
    }

    value = await appDb.categoryDao.findAll();
    notifyListeners();
  }
}

class OrderValueNotifierData extends ValueNotifier<List<Order>> {
  OrderValueNotifierData(value) : super(value);
}

class FoodValueNotifierData extends ValueNotifier<List<Item>> {
  FoodValueNotifierData(value) : super(value);
  reload(List<Item> items) {
    value = items;
  }

  removeFood(int id) {
    value = value.where((element) => element.id != id).toList();
  }

  addFood(String title, int catID, double price) {
    List<int> ids = value.map((e) => e.id!).toList();
    int n = 0;
    // 找到一个能用的 ID
    for (; true; n++) {
      if (ids.indexOf(n) < 0) {
        break;
      }
    }
    value.add(Item(title, catID, price, count: 0));
  }

  updateFood(Item food) {
    for (var i = 0; i < value.length; i++) {
      if (value[i].id == food.id) {
        value[i] = food;
      }
    }
  }

  int? findFoodCatID(Item food) {
    if (food == null) {
      return null;
    }
    for (var i = 0; i < value.length; i++) {
      if (food.id == value[i].id) {
        return value[i].catId;
      }
    }
    return null;
  }

  saveAll() async {
    for (var item in value) {
      if (item.id == 0 ||item.id==null) {
        item.id = await appDb.itemDao.add(item);
      } else {
        var ret=await appDb.itemDao.findById(item.id!);
        await appDb.itemDao.save(item);
      }
    }
    value = await appDb.itemDao.findAll();
    notifyListeners();
  }
}

class FoodListView extends StatefulWidget {
  FoodListView(this.catSelect, this.order, this.food);
  CatSelectValueNotifierData catSelect;
  OrderValueNotifierData order;
  FoodValueNotifierData food;

  List<Item> foods = [];

  List<Item> getFoodList(value) {
    if (value == null) {
      value = 1;
    }
    List<Item> foods = food.value.where((e) => e.catId == value).toList();
    return foods;
  }

  List<Widget> _buildFoodList() {
    return foods.map((item) {
      return FoodItem(item, order);
    }).toList();
  }

  @override
  State<StatefulWidget> createState() {
    return _FoodListViewState();
  }
}

class _FoodListViewState extends State<FoodListView> {
  _FoodListViewState();

  @override
  Widget build(BuildContext context) {
    print("_FoodListViewState build");
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: widget._buildFoodList(),
    );
  }

  _handleValueChanged() {
    setState(() {
      widget.foods = widget.getFoodList(widget.catSelect.value);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.catSelect.addListener(_handleValueChanged);
    widget.food.addListener(_handleValueChanged);
  }

  @override
  dispose() {
    widget.catSelect.removeListener(_handleValueChanged);
    widget.food.removeListener(_handleValueChanged);
    super.dispose();
  }
}
