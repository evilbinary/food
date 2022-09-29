import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app2/model/food.dart';

class FoodMenuEditor extends StatefulWidget {
  FoodMenuEditor({Key key, this.foodWatcher}) : super(key: key);
  FoodValueNotifierData foodWatcher;

  @override
  State<FoodMenuEditor> createState() => _FoodMenuEditorState();
}

class _FoodMenuEditorState extends State<FoodMenuEditor> {
  @override
  void initState() {
    super.initState();
    widget.foodWatcher.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<FoodMenuCatCard> cats = widget.foodWatcher.value.category
        .map((e) => FoodMenuCatCard(item: e, foodWatcher: widget.foodWatcher))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('菜单编辑'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: cats,
      ),
    );
  }
}

class FoodMenuCatCard extends StatefulWidget {
  const FoodMenuCatCard({this.item, this.foodWatcher});
  final CategoryItem item;
  final FoodValueNotifierData foodWatcher;
  @override
  State<StatefulWidget> createState() {
    return _FoodMenuCatCardState();
  }
}

class _FoodMenuCatCardState extends State<FoodMenuCatCard> {
  @override
  Widget build(BuildContext context) {
    List<Item> foods =
        filterFoodByCatID(widget.item.id, widget.foodWatcher.value);
    foods = foods != null ? foods : [];
    List<Widget> foodsForm = foods.map((e) => FoodForm(e)).toList();

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
