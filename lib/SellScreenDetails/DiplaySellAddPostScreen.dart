import 'package:connectivity/connectivity.dart';
import 'package:dealsezy/EditPostImageScreen/EditPostImage.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Model/DiplaySellAddPostScreenModel.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealsezy/Model/EditPostMode.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
//---------------------------------------------------------------------------------------------------//
class DiplaySellAddPostScreen extends StatefulWidget {
  static String tag = 'DiplaySellAddPostScreen';
//---------------------------------------------------------------------------------------------------//
  List data;
  var loading = false;
  final String value;
  final String value1;
//---------------------------------------------------------------------------------------------------//
  DiplaySellAddPostScreen({Key key, this.value,this.value1}) : super(key: key);
//---------------------------------------------------------------------------------------------------//
  @override
  _DiplaySellAddPostScreen createState() => new _DiplaySellAddPostScreen();
}
//---------------------------------------------------------------------------------------------------//
class _DiplaySellAddPostScreen extends State<DiplaySellAddPostScreen> {
  var data;
  var dataGetImages;
  String status = '';
  String errMessage = 'Error Send Data';
  String ReciveJsonStatus ='';
  String Cat_ID ='';
  var loading = false;
  String ReciveTitle ='';
  String RecivePrice ='';
  String ReciveDescription ='';
  String ReciveFeatures ='';
  String ReciveCondition ='';
  String ReciveReasonofSelling ='';
  String RecivePost_Time ='';
  String ReciveVisible_To ='';
  String ReciveJsonAdv_ID ='';
  String ReciveJsonCat_ID ='';
  String ReciveJsonSubCat_ID ='';
  String JsonReciveUser_ID ='';
  String ReciveStatus ='';
  List<Posts> _list = [];
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  List dataimage;
  var AppReciveUserID="";
  bool _visibleEditBtn = false;
  bool _visibleStatusCard = false;
  bool _visibleChatBtn = false;
//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/AdvView.php';
  fetchPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    // print("ReciveUserID"+ReciveUserID.toString());
    http.post(url, body: {
      "Token": GlobalString.Token,
      "Adv_ID": widget.value1.toString(),
    }).then((result) {
      // print("uploadEndPoint"+url.toString());
      //print("Token" + GlobalString.Token);
      //print("DisplayAdv_ID" + widget.value1.toString());
      //  print("statusCode" + result.statusCode.toString());
      //  print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      setState(() {
        var extractdata = json.decode(result.body);
        data = extractdata["JSONDATA"];
        print("ReciveData"+data.toString());

        ReciveJsonAdv_ID = data[0]["Adv_ID"].toString();
        ReciveJsonCat_ID = data[0]["Cat_ID"].toString();
        ReciveJsonSubCat_ID = data[0]["SubCat_ID"].toString();
        ReciveTitle = data[0]["Title"].toString();
        RecivePrice = data[0]["Price"].toString();
        ReciveDescription = data[0]["Description"].toString();
        ReciveFeatures = data[0]["Features"].toString();
        ReciveCondition = data[0]["Condition"].toString();
        ReciveReasonofSelling = data[0]["Reason of Selling"].toString();
        JsonReciveUser_ID = data[0]["User_ID"].toString();
        RecivePost_Time = data[0]["Post_Time"].toString();
        ReciveVisible_To = data[0]["Visible_To"].toString();
        ReciveStatus = data[0]["Publish_Status"].toString();

          /* print("ReciveJsonAdv_ID"+ReciveJsonAdv_ID.toString());
           print("ReciveJsonCat_ID"+ReciveJsonCat_ID.toString());
           print("ReciveJsonSubCat_ID"+ReciveJsonSubCat_ID.toString());
           print("ReciveTitle"+ReciveTitle.toString());
           print("RecivePrice"+RecivePrice.toString());
           print("ReciveDescription"+ReciveDescription.toString());
           print("ReciveFeatures"+ReciveFeatures.toString());
           print("ReciveCondition"+ReciveCondition.toString());
           print("ReciveReasonofSelling"+ReciveReasonofSelling.toString());
           print("ReciveUser_ID"+ReciveUser_ID.toString());
           print("RecivePost_Time"+RecivePost_Time.toString());
           print("ReciveVisible_To"+ReciveVisible_To.toString());
           print("ReciveStatus"+ReciveStatus.toString());*/
          //print("JsonUser_ID"+JsonReciveUser_ID.toString());


      });
    }).catchError((error) {
      setStatus(error);
    });
  }

 void _CheckBtnsChatEdit() {
  // print("Function equal");
   print("ReciveUserIDApp"+AppReciveUserID);
   print("JsonReciveUser_ID"+JsonReciveUser_ID);

    if(AppReciveUserID.toString() == JsonReciveUser_ID){
      setState(() {
        _visibleEditBtn = !_visibleEditBtn;
        _visibleStatusCard = !_visibleStatusCard;
      });
    }else if(AppReciveUserID.toString() != JsonReciveUser_ID.toString()){
      print("Condition Not equal");
      setState(() {
        _visibleChatBtn = !_visibleChatBtn;
      });

    }
  }
  //---------------------------------------------------------------------------------------------------//
  String ImagePosturl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/ViewAdvImages.php';
  fetchImagePost() {
    http.post(ImagePosturl, body: {
      "Token": GlobalString.Token,
      "Adv_ID":widget.value1.toString()
    }).then((resultImagePost) {
      //print("uploadEndPoint"+url.toString());
      //print("Token" + GlobalString.Token);
      //print("statusCode" + resultImagePost.statusCode.toString());
     // print("resultbody" + resultImagePost.body);
      // return result.body.toString();
      setStatus(resultImagePost.statusCode == 200 ? resultImagePost.body : errMessage);
      setState(() {
        var extractdata = json.decode(resultImagePost.body);
        dataimage = extractdata["data"];
       // print("dataimage"+dataimage.toString());
      });
      this._CheckBtnsChatEdit();
    }).catchError((error) {
      setStatus(error);
    });
  }
  //-----------------------------------------------------------------------------------------------------//
  /*void _handleSubmitted() {
    if(ReciveJsonStatus == "true"){
      print(ReciveJsonStatus);
      fetchPost();
    }else if(ReciveJsonStatus == "false"){
      print(ReciveJsonStatus);
      //_LoadDataAlert();
      print(ReciveJsonStatus);
    }
  }*/
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
//---------------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this._checkInternetConnectivity();
    this.fetchPost();
    this.fetchImagePost();
  }
