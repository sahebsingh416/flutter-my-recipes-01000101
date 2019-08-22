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
            itemCount: 5,
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
                        child: Text("Soup",textAlign: TextAlign.left,style: TextStyle(color: Colors.grey),),
                      ),
                      Container(
                        alignment: Alignment(-0.9, 0.0),
                        margin: EdgeInsets.only(top: 10),
                        child: Text("AlfredoSauce",textAlign: TextAlign.left,style: TextStyle(fontSize: 17),),
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
