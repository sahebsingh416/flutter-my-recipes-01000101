import 'package:flutter/material.dart';
import './tabbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import './showdialog.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNewRecipe extends StatefulWidget {
  @override
  _AddNewRecipeState createState() => _AddNewRecipeState();
}

class _AddNewRecipeState extends State<AddNewRecipe> {
  final store = LocalStorage('recipes');
  var _textFieldController = TextEditingController();
  var _tagController = TextEditingController();
  var _recipeNameController = TextEditingController();
  var _recipeDurationController = TextEditingController();
  var _recipeServesController = TextEditingController();
  var _ingredientName = TextEditingController();
  var _ingredientQuant = TextEditingController();
  var _instructionController = TextEditingController();
  var url;
  final _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _dropDownType;
  String _dropDownComplexity;
  bool _isValid = false;
  File _image;
  List _recipeIngredients = [];
  List _instructionSteps = [];
  List tags = [];

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

  void _storeURL() {
    setState(() {
      url = _textFieldController.text;
      _textFieldController.clear();
    });
  }

  void _addTag() {
    setState(() {
      tags.add(_tagController.text);
      _tagController.clear();
    });
    print(tags);
  }

  void _addRecipe() {
    print(url);
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return Tabbar();
    }));
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
    final token = store.getItem('userToken');
    final req = await http
        .post("http://35.160.197.175:3006/api/v1/recipe/add", headers: {
      HttpHeaders.authorizationHeader: token
    }, body: {
      "name": _recipeNameController.text,
      "preparationTime": _recipeDurationController.text + " Min",
      "serves": _recipeServesController.text,
      "complexity": _dropDownComplexity,
      "metaTags": tags.toString(),
      "ytUrl": url
    });

    var addResponse = jsonDecode(req.body);
    print(addResponse);
    /*final res1 = await http.get(
        "http://35.160.197.175:3006/api/v1/recipe/feeds",
        headers: {HttpHeaders.authorizationHeader: token});
    var jsonResponse = jsonDecode(res1.body);
    store.setItem('recipeJSON', jsonResponse);*/
    _addIngredents(addResponse["id"].toString());
  }

  _addIngredents(String id) async {
    final token = store.getItem('userToken');
    for (var ingredient in _recipeIngredients) {
      final req = await http.post(
          "http://35.160.197.175:3006/api/v1/recipe/add-ingredient",
          headers: {
            HttpHeaders.authorizationHeader: token
          },
          body: {
            "ingredient": ingredient.toString(),
            "recipeId": id,
          });
    }
    _addInstructions(id.toString());
  }

  _addInstructions(String id) async {
    final token = store.getItem('userToken');
    for (var instruction in _instructionSteps) {
      final req = await http.post(
          "http://35.160.197.175:3006/api/v1/recipe/add-instruction",
          headers: {
            HttpHeaders.authorizationHeader: token
          },
          body: {
            "instruction": instruction.toString(),
            "recipeId": id,
          });
    }
    _addRecipe();
  }
  /*_uploadImage(String id) async {
    final token = store.getItem('userToken');
    /*var base64Image = base64Encode(_image.readAsBytesSync());
    final req1 = await http.post(
        "http://35.160.197.175:3006/api/v1/recipe/add-update-recipe-photo",
        headers: {HttpHeaders.authorizationHeader: token},
        body: {"photo": base64Image, "recipeId": id});
    print(req1.statusCode);*/
    var stream =
        new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    var length = await _image.length();
    var uri = Uri.parse("http://35.160.197.175:3006/api/v1/recipe/add-update-recipe-photo");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile("photo", stream , length);
    request.headers[HttpHeaders.authorizationHeader] = token;
    request.files.add(multipartFile);
    request.fields["recipeId"] = id;
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    _addRecipe();
  }*/

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
                          margin: EdgeInsets.all(0),
                          width: double.maxFinite,
                          child: Stack(
                            children: <Widget>[
                              new Positioned(
                                child: Container(
                                  width: double.maxFinite,
                                  //margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 15),
                                  constraints: BoxConstraints.tightForFinite(),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Stack(
                                        children: <Widget>[
                                          new Positioned(
                                            child: tags.length == 0
                                                ? Container(
                                                    child: Text(
                                                      "Tags*",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        top: 18),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        right: 50),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: tags.length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  top: 5,
                                                                  bottom: 8),
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                          alignment: Alignment(
                                                              0.0, -1.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(tags[
                                                                      index])),
                                                              Container(
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      tags.removeAt(
                                                                          index);
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              new Positioned(
                                top: 20,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Add Tags'),
                                            content: TextField(
                                              controller: _tagController,
                                              decoration: InputDecoration(
                                                  hintText: "Enter a Tag",
                                                  border: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.orange))),
                                              cursorColor: Colors.orange,
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                  child: new Text(
                                                    "Add",
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  ),
                                                  onPressed: _addTag),
                                              new FlatButton(
                                                child: new Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              )
                            ],
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
                            "Add Image / Add URL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                          child: Column(
                            children: <Widget>[
                              _image == null
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Container(
                                      child: Stack(
                                      children: <Widget>[
                                        new Positioned(
                                          child: Image.file(_image),
                                        ),
                                        new Positioned(
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _image = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              Padding(
                                padding: EdgeInsets.only(top: 25),
                              ),
                              url == null
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Container(
                                      child: Stack(
                                      children: <Widget>[
                                        new Positioned(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0)),
                                                border: Border.all(
                                                    color:
                                                        Colors.orangeAccent)),
                                            child: Center(child: Text(url)),
                                          ),
                                        ),
                                        new Positioned(
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                url = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                            ],
                          )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: 15, bottom: 10, left: 10),
                                child: RaisedButton(
                                  color: Colors.orange,
                                  child: Text(
                                    "Add URL",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Add URL'),
                                            content: Form(
                                              key: _formkey,
                                              autovalidate: _autoValidate,
                                              child: TextFormField(
                                                validator: (value) {
                                                  Pattern pattern =
                                                      r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$';
                                                  RegExp regex =
                                                      new RegExp(pattern);
                                                  if (!regex.hasMatch(value))
                                                    return 'Enter Valid URL';
                                                  else
                                                    //_storeURL();
                                                    return null;
                                                },
                                                controller:
                                                    _textFieldController,
                                                decoration: InputDecoration(
                                                    hintText: "Enter your URL",
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .orange))),
                                                cursorColor: Colors.orange,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                                onPressed: () {
                                                  if (_formkey.currentState
                                                      .validate()) {
                                                    _formkey.currentState
                                                        .save();
                                                    _storeURL();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    setState(() {
                                                      _autoValidate = true;
                                                    });
                                                  }
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                )),
                            Container(
                                //alignment: Alignment(0.95, 0.0),
                                margin: EdgeInsets.only(
                                    top: 15, bottom: 10, right: 10),
                                child: RaisedButton(
                                  color: Colors.orange,
                                  child: Text(
                                    "Add Image",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: _getImageFromGallery,
                                )),
                          ],
                        ),
                      ),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
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
