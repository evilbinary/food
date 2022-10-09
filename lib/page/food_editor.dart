import 'package:flutter/material.dart';
import 'package:flutter_app2/model/food.dart';

class FoodEditor extends StatefulWidget {
  FoodEditor({Key key, this.foodWatcher}) : super(key: key);
  final FoodValueNotifierData foodWatcher;
  @override
  State<FoodEditor> createState() => _FoodEditorState();
}

class _FoodEditorState extends State<FoodEditor> {
  editFood(BuildContext context, Item food) async {
    TextEditingController _foodNameController = TextEditingController();
    TextEditingController _foodPriceController = TextEditingController();

    if (food != null) {
      _foodNameController.text = food.title;
      _foodPriceController.text = food.price.toString();
    }
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('编辑菜品'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _foodNameController,
                  decoration: InputDecoration(hintText: '请输入菜名'),
                ),
                TextField(
                  controller: _foodPriceController,
                  decoration: InputDecoration(hintText: '请输入价格'),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (_foodNameController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: Text('菜不能为空'),
                            );
                          });
                    }
                  },
                  child: Text('确认')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('取消'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑菜品'),
        actions: [
          IconButton(
              onPressed: () {
                editFood(context, null);
              },
              icon: Icon(Icons.add))
        ],
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
                print('---');
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
