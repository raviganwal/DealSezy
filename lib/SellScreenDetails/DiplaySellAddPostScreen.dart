import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:dealsezy/EditPostImageScreen/EditPostImage.dart';
import 'package:dealsezy/EditPostScreen/EditPost.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/Model/SliderImageImageModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
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
  String SendReciveJsonAdv_ID ='';
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
  String AppReciveUserID="";
  bool _visibleEditBtn = false;
  bool _visibleStatusCard = false;
  bool _visibleChatBtn = false;
  bool _visibleEditPostBtn = false;
  List<Data> _list = [];
  int _current = 0;
  List<Data> imgList = List();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
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
         //print("ReciveData"+data.toString());

        ReciveJsonAdv_ID = data[0]["Adv_ID"].toString();
        ReciveJsonCat_ID = data[0]["Cat_ID"].toString();
        ReciveJsonSubCat_ID = data[0]["SubCat_ID"].toString();
        ReciveTitle = data[0]["Title"].toString();
        RecivePrice = data[0]["Price"].toString();
        ReciveDescription = data[0]["Description"].toString();
        ReciveFeatures = data[0]["Features"].toString();
        ReciveCondition = data[0]["Condition"].toString();
        ReciveReasonofSelling = data[0]["Reason_of_Selling"].toString();
        JsonReciveUser_ID = data[0]["User_ID"].toString();
        RecivePost_Time = data[0]["Post_Time"].toString();
        ReciveVisible_To = data[0]["Visible_To"].toString();
        ReciveStatus = data[0]["Publish_Status"].toString();

           /*print("ReciveJsonAdv_ID"+ReciveJsonAdv_ID.toString());
           print("ReciveJsonCat_ID"+ReciveJsonCat_ID.toString());
           print("ReciveJsonSubCat_ID"+ReciveJsonSubCat_ID.toString());
           print("ReciveTitle"+ReciveTitle.toString());
           print("RecivePrice"+RecivePrice.toString());
           print("ReciveDescription"+ReciveDescription.toString());
           print("ReciveFeatures"+ReciveFeatures.toString());
           print("ReciveCondition"+ReciveCondition.toString());
           print("ReciveReasonofSelling"+ReciveReasonofSelling.toString());
           print("JsonReciveUser_ID"+JsonReciveUser_ID.toString());
           print("RecivePost_Time"+RecivePost_Time.toString());
           print("ReciveVisible_To"+ReciveVisible_To.toString());
           print("ReciveStatus"+ReciveStatus.toString());*/
        this._CheckBtnsChatEdit();
      });
    }).catchError((error) {
      setStatus(error);
    });
  }

  //---------------------------------------------------------------------------------------------------//
  String ImagePosturl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/ViewAdvImages.php';

  fetchImagePost() {
    http.post(ImagePosturl, body: {
      "Token": GlobalString.Token,
      "Adv_ID":widget.value1.toString()
    }).then((resultImagePost) {
      //print("uploadEndPoint" + url.toString());
      //print("Token" + GlobalString.Token);
      //print("statusCode" + resultImagePost.statusCode.toString());
      //print("resultbody" + resultImagePost.body);
      // return result.body.toString();
      setStatus(resultImagePost.statusCode == 200 ? resultImagePost.body : errMessage);
      var dataImagePost = json.decode(resultImagePost.body);
      ReciveJsonStatus = dataImagePost["Status"].toString();
      // print("ReciveJsonStatus" + ReciveJsonStatus.toString());
      Posts model =
      Posts.fromJson(dataImagePost);

      final extractdata = jsonDecode(resultImagePost.body);
      dataImagePost = extractdata["data"];
      //print("ReciveData" + dataImagePost.toString());

      //_handleReciveFalse();
      setState(() {
        imgList.addAll(model.data);
//        for (Map i in dataImagePost) {
//          _list.add(Posts.formJson(i));
//          // loading = false;
//        }
      });
    }).catchError((error) {
      setStatus(error);
    });
  }