//----------------------------------------------------------------------------------------//

//---------------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    double height = MediaQuery.of(context).size.height;
    double _height = height * 0.85;
//-------------------------------------------------------------------------------------------------------//
    final EditPosttab = new Align(
      alignment: Alignment.topRight,
        child: new Column(
          children: <Widget>[

       Visibility(
         visible: _visibleEditBtn,
         child: new IconButton(
           padding: new EdgeInsets.all(0.0),
           icon: new Icon(
             FontAwesomeIcons.edit,
             color:ColorCode.TextColorCodeBlue,
             ),
           onPressed: () {
             setState(() {
               //ReciveJsonRECID =widget.value2.toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
               // print("CatID"+widget.value2.toString());
               print("hello"+widget.value1.toString());
             });
             var route = new MaterialPageRoute(
               builder: (BuildContext context) =>
               new EditPostImage(
                   value1: " ${widget.value1.toString()}"),
               );
             Navigator.of(context).push(route);
           },
           ),

       ),
          ],
        ),


      );
//-----------------------------------------------------------------------------------------------------------------------//
    final ImageSlider =  new Swiper(
      itemBuilder: (context, i){
        //final a = _list[i];
        return new Image.network(imageurl+dataimage[i]["ImageData"],fit: BoxFit.fill,);
      },
      autoplay: true,
      itemCount: dataimage.length,
      viewportFraction: 0.8,
      scale: 0.85,
      pagination: new SwiperPagination(),
      //control: new SwiperControl(),
      );
//-----------------------------------------------------------------------------------------------------------------------//
    final listJson = new Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
