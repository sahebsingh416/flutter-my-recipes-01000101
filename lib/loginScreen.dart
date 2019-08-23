import 'package:flutter/material.dart';
// import './recipe.dart';
import './showdialog.dart';
import './recipedetails.dart';

void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _isValidate = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  
   void _checkFields(){
    if (emailController.text.length == 0 || passwordController.text.length == 0){
      _isValidate = false;
      showDialog(
        context: context,
        builder: (BuildContext context){
          return ShowDialog("Invalid Authentication", "Please enter information in required fields");
        }
      );
    }else{
      _isValidate = true;
    }
  }

  void _onLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return RecipeDetails();
    }));
  }

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  margin: EdgeInsets.only(left: 16,right: 16),
                  alignment: Alignment(0.0, 0.2),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment(0.0, 0.1),
                        child: TextField(
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
                        alignment: Alignment(0.0, 0.6),
                        child: RaisedButton(
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.orange,
                          onPressed: (){
                            _checkFields();
                            if (_isValidate == true) {
                              _onLogin();
                            }                            
                          },
                        ),
                      )
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
