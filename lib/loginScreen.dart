import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/profile.dart';
import './recipe.dart';
import './showdialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
// import './profile.dart';
void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _apiCalled = false;
  var fullname;
  var email;
  final store = LocalStorage('recipes');
  bool _isValidate = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  void _checkFields() {
    if (emailController.text.length == 0 ||
        passwordController.text.length == 0) {
      _isValidate = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ShowDialog("Invalid Authentication",
                "Please enter information in required fields");
          });
    } else if (emailController.text.contains('@') == false) {
      _isValidate = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ShowDialog(
                "Invalid Email", "Please enter a valid email address");
          });
    } else {
      _isValidate = true;
    }
  }

  void _onLogin() async {
    setState(() {
      _apiCalled = true;
    });
    final login = await http
        .post("http://35.160.197.175:3006/api/v1/user/login", body: {
      "email": emailController.text,
      "password": passwordController.text
    });
    if (login.statusCode == 400) {
      setState(() {
        _apiCalled = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ShowDialog("Invalid User",
                "The user has not signed up yet. Please sign up before logging in.");
          });
    } else {
      final loginJSON = jsonDecode(login.body);
      fullname = loginJSON["firstName"]+" "+loginJSON["lastName"];
      email = loginJSON["email"];
      store.setItem('fullName', fullname);
      store.setItem('email', email);
      final token = loginJSON["token"];
      store.setItem('userToken', token);
      //var jsonResponse;
      // final res2 = await http.get(
      //     "http://35.160.197.175:3006/api/v1/recipe/1/ingredients",
      //     headers: {HttpHeaders.authorizationHeader: token});
      // jsonResponse = jsonDecode(res2.body);
      // store.setItem('ingredientsJSON', jsonResponse);
      // final res3 = await http.get(
      //     "http://35.160.197.175:3006/api/v1/recipe/1/instructions",
      //     headers: {HttpHeaders.authorizationHeader: token});
      // jsonResponse = jsonDecode(res3.body);
      // store.setItem('instructionsJSON', jsonResponse);
      try {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return Recipe();
      }));}
      catch(Exception){}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange, accentColor: Colors.orange),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Container(
            child: Card(
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment(0.0, -0.75),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment(0.0, -0.62),
                  child: Text(
                    'Good to see you again',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                    alignment: Alignment(0.0, -0.4),
                    child: Image.asset("images/logo.png")),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment(0.0, 0.2),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment(0.0, 0.1),
                        child: TextField(
                          cursorColor: Colors.orange,
                          decoration: InputDecoration(
                            hintText: "Email Address*",
                            border: OutlineInputBorder(),
                          ),
                          controller: emailController,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        alignment: Alignment(0.0, 0.35),
                        child: TextField(
                          cursorColor: Colors.orange,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password*",
                            border: OutlineInputBorder(),
                          ),
                          controller: passwordController,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        alignment: Alignment(0.0, 0.6),
                        child: ButtonTheme(
                          minWidth: double.maxFinite,
                          height: 44,
                          child: RaisedButton(
                              color: Colors.orange,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                _checkFields();
                                if (_isValidate == true) {
                                  _onLogin();
                                }
                              }),
                        ),
                      ),
                      Container(
                        alignment: Alignment(0.0, 0.85),
                        child: _apiCalled == true
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
