import 'package:flutter/material.dart';
import 'package:food/model/food.dart';

import '../data/entity/category.dart';
import '../data/entity/item.dart';
import '../widget/food_list.dart';

class FoodMenuEditor extends StatefulWidget {
  FoodMenuEditor({required Key key, required this.catWatcher}) : super(key: key);
  CatValueNotifierData catWatcher;

  @override
  State<FoodMenuEditor> createState() => _FoodMenuEditorState();
}

class _FoodMenuEditorState extends State<FoodMenuEditor> {
  @override
  void initState() {
    super.initState();
    widget.catWatcher.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<FoodMenuCatCard> cats = widget.catWatcher.value
        .map((e) => FoodMenuCatCard(item: e, catWatcher: widget.catWatcher))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('菜单编辑'),
      ),
      body: ListView(
        children: cats,
      ),
    );
  }
}

class FoodMenuCatCard extends StatefulWidget {
  const FoodMenuCatCard({required this.item, required this.catWatcher});
  final Category item;
  final CatValueNotifierData catWatcher;
  @override
  State<StatefulWidget> createState() {
    return _FoodMenuCatCardState();
  }
}

class _FoodMenuCatCardState extends State<FoodMenuCatCard> {
  @override
  Widget build(BuildContext context) {
    // List<Item> foods =
    //     filterFoodByCatID(widget.item.id, widget.catWatcher.value);
    // foods = foods != null ? foods : [];
    // List<Widget> foodsForm = foods.map((e) => FoodForm(e)).toList();

    List<Widget> foodsForm=[];
    return Column(
      children: [
        Text(
          widget.item.name,
          style: TextStyle(
              backgroundColor: Colors.blue, color: Colors.white, fontSize: 30),
        ),
        ListView(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          children: foodsForm,
        )
      ],
    );
  }
}

List<Item> filterFoodByCatID(int id, FoodMenu menu) {
  return menu.list.where((element) => element.catId == id).toList();
}

class FoodForm extends StatefulWidget {
  FoodForm(this.food);
  Item food;
  @override
  State<StatefulWidget> createState() {
    return _FoodFormState();
  }
}

class _FoodFormState extends State<FoodForm> {
  @override
  Widget build(BuildContext context) {
    GlobalKey _key = GlobalKey<FormState>();
    TextEditingController _nameController =
        TextEditingController(text: widget.food.title);
    TextEditingController _priceController =
        TextEditingController(text: widget.food.price.toString());
    return Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.only(left: 13, right: 13),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  focusNode: FocusNode(),
                  controller: _nameController,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  focusNode: FocusNode(),
                  controller: _priceController,
                ),
              ),
            ],
          ),
        ));
  }
}
