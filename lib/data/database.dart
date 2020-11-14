// required package imports
//flutter packages pub run build_runner watch ./ -v
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/order_dao.dart';
import 'entity/order.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Order])
abstract class AppDatabase extends FloorDatabase {
  OrderDao get orderDao;
}