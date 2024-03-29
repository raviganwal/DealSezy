
import 'package:dealsezy/EditPostImageScreen/EditPostImage.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

import 'dart:math' as Math;

//------------------------------------------------------------------------------------------//
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
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;

    int rand= new Math.Random().nextInt(1);

    Img.Image image2= Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResizeCropSquare(image2, 500);

    var compressImg= new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImg;
      print("getImageFromCamera"+_image.toString());
    });
  }
//-------------------------------------------------------------------------------------------//
  Future getImageGallery() async{
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;

    int rand= new Math.Random().nextInt(1);

    Img.Image image1= Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResizeCropSquare(image1, 500);

    var compressImg= new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


    setState(() {
      _image = compressImg;
      print("getImageFromGallery"+_image.toString());
    });
  }
//---------------------------------------------------------------------------------------------------//

  Future Upload(File imageFile) async {
    var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length= await imageFile.length();

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
    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
    //var imagelength = await imageFile.length();
   // print("response"+response.body.toString());
    request.files.add(multipartFile);

    var respone = await request.send();
    print(response.toString());

    if(response.statusCode==200){
      print("Image Uploaded");
    }else{
      print("Upload Failed");
    }
   /* response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });*/
  }
//-------------------------------------------------------------------------------------------//
/*  void _showDialog(BuildContext context) {
    setState(() {
      dialog = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Container(
            height: 260.0,
            child: ListView(
              children: <Widget>[
                Card(child: ListTile(title: Text(GlobalString.CameraString,textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),))),
                Card(
                  child: ListTile(
                      leading: IconButton(icon:Icon(FontAwesomeIcons.camera,size:35.0,color: ColorCode.TextColorCodeBlue,),),
                      title: Text(GlobalString.Camera.toUpperCase(),textAlign: TextAlign.start,style: TextStyle(fontSize: 15.0,color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
                      onTap: () { getImageFromCam();}
                      ),
                  ),
                Card(
                  child: ListTile(
                      leading: IconButton(icon:Icon(FontAwesomeIcons.image,size:35.0,color: ColorCode.TextColorCodeBlue,),),
                      title: Text(GlobalString.Gallary.toUpperCase(),textAlign: TextAlign.start,style: TextStyle(fontSize: 15.0,color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),),
                      onTap: () { getImageFromGallery();}
                      ),
                  ),
                Card(
                  child: ListTile(
                      subtitle: Text(
                          ''
                          ),
                      trailing: Text('Cancel', style: new TextStyle(fontSize: 15.0,
                                                                        color: ColorCode.TextColorCodeBlue,
                                                                        fontWeight: FontWeight
                                                                            .bold),),
                      onTap: () { Navigator.pop(context, true);}
                      ),
                  ),
              ],
              )
            ),
        ),
      ).then((_) {
      if (mounted) {
        setState(() {
          dialog = false; // dialog was closed
        });
      }
    });

    new Future.delayed(const Duration(seconds:5), () {
      // When task is over, close the dialog
      Navigator.of(context, rootNavigator: false).pop();
    });
  }*/
//-------------------------------------------------------------------------------------------//
  void  _displaySnackbar(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Text('Please Wait........',style: TextStyle(color: ColorCode.TextColorCode),),
      backgroundColor: ColorCode.AppColorCode,
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
        body: SingleChildScrollView(
         child:Column(
           children: <Widget>[
             SizedBox(
               height: 2.0,
             ),
             Container(
               width: MediaQuery.of(context).size.width,
               color: Colors.grey[200],
               child: Center(
                 child: _image == null
                     ? Image.asset("assets/images/noimage.jpg")
                     : Image.file(_image),

                 ),
               ),
           ],
         ),
          ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

//------------------------------------------------------------------------------------------//
              Expanded(
                child: Container(
                  height: 50,
                  color:ColorCode.TextColorCodeBlue,
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon(FontAwesomeIcons.camera,color: Colors.white,), //`Icon` to display
                      label: Text("".toUpperCase().toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        getImageFromCam();
                      },
                    ),

                  ),
                flex: 0,
                ),
//----------------------------------------------------------------------------------------------------------//
              new Container(
                color: ColorCode.TextColorCode,
                height: 50.0,
                width: 0.5,
                ),
//----------------------------------------------------------------------------------------------------------//
              Expanded(
                child: Container(
                  height: 50,
                  color:ColorCode.TextColorCodeBlue,
                  child: new FlatButton.icon(
                    //color: Colors.red,
                    icon: Icon( FontAwesomeIcons.solidImage,
                                  color: Colors.white,), //`Icon` to display
                      label: Text("".toUpperCase(),textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: () {
                        getImageGallery();
                      },
                    ),

                  ),
                flex: 0,
                ),
//----------------------------------------------------------------------------------------------------------//
              new Container(
                color: ColorCode.TextColorCode,
                height: 50.0,
                width: 0.5,
                ),
//----------------------------------------------------------------------------------------------------------//
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
                        _displaySnackbar(context);
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
//----------------------------------------------------------------------------------------------------------//
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