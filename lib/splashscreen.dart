import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/recipe.dart';
import 'dart:async';
import './loginScreen.dart';
import './profile.dart';
import 'package:localstorage/localstorage.dart';
import './tabbar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final store = LocalStorage("recipes");
  var _userLoggedIn;
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    _userLoggedIn = store.getItem('isLoggedIn');
    print(_userLoggedIn);
  }
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () =>
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return  Tabbar();
            })));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Card(
              margin: EdgeInsets.all(0),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "images/splash.jpg",
                    fit: BoxFit.fitHeight,
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ),
                  Container(
                      alignment: Alignment(0.0, 0.0),
                      child: Text(
                        "Flavr",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 55,
                            fontWeight: FontWeight.w600),
                      )),
                  Container(
                      alignment: Alignment(0.0, 0.15),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                      )),
                ],
              )),
        ),
      ),
    );
  }
}
