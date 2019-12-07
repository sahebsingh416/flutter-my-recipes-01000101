import 'package:flutter/material.dart';
import 'package:flutter_my_recipes_01000101/wishList.dart';
import './recipe.dart';
import './profile.dart';

class Tabbar extends StatefulWidget {
  Tabbar() : super();

  final String title = "Flutter Bottom Tab demo";

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int currentTabIndex = 0;
  List<Widget> tabs = [Recipe(), WishList(), Profile()];
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: currentTabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt,
              ),
              title: Text("Recipes"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text("Wishlist"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
