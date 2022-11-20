import 'package:flutter/material.dart';
import 'package:food/model/food.dart';

import '../data/entity/item.dart';
import 'food_list.dart';

class FoodItem extends StatefulWidget {
  FoodItem(this.item, this.order);
  OrderValueNotifierData order;
  Item item;
  @override
  State<StatefulWidget> createState() {
    return _FoodItemStae();
  }
}

class _FoodItemStae extends State<FoodItem> {
  Widget build(BuildContext context) {
    var item = widget.item;
    ThemeData themeData = Theme.of(context);
    // print('build item=>${item}');
    if (item.widget == 'text') {
      return Column(children: [
        // Text('${item["title"]}'),
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '请输入备注',
          ),
          controller: TextEditingController.fromValue(TextEditingValue(
              text:
                  '${item.content == null ? "" : item.content}', //判断keyword是否为空
              // 保持光标在最后
              selection: TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: '${item.content}'.length)))),
          onChanged: (text) {
            item.content = text;
            print("content: $text");
          },
        )
      ]);
    }
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            height: 80.0,
            child: Flex(direction: Axis.vertical, children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 50.0,
                  child: Text(item.title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 30.0,
                  // color: Colors.green,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 30.0,
                          child: Text('¥${item.price}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              )),
                          // color: Colors.yellow,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            IconButton(
                                iconSize: 28,
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (item.count >= 1) {
                                      item.count--;
                                      widget.order.notifyListeners();
                                    }
                                  });

                                  print('count ${item.count}');
                                }),
                            Text(
                              '${item.count}',
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                                iconSize: 28,
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    item.count++;
                                    widget.order.notifyListeners();
                                  });

                                  print('add item ${item.title} ${item.count}');
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
