import 'package:flutter/material.dart';
import 'package:flutter_app2/widget/category.dart';
import 'package:flutter_app2/widget/food_list.dart';
import '../widget/food_item.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

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

class _MyHomePageState extends State<MyHomePage> {
  double _total = 0;
  int _count=0;
  void _calcTotal() {
    setState(() {
      if(foodListView.order.value.length>0) {
        _total = foodListView.order.value.map((e) => e['price'] * e['count'])
            .toList()
            .reduce((a, b) => a + b);
        _count = foodListView.order.value.map((e) =>  e['count'])
            .toList()
            .reduce((a, b) => a + b);
      }
    });
  }
  void _settle(){
    print("settele ${foodListView.order}");
  }

  CatValueNotifierData catValueNotifierData = CatValueNotifierData(1);
  OrderValueNotifierData orderValueNotifierData = OrderValueNotifierData([]);

  FoodListView foodListView =null;
  CategoryListView categoryListView=null;

  @override
  void initState() {
    // catValueNotifierData.notifyListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyHomePageState build ");
    orderValueNotifierData.addListener(() {
      _calcTotal();
    });
    if(foodListView==null) {
      foodListView = FoodListView(catValueNotifierData, orderValueNotifierData);
    }
    if(categoryListView==null){
      categoryListView=CategoryListView(catValueNotifierData);
    }
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
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
            ],
          ),
        ),
        floatingActionButton: Container(
          color: Colors.black54,
          // decoration: ,
          margin: EdgeInsets.only(left: 0,right: 0,bottom: 0),
          child: Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text('       合计：$_count 件', style: TextStyle(fontSize: 20, color: themeData.buttonColor)),
              ),
              Expanded(
                  flex: 0,
                  child: Text(
                    '¥$_total  ',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  )),
              Expanded(
                  flex: 0,
                  child: FlatButton(
                      color: themeData.primaryColor,
                      textColor: themeData.buttonColor,
                      onPressed: _settle,
                      child: Text("结算"))),
            ],
          ),
        ));
  }
}
