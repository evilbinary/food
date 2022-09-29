import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app2/model/food.dart';

class CategoryEditor extends StatefulWidget {
  const CategoryEditor({Key key, this.foodWatcher}) : super(key: key);

  final FoodValueNotifierData foodWatcher;
  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑分类'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
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
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                    iconSize: 30,
                  )))
              .toList()),
    );
  }
}
