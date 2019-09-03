import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class RecipeDetails extends StatefulWidget {
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  var recipeIndex;
  var currentRecipeId;
  var ingredients;
  var instructions;
  var recipes;
  Icon _favIcon;
  final defaultImage =
      "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg";
  final store = LocalStorage('recipes');
  @override
  void initState() {
    super.initState();
    currentRecipeId = store.getItem('currentID');
    print(currentRecipeId);
    ingredients = store.getItem('ingredientsJSON');
    recipes = store.getItem('recipeJSON');
    for (int i = 0; i < recipes.length; i++) {
      if (currentRecipeId == recipes[i]["recipeId"]) {
        recipeIndex = i;
        if (recipes[i]["inCookingList"] == 1) {
          _favIcon = Icon(
            Icons.favorite,
            color: Colors.red,
          );
        } else {
          _favIcon = Icon(
            Icons.favorite_border,
            color: Colors.white,
          );
        }
      }
    }
    instructions = store.getItem('instructionsJSON');
  }

  void _backToRecipes() {
    Navigator.pop(context);
  }

  void _addToFavorite() {
    setState(() {
      if (_favIcon.icon == Icons.favorite) {
        _favIcon = Icon(
          Icons.favorite_border,
          color: Colors.white,
        );
        _removedFromFavorite();
      } else {
        _addedInFavorite();
        _favIcon = Icon(
          Icons.favorite,
          color: Colors.red,
        );
      }
    });
  }

  void _addedInFavorite() async {
    final token = store.getItem('userToken');
    final req = await http.post(
        "http://35.160.197.175:3006/api/v1/recipe/add-to-cooking-list",
        headers: {
          HttpHeaders.authorizationHeader:
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.MGBf-reNrHdQuwQzRDDNPMo5oWv4GlZKlDShFAAe16s"
        },
        body: {
          "recipeId": currentRecipeId.toString()
        });
    print(req.statusCode);
    print(jsonDecode(req.body));
    setState(() {
      _favIcon = Icon(
        Icons.favorite,
        color: Colors.red,
      );
    });
  }

  void _removedFromFavorite() async {
    final token = store.getItem('userToken');
    final req = await http.post(
        "http://35.160.197.175:3006/api/v1/recipe/rm-from-cooking-list",
        headers: {
          HttpHeaders.authorizationHeader:
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.MGBf-reNrHdQuwQzRDDNPMo5oWv4GlZKlDShFAAe16s"
        },
        body: {
          "recipeId": currentRecipeId.toString()
        });
    print(req.statusCode);
    setState(() {
      _favIcon = Icon(
        Icons.favorite_border,
        color: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: FlatButton(
            child: Icon(Icons.arrow_back_ios),
            onPressed: _backToRecipes,
          ),
          title: Text(
            "Recipes Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              alignment: Alignment(0.0, -1.0),
              children: <Widget>[
                CachedNetworkImage(
                  height: 250,
                  width: double.maxFinite,
                  imageUrl: recipes[recipeIndex]["photo"] == null
                      ? defaultImage
                      : recipes[recipeIndex]["photo"],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Container(
                        height: 30,
                        width: 30,
                        child: new CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                        )),
                  ),
                ),
                new Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: _favIcon,
                    onPressed: () {
                      if (_favIcon.icon == Icons.favorite) {
                        _removedFromFavorite();
                      } else {
                        _addedInFavorite();
                      }
                    },
                  ),
                )
              ],
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Soup",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      recipes[recipeIndex]["name"],
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Container(
                              width: 100,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                  ),
                                  Text(
                                    recipes[recipeIndex]["preparationTime"],
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
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 10),
                          ),
                          Container(
                              width: 120,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.view_list,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                  ),
                                  Text(
                                    recipes[recipeIndex]["complexity"],
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
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          Container(
                              child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              Text(
                                recipes[recipeIndex]["serves"],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                              ),
                            ],
                          ))
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black12,
                    height: 30,
                    padding: EdgeInsets.only(top: 5),
                    width: double.maxFinite,
                    child: Text(
                      "INGREDIENTS",
                      style: TextStyle(fontSize: 15, letterSpacing: sqrt1_2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: Icon(
                              Icons.fiber_manual_record,
                              color: Colors.orange,
                            ),
                            title: Text(
                              "2 Spring Onions",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black12,
                    height: 30,
                    padding: EdgeInsets.only(top: 5),
                    width: double.maxFinite,
                    child: Text(
                      "INSTRUCTIONS",
                      style: TextStyle(fontSize: 15, letterSpacing: sqrt1_2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: CircleAvatar(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              backgroundColor: Colors.orange,
                              radius: 10.0,
                            ),
                            title: Text(
                              "Saute onions till it become translucent",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
