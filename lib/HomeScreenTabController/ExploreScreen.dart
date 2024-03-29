import 'dart:async';
import 'package:dealsezy/AboutUs/AboutUsScreen.dart';
import 'package:dealsezy/CategoriesScreen/Categories.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealsezy/HomeScreenSubCategory/HomeScreenSubCategory.dart';
import 'package:dealsezy/SeeAllScreenTag/SeeAllScreen.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
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
import 'package:dealsezy/Model/DiplaySellAddPostScreenModel.dart';
import 'package:dealsezy/Model/ExploresCategoriesModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:dealsezy/ConstantServerBasedUrl/ConstantURL.dart';
import 'package:dealsezy/Model/CategoriesModel.dart';
import 'package:connectivity/connectivity.dart';
//----------------------------------------------------------------------------------------------//
class ExploreScreen extends StatefulWidget {
  static String tag = 'ExploreScreen';
  final String value;
  ExploreScreen({Key key, this.value}) : super(key: key);
  @override
  ExploreScreenState createState() => new ExploreScreenState();
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
    'icon': FontAwesomeIcons.bolt,
  },
  {
    'icon': FontAwesomeIcons.conciergeBell,
  },
  {
    'icon': FontAwesomeIcons.accusoft,
  },
  {
    'icon': FontAwesomeIcons.gem,
  },
  {
    'icon': FontAwesomeIcons.book,
  },
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
    'icon': FontAwesomeIcons.bolt,
  },
  {
    'icon': FontAwesomeIcons.conciergeBell,
  },
  {
    'icon': FontAwesomeIcons.accusoft,
  },
  {
    'icon': FontAwesomeIcons.gem,
  },
  {
    'icon': FontAwesomeIcons.book,
  },
];
//----------------------------------------------------------------------------------------------//
class ExploreScreenState extends State<ExploreScreen>{
  TextEditingController controller1 = new TextEditingController();
  List<MyAdvsPosts> _list = [];
  List<MyAdvsPosts> _search = [];
  List<Posts> _listCategory = [];
  List<Posts> _searchCategory = [];
  List data;
  String ProductName="";
  var loading = true;
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  String GetLoginUserID="";
  String status = '';
  String errMessage = 'Error Send Data';
  String ReciveJsonStatus ='';
  String Cat_ID ='';
  var ReciveUserID="";
  var ReciveUserEmail="";
  var ReciveUserFullName="";
  String ReciveAdv_ID ='';
//---------------------------------------------------------------------------------------------------//
  String resultMyAdvurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/HomePageAdv.php';
  fetchMyAdv() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    ReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    print("Akash"+ReciveUserFullName);
    http.post(resultMyAdvurl, body: {
      "Token": GlobalString.Token,
      "User_ID": ReciveUserID.toString()
    }).then((resultMyAdv) {
      //print("uploadEndPoint"+resultMyAdvurl.toString());
      //print("Token" + GlobalString.Token);
      //print("statusCode" + resultMyAdv.statusCode.toString());
      //print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(resultMyAdv.statusCode == 200 ? resultMyAdv.body : errMessage);
      var data = json.decode(resultMyAdv.body);
      ReciveJsonStatus = data["Status"].toString();
      //print("MyAdvReciveJsonStatus" + ReciveJsonStatus.toString());

      final extractdata = jsonDecode(resultMyAdv.body);
      data = extractdata["JSONDATA"];
      //print("MyAdvReciveData"+data.toString());
      //_handleReciveFalse();
      setState(() {
        for (Map i in data) {
          _list.add(MyAdvsPosts.formJson(i));
           loading = false;
        }
      });
    }).catchError((error) {
      setStatus(error);
    });
  }//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/HomePageCat.php';
  fetchPost() {
    http.post(url, body: {
      "Token": GlobalString.Token
    }).then((result) {
      // print("uploadEndPoint"+url.toString());
     // print("Token" + GlobalString.Token);
      //print("statusCode" + result.statusCode.toString());
      //print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var dataCategory = json.decode(result.body);
      ReciveJsonStatus = dataCategory["Status"].toString();
    //  print("Status     " + ReciveJsonStatus.toString());

      final extractdata = jsonDecode(result.body);
      dataCategory = extractdata["data"];
     // print("ReciveData"+data.toString());
      // _handleSubmitted();
      setState(() {
        for (Map i in dataCategory) {
          _listCategory.add(Posts.formJson(i));
          loading = false;
        }
      });
    }).catchError((error) {
      setStatus(error);
    });
  }
