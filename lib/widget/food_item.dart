import 'package:flutter/material.dart';

import 'food_list.dart';

class FoodItem extends StatefulWidget {
  FoodItem(this.item,this.order);
  OrderValueNotifierData order;
  var item;
  @override
  State<StatefulWidget> createState() {
    return _FoodItemStae();
  }
}

class _FoodItemStae extends State<FoodItem>{
  int count;
  Widget build(BuildContext context) {
    count=widget.item['count'];
    var item=widget.item;
    ThemeData themeData = Theme.of(context);
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Image.asset(
            "assets/images/food.png",
            fit: BoxFit.cover,
            width: 120,
            height: 120,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 120.0,
            child: Flex(direction: Axis.vertical, children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 30.0,
                  child: Text(item['title'],
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
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
                          child: Text('¥${item["price"]}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              )),
                          // color: Colors.yellow,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            IconButton(
                                iconSize: 28,
                                icon: Icon(Icons.remove),
                                onPressed: (){
                                  setState(() {
                                    if(count>=1) {
                                      count--;
                                      item["count"]--;
                                      widget.order.notifyListeners();
                                    }
                                  });

                                  print('count ${item["count"]}');
                                }),
                            Text('${item["count"]}',style: TextStyle(fontSize: 18),),
                            IconButton(
                                iconSize: 28,
                                icon: Icon(Icons.add),
                                onPressed: (){
                                  setState(() {
                                      count++;
                                      item["count"]++;
                                      widget.order.notifyListeners();
                                  });

                                  print('count ${item["count"]}');
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

