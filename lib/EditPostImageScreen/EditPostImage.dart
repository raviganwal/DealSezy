import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dealsezy/EditPostImageScreen/ImageUpload.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Model/EditPostMode.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
//---------------------------------------------------------------------------------------------------//
class EditPostImage extends StatefulWidget {
  static String tag = 'EditPostImage';
//---------------------------------------------------------------------------------------------------//
  List data;
  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  final String value;
  final String value1;
//---------------------------------------------------------------------------------------------------//
  EditPostImage({Key key,this.value1, this.value,}) : super(key: key);
//---------------------------------------------------------------------------------------------------//
  @override
  _EditPostImageScreen createState() => new _EditPostImageScreen();
}
//---------------------------------------------------------------------------------------------------//
class _EditPostImageScreen extends State<EditPostImage> {
  List data;
  List<Posts> _list = [];
  String status = '';
  String errMessage = 'Error Send Data';
  bool ReciveJsonStatus ;
  String Cat_ID ='';
  String ReciveJsonImageId ='';
  String GetImageId ='';
  bool  ImageDeleted ;
  var loading = false;
  List<Posts> _searchCategory = [];
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  String ReciveJsonRECID ='';
  bool statusProductDeleted = false;
//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/ViewAdvImages.php';
  fetchPost() {
    http.post(url, body: {
      "Token": GlobalString.Token,
      "Adv_ID":widget.value1.toString()
    }).then((result) {
      // print("uploadEndPoint"+url.toString());
      // print("Token" + GlobalString.Token);
      //print("statusCode" + result.statusCode.toString());
      //print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var data = json.decode(result.body);
      ReciveJsonStatus = data["Status"];
      print("GetStatus" + ReciveJsonStatus.toString());
      //_handleBlankData();
      var extractdata = jsonDecode(result.body);
      data = extractdata["data"];
      print("ReciveData"+data.toString());
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
  //--------------------------------------------------------------------------------------//
  void _handleBlankData() {
    if(ReciveJsonStatus == false){
      print("Okfalse");
      NoDataAvilable();
    }else if(ReciveJsonStatus == true){
      print("true");
      this.fetchPost();
    }
  }
//---------------------------------------------------------------------------------------------------//
  String DeleteImageurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/AdvImageDelete.php';
  DeleteImage() {
    http.post(DeleteImageurl, body: {
      "Token": GlobalString.Token,
      "Adv_Image_ID":ReciveJsonImageId.toString()
    }).then((resultDeleteImage) {
      print("DeleteImageurl "+DeleteImageurl.toString());
      print("Token " + GlobalString.Token);
      print("statusCode " + resultDeleteImage.statusCode.toString());
      print("ReciveData " + resultDeleteImage.body.toString());
      print("Adv_Image_ID " + ReciveJsonImageId.toString());
      //return result.body.toString();
      setStatus(resultDeleteImage.statusCode == 200 ? resultDeleteImage.body : errMessage);

      var ProductdataDelete = json.decode(resultDeleteImage.body);
      ImageDeleted = ProductdataDelete['status'];
      print("ImageDeleted =" + ImageDeleted.toString());
      _handleDeleteImages();
    }).catchError((error) {
      setStatus(error);
    });
  }
  void _handleDeleteImages() {
    if(ImageDeleted == false){
      print("Okfalse");
      FalseImageDialog();
    }else if(ImageDeleted == true){
      print("true");
      TrueImageDialog();
    }
  }

//------------------------------------------------------------------------------------------//
  Future<void> FalseImageDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning", textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Something Wrong...",
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
                setState(() {
                  //ReciveJsonRECID =widget.value2.toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                  // print("CatID"+widget.value2.toString());
                  print("hello"+widget.value1.toString());
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new ImageUpload(
                      value1: " ${widget.value1.toString()}"),
                  );
                Navigator.of(context).push(route);
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
  Future<void> TrueImageDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thanks", textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Image has been deleted from Gallery List Thanks..",
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
                setState(() {
                  //ReciveJsonRECID =widget.value2.toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                  // print("CatID"+widget.value2.toString());
                  print("hello"+widget.value1.toString());
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new ImageUpload(
                      value1: " ${widget.value1.toString()}"),
                  );
                Navigator.of(context).push(route);
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
  Future<void> NoDataAvilable() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Something Wrong...", textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("No Images Avilable Here Please Upload Images...",
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
                setState(() {
                  //ReciveJsonRECID =widget.value2.toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                  // print("CatID"+widget.value2.toString());
                  print("hello"+widget.value1.toString());
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new ImageUpload(
                      value1: " ${widget.value1.toString()}"),
                  );
                Navigator.of(context).push(route);
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
  }
//---------------------------------------------------------------------------------------------------//
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _width = width * 0.70;
    double height = MediaQuery.of(context).size.height;
    double _height = height * 0.85;
    final headerList =  GridView.builder(
        itemCount: _list.length,
        padding: EdgeInsets.all(5.0),
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, i) {
          final b = _list[i];
          ReciveJsonImageId = b.Adv_Image_ID.toString();
          //print("ReciveJsonImageId"+ReciveJsonImageId);
          return new Card(
            child: Stack(
              alignment: FractionalOffset.topLeft,
              children: <Widget>[
                new Stack(
                  alignment: FractionalOffset.bottomCenter,
                  children: <Widget>[
                    new  AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(imageurl+b.ImageData,
                                           fit: BoxFit.cover,
                                         ),
                      ),
                  ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      height: 30.0,
                      width: 60.0,
                      decoration: new BoxDecoration(
                          color: ColorCode.AppColorCode,
                          borderRadius: new BorderRadius.only(
                            topRight: new Radius.circular(5.0),
                            bottomRight: new Radius.circular(5.0),
                            )),
                      child: new Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new IconButton(
                              icon: Icon(
                                FontAwesomeIcons.trash,
                                color: Colors.white,
                                size: 15.0,
                                ),
                              onPressed: () {
                                setState(() {
                                  GetImageId = ( b.Adv_Image_ID.toString());
                                  //if you want to assign the index somewhere to check
                                  print("OnTapAdv_Image_ID"+GetImageId.toString());
                                });
                                print("true");
                                DeleteImage();
                              }),

                          /*new Text(
                      "x",
                      style: new TextStyle(color: Colors.white),
                      )*/
                        ],
                        ),
                      ),
                   /*new IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.blue,
                    ),
                  onPressed: () {})*/
                  ],
                  )
              ],
              ),
            );
        });
//---------------------------------------------------------------------------------------------------//
    Future<Null> BackScreen() async {
      setState(() {
        print("DiplaySellAddPostScreen"+widget.value1.toString());
      });
      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
        new DiplaySellAddPostScreen(
            value1: " ${widget.value1.toString()}"),
        );
      Navigator.of(context).push(route);

    }
