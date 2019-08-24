import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/addnew.dart';
import 'package:flutter_my_recipes_01000101/loginScreen.dart';
import './recipedetails.dart';

void main() => runApp(Recipe());

class Recipe extends StatefulWidget {
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: FlatButton(
            child: Icon(Icons.exit_to_app,size: 25,),
            onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
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
        body: SafeArea(
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
                            "Alfredo Sauce",
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
