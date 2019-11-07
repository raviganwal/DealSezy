import 'dart:async';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealsezy/SubCategoryScreen/SubCategoryItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dealsezy/Model/CategoriesModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/Categories.php';
  fetchData() {
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
  @override
  void initState() {
    super.initState();
    this.fetchData();
  }
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
                    /* new Divider(
                      color:ColorCode.AppColorCode,
                      ),*/
                    //SizedBox(height: 1.0),
                   /* new Container(
                      //color: Colors.grey,
                      height: 50.0, width: _width, child: studentdetailtab),*/
                   new Container(
                      //color: Colors.grey,
                      height: 500.0, width: _width, child: headerList),

                    //SizedBox(height: 1.0),
                   /* new Divider(
                      color:ColorCode.TextColorCodeBlue,
                      ),*/

                  ],
                  ),
                ),
            ],
            ),
          ),

        ),
      );
  }
/*//-------------------------------------------------------------------------------------------//
  Widget _buildContainerPROPERTIES() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

      child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.PROPERTIES.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.building,
                        size: 30.0, color:ColorCode.TextColorCodeBlue,),
          ),
        ),
        ),
      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),

      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerCARS() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },
      child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.CARS.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.car,
                        size: 30.0,color:ColorCode.TextColorCodeBlue,),
          ),
        ),
        ),
      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerFURNITURE() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

    child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.FURNITURE.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.couch,
                        size: 30.0, color:ColorCode.TextColorCodeBlue,),
          ),
        ),
        ),
      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerJOBS() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

    child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.JOBS.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.userMd,
                        size: 30.0, color:ColorCode.TextColorCodeBlue,),
          ),
        ),
        ),
      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerELECTRONICS() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

    child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.ELECTRONICS.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.chargingStation,
                        size: 30.0,color:ColorCode.TextColorCodeBlue,),
          ),
        ),
        ),
      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerMOBILES() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

    child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.MOBILES.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.mobileAlt,
                        size: 30.0,color:ColorCode.TextColorCodeBlue,),
          ),
        ),
        ),
      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerBIKES() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

    child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.BIKE.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.biking,
                        size: 30.0, color:ColorCode.TextColorCodeBlue,),
          ),
        ),
      //color: Colors.blue[400],
        ),
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerBOOKS() {
    return  Container(
        child: new GestureDetector(
        onTap: () {

      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new SellScreenCategoryList(),
        );
      Navigator.of(context).push(route);
    },

    child: Center(
        child: GridTile(
          footer: Text(
            GlobalString.BOOKS.toUpperCase(),
            textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                           fontSize: 9,
                                                           letterSpacing: 0.27,),
            ),
          *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
          child: Icon(FontAwesomeIcons.book,
                        size: 30.0, color:ColorCode.TextColorCodeBlue,),
          ),
        ),
      //color: Colors.blue[400],
        ),
      margin: EdgeInsets.all(1.0),
      );
  }
//-------------------------------------------------------------------------------------------//
  Widget _buildContainerFASHION() {
    return  Container(
        child: new GestureDetector(
          onTap: () {

            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new SellScreenCategoryList(),
              );
            Navigator.of(context).push(route);
          },
          child: Center(
            child: GridTile(
              footer: Text(
                GlobalString.FASHION.toUpperCase(),
                textAlign: TextAlign.center,style: TextStyle(color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.normal,
                                                               fontSize: 9, letterSpacing: 0.27,),
                ),
              *//* header: Text(
            'SubItem',
            textAlign: TextAlign.center,
            ),*//*
              child: Icon(FontAwesomeIcons.tshirt,
                            size: 30.0, color:ColorCode.TextColorCodeBlue,),
              ),
            ),
        ),
      //padding: const EdgeInsets.all(0.0),

      //color: Colors.blue[400],
      margin: EdgeInsets.all(1.0),
      );
  }*/
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
//----------------------------------------------------------------------------------------------//
class ExploreScreenDetails extends StatelessWidget {
  ExploreScreenDetails(this.data);
  final data;
  String imageurl = 'https://gravitinfosystems.com/MDNS/uploads/';
  CarouselSlider carouselSlider;
  int _current = 0;

