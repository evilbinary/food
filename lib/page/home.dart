import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/data/entity/order.dart';
import 'package:food/model/food.dart';
import 'package:food/page/cat_editor.dart';
import 'package:food/page/food_editor.dart';
import 'package:food/widget/category.dart';
import 'package:food/widget/food_list.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/database.dart';
import 'package:file_picker/file_picker.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.db, @required this.food})
      : super(key: key);
  final String title;
  AppDatabase db;
  FoodValueNotifierData food;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _total = 0;
  int _count = 0;

  void _calcTotal() {
    setState(() {
      if (foodListView.order.value.length > 0) {
        _total = foodListView.order.value
            .map((e) => e.price * e.count * 1.0)
            .toList()
            .reduce((a, b) => (a + b));
        _count = foodListView.order.value
            .map((e) => e.count)
            .toList()
            .reduce((a, b) => a + b);
      }
    });
  }

  void _settle() async {
    //print("settele ${foodListView.order}");
    var mark = foodListView.order.value.where((e) => e.widget == 'text');
    var goods = foodListView.order.value.where((e) => e.count > 0).toList();
    var printData = {
      "shopName": "萌丫炸鸡汉堡",
      "total": _total,
      "count": _count,
      "mark": mark.length <= 0 ? '' : mark.first.content,
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
      foodListView.order.value.forEach((e) => {e.count = 0, e.content = ''});
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
  OrderValueNotifierData orderValueNotifierData =
      OrderValueNotifierData(<OrderFood>[]);

  FoodListView foodListView;
  CategoryListView categoryListView;

  static const nativeChannel =
      const MethodChannel('org.evilbinary.flutter/native');
  static const basicChannel = BasicMessageChannel<String>(
      'org.evilbinary.flutter/message', StringCodec());

  // 返回每个隐藏的菜单项
  selectView(IconData icon, String text, String id) {
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

  void refresh() {
    setState(() {
      foodListView = FoodListView(
          catValueNotifierData, orderValueNotifierData, widget.food);
      categoryListView = CategoryListView(catValueNotifierData, widget.food);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("_MyHomePageState build ");
    basicChannel.setMessageHandler(onMessage);
    orderValueNotifierData.addListener(() {
      _calcTotal();
    });
    if (foodListView == null) {
      foodListView = FoodListView(
          catValueNotifierData, orderValueNotifierData, widget.food);
    }
    if (categoryListView == null) {
      categoryListView = CategoryListView(catValueNotifierData, widget.food);
    }
    catValueNotifierData.notifyListeners();
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            //导航栏右侧菜单
            // IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            // 隐藏的菜单
            new PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                this.selectView(Icons.settings, '打印设置', 'print'),
                this.selectView(Icons.category, '编辑菜品', 'cat'),
                this.selectView(Icons.menu_book, '编辑分类', 'menu'),
                this.selectView(Icons.import_export, '导入菜单', 'import'),
                this.selectView(Icons.import_export, '导出菜单', 'export'),
              ],
              onSelected: (String action) {
                // 点击选项的时候
                switch (action) {
                  case 'print':
                    showPrint();
                    break;
                  case 'cat':
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                              builder: (context) => FoodEditor(
                                    foodWatcher: widget.food,
                                  )),
                        )
                        .then((value) => {refresh()});
                    break;
                  case 'menu':
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                              builder: (context) => CategoryEditor(
                                    foodWatcher: widget.food,
                                  )),
                        )
                        .then((value) => {refresh()});

                    break;
                  case 'import':
                    showImport(context);
                    break;
                  case 'export':
                    showExport(context);
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
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                              title: new Text('已选菜共${_count}份'),
                              children: _buildOrderPreview(),
                            );
                          },
                        ).then((val) {});
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
        .where((e) => e.count > 0 || e.widget == 'text')
        .map((e) {
      if (e.widget == 'text') {
        return new SimpleDialogOption(child: Text("备注:${e.content}"));
      }
      return new SimpleDialogOption(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: Text('${e.title}'),
            ),
            Expanded(child: Text(' ${e.count}份')),
            Expanded(child: Text(' ${e.price * e.count}元'))
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }).toList();
  }

  showImport(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
    );
    PlatformFile file = result.files.first;
    String path = file.path;
    XFile xf = XFile("${path}");
    // XTypeGroup group = XTypeGroup(label: "json", extensions: <String>['json']);
    // XFile xf = await openFile(acceptedTypeGroups: <XTypeGroup>[group]);
    // if (xf == null) {
    //   return;
    // }
    try {
      FoodMenu food = await loadFood(xf);
      // 更新菜品
      widget.food.reload(food);
    } catch (e) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(title: Text('导入失败，请检查配置文件'));
          });
      return;
    }
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: Text('导入成功'));
        });
  }

  showExport(BuildContext context) async {
    String path=null;
    // if (Platform.isAndroid || Platform.isIOS)) {
      // use file_picker plugin
      String result = await FilePicker.platform.getDirectoryPath();
      if(result != null) {
        path=result;
      } else {
        // User canceled the picker
      }

    // }else{
    //   XTypeGroup group = XTypeGroup(label: "json", extensions: <String>['json']);
    //   path = await getSavePath(acceptedTypeGroups: <XTypeGroup>[group]);
    // }

    String content = jsonEncode(widget.food.value);
    File file = File("${path}/菜单.json");
    var writer = file.openWrite();
    writer.write(content);
    await writer.close();
    // file.writeAsString(content);
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: Text('导出成功'));
        });
  }
}
