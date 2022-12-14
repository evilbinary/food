import 'package:flutter/material.dart';
import 'package:food/model/food.dart';
import '../widget/food_list.dart';

class CategoryEditor extends StatefulWidget {
  CategoryEditor(this.catWatcher);

  CatValueNotifierData catWatcher;
  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  editCategory(BuildContext context, String cat) async {
    TextEditingController _controller = TextEditingController();
    if (cat != null) {
      _controller.text = cat;
    }
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('编辑分类'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑分类'),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                String cat = await editCategory(context, '');
                if (cat.length > 0) {
                  setState(() {
                    widget.catWatcher.addCategory(cat);
                  });
                }
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView(
          children: widget.catWatcher.value
              .map((e) => ListTile(
                  leading: CircleAvatar(child: Text(e.name[0])),
                  title: Text(
                    e.name,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  onTap: () async {
                    String cat = await editCategory(context, e.name);
                    if (cat != null && cat.length > 0) {
                      setState(() {
                        widget.catWatcher.updateCategory(e.id!, cat);
                      });
                    }
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      bool remove = await confirmRemoveCat(context, e.name);
                      if (remove) {
                        widget.catWatcher.removeCategory(e.id);
                      }
                    },
                    icon: Icon(Icons.delete),
                    iconSize: 30,
                  )))
              .toList()),
      bottomNavigationBar: Container(
        color: Colors.black54,
        height: 35,
        child: TextButton(
            onPressed: () async {
              widget.catWatcher.saveAll();
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
}
