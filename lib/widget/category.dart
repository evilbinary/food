import 'package:flutter/material.dart';
import 'package:food/model/food.dart';
// 引入 mock 数据
import '../data/entity/category.dart';
import 'food_list.dart';

class CategoryListViewSate extends State<CategoryListView> {
  CategoryListViewSate(this.catSelect);
  CatSelectValueNotifierData catSelect;
  int selectedCat = 1;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: _getCategoryList());
  }

  @override
  void initState() {
    widget.cat.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  List<Widget> _getCategoryList() {
    List<Widget> cats = widget.cat.value.map<Widget>((item) {
      // return CategoryItem(item);
      return _buildItem(item);
    }).toList();
    return cats;
  }

  _buildItem(Category item) {
    return ListTile(
      title: Text(
        item.name,
      ),
      // selected: ,
      onTap: () {
        print("selectCat=${item.id}");

        catSelect.value=item.id!;
        catSelect.notifyListeners();
        setState(() {
          selectedCat = item.id!;
        });
      },
      selected: item.id == selectedCat,
    );
  }
}

class CategoryListView extends StatefulWidget {
  CategoryListView(this.cat,this.catSelect);

  CatValueNotifierData cat;
  CatSelectValueNotifierData catSelect;

  @override
  State<StatefulWidget> createState() {
    return CategoryListViewSate(catSelect);
  }
}