//---------------------------------------------------------------------------------------------------//
    return new WillPopScope(
      onWillPop: BackScreen,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new Container(
              color: Colors.transparent,
              child: Text(
                GlobalString.editPostd.toString().toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
              ),
            ),
          centerTitle: true,
            leading: IconButton(icon:Icon(Icons.arrow_back),
                                  onPressed: () {
                                    setState(() {
                                      print("DiplaySellAddPostScreen"+widget.value1.toString());
                                    });
                                    var route = new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new DiplaySellAddPostScreen(
                                          value1: " ${widget.value1.toString()}"),
                                      );
                                    Navigator.of(context).push(route);
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
        body: headerList,
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  color:ColorCode.AppColorCode,
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(FontAwesomeIcons.plusCircle,color: Colors.white,), //`Icon` to display
                      label: Text(GlobalString.AddImage.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        setState(() {
                          //ReciveJsonRECID =widget.value2.toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                          // print("CatID"+widget.value2.toString());
                          print("ImageUpload"+widget.value1.toString());
                        });
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new ImageUpload(
                              value1: " ${widget.value1.toString()}"),
                          );
                        Navigator.of(context).push(route);
                      },
                    ),

                  ),
                //flex: 2,
                ),
            ],
            ),
          ),
        ),
      );
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

