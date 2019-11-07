import 'dart:async';
import 'package:dealsezy/AboutUs/AboutUsScreen.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealsezy/SplashScreen/SplashScreen.dart';
import 'package:dealsezy/SubCategoryScreen/SubCategoryItem.dart';
import 'package:dealsezy/TermAndCondition/TermAndCondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dealsezy/Model/CategoriesModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
//----------------------------------------------------------------------------------------------//
class SellScreen extends StatefulWidget {
  static String tag = 'SellScreen';
  final String value;
  SellScreen({Key key, this.value}) : super(key: key);
  @override
  SellScreenState createState() => new SellScreenState();
}
//----------------------------------------------------------------------------------------------//
class SellScreenState extends State<SellScreen>{
  TextEditingController controller1 = new TextEditingController();
  List<Posts> _list = [];
  List<Posts> _search = [];
  List data;
  String ProductName="";
  var loading = false;
  String status = '';
  String errMessage = 'Error Send Data';
  String ReciveJsonStatus ='';
  String Cat_ID ='';
  var ReciveUserID="";
  var ReciveUserEmail="";
  var ReciveUserFullName="";
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/Categories.php';
  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    ReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    http.post(url, body: {
      "Token": GlobalString.Token
    }).then((result) {
      // print("uploadEndPoint"+url.toString());
     // print("Token" + GlobalString.Token);
      //print("statusCode" + result.statusCode.toString());
     // print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var data = json.decode(result.body);
      ReciveJsonStatus = data["Status"].toString();
     // print("Status     " + ReciveJsonStatus.toString());

      final extractdata = jsonDecode(result.body);
      data = extractdata["data"];
     // print("ReciveData"+data.toString());

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
//----------------------------------------------------------------------------------------------//
  void _handleSubmitted() {
    if(ReciveJsonStatus == "true"){
    //  print(ReciveJsonStatus);
      fetchData();
    }else if(ReciveJsonStatus == "false"){
     // print(ReciveJsonStatus);
      _LoadDataAlert();
    //  print(ReciveJsonStatus);
    }
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
                                                 color:ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("No Data Found".toString(),
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color:ColorCode.TextColorCodeBlue,
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
                                                         color:ColorCode.TextColorCodeBlue,
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
    super.initState();
    this.fetchData();
  }
//----------------------------------------------------------------------------------------------//
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
//----------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _Cat_ID;
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//----------------------------------------------------------------------------------------------//
    final headerList =  GridView.builder(
      itemCount: _list.length,
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        ),
      itemBuilder: (context, i) {
        final b = _list[i];
        Cat_ID = b.Cat_ID.toString();
       // print("Cat_ID"+Cat_ID);
        return new Container(
          child: new GestureDetector(
            onTap: () {
           //   print("Cat_ID"+b.Cat_ID.toString().toString());
              setState(() {
                Cat_ID = b.Cat_ID.toString(); //if you want to assign the index somewhere to check
             //   print("CatID"+b.Cat_ID.toString());
              });
              var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                new SubCategoryItem(
                    value: b.Cat_ID.toString(),
                    value2: " ${ b.Cat_ID.toString() }"),
                );
              Navigator.of(context).push(route);
            },
            child: Center(
              child: GridTile(
                footer: Text(
                  b.Cat_Name.toUpperCase(),
                  textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                                 fontSize: 9,
                                                                 letterSpacing: 0.27,),
                  ),
                /* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*/
                child: Icon(_categories[i]['icon'],size: 30.0,color:ColorCode.TextColorCodeBlue,),
                ),
              ),
            ),
          margin: EdgeInsets.all(1.0),
          );
      },);

//---------------------------------------------------------------------------------------------//
    return new WillPopScope(
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: Scaffold(
        drawer: _drawer(),
        appBar: new AppBar(
          title: Text(GlobalString.SELL.toUpperCase(),style: TextStyle(
              fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold),),
          iconTheme: new IconThemeData(color: Colors.white),
          centerTitle: true,
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
        // backgroundColor:ColorCode.AppColorCode,
        body: new Container(
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 0.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                   new Container(
                      height: 500.0, width: _width, child: headerList),
                  ],
                  ),
                ),
            ],
            ),
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
              accountName: Text("Mr. "+ReciveUserFullName.toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: ColorCode.TextColorCode,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text(ReciveUserEmail,style: TextStyle(
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
//---------------------------------------------------------------------------------------------------//
  void TapMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Want to logout?'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              removeData(context);
            },
            child: new Text('OK'))
      ],
      );
    showDialog(context: context, child: alert);
  }
  //---------------------------------------------------------------------------------------------------//
  removeData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_UserStatus);
    Navigator.of(context).pushNamed(SplashScreen.tag);
  }
}
//----------------------------------------------------------------------------------------------//