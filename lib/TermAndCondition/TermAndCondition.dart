import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
//-------------------------------------------------------------------------------------------//
class TermAndCondition extends StatefulWidget {
  static String tag = 'TermAndCondition';
//-------------------------------------------------------------------------------------------//
  @override
  _TermAndCondition createState() => new _TermAndCondition();
}
//-------------------------------------------------------------------------------------------//
class _TermAndCondition extends State<TermAndCondition> {
  String status = '';
  String errMessage = 'Error Send Data';
  var ReciveUserEmail='';
  var ReciveUserFullName='';
  var ReciveUserID='';
  var data;
  var loading = false;
  var ReciveJsonData='';
//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//
  String TermAndConditionurl ='http://192.168.0.200/anuj/Dealseazy/Dealsezy/dealseazyApp/TermAndCondition.php';
  fetchTermAndConditionurl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    ReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(TermAndConditionurl, body: {
      "Token": GlobalString.Token,
    }).then((resultMyProfile) {
      /*print("uploadEndPoint"+AboutUsurl.toString());
      print("Token" + GlobalString.Token);
      print("statusCode" + resultMyProfile.statusCode.toString());*/
      // print("resultbody" + resultMyProfile.body);
      //return result.body.toString();
      setStatus(resultMyProfile.statusCode == 200 ? resultMyProfile.body : errMessage);
      setState(() {
        var extractdata = json.decode(resultMyProfile.body);
        data = extractdata["JSONDATA"];
       // print("ReciveData"+data.toString());
        ReciveJsonData = data[0]["TermandCondition"];
       // print("ReciveJsonData"+ReciveJsonData.toString());
      });

    }).catchError((error) {
      setStatus(error);
    });
  }
//---------------------------------------------------------------------------------------------------//
/*  void _handleSubmitted() {
    //print("hellooo");
    if(ReciveJsonStatus == "true"){
      //print("hello"+ReciveJsonStatus);
      fetchPost();
    }else if(ReciveJsonStatus == "false"){
      // print(ReciveJsonStatus);
      _LoadDataAlert();
      // print(ReciveJsonStatus);
    }
  }*/
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
    this.fetchTermAndConditionurl();
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(HomeScreen.tag);
  }
//-------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _id;
//-------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final AboutUs = new Padding(
        padding: EdgeInsets.all(0.0),
        child:   new Container(
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: EdgeInsets.only(top:10.0),
            child: new Card(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    leading: Icon(FontAwesomeIcons.addressCard,size: 30.0,color:ColorCode.TextColorCodeBlue,),

                    title: new Text(
                      "Term and Condition".toUpperCase(),textAlign: TextAlign.start,
                      style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                      ),
                    //trailing: Icon(Icons.keyboard_arrow_right,color: ColorCode.TextColorCodeBlue,),

                    subtitle: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(ReciveJsonData.toString(),overflow: TextOverflow.ellipsis,maxLines: 100,
                                       style: new TextStyle(
                                           fontSize: 13.0, fontWeight: FontWeight.normal,color: ColorCode.TextColorCodeBlue)),
                        ]),
                    )
                ],
                ),
              ),
            ),
          )
        );
//-------------------------------------------------------------------------------------------//
    return new WillPopScope(
      //onWillPop: () => BackScreen(context),
      child:  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(GlobalString.TermAndCondition.toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
          centerTitle: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
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
        body: AboutUs,),
      );
  }
//-------------------------------------------------------------------------------------------//
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