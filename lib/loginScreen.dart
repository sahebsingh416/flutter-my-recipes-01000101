import 'package:flutter/material.dart';

void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Text(
                  'LOG IN',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Text(
              'Good to see you again',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
