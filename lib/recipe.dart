import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/addnew.dart';
import 'package:flutter_my_recipes_01000101/loginScreen.dart';
import './recipedetails.dart';
import 'package:localstorage/localstorage.dart';
import './Skeleton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(Recipe());
}

class Recipe extends StatefulWidget {
  final defaultImage =
      "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg";
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  bool _apiCalled = false;
  final store = LocalStorage("recipes");
  final TextEditingController _searchController = TextEditingController();
  String _searchText;
  _RecipeState(){
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchController.text;
        });
      }
    });
  }
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Colors.black,
  );
  Widget _appBarTitle = new Text(
    "Recipes",
    style: TextStyle(
      color: Colors.black,
      fontSize: 25,
    ),
  );
  var recipes;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getRecipes();
      recipes = store.getItem('recipeJSON');
    });
  }

  void _getRecipes() async {
    final token = store.getItem('userToken');
    final res1 = await http.get(
        "http://35.160.197.175:3006/api/v1/recipe/feeds",
        headers: {HttpHeaders.authorizationHeader: token});
    final jsonResponse = jsonDecode(res1.body);
    store.setItem('recipeJSON', jsonResponse);
    setState(() {
      _apiCalled = true;
    });
  }

  void _searchedRecipes() async {
    final _api = "http://35.160.197.175:3006/api/v1/recipe/feeds?q=" + _searchText;
    final token = store.getItem('userToken');
    final res1 =
        await http.get(_api, headers: {HttpHeaders.authorizationHeader: token});
    final jsonResponse = jsonDecode(res1.body);
    setState(() {
      recipes = jsonResponse;
    });
  }

  void _searchPressed() async {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(
          Icons.close,
          color: Colors.black,
        );
        this._appBarTitle = new TextField(
          controller: _searchController,
          cursorColor: Colors.orange,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              border: InputBorder.none,
              hintText: 'Search...'),
        );
        setState(() {
          if (_searchController.text.isNotEmpty) {
            _searchedRecipes();
          }
        });
      } else {
        setState(() {
          recipes = store.getItem('recipeJSON');
        });
        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.black,
        );
        this._appBarTitle = new Text(
          "Recipes",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.orange, primaryColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: FlatButton(
            color: Colors.white,
            child: Icon(
              Icons.playlist_add,
              size: 35,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddNewRecipe();
              }));
            },
          ),
          // FlatButton(
          //   child: Icon(
          //     Icons.exit_to_app,
          //     size: 25,
          //   ),
          //   onPressed: () {
          //     Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (_) {
          //       return Login();
          //     }));
          //   },
          // ),
          title: _appBarTitle,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(0),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: recipes.length,
              itemBuilder: (BuildContext context, int index) {
                return FlatButton(
                  child: Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: recipes[index]["photo"] == null
                                  ? widget.defaultImage
                                  : recipes[index]["photo"],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Skeleton(
                                height: 150,
                                width: double.maxFinite,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment(-0.8, 0.0),
                            margin: EdgeInsets.only(top: 10),
                            child: _apiCalled == false
                                ? Skeleton()
                                : Text(
                                    "Soup",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ),
                          Container(
                            alignment: Alignment(-0.9, 0.0),
                            margin: EdgeInsets.only(top: 10),
                            child: _apiCalled == false
                                ? Skeleton()
                                : Text(
                                    recipes[index]["name"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 17),
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: 15),
                                  // ),
                                  _apiCalled == false
                                      ? Skeleton(
                                          width: 80,
                                        )
                                      : Container(
                                          width: 120,
                                          child: _apiCalled == false
                                              ? Skeleton()
                                              : Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.access_time,
                                                      color: Colors.grey,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0),
                                                    ),
                                                    Text(
                                                      recipes[index]
                                                          ["preparationTime"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                ]),
                                Row(children: <Widget>[
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: 2, right: 4),
                                  // ),
                                  _apiCalled == false
                                      ? Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Skeleton(width: 80))
                                      : Container(
                                          width: 90,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.view_list,
                                                color: Colors.grey,
                                              ),
                                              // Padding(
                                              //   padding: EdgeInsets.only(
                                              //       left: 2, right: 5),
                                              // ),
                                              Text(
                                                recipes[index]["complexity"],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ))
                                ]),
                                Row(children: <Widget>[
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: 0),
                                  // ),
                                  _apiCalled == false
                                      ? Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Skeleton(width: 80))
                                      : Container(
                                          child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.restaurant,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(left: 5),
                                            // ),
                                            Text(
                                              recipes[index]["serves"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ))
                                ]),
                              ],
                            ),
                          ),
                        ],
                      )),
                  onPressed: () {
                    store.setItem('currentID', recipes[index]["recipeId"]);
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return RecipeDetails();
                    }));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
