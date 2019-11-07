import 'dart:async';
import 'dart:convert';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
//-------------------------------------------------------------------------------------------------//
class ChatScreen extends StatefulWidget {
  static String tag = 'ChatScreen';

  @override
  _ServiceState createState() => new _ServiceState();
}

class _ServiceState extends State<ChatScreen> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 3, vsync: this);

    var tabBarItem = new TabBar(
      tabs: [
        new Tab(
          //icon: new Icon(Icons.list),
          text: "ALL",
          ),
        new Tab(
          // icon: new Icon(Icons.grid_on),
          text: "BUYING",
          ),
        new Tab(
          // icon: new Icon(Icons.grid_on),
          text: "SELLING",
          ),
      ],
      controller: tabController,
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      );

    var ALL;
    ALL = new Padding(
      padding: const EdgeInsets.only(bottom:2.0),
      child: new GestureDetector(
        onTap: () {
          //Navigator.of(context).pushNamed(StudentDetail.tag);
        },
        child: new Card(
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: Image.network(
                'https://gravitinfosystems.com/MDNS/uploads/s-l1000.jpg',
                height: 250.0,
                width: 50.0,
                ),

              title: new Text(
                "AKASH GUPTA".toUpperCase(),textAlign: TextAlign.start,
                style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                ),
              trailing: new Text(
                "CHATNOW".toUpperCase(),textAlign: TextAlign.start,
                style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                ),
              subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('01-10-2019',
                                  style: new TextStyle(
                                      fontSize: 13.0, fontWeight: FontWeight.normal,color: ColorCode.TextColorCodeBlue)),
                            ]),
              )
          ],
          ),
        ),
        ),
      );

    var Buying;
    Buying = new Padding(
      padding: const EdgeInsets.all(2.0),
      child: new GestureDetector(
        onTap: () {
          //Navigator.of(context).pushNamed(StudentDetail.tag);
        },
        child: new Card(
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new ListTile(
                leading: Image.network(
                  'https://gravitinfosystems.com/MDNS/uploads/s-l1000.jpg',
                  height: 250.0,
                  width: 50.0,
                  ),

                title: new Text(
                  "AKASH GUPTA".toUpperCase(),textAlign: TextAlign.start,
                  style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                  ),
                trailing: new Text(
                  "CHATNOW".toUpperCase(),textAlign: TextAlign.start,
                  style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                  ),
                subtitle: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('01-10-2019',
                                   style: new TextStyle(
                                       fontSize: 13.0, fontWeight: FontWeight.normal,color: ColorCode.TextColorCodeBlue)),
                    ]),
                )
            ],
            ),
          ),
        ),
      );


    final GlobalKey<ScaffoldState> _scaffoldKey =
    new GlobalKey<ScaffoldState>();

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        drawer: _drawer(),
        appBar: new AppBar(
          title: Text(GlobalString.CHAT.toUpperCase(),style: TextStyle(
              fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold),),
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: tabBarItem,
          actions: <Widget>[
            new IconButton(
              padding: new EdgeInsets.all(15.0),
              icon: new Icon(
                Icons.notifications,
                color: Colors.white,
                ),
              onPressed: null,
              ),
          ],
          ),

        body: new TabBarView(
          controller: tabController,
          children: [
            new ListView(shrinkWrap: true, children: <Widget>[ALL]),
            new ListView(shrinkWrap: true, children: <Widget>[Buying,Buying]),
            new ListView(shrinkWrap: true, children: <Widget>[ALL,ALL,ALL,ALL,ALL,ALL,ALL]),
          ],
          ),

        ),
      );
  }
  Widget _drawer() {
    return new Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text("Mr. "+"Akash Gupta".toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: ColorCode.TextColorCode,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text("gupta.akash555@gmail.com",style: TextStyle(
                  fontSize: 16.0,
                  color: ColorCode.TextColorCode,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              currentAccountPicture:
              CircleAvatar(
                backgroundImage: ExactAssetImage('assets/images/aa.jpg'),
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
              title: Text(GlobalString.Home.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
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
              title: Text(GlobalString.Friend.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
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
              title: Text(GlobalString.Faq.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
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
              title: Text(GlobalString.About.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
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
              title: Text(GlobalString.Terms.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
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
              title: Text(GlobalString.logout.toUpperCase(),style: TextStyle( fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
              onTap: () {
                //Navigator.of(context).pushNamed(Help.tag);
              },
              ),
            Divider(
              height: 2.0,
              ),
          ],
          ));
  }
}