  List imgList = [
    'https://gravitinfosystems.com/MDNS/uploads/biotique-apricot-body-wash-transparent-200-ml-beauty-biotique-2_480x480.jpg',
    'https://gravitinfosystems.com/MDNS/uploads/71Hr2O6-4gL__SL1500_.jpg',
    'https://gravitinfosystems.com/MDNS/uploads/images.jpg',
    'https://gravitinfosystems.com/MDNS/uploads/s-l1000.jpg',
    'https://gravitinfosystems.com/MDNS/uploads/images_(1)1.jpg'
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
  @override
  Widget build(BuildContext context) => new Scaffold(

    backgroundColor: ColorCode.TextColorCode,
    /*appBar: new AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      title: new Padding(
        padding: const EdgeInsets.all(0.0),
        child: new Container(
          color: Colors.transparent,
          child: Text(
              "Add cart".toUpperCase()),
          ),
        ),
      centerTitle: true,
      actions: <Widget>[
        new Stack(
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.shopping_cart,
                color: Colors.white,
                ),
              onPressed: null,
              ),
            new Positioned(
                child: new Stack(
                  children: <Widget>[
                    new Icon(Icons.brightness_1,
                                 size: 20.0, color: Colors.grey),
                    new Positioned(
                        top: 5.0,
                        right: 6,
                        child: new Center(
                          child: new Text(
                            '10',
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
      ),*/

    body: new Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              new Padding(
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
                          new GestureDetector(
                            onTap: () {
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new HomeScreen()
                                  );
                              Navigator.of(context).push(route);
                            },
                            child: new Icon(
                              Icons.arrow_back,color: ColorCode.TextColorCodeBlue,
                              //size: 15.0,
                              ),
                            ),
                          new Stack(
                            children: <Widget>[
                              new IconButton(
                                padding: new EdgeInsets.only(left:18.0),
                                icon: new Icon(
                                  Icons.shopping_cart,
                                  color: ColorCode.TextColorCodeBlue,
                                  ),
                                onPressed: () {
                                  //print("hello"+id.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          /*  value: Userid.toString(),*/
                                          )),
                                    );
                                },
                                ),
                              new Positioned(
                                  child: new Stack(
                                    children: <Widget>[
                                      new Icon(null),
                                      new Positioned(
                                          left:16.0,
                                          top: 3.0,
                                          //right: 5,
                                          child: new Center(
                                            child: new Text(
                                              "9",
                                              style: new TextStyle(
                                                  color: ColorCode.TextColorCodeBlue,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                            )),
                                    ],
                                    )),
                            ],
                            ),
                        ],
                        ),
                      ),
                  ],
                  ),
                ),
              //SizedBox(height: 50.0),
              /* Container(
                margin: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(imageurl+data["image"],),
                    ),
                  ),
                ),*/
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    carouselSlider = CarouselSlider(
                      height: 250.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      reverse: false,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 2),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      pauseAutoPlayOnTouch: Duration(seconds: 10),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index) {
                        /* setState(() {
                          _current = index;
                        });*/
                      },
                      items: imgList.map((imgUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                //color: Colors.green,
                                ),
                              child: Image.network(
                                imgUrl,
                                fit: BoxFit.contain,
                                ),
                              );
                          },
                          );
                      }).toList(),
                      ),
                    /* SizedBox(
                      height: 20,
                      ),*/
                    /* Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(imgList, (index, url) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index ? ColorCode.AppColorCode : Colors.green,
                            ),
                          );
                      }),
                      ),*/
                  ],
                  ),
                ),
              new Card(
                child: new Container(
                  /* width: screenSize.width,*/
                  margin: new EdgeInsets.all(10.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 1.0,
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Text(
                                      /*"${widget.itemRating}",*/
                                      data["categoryname"].toUpperCase(),
                                        style: new TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                                      ),
                                    new Text(
                                      /*"${widget.itemRating}",*/
                                      " > "+data["subcategoryname"].toUpperCase(),
                                        style: new TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                                      ),

                                  ],
                                  ),
                              ],
                              ),

                          ],
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Text(
                                      /*"${widget.itemRating}",*/
                                      "Rs."+data["MRP"],
                                        style: new TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,decoration: TextDecoration.lineThrough,),
                                      ),
                                    new Text(
                                      /*"${widget.itemRating}",*/
                                      " Rs."+data["SellingPrice"],
                                        style: new TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                                      ),

                                  ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      child: new CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.asset('assets/images/discount.png'),
                                        ),
                                      margin: const EdgeInsets.all(2.0),
                                      width: 15.0,
                                      height: 15.0,
                                      ),
                                    Container(
                                      child: new Text(data["Discount"],style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
                                      margin: const EdgeInsets.all(0.0),
                                      width: 15.0,
                                      height: 15.0,
                                      ),
                                  ],
                                  )
                              ],
                              ),

                          ],
                          ),

                        new SizedBox(
                          height: 2.0,
                          ),
                        new Text(
                          data["product_name"].toUpperCase(),textAlign: TextAlign.left,
                          style:
                          TextStyle(fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                          ),
                        /* new SizedBox(
                        height: 0.0,
                      ),*/
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Text(
                                  /*"${widget.itemRating}",*/
                                  data["product_number"].toUpperCase(),
                                    style: new TextStyle(fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                                  )
                              ],
                              ),
                          ],
                          ),
                      ],
                      ),
                  ),
                ),
              new Container(
                margin: EdgeInsets.all(0),
                //height: 120,
                child: Card(
                  //color: Colors.grey,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text(
                          "Description  ",textAlign: TextAlign.start,
                          style: new TextStyle(fontSize: 18.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 1.0,
                                ),
                              new Text(data["description"].toUpperCase(),
                                           style: new TextStyle(
                                               fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300)),
                              /* new Text('Price: ${data["Price"]}',
                                style: new TextStyle(
                                    fontSize: 11.0, fontWeight: FontWeight.normal,color: Palette.greenLandLight)),*/
                            ]),
                        )
                    ],
                    ),
                  ),
                ),
              new Container(
                margin: EdgeInsets.all(0),
                //height: 120,
                child: Card(
                  //color: Colors.grey,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text(
                          "How To Use  ",textAlign: TextAlign.start,
                          style: new TextStyle(fontSize: 18.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 1.0,
                                ),
                              new Text(data["how_to_use"].toUpperCase(),
                                           style: new TextStyle(
                                               fontSize: 15.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300)),
                              /* new Text('Price: ${data["Price"]}',
                                style: new TextStyle(
                                    fontSize: 11.0, fontWeight: FontWeight.normal,color: Palette.greenLandLight)),*/
                            ]),
                        )
                    ],
                    ),
                  ),
                ),
            ],
            ),
          )

      ],
      ),
    );
}