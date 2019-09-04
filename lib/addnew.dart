import 'package:flutter/material.dart';
import './tabbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:io';
import './showdialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewRecipe extends StatefulWidget {
  @override
  _AddNewRecipeState createState() => _AddNewRecipeState();
}

class _AddNewRecipeState extends State<AddNewRecipe> {
  final store = LocalStorage('recipes');
  var _recipeNameController = TextEditingController();
  var _recipeDurationController = TextEditingController();
  var _recipeServesController = TextEditingController();
  var _ingredientName = TextEditingController();
  var _ingredientQuant = TextEditingController();
  var _instructionController = TextEditingController();
  String _dropDownType;
  String _dropDownComplexity;
  bool _isValid = false;
  File _image;
  List _recipeIngredients = [];
  List _instructionSteps = [];

  void _addIngredient() {
    setState(() {
      var _ingredient = _ingredientName.text + " - " + _ingredientQuant.text;
      _ingredientName.clear();
      _ingredientQuant.clear();
      _recipeIngredients.add(_ingredient);
    });
  }

  void _addInstruction() {
    setState(() {
      print(_instructionController.text);
      _instructionSteps.add(_instructionController.text);
      _instructionController.clear();
    });
  }

  void _addRecipe() {
    Navigator.pop(context);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    //             return Tabbar();          
    //           }));
  }

  void _checkFields() {
    if (_recipeNameController.text.length == 0 ||
        _recipeDurationController.text.length == 0 ||
        _recipeServesController.text.length == 0) {
      _isValid = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ShowDialog("Missing Required Fields",
                "Please enter information in required fields");
          });
    } else {
      _isValid = true;
    }
  }

  void _submitRecipe() async {
    print(_dropDownComplexity);
    final token = store.getItem('userToken');
    final req = await http
        .post("http://35.160.197.175:3006/api/v1/recipe/add", headers: {
      HttpHeaders.authorizationHeader: token
    }, body: {
      "name": _recipeNameController.text,
      "preparationTime": _recipeDurationController.text + " Min",
      "serves": _recipeServesController.text,
      "complexity": _dropDownComplexity,
    });
    var statusCode = req.statusCode;
    print(statusCode);
    var addResponse = jsonDecode(req.body);
    print(addResponse);
    // final res1 = await http.get(
    //     "http://35.160.197.175:3006/api/v1/recipe/feeds",
    //     headers: {HttpHeaders.authorizationHeader: token});
    // var jsonResponse = jsonDecode(res1.body);
    // print(jsonResponse);
    // store.setItem('recipeJSON', jsonResponse);
    final req1 = await http.post(
        "http://35.160.197.175:3006/api/v1/recipe/add-update-recipe-photo",
        headers: {
          HttpHeaders.authorizationHeader: token
        },
        body: {
          "photo": base64Encode(_image.readAsBytesSync()),
          "recipeId": addResponse["id"].toString(),
        });
    print(req1.statusCode);
    _addRecipe();
  }

  Future _getImageFromGallery() async {
    File picture = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 250,
        maxWidth: double.maxFinite);
    setState(() {
      _image = picture;
      print(_image);
      print(picture.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:
            ThemeData(accentColor: Colors.orange, primaryColor: Colors.orange),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // backgroundColor: Colors.grey,
          appBar: AppBar(
            actions: <Widget>[
              FlatButton(
                child: Icon(Icons.cancel),
                onPressed: _addRecipe,
              )
            ],
            title: Text(
              "Add New Recipe",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment(-0.95, 0.0),
                            margin: EdgeInsets.only(left: 5, top: 15),
                            child: Text(
                              "Description",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange,
                              ),
                            )),
                        Container(
                          width: double.maxFinite,
                          //margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                          constraints: BoxConstraints.tightForFinite(),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Select Type*"),
                                  value: _dropDownType,
                                  iconSize: 30,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconDisabledColor: Colors.grey,
                                  iconEnabledColor: Colors.orange,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _dropDownType = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Soup',
                                    'Pasta',
                                    'Dal',
                                    'Rice',
                                    'Noodles',
                                    'Salad'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          //margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: TextField(
                            cursorColor: Colors.orange,
                            controller: _recipeNameController,
                            decoration: InputDecoration(
                                hintText: "Recipe Name*",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          //margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: TextField(
                            cursorColor: Colors.orange,
                            keyboardType: TextInputType.number,
                            controller: _recipeDurationController,
                            decoration: InputDecoration(
                                hintText: "Duration in Minutes*",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          //margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          constraints: BoxConstraints.tightForFinite(),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Select Complexity*"),
                                  value: _dropDownComplexity,
                                  iconSize: 30,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconDisabledColor: Colors.grey,
                                  iconEnabledColor: Colors.orange,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _dropDownComplexity = newValue;
                                    });
                                  },
                                  items: <String>['Easy', 'Medium', 'Hard']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          //TextField(
                          //   cursorColor: Colors.orange,
                          //   controller: _recipeTypeController,
                          //   decoration: InputDecoration(
                          //       hintText: "Type*",
                          //       border: OutlineInputBorder()),
                          // ),
                        ),
                        Container(
                          //margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 15),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.orange,
                            controller: _recipeServesController,
                            decoration: InputDecoration(
                                hintText: "Serves*",
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    )),
                Card(
                  margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment(-0.95, 0.0),
                          margin: EdgeInsets.only(left: 5, top: 15),
                          child: Text(
                            "Ingredients",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: TextField(
                          cursorColor: Colors.orange,
                          decoration: InputDecoration(
                              hintText: "Name*", border: OutlineInputBorder()),
                          controller: _ingredientName,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: TextField(
                          cursorColor: Colors.orange,
                          decoration: InputDecoration(
                              hintText: "Quantity*",
                              border: OutlineInputBorder()),
                          controller: _ingredientQuant,
                        ),
                      ),
                      Container(
                          alignment: Alignment(0.95, 0.0),
                          margin: EdgeInsets.only(top: 15, bottom: 10),
                          child: RaisedButton(
                            color: Colors.orange,
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _addIngredient,
                          )),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _recipeIngredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.orange,
                        ),
                        title: Text(
                          "${_recipeIngredients[index]}",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment(-0.95, 0.0),
                          margin: EdgeInsets.only(left: 5, top: 15),
                          child: Text(
                            "Instructions",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: TextField(
                          cursorColor: Colors.orange,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: InputDecoration(
                              hintText: "Instruction Step*",
                              border: OutlineInputBorder()),
                          controller: _instructionController,
                        ),
                      ),
                      Container(
                          alignment: Alignment(0.95, 0.0),
                          margin: EdgeInsets.only(top: 15, bottom: 10),
                          child: RaisedButton(
                            color: Colors.orange,
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _addInstruction,
                          )),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _instructionSteps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                          radius: 10.0,
                        ),
                        title: Text(
                          "${_instructionSteps[index]}",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment(-0.95, 0.0),
                          margin: EdgeInsets.only(left: 5, top: 20),
                          child: Text(
                            "Upload Image",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: _image == null
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Container(child: Image.file(_image)),
                      ),
                      Container(
                          alignment: Alignment(0.95, 0.0),
                          margin: EdgeInsets.only(top: 15, bottom: 10),
                          child: RaisedButton(
                            color: Colors.orange,
                            child: Text(
                              "Browse",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _getImageFromGallery,
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(35, 25, 35, 25),
                  alignment: Alignment(0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: double.maxFinite,
                    height: 44,
                    child: RaisedButton(
                        color: Colors.orange,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          _checkFields();
                          if (_isValid) {
                            _submitRecipe();
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
