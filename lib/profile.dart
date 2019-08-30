import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import './loginScreen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  var _bioController = TextEditingController();
  final store = LocalStorage('recipes');
  var _fullName;
  var _email;
  List moods = [0, 0, 0, 0, 0];
  Future _getImageFromGallery() async {
    File picture = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 250,
        maxWidth: double.maxFinite);
    setState(() {
      _image = picture;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _fullName = store.getItem('fullName');
      _email = store.getItem('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.orange, primaryColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
                height: 280,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.orange[800],
                      Colors.orange[400],
                      Colors.yellow[600],
                      Colors.yellow[400],
                    ],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        new Positioned(
                          child: Container(
                            margin: EdgeInsets.only(top: 45),
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: _image == null
                                    ? AssetImage("images/food.jpg")
                                    : FileImage(_image),
                              ),
                            ),
                          ),
                        ),
                        new Positioned(
                          top: 155,
                          left: 110,
                          child: Container(
                            alignment: Alignment(0.0, 0.5),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: IconButton(
                              icon: Icon(
                                Icons.camera,
                                color: Colors.orange,
                              ),
                              onPressed: _getImageFromGallery,
                            )),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text(
                          _fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.blue,
                                offset: Offset(5.0, 5.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              height: 45,
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: Stack(
                children: <Widget>[
                  new Positioned(
                    top: 15,
                    child: Text(
                      "Email:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  new Positioned(
                    left: 60,
                    top: 15,
                    child: Text(_email,style: TextStyle(fontSize: 16),),
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: Stack(
                children: <Widget>[
                  new Positioned(
                    top: 18,
                    child: Text(
                      "Bio:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ),
                  new Positioned(
                    left: 60,
                    top: 0,
                    child: Container(
                      width: 250,
                      child: TextField(
                            cursorColor: Colors.orange,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            maxLength: 160,
                            decoration: InputDecoration(
                                hintText: "Whats on your mind?",
                                border: OutlineInputBorder()),
                            controller: _bioController,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
