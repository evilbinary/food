import 'package:flutter/material.dart';
import 'package:flutter_app2/model/food.dart';

class FoodEditor extends StatefulWidget {
  FoodEditor({Key key, this.foodWatcher}) : super(key: key);
  final FoodValueNotifierData foodWatcher;
  @override
  State<FoodEditor> createState() => _FoodEditorState();
}

class _FoodEditorState extends State<FoodEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑菜品'),
        actions: [IconButton(onPressed: () {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(title: Text('edit'),content: _FoodEditor(Item()));
          });
        }, icon: Icon(Icons.add))],
      ),
      body: createFoodViews(),
      bottomNavigationBar: Container(
        color: Colors.black54,
        height: 35,
        child: TextButton(
            onPressed: () {},
            child: Text(
              '保存',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
      ),
    );
  }

  ListView createFoodViews() {
    List<ListTile> list = [];
    for (var cat in widget.foodWatcher.value.category) {
      for (var food in widget.foodWatcher.value.list) {
        if (food.catId == cat.id) {
          ListTile tile = ListTile(
              leading: CircleAvatar(child: Text(cat.name[0])),
              title: Text("${food.title}(¥${food.price})"),
              onTap: () {
                showDialog<Item>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('edit'), content: _FoodEditor(food));
                    });
              },
              trailing: IconButton(
                onPressed: () async {},
                icon: Icon(Icons.delete),
                iconSize: 30,
              ));
          list.add(tile);
        }
      }
    }
    return ListView(children: list);
  }
}

class _FoodEditor extends StatefulWidget {
  _FoodEditor(this.food);
  Item food;
  @override
  State<StatefulWidget> createState() {
    return __FoodEditorState();
  }
}

class __FoodEditorState extends State<_FoodEditor> {
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController =
        TextEditingController(text: widget.food.price != null ? widget.food.price.toString() : "");
    TextEditingController nameController =
        TextEditingController(text: widget.food.title);

    return Form(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(controller: priceController),
        TextFormField(
          controller: nameController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(onPressed: () {}, child: Text('yes')),
            TextButton(onPressed: () {}, child: Text('no'))
          ],
        )
      ],
    ));
  }
}
