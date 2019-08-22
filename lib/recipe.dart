import 'package:flutter/material.dart';

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
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: Text(
            "Recipes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return Card(
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
                                padding: EdgeInsets.only(left: 30),
                              ),
                              Container(
                                  width: 100,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.access_time,color: Colors.grey,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
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
                                padding: EdgeInsets.only(left: 15, right: 25),
                              ),
                              Container(
                                  width: 80,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.view_list,color: Colors.grey,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
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
                                padding: EdgeInsets.only(left: 25),
                              ),
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Icon(Icons.restaurant,color: Colors.grey,),
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
                  ));
            },
          ),
        ),
      ),
    );
  }
}
