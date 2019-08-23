import 'package:flutter/material.dart';
import 'dart:async';
import './loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () =>
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return Login();
            })));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      alignment: Alignment(0.0, -0.6),
                      child: Text(
                        "Flavr",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 55,
                            fontWeight: FontWeight.w600),
                      )),
                  Container(
                      alignment: Alignment(0.0, 0.8),
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