import 'dart:math';

import 'package:flutter/material.dart';

class RecipeDetails extends StatefulWidget {
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
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
                Image.asset("images/food.jpg",),
                new Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.favorite,color: Colors.white,),
                ),
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
                                      Icon(Icons.access_time,color: Colors.grey,),
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
                                padding: EdgeInsets.only(left: 8, right: 10),
                              ),
                              Container(
                                  width: 80,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.view_list,color: Colors.grey,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6,right: 1),
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
                    child: Text("INGREDIENTS",style: TextStyle(fontSize: 15,letterSpacing: sqrt1_2),textAlign: TextAlign.center,),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                     children: <Widget>[
                       ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context,int index){
                        return ListTile(
                          contentPadding: EdgeInsets.all(5),
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            radius: 6.0,
                          ),
                          title: Text("Hello",textAlign: TextAlign.left,style: TextStyle(fontSize: 14),),
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
                    child: Text("INSTRUCTIONS",style: TextStyle(fontSize: 15,letterSpacing: sqrt1_2),textAlign: TextAlign.center,),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                     children: <Widget>[
                       ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context,int index){
                        return ListTile(
                          contentPadding: EdgeInsets.all(5),
                          leading: CircleAvatar(
                            child: Text("${index+1}",style: TextStyle(fontSize: 12,color: Colors.white),),
                            backgroundColor: Colors.orange,
                            radius: 10.0,
                          ),
                          title: Text("Hello",textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
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
