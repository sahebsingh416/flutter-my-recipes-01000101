import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/addnew.dart';
import 'package:flutter_my_recipes_01000101/loginScreen.dart';
import './recipedetails.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './services.dart';
import 'package:flutter/foundation.dart';

Future<List<RecipesModel>> fetchRecipes(http.Client client) async {
  final response = await client.get(
      "http://35.160.197.175:3006/api/v1/recipe/feeds"); //, headers: {HttpHeaders.authorizationHeader : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.MGBf-reNrHdQuwQzRDDNPMo5oWv4GlZKlDShFAAe16s"});

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseRecipes, response.body);
}

// A function that converts a response body into a List<Photo>.
List<RecipesModel> parseRecipes(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<RecipesModel>((json) => RecipesModel.fromJson(json))
      .toList();
}

class RecipesModel {
  final File photo;
  final String name;
  final String serves;
  final String complexity;
  final String preparationTime;

  RecipesModel(
      {this.photo,
      this.name,
      this.serves,
      this.complexity,
      this.preparationTime});

  factory RecipesModel.fromJson(Map<String, dynamic> json) {
    return RecipesModel(
      name: json['name'],
      serves: json['serves'],
      complexity: json['complexity'],
      photo: json['photo'],
      preparationTime: json['preparationTime'],
    );
  }
}

void main() {
  runApp(Recipe());
}

// class MyHomePage extends StatelessWidget {
//   final String title;

//   MyHomePage({Key key, this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<RecipesModel>>(
//         future: fetchRecipes(http.Client()),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) print(snapshot.error);

//           return snapshot.hasData
//               ? _RecipeState(recipes: snapshot.data)
//               : Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

class Recipe extends StatefulWidget {
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  //var _recipes;
  final List<RecipesModel> recipes;
  _RecipeState({Key key, this.recipes});
  @override
  void initState() {
    super.initState();
    fetchRecipes(http.Client());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: FlatButton(
            child: Icon(
              Icons.exit_to_app,
              size: 25,
            ),
            onPressed: () {
              print(recipes[0].name);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return Login();
              }));
            },
          ),
          title: Text(
            "Recipes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            FlatButton(
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
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(0),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return FlatButton(
                child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: double.infinity,
                          child: Image.asset(
                            "images/food.jpg",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          alignment: Alignment(-0.9, 0.0),
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "Soup",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          alignment: Alignment(-0.9, 0.0),
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "recipes[0].name",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            children: <Widget>[
                              Row(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
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
                                          padding: EdgeInsets.only(left: 1),
                                        ),
                                        Text(
                                          "25 Minutes",
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
                                  padding: EdgeInsets.only(left: 6, right: 4),
                                ),
                                Container(
                                    width: 80,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.view_list,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 4, right: 5),
                                        ),
                                        Text(
                                          "Easy",
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
                                  padding: EdgeInsets.only(left: 2),
                                ),
                                Container(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.restaurant,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                    ),
                                    Text(
                                      "4 People",
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return RecipeDetails();
                  }));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
