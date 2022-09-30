import 'package:flutter/material.dart';
import 'package:flutter_app2/model/food.dart';

class CategoryEditor extends StatefulWidget {
  const CategoryEditor({Key key, this.foodWatcher}) : super(key: key);

  final FoodValueNotifierData foodWatcher;
  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  addCategory(BuildContext context) async {
    GlobalKey _key = GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController();

    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('添加分类'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: '请输入类型'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: Text('类型不能为空'),
                            );
                          });
                    }
                    setState(() {
                      Navigator.of(context).pop(_controller.text);
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

  confirmRemoveCat(BuildContext context, String name) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text("是否删除$name"), actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(true);
                });
              },
              child: Text('确认'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(false);
                });
              },
              child: Text('取消'),
            )
          ]);
        });
  }

  @override
  void initState() {
    super.initState();
    widget.foodWatcher.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑分类'),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                String cat = await addCategory(context);
                if (cat?.length > 0) {
                  setState(() {
                    widget.foodWatcher.addCategory(cat);
                  });
                }
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView(
          children: widget.foodWatcher.value.category
              .map((e) => ListTile(
                  leading: CircleAvatar(child: Text(e.name[0])),
                  title: Text(
                    e.name,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      bool remove = await confirmRemoveCat(context, e.name);
                      if (remove) {
                        print("删除 ${e.name}");
                        widget.foodWatcher.removeCategory(e.id);
                      }
                      ;
                    },
                    icon: Icon(Icons.delete),
                    iconSize: 30,
                  )))
              .toList()),
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
}
