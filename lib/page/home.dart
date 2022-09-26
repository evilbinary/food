import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/data/entity/order.dart';
import 'package:flutter_app2/widget/category.dart';
import 'package:flutter_app2/widget/food_list.dart';
import '../main.dart';
import '../widget/food_item.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/database.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.db}) : super(key: key);
  final String title;
  AppDatabase db;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    print('ee CustomButton $context');
    return ElevatedButton(
        onPressed: () {
          print("hello");
        },
        child: Text(label));
  }
}

// 返回每个隐藏的菜单项
SelectView(IconData icon, String text, String id) {
  return new PopupMenuItem<String>(
      value: id,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Icon(icon, color: Colors.blue),
          new Text(text),
        ],
      ));
}

class _MyHomePageState extends State<MyHomePage> {
  double _total = 0;
  int _count = 0;

  void _calcTotal() {
    setState(() {
      if (foodListView.order.value.length > 0) {
        _total = foodListView.order.value
            .map((e) => e['price'] * e['count'] * 1.0)
            .toList()
            .reduce((a, b) => (a + b));
        _count = foodListView.order.value
            .map((e) => e['count'])
            .toList()
            .reduce((a, b) => a + b);
      }
    });
  }

  void _settle() async {
    //print("settele ${foodListView.order}");
    var mark = foodListView.order.value.where((e) => e['widget'] == 'text');
    var goods = foodListView.order.value.where((e) => e['count'] > 0).toList();
    var printData = {
      "shopName": "萌丫炸鸡汉堡",
      "total": _total,
      "count": _count,
      "mark": mark.length <= 0 ? '' : mark.first['content'],
      "goods": goods,
      "no": 0,
    };
    if (_count > 0) {
      try {
        Order o = Order(null, _count, _total, jsonEncode(goods),
            DateTime.now().millisecondsSinceEpoch);
        this.widget.db.orderDao.add(o);
        var id = await this
            .widget
            .db
            .database
            .rawQuery('SELECT last_insert_rowid();')
            .asStream()
            .first;
        o.id = id.first.values.first;
        printData['no'] = o.id;
      } catch (ex) {
        _showToast("出错咯，$ex");
      }

      _send(printData);
    } else {
      _showToast("请先选择菜");
    }
    // foodListView.order.notifyListeners();
    // catValueNotifierData.notifyListeners();
  }

  void _clear() {
    setState(() {
      _total = 0;
      _count = 0;
      foodListView.order.value
          .forEach((e) => {e['count'] = 0, e['content'] = ''});
      catValueNotifierData.notifyListeners();
      // foodListView = FoodListView(catValueNotifierData, orderValueNotifierData);
    });
  }

  void _send(val) async {
    String reply = await basicChannel.send(jsonEncode(val));
    print('ret=>$reply');
    if (reply == "打印成功") {
      _clear();
    }
    _showToast(reply);
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  CatValueNotifierData catValueNotifierData = CatValueNotifierData(1);
  OrderValueNotifierData orderValueNotifierData = OrderValueNotifierData([]);

  FoodListView foodListView = null;
  CategoryListView categoryListView = null;

  static const nativeChannel =
      const MethodChannel('org.evilbinary.flutter/native');
  static const basicChannel = BasicMessageChannel<String>(
      'org.evilbinary.flutter/message', StringCodec());

  @override
  void initState() {
    super.initState();
  }

  // 返回每个隐藏的菜单项
  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        ));
  }

  void showPrint() async {
    var activity = 'net.printer.print.PrintActivity';
    await nativeChannel.invokeMethod('startActivity', activity);
  }

  Future<String> onMessage(String message) {
    print("onMessage=>$message");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyHomePageState build ");
    basicChannel.setMessageHandler(onMessage);
    orderValueNotifierData.addListener(() {
      _calcTotal();
    });
    if (foodListView == null) {
      foodListView = FoodListView(catValueNotifierData, orderValueNotifierData);
    }
    if (categoryListView == null) {
      categoryListView = CategoryListView(catValueNotifierData);
    }
    catValueNotifierData.notifyListeners();

    ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          // leading: Builder(
          //   builder: (BuildContext context) {
          //     return IconButton(
          //       icon: const Icon(Icons.settings),
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          //     );
          //   },
          // ),
          actions: <Widget>[
            //导航栏右侧菜单
            // IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            // 隐藏的菜单
            new PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                this.SelectView(Icons.settings, '打印设置', 'print'),
                this.SelectView(Icons.category, '添加分类', 'cat'),
                this.SelectView(Icons.menu_book, '设置菜名', 'menu'),
              ],
              onSelected: (String action) {
                // 点击选项的时候
                switch (action) {
                  case 'print':
                    showPrint();
                    break;
                  case 'cat':
                    break;
                  case 'menu':
                    break;
                }
              },
            ),
          ],
        ),
        body: Container(
            margin: EdgeInsets.only(bottom: 48),
            child: Row(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ConstrainedBox(
                    child: categoryListView,
                    constraints: BoxConstraints(
                      minWidth: 90,
                      maxWidth: 100,
                    ),
                  ),
                  Expanded(child: foodListView),
                ])),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Container(
          color: Colors.black54,
          // padding: EdgeInsets.only(bottom: 0),
          // alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
            left: 0,
            right: 0,
            bottom: 0,
          ),
          child: Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  flex: 2,
                  child: new GestureDetector(
                      onTap: () {
                        showDialog<Null>(
                          context: context,
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                              title: new Text('已选菜共${_count}份'),
                              children: _buildOrderPreview(),
                            );
                          },
                        ).then((val) {
                          print(val);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text('合计：$_count 件',
                            style: TextStyle(
                                fontSize: 20, color: themeData.buttonColor)),
                      ))),
              Expanded(
                  flex: 0,
                  child: Text(
                    '¥$_total  ',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  )),
              Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: TextButton(
                        onPressed: _settle,
                        child: Text("结算",
                            style: TextStyle(
                              color: themeData.primaryColor,
                              fontSize: 20.0,
                            )))),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildOrderPreview() {
    return foodListView.order.value
        .where((e) => e['count'] > 0 || e['widget'] == 'text')
        .map((e) {
      if (e['widget'] == 'text') {
        return new SimpleDialogOption(child: Text("备注:${e['content']}"));
      }
      return new SimpleDialogOption(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: Text('${e['title']}'),
            ),
            Expanded(child: Text(' ${e['count']}份')),
            Expanded(child: Text(' ${e['price'] * e['count']}元'))
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }).toList();
  }
}
