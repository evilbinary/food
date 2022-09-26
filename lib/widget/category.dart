import 'package:flutter/material.dart';
// 引入 mock 数据
import '../mock/food.dart' as food;
import 'food_list.dart';

class CategoryListViewSate extends State<CategoryListView> {
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

  _buildItem(item) {
    return ListTile(
      title: Text(
        item['name'],
      ),
      // selected: ,
      onTap: () {
        print("item=$item");
        widget.cat.value = item['id'];
        widget.cat.notifyListeners();
        setState(() {
          selectedCat = item['id'];
        });
        print("selectCat=$selectedCat");
      },
      selected: item['id'] == selectedCat,
    );
  }
}

class CategoryListView extends StatefulWidget {
  CategoryListView(cat) {
    this.cat = cat;
  }
  CatValueNotifierData cat;

  @override
  State<StatefulWidget> createState() {
    return CategoryListViewSate();
  }
}
