import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
//import 'package:video_player/video_player.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:share/share.dart';

class RecipeDetails extends StatefulWidget {
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  var recipeIndex;
  bool _apiCalled = false;
  var currentRecipeId;
  var ingredients;
  var instructions;
  var recipes;
  bool videoUrl = true;
  Icon _favIcon;
  final defaultImage =
      "https://cdn.dribbble.com/users/1012566/screenshots/4187820/topic-2.jpg";
  final store = LocalStorage('recipes');
  VideoPlayerController _videoController;
  bool _isPlaying = false;
  bool _hasVideo = true;

  @override
  void initState() {
    super.initState();
//    _controller = VideoPlayerController.network("https://www.youtube.com/watch?v=-liJSfU5yBk");
//    _controller.addListener((){
//      final bool isPlaying = _controller.value.isPlaying;
//      if(isPlaying != _isPlaying){
//        setState(() {
//          _isPlaying = isPlaying;
//        });
//      }
//    });
//    _controller.initialize().then((_){
//      setState(() {
//
//      });
//    });
    currentRecipeId = store.getItem('currentID');
    recipeIndex = currentRecipeId;
    _recipeDetails();
  }

  Future<void> _recipeDetails() async {
    final token = store.getItem('userToken');
    final req = await http.get(
        "http://35.160.197.175:3006/api/v1/recipe/${currentRecipeId}/details",
        headers: {HttpHeaders.authorizationHeader: token});
    setState(() {
      recipes = jsonDecode(req.body);
      if (recipes["inCookingList"] == 1) {
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
      if (recipes["ytUrl"] == null || recipes["ytUrl"] == "") {
        _hasVideo = false;
      }
      ingredients = recipes["ingredients"];
      instructions = recipes["instructions"];
      _apiCalled = true;
    });
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
        headers: {HttpHeaders.authorizationHeader: token},
        body: {"recipeId": currentRecipeId.toString()});
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ),
              onPressed: () {
                Share.share("You can see, my receipe!");
              },
            ),
          ],
          title: Text(
            "Recipes Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: _apiCalled ? ListView(
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              alignment: Alignment(0.0, -1.0),
              children: <Widget>[
                _isPlaying == false
                    ? CachedNetworkImage(
                        height: 250,
                        width: double.maxFinite,
                        imageUrl: recipes["photo"] == null
                            ? defaultImage
                            : recipes["photo"],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Container(
                              height: 30,
                              width: 30,
                              child: new CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                              )),
                        ),
                      )
                    : Container(
                        height: 250,
                        width: double.maxFinite,
                        child: YoutubePlayer(
                          context: context,
                          controlsColor: ControlsColor(
                              buttonColor: Colors.amber,
                              playPauseColor: Colors.red,
                              progressBarBackgroundColor: Colors.pink,
                              seekBarPlayedColor: Colors.white),
                          source: recipes["ytUrl"],
                          quality: YoutubeQuality.LOWEST,
                          autoPlay: true,
                          keepScreenOn: true,
                          // callbackController is (optional).
                          // use it to control player on your own.
                          callbackController: (controller) {
                            _videoController = controller;
                            // _isPlaying = true;
                          },
                        ),
                      ),
                      _hasVideo && _isPlaying == false
                    ? new Positioned(
                        top: 100,
                        child: Center(
                          child: IconButton(
                            icon: Image.asset('images/youtube.png'),
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                _isPlaying = true;
                              });
                            },
                          ),
                        ),
                      )
                    : Text(""),
                _isPlaying == false
                    ? new Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: _favIcon,
                          onPressed: () {
                            if (_favIcon.icon == Icons.favorite) {
                              _removedFromFavorite();
                            } else {
                              _addToFavorite();
                            }
                          },
                        ),
                      )
                // _hasVideo
                //     ? (_isPlaying == false
                //         ? new Positioned(
                //             top: 100,
                //             child: Center(
                //               child: IconButton(
                //                 icon: Image.asset('images/youtube.png'),
                //                 iconSize: 50,
                //                 onPressed: () {
                //                   setState(() {
                //                     _isPlaying = true;
                //                   });
                //                 },
                //               ),
                //             ),
                //           )
                //         : Text(""))
                //     : Text(""),
                // _isPlaying == false
                //     ? new Positioned(
                //         top: 10,
                //         right: 10,
                //         child: IconButton(
                //           icon: _favIcon,
                //           onPressed: () {
                //             if (_favIcon.icon == Icons.favorite) {
                //               _removedFromFavorite();
                //             } else {
                //               _addToFavorite();
                //             }
                //           },
                //         ),
                //       )
                    : new Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPlaying = false;
                            });
                          },
                        ),
                      ),
              ],
            ),
            Card(
              child: Column(
                children: <Widget>[
                  /*Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Soup",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),*/
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      recipes["name"],
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
                              width: 120,
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
                                    recipes["preparationTime"],
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
                                    recipes["complexity"],
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
                                recipes["serves"],
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
                        itemCount: ingredients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: Icon(
                              Icons.fiber_manual_record,
                              color: Colors.orange,
                            ),
                            title: Text(
                              ingredients[index]["ingredient"],
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
                        itemCount: instructions.length,
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
                              instructions[index]["instruction"],
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
        ) : Container(child: Center(child: CircularProgressIndicator(),),),
      ),
    );
  }
}