//---------------------------------------------------------------------------------------------------------//
  void _CheckBtnsChatEdit() {
    // print("Function equal");
    print("ReciveUserIDApp"+AppReciveUserID);
    print("JsonReciveUser_ID"+JsonReciveUser_ID);

    if(AppReciveUserID.toString() == JsonReciveUser_ID){
      setState(() {
        _visibleEditBtn = !_visibleEditBtn;
        _visibleStatusCard = !_visibleStatusCard;
        _visibleEditPostBtn = !_visibleEditPostBtn;
      });
    }else if(AppReciveUserID.toString() != JsonReciveUser_ID.toString()){
      print("Condition Not equal");
      setState(() {
        _visibleChatBtn = !_visibleChatBtn;
      });

    }
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
    final listJson = new Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
//--------------------------------------------------------------------------------------------//
              new SizedBox(
                height: 10.0,
                ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if(imgList.length>0)CarouselSlider(
                      height: 200.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      reverse: false,
                      enableInfiniteScroll: false,

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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                //color: Colors.green,
                                ),
                              child: Image.network(
                                'http://gravitinfosystems.com/Dealsezy/dealseazyApp/${imgUrl.imageData}',
                                fit: BoxFit.cover,
                                ),
                              );
                          },
                          );
                      }).toList(),
                      ),

                  ],
                  ),
                ),
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
                  /*  Card(
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
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(GlobalString.Visible.toUpperCase()
                                        .toString(),
                                        style: TextStyle(fontSize: 13.0, color: ColorCode
                                            .TextColorCodeBlue, fontWeight: FontWeight
                                            .bold)),
                        subtitle: Text(
                          ReciveVisible_To,
                          style: TextStyle(fontSize: 13.0, color: ColorCode
                              .TextColorCodeBlue, fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.solidEye, color: ColorCode
                              .TextColorCodeBlue),
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
                        title: Text(GlobalString.Status.toUpperCase()
                                        .toString(),
                                        style: TextStyle(fontSize: 13.0, color: ColorCode
                                            .TextColorCodeBlue, fontWeight: FontWeight
                                            .bold)),
                        subtitle: Text(
                          ReciveStatus,
                          style: TextStyle(fontSize: 13.0, color: ColorCode
                              .AppColorCode, fontWeight: FontWeight.bold),
                          ),
                        leading: IconButton(
                          icon: Icon(FontAwesomeIcons.infoCircle,
                                         color: ColorCode.TextColorCodeBlue),
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
                  /*onPressed: () {
                    //  _launchCaller(phoneNumber);
                  },*/
                  ),
                ),
              ),

            ),
        ],
        ),
      );
//---------------------------------------------------------------------------------------------------//
    Future<Null> BackScreen() async {
      Navigator.of(context).pushNamed(HomeScreen.tag);
    }
//---------------------------------------------------------------------------------------------------//
    return Scaffold(
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
        body: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            EditPosttab,
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
              Visibility(
                  visible: _visibleEditPostBtn,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height:50,
                    child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          SendReciveJsonAdv_ID =ReciveJsonAdv_ID.toString(); //if you want to assign the index somewhere to check
                           print("SendReciveJsonAdv_ID"+ReciveJsonAdv_ID.toString());
                        });
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new EditPost(
                              value: ReciveJsonAdv_ID.toString(),
                              ),
                          );
                        Navigator.of(context).push(route);
                      },
                      color: ColorCode.AppColorCode,
                      icon: Icon(FontAwesomeIcons.solidEdit,color: Colors.white,), //`Icon` to display
                      label: Text(GlobalString.EditPodt.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)),
                      ),
                    )
                  ),
            ],
            ),
          ),
        /*        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  color:Color(0xFF222B78),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(Icons.arrow_back,color: Colors.white,), //`Icon` to display
                      label: Text('back'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                       / / Navigator
                            .of(context)
                            .push(new MaterialPageRoute(builder: (_) => new Product()));/ /
                      },
                    ),

                  ),
                flex: 2,
                ),
              Expanded(
                child: Container(
                  height: 50,
                  color:Color(0xFFE0318C),
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(Icons.add_shopping_cart,color: Colors.white,), //`Icon` to display
                      label: Text('add to cart'.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                       / / GetCountRequest(); //fun1
                        _ackAlert(); //fun2*//*
                      },
                    ),

                  ),
                flex: 3,
                ),
            ],
            ),
          ),*/
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