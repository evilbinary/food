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
    int catId;
    if (food != null) {
      _foodNameController.text = food.title;
      _foodPriceController.text = food.price.toString();
      catId = food.catId;
    }
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('编辑菜品'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _foodNameController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return "菜名不能为空";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: '请输入菜名',
                        prefix: Padding(
                          child: Text('菜名'),
                          padding: EdgeInsets.only(right: 10),
                        )),
                  ),
                  TextFormField(
                    controller: _foodPriceController,
                    validator: (value) {
                      if (double.tryParse(value) == null) {
                        return '请输入合法的数字';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: '请输入价格',
                        prefix: Padding(
                          child: Text('价格'),
                          padding: EdgeInsets.only(right: 10),
                        )),
                  ),
                  DropdownButtonFormField(
                      validator: ((value) {
                        if (value == null) {
                          return '必须选择一个菜品分类';
                        }
                        return null;
                      }),
                      value: widget.foodWatcher.findFoodCatID(food),
                      items: widget.foodWatcher.value.category
                          .map((e) => DropdownMenuItem(
                                child: Text(e.name),
                                value: e.id,
                              ))
                          .toList(),
                      onChanged: (v) {
                        catId = v;
                      })
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (!formKey.currentState.validate()) {
                      return;
                    }
                    // 添加新菜
                    if (food == null || food.id == null) {
                      widget.foodWatcher.addFood(_foodNameController.text,
                          catId, double.tryParse(_foodPriceController.text));
                    } else {
                      // 更新菜品配置
                      food.catId = catId;
                      food.price = double.tryParse(_foodPriceController.text);
                      food.title = _foodNameController.text;
                      widget.foodWatcher.updateFood(food);
                    }
                    setState(() {
                      Navigator.of(context).pop();
                    });
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
            onPressed: () async {
              saveFood(widget.foodWatcher.value);
              widget.foodWatcher.value = await getFood();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('保存成功')));
            },
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
                editFood(context, food);
              },
              trailing: IconButton(
                onPressed: () async {
                  setState(() {
                    widget.foodWatcher.removeFood(food.id);
                  });
                },
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
    TextEditingController priceController = TextEditingController(
        text: widget.food.price != null ? widget.food.price.toString() : "");
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
