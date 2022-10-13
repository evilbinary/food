import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/model/food.dart';
import 'food_item.dart';
// 引入 mock 数据

class CatValueNotifierData extends ValueNotifier<int> {
  CatValueNotifierData(value) : super(value);
}

class OrderValueNotifierData extends ValueNotifier<List<OrderFood>> {
  OrderValueNotifierData(value) : super(value);
}

class FoodListView extends StatefulWidget {
  FoodListView(this.cat, this.order, this.food);
  CatValueNotifierData cat;
  OrderValueNotifierData order;
  FoodValueNotifierData food;

  List<Item> foods = [];

  List getFoodList(value) {
    if (value == null) {
      value = 1;
    }
    List foods = food.value.list.where((e) => e.catId == value).toList();
    return foods;
  }

  List<Widget> _buildFoodList() {
    return foods.map((item) {
      var foodFind = order.value.where((element) => element.id == item.id);
      OrderFood food;
      if (foodFind.isEmpty) {
        food = OrderFood(
            title: item.title,
            id: item.id,
            count: 0,
            price: item.price,
            widget: "",
            content: "");

        order.value.add(food);
      } else {
        food = foodFind.first;
      }
      // print("order ==>$order");
      return FoodItem(food, order);
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
    print("_FoodListViewState build");
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: widget._buildFoodList(),
    );
  }

  _handleValueChanged() {
    setState(() {
      widget.foods = widget.getFoodList(widget.cat.value);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.cat.addListener(_handleValueChanged);
    widget.food.addListener(_handleValueChanged);
  }

  @override
  dispose() {
    widget.cat.removeListener(_handleValueChanged);
    widget.food.removeListener(_handleValueChanged);
    super.dispose();
  }
}
