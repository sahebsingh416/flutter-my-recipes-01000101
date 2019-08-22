import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/loginScreen.dart';
import './recipe.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Login(),
        '/recipes': (context) => Recipe(),
      },
      initialRoute: '/recipes',
    );
  }
}
      