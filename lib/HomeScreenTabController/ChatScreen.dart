import 'package:dealsezy/AboutUs/AboutUsScreen.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/HomeScreenTabController/SellScreen.dart';
import 'package:dealsezy/Model/ChatReciveDataModel.dart';
import 'package:dealsezy/SubCategoryScreen/SubCategoryItem.dart';
import 'package:dealsezy/TermAndCondition/TermAndCondition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Model/ChatUserShowModel.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
//-------------------------------------------------------------------------------------------//
class ChatScreen extends StatefulWidget {
  static String tag = 'ChatScreen';
  final String value;
//-------------------------------------------------------------------------------------------//
  ChatScreen({Key key, this.value}) : super(key: key);
  @override
  _ChatScreen createState() => new _ChatScreen();
}
//-------------------------------------------------------------------------------------------//
class _ChatScreen extends State<ChatScreen> {
  var data;
  var RecivedataFromServer;
  String categoryid;
  List<ChatUserShowModel> _ChatReciveDatalist = [];
  var loading = true;
  String status = '';
  String errMessage = 'Error Send Data';
  var ReciveUserEmail="";
  var ReciveUserFullName="";
  var ReciveUserID="";
  var ReciveAdv_Title="";
  //final List<String> products;
//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//
  String ChatReciveurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/ChatList.php';
  fetchChatReciveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    ReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    http.post(ChatReciveurl, body: {
      "Token": GlobalString.Token,
      "UserID": ReciveUserID.toString()
    }).then((result) {
       print("uploadEndPoint"+ChatReciveurl.toString());
       print("Token" + GlobalString.Token);
       print("UserID" +  ReciveUserID.toString());
       print("statusCode" + result.statusCode.toString());
       //print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);

       print("jsonresp ${result.body}");
       data = json.decode(result.body);

       RecivedataFromServer =data["data"];
       print("RecivedataFromServer $RecivedataFromServer}");

       setState(() {
         for (Map i in RecivedataFromServer) {
           _ChatReciveDatalist.add(ChatUserShowModel.formJson(i));
            loading = false;
         }
       });
    }).catchError((error) {
      setStatus(error);
    });
  }
  //----------------------------------------------------------------------------------------------------------//
  void _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(
          'No internet',
          "You're not connected to a network"
          );
    } /*else if (result == ConnectivityResult.mobile) {
      _showDialog(
          'Internet access',
          "You're connected over mobile data"
          );
    } else if (result == ConnectivityResult.wifi) {
      _showDialog(
          'Internet access',
          "You're connected over wifi"
          );
    }*/
  }
  //--------------------------------------------------------------------------------------------------------//
  Future<void> _showDialog(title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Internet Warning", textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(title.toString(),
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color: ColorCode.TextColorCodeBlue,
                                                fontWeight: FontWeight.bold),),
              ],
              ),
            ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                //("hello123"+id.toString());
                Navigator.of(context).pop();
              },
              child: Text('Ok', style: new TextStyle(fontSize: 15.0,
                                                         color: ColorCode.TextColorCodeBlue,
                                                         fontWeight: FontWeight
                                                             .bold),),
              ),
          ],
          );
      },
      );
  }
  //--------------------------------------------------------------------------------------------------------//
  Future<void> _LoadDataAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something Wrong ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("No Data Found",
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color: ColorCode.TextColorCodeBlue,
                                                fontWeight: FontWeight.bold),),
              ],
              ),
            ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                //("hello123"+id.toString());

                Navigator.of(context).pop();
              },
              child: Text('OK', style: new TextStyle(fontSize: 15.0,
                                                         color: ColorCode.TextColorCodeBlue,
                                                         fontWeight: FontWeight
                                                             .bold),),
              ),
          ],
          );
      },
      );
  }
//-------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this._checkInternetConnectivity();
    super.initState();
    this.fetchChatReciveData();
  }
//---------------------------------------------------------------------------------------------------//
  /*Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(SellScreen.tag);
  }*/
//-------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _id;
//-------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final listJson =  new Container(
      child: Column(
        children: <Widget>[
          new Container(),
          loading
              ? Center(
            child: CircularProgressIndicator(),
            )
              : Expanded(
            child: ListView.builder(

              padding: const EdgeInsets.all(4.0),
              //crossAxisSpacing: 10,
              itemCount: _ChatReciveDatalist == null ? 0 : _ChatReciveDatalist.length,
              itemBuilder: (context, i) {
                final ReciveData = _ChatReciveDatalist[i];
                return new Container(
                  child: new GestureDetector(
                 /*   onTap: () {
                      // print("Cat_ID"+a.Cat_ID.toString().toString());
                      setState(() {
                        Cat_ID = a.Cat_ID.toString(); //if you want to assign the index somewhere to check
                        // print("CatID"+a.Cat_ID.toString());
                      });
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new SubCategoryItem(
                            value: a.Cat_ID.toString(),
                            value2: " ${ a.Cat_ID.toString() }"),
                        );
                      Navigator.of(context).push(route);
                    },*/
                    child: new Card(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: Image.asset(
                              'assets/images/communication.png',
                              height: 250.0,
                              width: 50.0,
                              ),
                            title: new Text(
                              ReciveData.toName.toString().toUpperCase(),textAlign: TextAlign.start,
                              style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                              ),
                            trailing: Icon(Icons.keyboard_arrow_right,color: ColorCode.TextColorCodeBlue,),
                            subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(ReciveData.advTitle,
                                  style: new TextStyle(
                                      fontSize: 13.0, fontWeight: FontWeight.normal,color: ColorCode.TextColorCodeBlue)),
                            ]),
                            )
                        ],
                        ),
                      ),
                    ),

                  );
              },
              ),
            ),
        ],
        ),
      );
//-------------------------------------------------------------------------------------------//
    return  Scaffold(
      drawer: _drawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(GlobalString.Chattitle.toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
        centerTitle: true,
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(
                padding: new EdgeInsets.all(15.0),
                icon: new Icon(
                  Icons.notifications,
                  color: Colors.white,
                  ),
                /*onPressed: () {
                    //print("hello"+id.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryTotalAddList(
                            value: Userid.toString(),
                            )),
                      );
                  },*/
                ),
              new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      new Icon(null),
                      new Positioned(
                          top: 5.0,
                          right: 5,
                          child: new Center(
                            child: new Text(
                              "".toString(),
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                              ),
                            )),
                    ],
                    )),
            ],
            ),
        ],
        ),
      backgroundColor: Colors.white,
      body: listJson,);
  }
//-------------------------------------------------------------------------------------------//
  Widget _drawer() {
    return new Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text("Mr. "+ReciveUserFullName.toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: ColorCode.TextColorCode,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text(ReciveUserEmail.toString(),style: TextStyle(
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
                Navigator.of(context).pushNamed(AboutUsScreen.tag);
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
                Navigator.of(context).pushNamed(TermAndCondition.tag);
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
                TapMessage(context, "Logout!");
              },
              ),
            Divider(
              height: 2.0,
              ),
          ],
          ));
  }
//-------------------------------------------------------------------------------------------//
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
//-------------------------------------------------------------------------------------------//
  removeData() async {
    /* final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    Navigator.of(context).pushNamed(Splash.tag);*/
  }
}
//-------------------------------------------------------------------------------------------//