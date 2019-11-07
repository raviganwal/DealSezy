import 'dart:async';
import 'dart:convert';
import 'package:dealsezy/HomeScreenTabController/ExploreScreen.dart';
import 'package:dealsezy/HomeScreenTabController/MyAccount.dart';
import 'package:dealsezy/HomeScreenTabController/MyAdv.dart';
import 'package:dealsezy/SplashScreen/SplashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:dealsezy/HomeScreenTabController/ChatScreen.dart';
import 'package:dealsezy/HomeScreenTabController/SellScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
//-----------------------------------------------------------------------------------------//
class HomeScreen extends StatefulWidget {
  static String tag = 'HomeScreen';

  @override
  _HomeScreenState createState() {
    return new _HomeScreenState();
  }
}
//-----------------------------------------------------------------------------------------//
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  // Create a tab controller
  TextEditingController controller1 = new TextEditingController();
  TabController controller;
  List<Color> _colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  int _currentIndex = 0;
  bool isSmall = false;

//-----------------------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    // Initialize the Tab Controller
    controller = TabController(length: 5, vsync: this);
  }
//-----------------------------------------------------------------------------------------//
  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }
//-----------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    return new WillPopScope(
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: Scaffold(
  /*      drawer: _drawer(),
        // Appbar
        appBar: new AppBar(
          title: new Container(
            color: Colors.transparent,
            width: _width / 0,
            height: 40,
            *//*child: new TextField(
              //cursorColor: Colors.white,
              controller: controller1,
                textAlign: TextAlign.center,
                // onChanged: onSearch,
                decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Search ",hintStyle: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.w500),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,color: Colors.white,
                      size: 28.0,
                      ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel,color: Colors.white,),
                      onPressed: () {
                        //controller.clear();
                        // onSearch('');
                      },)
                    ),
              ),*//*
            ),
          ),*/
//-----------------------------------------------------------------------------------------//
        // Set the TabBar view as the body of the Scaffold
        body: TabBarView(
          // Add tabs as widgets
          children: <Widget>[ExploreScreen(),ChatScreen(),SellScreen(),MyAdv(),MyAccount()],
            // set the controller
            controller: controller,
          ),
//-----------------------------------------------------------------------------------------//
        // Set the bottom navigation bar
        bottomNavigationBar: Material(
          // set the color of the bottom navigation bar
          color: ColorCode.AppColorCode,
            // set the tab bar as the child of bottom navigation bar
            child: TabBar(
              labelColor: _colors[_currentIndex],
              labelPadding: new EdgeInsets.only(top:10.0),
              tabs: <Tab>[
                new Tab(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.explore,color: ColorCode.TextColorCode,
                        //size: 15.0,
                        ),
                      SizedBox(height:5.0),
                      new Text(GlobalString.EXPLORE,
                                   style: new TextStyle(fontSize: 9.0,color: ColorCode.TextColorCode,fontWeight: FontWeight.normal,
                                   ))
                    ],
                    ),
                  ),
                new Tab(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.chat_bubble,color: ColorCode.TextColorCode,
                        //size: 15.0,
                        ),
                      SizedBox(height:5.0),
                      new Text(GlobalString.CHAT,
                                   style: new TextStyle(fontSize: 9.0,color: ColorCode.TextColorCode,fontWeight: FontWeight.normal,
                                                        ))
                    ],
                    ),
                  ),
                new Tab(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.add_shopping_cart,color: ColorCode.TextColorCode,
                        //size: 15.0,
                        ),
                      SizedBox(height:5.0),
                      new Text(GlobalString.SELL,
                                   style: new TextStyle(fontSize: 9.0,color: ColorCode.TextColorCode,fontWeight: FontWeight.normal,
                                                        ))
                    ],
                    ),
                  ),
                new Tab(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.apps,color: ColorCode.TextColorCode,
                        //size: 15.0,
                        ),
                      SizedBox(height:5.0),
                      new Text(GlobalString.MYADV,
                                   style: new TextStyle(fontSize: 9.0,color: ColorCode.TextColorCode,fontWeight: FontWeight.normal,
                                                        ))
                    ],
                    ),
                  ),
                new Tab(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.account_box,color: ColorCode.TextColorCode,
                        //size: 15.0,
                        ),
                      SizedBox(height:5.0),
                      new Text(GlobalString.ACCOUNT,
                                   style: new TextStyle(fontSize: 9.0,color: ColorCode.TextColorCode,fontWeight: FontWeight.normal,
                                                        ))
                    ],
                    ),
                  ),
              ],
              indicatorColor: Colors.white,
              // setup the controller
              controller: controller,
              ),
          ),
        ),
      );
  }
//-----------------------------------------------------------------------------------------//
/*  Widget _drawer() {
    return new Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text("Mr. "+"Akash Gupta".toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text("gupta.akash555@gmail.com",style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              currentAccountPicture:
              CircleAvatar(
                backgroundImage: ExactAssetImage('assets/images/logos.jpg'),
                minRadius: 90,
                maxRadius: 100,
                ),
              decoration: BoxDecoration(color: ColorCode.AppColorCode),
              ),
            ListTile(
              leading: new Image.asset(
                'assets/images/home.png',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
                ),
              title: Text(GlobalString.Home.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.of(context).pushNamed(HomeScreen.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
            ListTile(
              leading: new Image.asset(
                'assets/images/friend.png',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
                ),
              title: Text(GlobalString.Friend.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),),
              onTap: () {
                //Navigator.of(context).pushNamed(Profile.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
            ListTile(
              leading: new Image.asset(
                'assets/images/faq.png',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
                ),
              title: Text(GlobalString.Faq.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigator.of(context).pushNamed(Product.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
            ListTile(
              leading: new Image.asset(
                'assets/images/about.png',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
                ),
              title: Text(GlobalString.About.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigator.of(context).pushNamed(CategoryScreenList.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
            ListTile(
              leading: new Image.asset(
                'assets/images/term.png',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
                ),
              title: Text(GlobalString.Terms.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),),
              onTap: () {
                // Navigator.of(context).pushNamed(CategoryScreenList.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
            ListTile(
              leading: new Image.asset(
                'assets/images/logout.png',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.cover,
                ),
              title: Text(GlobalString.logout.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),),
              onTap: () {
                //Navigator.of(context).pushNamed(Help.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
          ],
          ));
  }*/
//-----------------------------------------------------------------------------------------//
  void TapMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Want to logout?'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              removeData();
            },
            child: new Text('OK'))
      ],
      );
    showDialog(context: context, child: alert);
  }
//-----------------------------------------------------------------------------------------//
  removeData() async {
    /* final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    prefs.remove(Preferences.KEY_ROLE);
    prefs.remove(Preferences.KEY_NAME);
    prefs.remove(Preferences.KEY_Email);
    prefs.remove(Preferences.KEY_Contact);*/
    Navigator.of(context).pushNamed(SplashScreen.tag);
  }
}
//-----------------------------------------------------------------------------------------//