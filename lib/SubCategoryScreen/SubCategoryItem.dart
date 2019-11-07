import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SellScreenDetails/SellAddPostScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Model/SubCategoryModel.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:connectivity/connectivity.dart';
//-------------------------------------------------------------------------------------------//
class SubCategoryItem extends StatefulWidget {
  static String tag = 'SubCategoryItem';
  final String value;
  final String value1;
  final String value2;
//-------------------------------------------------------------------------------------------//
  SubCategoryItem({Key key, this.value, this.value1, this.value2}) : super(key: key);
  @override
  _SubCategoryItem createState() => new _SubCategoryItem();
}
//-------------------------------------------------------------------------------------------//
class _SubCategoryItem extends State<SubCategoryItem> {
  List data;
  String categoryid;
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String CountProduct = '';
  String Userid = '';
  String ReciveCount = '';
  String IconfromApi = '';
  final String phone = 'tel:+917000624695';
  String ProfileName="" ;
  String ProfileData = '';
  String ProfileMobile;
  String ProfileAddress = '';
  String ProfileStatus = '';
  String ProfileUserType = '';
  String ProfileEmail = '';
  String status = '';
  String errMessage = 'Error Send Data';
  String ReciveJsonStatus ='';
  String Cat_ID ='';
  String SubCat_ID ='';
//---------------------------------------------------------------------------------------------------//
  List<Map<String, IconData>> _categories = [
    {
      'icon': FontAwesomeIcons.car,
    },
    {
      'icon': FontAwesomeIcons.building,
    },
    {
      'icon': FontAwesomeIcons.couch,
    },
    {
      'icon': FontAwesomeIcons.mobileAlt,
    },
    {
      'icon': FontAwesomeIcons.bolt,
    },
    {
      'icon': FontAwesomeIcons.conciergeBell,
    },
    {
      'icon': FontAwesomeIcons.tshirt,
    },
    {
      'icon': FontAwesomeIcons.gem,
    },
    {
      'icon': FontAwesomeIcons.lifeRing,
    },
    {
      'icon': FontAwesomeIcons.book,
    },
    {
      'icon': FontAwesomeIcons.dog,
    },
    {
      'icon': FontAwesomeIcons.servicestack,
    },
    {
      'icon': FontAwesomeIcons.building,
    },
    {
      'icon': FontAwesomeIcons.couch,
    },
    {
      'icon': FontAwesomeIcons.mobileAlt,
    },
    {
      'icon': FontAwesomeIcons.cuttlefish,
    },
    {
      'icon': FontAwesomeIcons.tshirt,
    },
    {
      'icon': FontAwesomeIcons.ring,
    },
    {
      'icon': FontAwesomeIcons.gem,
    },
    {
      'icon': FontAwesomeIcons.book,
    },
    {
      'icon': FontAwesomeIcons.dog,
    },
    {
      'icon': FontAwesomeIcons.servicestack,
    },
  ];
//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//

    String url = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/SubCategories.php';
  fetchPost() {
    http.post(url, body: {
      "Token": GlobalString.Token,
      "CAT_ID": widget.value2.toString(),

    }).then((result) {
    //  print("url"+url.toString());
    //  print("Token" + GlobalString.Token);
    //  print("statusCode" + result.statusCode.toString());
    //  print("CAT_ID" +widget.value2.toString());
     // print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var data = json.decode(result.body);
      ReciveJsonStatus = data["Status"].toString();
      //print("Status     " + ReciveJsonStatus.toString());

      final extractdata = jsonDecode(result.body);
      data = extractdata["data"];
      //print("ReciveData"+data.toString());
      // _handleSubmitted();

      setState(() {
        for (Map i in data) {
          _list.add(Posts.formJson(i));
          // loading = false;
        }
      });
    }).catchError((error) {
      setStatus(error);
    });
  }

  void _handleSubmitted() {
    //print("hellooo");
    if(ReciveJsonStatus == "true"){
      print("hello"+ReciveJsonStatus);
      fetchPost();
    }else if(ReciveJsonStatus == "false"){
     // print(ReciveJsonStatus);
      _LoadDataAlert();
     // print(ReciveJsonStatus);
    }
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
    this.fetchPost();
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
              itemCount: _list.length,
              itemBuilder: (context, i) {
                final a = _list[i];
                //print("SubCat_ID"+a.SubCat_ID);
                return new Container(
                  child: new GestureDetector(
                    onTap: () {
                  //    print("Cat_ID"+widget.value2.toString());
                  //    print("SubCat_ID"+a.SubCat_ID.toString());
                      setState(() {
                        Cat_ID = widget.value2.toString(); //if you want to assign the index somewhere to check
                        SubCat_ID = a.SubCat_ID.toString(); //if you want to assign the index somewhere to check
                       // print("CatID"+widget.value2.toString());
                       // print("SubCat_ID"+widget.value2.toString());
                      });
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new SellAddPostScreen(
                            value1: a.SubCat_ID.toString(),
                            value2: " ${widget.value2.toString()}"),
                        );
                      Navigator.of(context).push(route);
                    },
                    child: new Card(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            //leading: Icon(_categories[i]['icon'],size: 30.0,color:ColorCode.TextColorCodeBlue,),

                            title: new Text(
                              a.SubCat_Name.toUpperCase(),textAlign: TextAlign.start,
                              style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: ColorCode.TextColorCodeBlue),
                              ),
                            trailing: Icon(Icons.keyboard_arrow_right,color: ColorCode.TextColorCodeBlue,),
                            /* subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('CatID: '+a.Cat_ID,
                                  style: new TextStyle(
                                      fontSize: 13.0, fontWeight: FontWeight.normal,color: ColorCode.TextColorCodeBlue)),
                            ]),*/
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
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(GlobalString.SUBCATEGORY.toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
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
                              ReciveCount.toString(),
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