//------------------------------------------------------------------------------------------------------//
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Title.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ReciveTitle,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.heading, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),
//-------------------------------------------------------------------------------------------------------//
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Price.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          RecivePrice,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.rupeeSign, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),
//-------------------------------------------------------------------------------------------------------//
                    /*Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Time.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          RecivePost_Time.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.solidClock, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),*/
//-------------------------------------------------------------------------------------------------------//
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Features.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ReciveFeatures,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.solidFlag, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),
//-------------------------------------------------------------------------------------------------------//
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Conditions.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ReciveCondition,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.solidQuestionCircle, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),
//-------------------------------------------------------------------------------------------------------//
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.ReasonofSelling.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ReciveReasonofSelling,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.sellcast, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),
//-------------------------------------------------------------------------------------------------------//
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Description.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ReciveDescription,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.solidCommentDots, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),
//-------------------------------------------------------------------------------------------------------//

//-------------------------------------------------------------------------------------------------------//
                  /*  Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Status.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ReciveStatus,style: TextStyle(fontSize: 13.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.infoCircle, color: ColorCode.TextColorCodeBlue),
                          onPressed: () {
                            //  _launchCaller(phoneNumber);
                          },
                          ),
                        ),
                      ),*/

                  ],
                  ),
                ),
            ],
            ),
          )

      ],
      );
    final Status = Padding(
      padding: EdgeInsets.only(left: 00.0, right: 00.0),
      child: new Column(
        children: <Widget>[
          Visibility(
            visible: _visibleStatusCard,
            child: new   Card(
              color: Colors.white70,
              child: ListTile(
                title: Text(GlobalString.Status.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                subtitle: Text(
                  ReciveStatus,style: TextStyle(fontSize: 13.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),
                  ),
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.infoCircle, color: ColorCode.TextColorCodeBlue),
                  onPressed: () {
                    //  _launchCaller(phoneNumber);
                  },
                  ),
                ),
              ),

            ),
        ],
        ),
      );
//---------------------------------------------------------------------------------------------------//
    Future<Null> BackScreen() async {
      Navigator.of(context);
    }
//---------------------------------------------------------------------------------------------------//
    return  Scaffold(
        drawer: _drawer(),
        key: _scaffoldKey,
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new Container(
              color: Colors.transparent,
              child: Text(
                ReciveTitle.toString().toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
              ),
            ),
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
                  onPressed: () {
                    //print("hello"+id.toString());
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductTotalCardList(
                            value: id.toString(),
                            )),
                      );*/
                  },
                  ),
                new Positioned(
                    child: new Stack(
                      children: <Widget>[
                        new Icon(null),
                        new Positioned(
                            top: 5.0,
                            right: 3,
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
                      )
                    ),
              ],
              ),
          ],
          ),
//---------------------------------------------------------------------------------------------------//
        backgroundColor: Colors.white,
        /*body: listJson,*/
        body: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            EditPosttab,
            new Container(
              //color: Colors.grey,
              height: 200.0, width: _width,child: ImageSlider),
            listJson,
            Status,
            //listJson
          ],
          ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _visibleChatBtn,
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height:50,
                  child: FlatButton.icon(
                    onPressed: () {},
                    color: ColorCode.AppColorCode,
                    icon: Icon(FontAwesomeIcons.solidComment,color: Colors.white,), //`Icon` to display
                    label: Text(GlobalString.Chat.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)),
                    ),
                  )
              ),
              /*  Expanded(
                child: Container(
                  height: 50,
                  color:ColorCode.AppColorCode,
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(FontAwesomeIcons.trash,color: Colors.white,), //`Icon` to display
                      label: Text(GlobalString.DeleteImage.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        *//* GetCountRequest(); //fun1
                        _ackAlert(); //fun2*//*
                      },
                    ),

                  ),
                flex: 3,
                ),*/
            ],
            ),
          ),
        );
  }
//---------------------------------------------------------------------------------------------------//
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
//---------------------------------------------------------------------------------------------------//
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
//---------------------------------------------------------------------------------------------------//
  removeData() async {
    /* final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_ID);
    Navigator.of(context).pushNamed(Splash.tag);*/
  }
}
//---------------------------------------------------------------------------------------------------//