//----------------------------------------------------------------------------------------------//
  void _handleSubmitted() {
    //print("hellooo");
    if(ReciveJsonStatus == "true"){
     // print("hello"+ReciveJsonStatus);
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
//-----------------------------------------fetchData()-----------------------------------------------------//
  @override
  void initState() {
    this._checkInternetConnectivity();
    super.initState();
    this.fetchMyAdv();
    this.fetchPost();
  }
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final studentdetailtab = new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  GlobalString.Categories.toUpperCase(),
                  style: TextStyle(
                      color:ColorCode.TextColorCodeBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  ),
                new GestureDetector(
                  onTap: () {
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new SeeAllScreen()
                  );
                  Navigator.of(context).push(route);
                },
                  child: new Text(
                      GlobalString.Seeall.toUpperCase(),
                      style: TextStyle(
                          color:ColorCode.TextColorCodeBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  ),
              ],
              ),
            ),
        ],
        ),
      );
//----------------------------------------------------------------------------------------------//
    final headerList =  new Container(
      child: Column(
        children: <Widget>[
          loading
              ? Center(
            child: CircularProgressIndicator(),
            )
              : Expanded(
            child: GridView.builder(
              itemCount: _listCategory.length,
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,

                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                ),
                itemBuilder: (context, i) {
                  final b = _listCategory[i];
                  Cat_ID = b.Cat_ID.toString();
                  // print("Cat_ID"+Cat_ID);
                  return new Container(
                    child: new GestureDetector(
                      onTap: () {
                        //  print("Cat_ID"+b.Cat_ID.toString().toString());
                        setState(() {
                          Cat_ID = b.Cat_ID.toString(); //if you want to assign the index somewhere to check
                          //  print("CatID"+b.Cat_ID.toString());
                        });
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new HomeScreenSubCategory(
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
                          child: Icon(_categories[i]['icon'],size: 30.0,color:ColorCode.TextColorCodeBlue,),
                          ),
                        ),
                      ),
                    margin: EdgeInsets.all(1.0),
                    );
                }
              ),
            ),
        ],
        ),
      );

//---------------------------------------------------------------------------------------------//
    return new WillPopScope(
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: Scaffold(
        drawer: _drawer(),
        appBar: new AppBar(
          title: new Container(
            color: Colors.transparent,
            width: _width / 0,
            height: 40,
            child: new TextField(
              //cursorColor: Colors.white,
              controller: controller1,
                textAlign: TextAlign.center,
                // onChanged: onSearch,
                decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Search ",hintStyle: TextStyle(fontSize: 15.0, color: ColorCode.TextColorCode,fontWeight: FontWeight.w500),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,color: ColorCode.TextColorCode,
                      size: 28.0,
                      ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel,color: ColorCode.TextColorCode,),
                      onPressed: () {
                        //controller.clear();
                        // onSearch('');
                      },)
                    ),
              ),
            ),
          iconTheme: new IconThemeData(color: ColorCode.TextColorCode,),
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
                    /* new Divider(
                      color:ColorCode.AppColorCode,
                      ),*/
                    //SizedBox(height: 1.0),
                    new Container(
                      //color: Colors.grey,
                      height: 50.0, width: _width, child: studentdetailtab),
                    new Container(
                      //color: Colors.grey,
                      height: 230.0, width: _width, child: headerList),

                    //SizedBox(height: 1.0),
                    new Divider(
                      color:ColorCode.TextColorCodeBlue,
                      ),

                    loading
                        ? Center(
                      child: CircularProgressIndicator(backgroundColor: ColorCode.AppColorCode),
                      ): Expanded(child:
                                  GridView.builder(
                                      padding: const EdgeInsets.all(5),
                                      itemCount: _list.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        //padding: EdgeInsets.all(4.0),
                                        /*childAspectRatio: 8.0 / 9.0,*/),
                                      itemBuilder: (context, i) {
                                        final a = _list[i];
                                        return new Container(
                                          child: new GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ReciveAdv_ID =a.Adv_ID.toString().toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                                                // print("CatID"+widget.value2.toString());
                                                print("DiplaySellAddPostScreenAdv_ID"+a.Adv_ID.toString());
                                              });
                                              var route = new MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                new DiplaySellAddPostScreen(
                                                    value1: " ${a.Adv_ID.toString()}"),
                                                );
                                              Navigator.of(context).push(route);
                                            },
                                            child: new Card(
                                              //color: Colors.white70,
                                                elevation: 1,
                                                child: new Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisSize: MainAxisSize.min,
                                                  verticalDirection: VerticalDirection.down,
                                                  children: <Widget>[
                                                    new Image.network(
                                                      imageurl+a.Image,
                                                      height: 150.0,
                                                      width: 100.0,
                                                      fit: BoxFit.cover,
                                                      ),
                                                    new Padding(
                                                      padding: EdgeInsets.only(top: 0.0),
                                                      child: new Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          new Text(a.Title.toUpperCase().toString(),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle( fontWeight: FontWeight.bold,
                                                                                                                                                           fontSize: 14,
                                                                                                                                                           color: ColorCode.TextColorCodeBlue,),),
                                                          /*new Text(country.nativeName),
                                                          new Text(country.capital),*/
                                                        ],
                                                        ),
                                                      )
                                                  ],
                                                  )),
                                            ),

                                          );
                                      }))
                  ],
                  ),
                ),
            ],
            ),
          ),

        ),
      );
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