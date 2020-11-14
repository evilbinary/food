import 'dart:io';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'data/database.dart';
import 'page/login.dart';
import 'page/home.dart';
import 'package:path/path.dart';

Future<AppDatabase> buildDataBase() async{

    Directory appDocDir = await getExternalStorageDirectory();
    var databasesPath = appDocDir.path;
    var path = join('databasesPath', 'food2.db');

    // create migration
    final migration1to2 = Migration(1, 2, (database) async {
      // await database.execute('DROP TABLE IF EXISTS Order;');
      await database.execute('ALTER TABLE Order ADD COLUMN goods TEXT');
      await database.execute('ALTER TABLE Order ADD COLUMN createTime INTEGER');
    });
    AppDatabase database = await $FloorAppDatabase.databaseBuilder(path).addMigrations([migration1to2])
        .build();
  return database;
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var db=await buildDataBase();
  runApp(MyApp(db));
}

class MyApp extends StatelessWidget {
  AppDatabase db;
  MyApp(db){
    this.db=db;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '点餐',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: <String, WidgetBuilder>{
          "login": (context) => LoginPage(),
          // "themes": (context) => ThemeChangeRoute(),
          // "language": (context) => LanguageRoute(),
        },
        home: MyHomePage(title: '点餐',db:db),
    );
  }
}





