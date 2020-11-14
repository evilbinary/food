import 'package:flutter/cupertino.dart';
import 'food_item.dart';
// 引入 mock 数据
import '../mock/food.dart' as food;


class CatValueNotifierData extends ValueNotifier<int> {
  CatValueNotifierData(value) : super(value);
}

class OrderValueNotifierData extends ValueNotifier<List> {
  OrderValueNotifierData(value) : super(value);
}

class FoodListView extends StatefulWidget {
  FoodListView(this.cat,this.order);
  CatValueNotifierData cat;
  OrderValueNotifierData order;

  List foods=[];

  List getFoodList(value){
    if(value==null){
      value=1;
    }
    List foods=food.list.where((e) => e['catId']==value).toList();
    return foods;
  }

  List<Widget> _buildFoodList() {
    return foods.map((item) {
      var foodFind=order.value.where((element) => element['id']==item['id']);
      var food=null;
      if(foodFind.isEmpty) {
        food = {
          "id": item['id'],
          "count": 0,
          "title": item['title'],
          "price": item['price'],
          "widget": item['widget'],
          "content": item['content'],
        };
        order.value.add(food);
      }else{
        food=foodFind.first;
      }
      // print("order ==>$order");
      return FoodItem(food,order);
    }).toList();
  }
  @override
  State<StatefulWidget> createState() {
    return _FoodListViewState();
  }

}

class _FoodListViewState extends State<FoodListView> {
  _FoodListViewState();

  @override
  Widget build(BuildContext context) {
    widget.cat.addListener(_handleValueChanged);
    print("_FoodListViewState build");
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: widget._buildFoodList(),
    );
  }

  _handleValueChanged() {
    print("_FoodListViewState _handleValueChanged ${widget.cat.value}");
    setState(() {
      widget.foods=widget.getFoodList(widget.cat.value);
    });
  }

  @override
  dispose() {
    widget.cat.removeListener(_handleValueChanged);
    super.dispose();
  }

}