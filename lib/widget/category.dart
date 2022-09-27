import 'package:flutter/material.dart';
import 'package:flutter_app2/model/food.dart';
// 引入 mock 数据
import 'food_list.dart';

class CategoryListViewSate extends State<CategoryListView> {
  CategoryListViewSate(this.food);
  Food food;
  int selectedCat = 1;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: _getCategoryList());
  }

  List<Widget> _getCategoryList() {
    List<Widget> cats = food.category.map<Widget>((item) {
      // return CategoryItem(item);
      return _buildItem(item);
    }).toList();
    return cats;
  }

  _buildItem(CategoryItem item) {
    return ListTile(
      title: Text(
        item.name,
      ),
      // selected: ,
      onTap: () {
        print("item=$item");
        widget.cat.value = item.id;
        widget.cat.notifyListeners();
        setState(() {
          selectedCat = item.id;
        });
        print("selectCat=$selectedCat");
      },
      selected: item.id == selectedCat,
    );
  }
}

class CategoryListView extends StatefulWidget {
  CategoryListView(cat, food) {
    this.cat = cat;
    this.food = food;
  }
  CatValueNotifierData cat;
  Food food;

  @override
  State<StatefulWidget> createState() {
    return CategoryListViewSate(food);
  }
}
