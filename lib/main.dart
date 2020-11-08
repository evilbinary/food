import 'package:flutter/material.dart';
import 'page/login.dart';
import 'page/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        home: MyHomePage(title: '点餐'),
    );
  }
}





