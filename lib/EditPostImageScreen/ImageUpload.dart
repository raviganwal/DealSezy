import 'dart:io';
import 'package:dealsezy/EditPostImageScreen/EditPostImage.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
//------------------------------------------------------------------------------------------//
class Palette1 {
  static Color greenLandLight1 = Color(0xFF222B78);
}
class Palette2 {
  static Color greenLandLight2 = Color(0xFFE0318C);
}
//-------------------------------------------------------------------------------------------//
class ImageUpload extends StatefulWidget {
  static String tag = 'ImageUpload';
  ImageUpload({Key key, this.title, this.value1,}) : super(key: key);
  final String title;
  final String value1;
  @override
  _ImageUploadState createState() => new _ImageUploadState();
}
//-------------------------------------------------------------------------------------------//
class _ImageUploadState extends State<ImageUpload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  String UserName = '';
  String UserEmail = '';
  String UserContact = '';
  String Userid = '';
  final String phone = 'tel:+917000624695';
  String id;
  bool statusDataSend = false;
  var ReciveData = '';
  bool dialog = false;
//-------------------------------------------------------------------------------------------//
  @override
  void initState() {
    this.fetchData();
    super.initState();
  }
//-------------------------------------------------------------------------------------------//
  @override
  void dispose() {
    super.dispose();
  }
//-------------------------------------------------------------------------------------------//
  Future<Null> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  /*  UserName = prefs.getString(Preferences.KEY_NAME).toString();
    UserEmail = prefs.getString(Preferences.KEY_Email).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    UserContact = prefs.getString(Preferences.KEY_Contact).toString();
    Userid = prefs.getString(Preferences.KEY_ID).toString();*/
  }
//-------------------------------------------------------------------------------------------//
  Future getImageFromCam() async { // for camera
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print("getImageFromCam"+_image.toString());
    });
  }
//-------------------------------------------------------------------------------------------//
  Future getImageFromGallery() async {// for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("getImageFromGallery"+_image.toString());
    });
  }
//---------------------------------------------------------------------------------------------------//

  Future Upload(File imageFile) async {
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("http://gravitinfosystems.com/Dealsezy/dealseazyApp/AdvImageAdd.php");
    final response =
    await http.get(uri);
    if (response.statusCode == 200) {
    }
    print("uri"+uri.toString());
    var request = new http.MultipartRequest("POST", uri);
    request.fields['Token'] = GlobalString.Token;
    request.fields['Adv_ID'] = widget.value1.toString();

    print("Token"+request.fields['Token'].toString());
    print("Adv_ID"+request.fields['Adv_ID'].toString());
    var multipartFile =  new http.MultipartFile("image", stream,length,filename: basename(imageFile.path));
   // print("response"+response.body.toString());
    request.files.add(multipartFile);

    var respone = await request.send();
    print(response.toString());

    if (respone.statusCode==200) {
      print("Image Uploaded");
    }
    else{
      print("Image Failed");
    }
  }
//-------------------------------------------------------------------------------------------//
        void _showDialog(BuildContext context) {
          setState(() {
            dialog = true;
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            child: new Dialog(

              child: new Container(
                  height: 125.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Icon(Icons.camera,color:ColorCode.TextColorCodeBlue),
                        GestureDetector(
                          onTap: () {getImageFromCam();},
                          child: Container(
                            padding: EdgeInsets.only(left:20.0),
                            child: Text(GlobalString.Camera.toUpperCase().toString(),style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color:ColorCode.TextColorCodeBlue),),
                            ),
                          ),
                      ],
                      ),
                    new SizedBox(
                      //height: 20.0,
                      ),
                    new Row(
                      children: <Widget>[
                        new Icon(Icons.photo,color:ColorCode.TextColorCodeBlue),
                        GestureDetector(
                          onTap: () {getImageFromGallery();},
                          child: Container(
                            padding: EdgeInsets.only(left:20.0),
                            child: Text(GlobalString.Gallary.toUpperCase().toString(),style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color:ColorCode.TextColorCodeBlue),),
                            ),
                          ),
                      ],
                      ),
                  ],
                  ),
                  ),
              ),
            ).then((_) {
            if (mounted) {
              setState(() {
                dialog = false; // dialog was closed
              });
            }
          });

          new Future.delayed(const Duration(seconds: 5), () {
            // When task is over, close the dialog
            Navigator.of(context, rootNavigator: false).pop();
          });
        }
//-------------------------------------------------------------------------------------------//
  void  _displaySnackbar(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Image Uploaded Successfully........')
        ));
  }
  //--------------------------------------------------------------------------------------------------------//
  Future<void> _SignupAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thanks.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Image Insert Sucessfully".toString(),
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
                  print("ReciveImage+ID"+widget.value1.toString());
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new EditPostImage(
                      value1: " ${widget.value1.toString()}"),
                  );
                Navigator.of(context).push(route);
              },
              child: Text('Ok', style: new TextStyle(fontSize: 15.0,
                                                                color: ColorCode.TextColorCodeBlue,
                                                                fontWeight: FontWeight
                                                                    .bold),),
              )
          ],
          );
      },
      );
  }
  //-------------------------------------------------------------------------------------------//
  Future<Null> BackScreen(BuildContext context) async {
    setState(() {
      print("GetEditPostImage"+widget.value1.toString());
    });
    var route = new MaterialPageRoute(
      builder: (BuildContext context) =>
      new EditPostImage(
          value1: " ${widget.value1.toString()}"),
      );
    Navigator.of(context).push(route);

  }
//-------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => BackScreen(context),
        child:  Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Padding(
          padding: const EdgeInsets.all(0.0),
          child: new Container(
            color: Colors.transparent,
            child: Text(
              GlobalString.UploadImage.toString().toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
            ),
          ),
        centerTitle: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  print("GetEditPostImage"+widget.value1.toString());
                                });
                                var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new EditPostImage(
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
        body: ListView(
          children: [
            /* new SizedBox(
              height: 2.0,
              ),*/
            new SizedBox(
              height: 10.0,
              ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              height: 200.0,

              child: Center(
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),

                ),
              ),
            new SizedBox(
              height: 10.0,
              ),
          ],
          ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  color:ColorCode.TextColorCodeBlue,
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(FontAwesomeIcons.camera,color: Colors.white,), //`Icon` to display
                      label: Text(GlobalString.Camera.toUpperCase().toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        _showDialog(context);
                       /*_displaySnackbar(context);
                        Upload(_image);
                        Navigator.of(context).pushNamed(HomeScreen.tag);*/
                        //print("hello");
                        // model.removeProduct(model.cart[index]);
                      },
                    ),

                  ),
                flex: 2,
                ),
              Expanded(
                child: Container(
                  height: 50,
                  color:ColorCode.AppColorCode,
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon( FontAwesomeIcons.paperPlane,
                                  size: 18,
                                  color: Colors.white,), //`Icon` to display
                      label: Text(GlobalString.SendImage.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        //_displaySnackbar(context);
                        Upload(_image);
                        _SignupAlert(context);
                        //Navigator.of(context).pushNamed(DiplaySellAddPostScreen.tag);
                        //print("hello");
                        // model.removeProduct(model.cart[index]);
                      },
                    ),

                  ),
                flex: 3,
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
              //removeData();
            },
            child: new Text('OK'))
      ],
      );
    showDialog(context: context, child: alert);
  }
//---------------------------------------------------------------------------------------------------//
}
//-------------------------------------------------------------------------------------------//