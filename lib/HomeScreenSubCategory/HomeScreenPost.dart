import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:dealsezy/Model/DiplaySellAddPostScreenModel.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
//-------------------------------------------------------------------------------------------------//
class HomeScreenPost extends StatefulWidget {
  static String tag = 'HomeScreenPost';
  final String value;
  final String value1;
  HomeScreenPost({Key key, this.value,this.value1}) : super(key: key);
  @override
  _HomeScreenPostState createState() => new _HomeScreenPostState();
}

class _HomeScreenPostState extends State<HomeScreenPost> with TickerProviderStateMixin {
  TabController tabController;
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  List<MyAdvsPosts> _list = [];
  List<MyAdvsPosts> _search = [];
  List data;
  var loading = false;
  TextEditingController controller1 = new TextEditingController();
  var ReciveUserID="";
  String errMessage = 'Error Send Data';
  String status = '';
  String ReciveJsonStatus ='';
  String ReciveJsonMSG ='';
  String ReciveJsonRECID ='';
  String ReciveAdv_ID ='';
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/SubCatPosts.php';
  fetchMyAdv() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(url, body: {
      "Token": GlobalString.Token,
      "Sub_Cat_ID": widget.value1.toString()
    }).then((result) {
      print("uploadEndPoint"+url.toString());
      print("Token" + GlobalString.Token);
      print("Sub_Cat_ID" + widget.value1.toString());
      print("statusCode" + result.statusCode.toString());
      print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var data = json.decode(result.body);
      ReciveJsonStatus = data["Status"].toString();
       print("ReciveJsonStatus" + ReciveJsonStatus.toString());

      final extractdata = jsonDecode(result.body);
      data = extractdata["data"];
      print("ReciveData"+data.toString());

    //  _handleReciveFalse();
      setState(() {
        for (Map i in data) {
          _list.add(MyAdvsPosts.formJson(i));
          // loading = false;
        }
      });
    }).catchError((error) {
      setStatus(error);
    });
  }
  //---------------------------------------------------------------------------------------------------//
  void _handleReciveFalse() {
    if(ReciveJsonStatus == "false"){
      print("Okfalse");
      FalseDataDialog();
    }else if(ReciveJsonStatus == "true"){
      print("true");
      fetchMyAdv();
    }
  }
  //---------------------------------------------------------------------------------------------------------//
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
                //Navigator.of(context).pushNamed(Product.tag);
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
//------------------------------------------------------------------------------------------//
  Future<void> FalseDataDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ooops...", textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("No Post Avilable Here..",
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
                Navigator.pop(context, false);
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
  //---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//----------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this._checkInternetConnectivity();
    this.fetchMyAdv();
    super.initState();
  }
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    final listJson =  new Container(
      child: Column(
        children: <Widget>[
          new Container(),
          loading
              ? Center(
            child: CircularProgressIndicator(),
            )
              : Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(4.0),
              //crossAxisSpacing: 10,
              itemCount: _list.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.0, color: Colors.grey),
              itemBuilder: (context, i) {
                //categoryid = data[i]["categoryid"];
                final a = _list[i];
                ReciveAdv_ID = a.Adv_ID.toString();
                // CardItemId = a.id.toString();
                //print("ReciveProductID"+GlobalProductId);
                //print("ItemId"+ItemId);
                return new Container(
                  color: ColorCode.TextColorCode,
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        ReciveAdv_ID =a.Adv_ID.toString().toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                        // print("CatID"+widget.value2.toString());
                        print("Adv_ID"+a.Adv_ID.toString());
                      });
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new DiplaySellAddPostScreen(
                            value1: " ${a.Adv_ID.toString()}"),
                        );
                      Navigator.of(context).push(route);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            //  width: 100.0,
                            height: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                //color: Colors.redAccent,
                                ),
                              child: Image.network(
                                imageurl+a.Image,
                                height: 150.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                                ),
                            ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    a.Title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: ColorCode.TextColorCodeBlue,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                    ),
                                  Text(
                                    "Time  ${a.Post_Time}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: ColorCode.TextColorCodeBlue,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 5,
                                    ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          a.Status,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: ColorCode.AppColorCode,
                                            ),
                                          ),
                                        ),
                                      Icon(
                                        FontAwesomeIcons.rupeeSign,
                                        size: 15,
                                        color: ColorCode.TextColorCodeBlue,
                                        ),
                                      new Text(a.Price.toString(), style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: ColorCode.TextColorCodeBlue,
                                        ),
                                               ),

                                      /*new Text(a.id.toString(), style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color:Color(0xFF222B78),
                                        ),
                                               ),*/
                                      SizedBox(
                                        width: 5,
                                        ),
                                      /*Icon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color:Color(0xFFE0318C),
                                        ),*/
                                    ],
                                    ),
                                  /*     SizedBox(
                                    height: 5,
                                    ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:Color(0xFF222B78),
                                            ),
                                          ),
                                        ),

                                      *//*Container(
                                        color:Color(0xFFE0318C),
                                        child: IconButton(
                                          icon: Icon(Icons.remove,color: Colors.white,),
                                          *//**//*onPressed: () {
                                            setState(() {

                                              CardItemId = (data[i][
                                              "Id"]);
                                              //if you want to assign the index somewhere to check
                                              //print("OnTapProductId"+GlobalProductId.toString());
                                            });
                                            RemoveProductCount();
                                            _RemoveProductItemAlert();
                                            //print("hello");
                                            // model.removeProduct(model.cart[index]);
                                          },*//**//*
                                          ),
                                        ),*//*
                                      *//*Container(
                                        color:Color(0xFFE0318C),
                                        child: IconButton(
                                          icon: Icon(Icons.add,color: Colors.white,),
                                         *//**//* onPressed: () {
                                            setState(() {

                                              GlobalProductId = (data[i][
                                              "product_id"]);
                                              //if you want to assign the index somewhere to check
                                              print("OnTapProductId"+GlobalProductId.toString());
                                            });
                                            AddProductCount();
                                            _AddProductItemAlert();
                                            //print("hello");
                                            // model.removeProduct(model.cart[index]);
                                          },*//**//*
                                          ),
                                        ),*//*
                                     *//* Container(
                                        color:Color(0xFFE0318C),
                                        child: IconButton(
                                          icon: Icon(Icons.delete,color: Colors.white,),
                                          *//**//*onPressed: () {
                                            setState(() {

                                              GlobalProductId = (data[i][
                                              "product_id"]);
                                              //if you want to assign the index somewhere to check
                                              //print("OnTapProductId"+GlobalProductId.toString());
                                            });
                                            DeleteProductItem();
                                            _DeleteProductItemAlert();
                                            //print("hello");
                                            // model.removeProduct(model.cart[index]);
                                          },*//**//*
                                          ),
                                        ),*//*
                                      *//*SizedBox(
                                        width: 5,
                                        ),*//*
                                      *//*Icon(
                                        FontAwesomeIcons.trash,
                                        size: 18,
                                        color:Color(0xFFE0318C),
                                        ),*//*
                                    ],
                                    ),*/
                                ],
                                ),
                              ),
                            ),

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
    return Scaffold(
     // drawer: _drawer(),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(GlobalString.SubPost.toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
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
                              "",
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
      body: listJson,
      );
  }
  //-------------------------------------------------------------------------------//
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
