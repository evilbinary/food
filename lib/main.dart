import 'dart:io';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:food/model/food.dart';
import 'package:path_provider/path_provider.dart';
import 'data/database.dart';
import 'data/entity/category.dart';
import 'page/home.dart';
import 'package:path/path.dart';

Future<AppDatabase> buildDataBase() async {
  Directory? appDocDir;
  if (Platform.isAndroid) {
    appDocDir = await getExternalStorageDirectory();
  } else {
    // for linux
    appDocDir = await Directory("${Platform.environment['HOME']}/.config/food/")
        .create(recursive: true);
  }
  var databasesPath = appDocDir?.path;
  var path = join(databasesPath!, 'food4.db');
  print("db path ${path}");
  // create migration
  final migration1to2 = Migration(1, 2, (database) async {
    // await database.execute('DROP TABLE IF EXISTS Order;');
    await database.execute('ALTER TABLE Order ADD COLUMN goods TEXT');
    await database.execute('ALTER TABLE Order ADD COLUMN createTime INTEGER');
  });
  AppDatabase database = await $FloorAppDatabase
      .databaseBuilder(path)
      .addMigrations([migration1to2]).build();
  return database;
}

Future<int> loadDefault(AppDatabase db) async{
  List<Category> cats=await db.categoryDao.findAll();
  if(cats.length<=0) {
    print("init cat food data");
    FoodMenu foodMenu = await getFood();
    print("foodMenu.category $foodMenu.category");
    db.categoryDao.adds(foodMenu.category);
    db.itemDao.adds(foodMenu.list);
    return Future.value(foodMenu.list.length);
  }
  return Future.value(0);
}

late AppDatabase appDb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appDb = await buildDataBase();
  int count=await loadDefault(appDb);
  runApp(MyApp(appDb));
}

class MyApp extends StatelessWidget  {
  late AppDatabase db;
  MyApp(this.db);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '点餐',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        // "themes": (context) => ThemeChangeRoute(),
        // "language": (context) => LanguageRoute(),
      },
      home: MyHomePage(
         '点餐',db
      ),
    );
  }
}
