import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/addnew.dart';
import 'package:flutter_my_recipes_01000101/loginScreen.dart';
import './recipedetails.dart';
import 'package:localstorage/localstorage.dart';
import './Skeleton.dart';

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
  final store = LocalStorage("recipes");
  var recipes;
  @override
  void initState() {
    super.initState();
    setState(() {
      recipes = store.getItem('recipeJSON');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.orange),
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
                              placeholder: (context, url) => Center(
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: new CircularProgressIndicator(
                                      backgroundColor: Colors.transparent,
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment(-0.8, 0.0),
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
                                  Container(
                                      width: 120,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 0),
                                          ),
                                          Text(
                                            recipes[index]["preparationTime"],
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
                                  Container(
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
                                  Container(
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
