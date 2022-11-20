// required package imports
//flutter packages pub run build_runner watch ./ -v
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:food/data/dao/category_dao.dart';
import 'package:food/data/dao/item_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/order_dao.dart';
import 'entity/category.dart';
import 'entity/item.dart';
import 'entity/order.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Order,Category,Item])
abstract class AppDatabase extends FloorDatabase {
  OrderDao get orderDao;
  CategoryDao get categoryDao;
  ItemDao get itemDao;
}