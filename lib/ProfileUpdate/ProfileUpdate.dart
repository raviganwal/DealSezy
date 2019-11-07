import 'dart:async';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
//----------------------------------------------------------------------------------------------//
class ProfileUpdate extends StatefulWidget {
  static String tag = 'ProfileUpdate';
  final String value;
  ProfileUpdate({Key key, this.value}) : super(key: key);
  @override
  ProfileUpdateState createState() => new ProfileUpdateState();
}
//----------------------------------------------------------------------------------------------//
class ProfileUpdateState extends State<ProfileUpdate> with SingleTickerProviderStateMixin{
  TextEditingController controller1 = new TextEditingController();
  var data;
  var loading = false;
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  final FocusNode myFocusNode = FocusNode();
  var ReciveUserID="";
  String errMessage = 'Error Send Data';
  String status = '';
  String ReciveJsonStatus ='';
  String ReciveJsonUSER_ID ='';
  String ReciveJsonUSERFirstName ='';
  String ReciveJsonUSERLastName ='';
  String ReciveJsonUSEREmail ='';
  String ReciveJsonUSERMobile ='';
  String ReciveJsonUSEROrganization ='';
  String ReciveJsonUSERStatus='';

  TextEditingController FirstNameController = new TextEditingController();
  TextEditingController LastNameController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  TextEditingController MobileController = new TextEditingController();
  TextEditingController OrganizationController = new TextEditingController();

  final FocusNode myFocusNodeFirstName = FocusNode();
  final FocusNode myFocusNodeLastName = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeMobile = FocusNode();
  final FocusNode myFocusNodeOrganization = FocusNode();

//----------------------------------------------------------------------------------------------//
  String UpdateProfileurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/MyProfile.php';
  fetchMyProfileUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(UpdateProfileurl, body: {
      "Token": GlobalString.Token,
      "User_ID": ReciveUserID.toString()
    }).then((resultUpdateProfile) {
      print("uploadEndPoint"+UpdateProfileurl.toString());
      print("Token" + GlobalString.Token);
      print("statusCode" + resultUpdateProfile.statusCode.toString());
      // print("resultbody" + resultMyProfile.body);
      //return result.body.toString();
      setStatus(resultUpdateProfile.statusCode == 200 ? resultUpdateProfile.body : errMessage);
      setState(() {
        var extractdata = json.decode(resultUpdateProfile.body);
        data = extractdata["JSONDATA"];
        print("ReciveData"+data.toString());

        ReciveJsonUSER_ID = data[0]["USER_ID"].toString();
        ReciveJsonUSERFirstName = data[0]["First Name"].toString();
        ReciveJsonUSERLastName = data[0]["Last Name"].toString();
        ReciveJsonUSEREmail = data[0]["Email"].toString();
        ReciveJsonUSERMobile = data[0]["Mobile"].toString();
        ReciveJsonUSEROrganization = data[0]["Organization"].toString();
        ReciveJsonUSERStatus = data[0]["Status"].toString();

           print("ReciveJsonUSER_ID"+ReciveJsonUSER_ID.toString());
           print("ReciveJsonUSERFirstName"+ReciveJsonUSERFirstName.toString());
           print("ReciveJsonUSERLastName"+ReciveJsonUSERLastName.toString());
           print("ReciveJsonUSEREmail"+ReciveJsonUSEREmail.toString());
           print("ReciveJsonUSERMobile"+ReciveJsonUSERMobile.toString());
           print("ReciveJsonUSEROrganization"+ReciveJsonUSEROrganization.toString());
           print("ReciveJsonUSERStatus"+ReciveJsonUSERStatus.toString());
      });

    }).catchError((error) {
      setStatus(error);
    });
  }
  //---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//---------------------------------------------------------------------------------------------------//
  String Upadteurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/ProfileUpdate.php';
  uploadProfileUpadte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(Upadteurl, body: {
      "Token": GlobalString.Token,
      "User_ID": ReciveUserID.toString(),
      "FirstName": FirstNameController.text.toString(),
      "LastName": LastNameController.text.toString(),
      "Mobile": MobileController.text.toString(),
      "Organization": OrganizationController.text.toString(),
    }).then((resultUpadte) {
      print("URL"+Upadteurl.toString());
      print("Token"+GlobalString.Token);
      print("User_ID"+ReciveUserID.toString());
      print("FirstName"+FirstNameController.text.toString());
      print("LastName" + LastNameController.text.toString());
      print("Mobile" + MobileController.text.toString());
      print("Organization" + OrganizationController.text.toString());
      print("statusCode" + resultUpadte.statusCode.toString());
      print("resultbody" + resultUpadte.body);
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(resultUpadte.statusCode == 200 ? resultUpadte.body : errMessage);
      var data = json.decode(resultUpadte.body);
      ReciveJsonStatus = data["status"].toString();
      print("status" + ReciveJsonStatus.toString());

      _handleSubmitted();

    }).catchError((error) {
      setStatus(error);
    });
  }
  //--------------------------------------------------------------------------------------------------------//
  Future<void> _FalseAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ooops Try Again.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Someting Wrong".toString(),
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color: ColorCode.TextColorCodeBlue,
                                                fontWeight: FontWeight.bold),),
              ],
              ),
            ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Try Again', style: new TextStyle(fontSize: 15.0,
                                                                color: ColorCode.TextColorCodeBlue,
                                                                fontWeight: FontWeight
                                                                    .bold),),
              )
          ],
          );
      },
      );
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _TrueSuccessAlert() async {
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
                Text("Profile has benn Update Successfully".toString(),
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
              child: Text('Cancel', style: new TextStyle(fontSize: 15.0,
                                                             color: ColorCode.TextColorCodeBlue,
                                                             fontWeight: FontWeight
                                                                 .bold),),
              ),
            FlatButton(
              onPressed: () {


                Navigator.of(context).pushNamed(HomeScreen.tag);
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
//------------------------------------------------------------------------------------------------------------//
  void _handleSubmitted() {
    if(ReciveJsonStatus == "false"){
      print("false");
      _FalseAlert();
    }else if(ReciveJsonStatus == "true"){
      _TrueSuccessAlert();
      print("True");
    }
  }
  @override
  void initState() {
    super.initState();
    this.fetchMyProfileUpdate();
  }
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;


    final ProfileData = new Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: new Column(
        children: <Widget>[
          new Container(
            color: Color(0xffFFFFFF),
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'First Name*',
                                style: TextStyle(
                                    color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w600,fontSize: 15.0,
                                    letterSpacing: 1.3),
                                ),
                            ],
                            ),
                        ],
                        )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              controller: FirstNameController,
                              focusNode: myFocusNodeFirstName,
                              decoration: InputDecoration(
                                hintText: ReciveJsonUSERFirstName,
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.adn,
                                    color: ColorCode.TextColorCodeBlue,
                                    ),
                                  ),
                                ),
                              //enabled: !_status,
                              //autofocus: !_status,
                              ),
                            ),
                        ],
                        )),
 //----------------------------------------------------------------------------------------------------------------//
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Last Name*',
                                style: TextStyle(
                                    color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w600,fontSize: 15.0,
                                    letterSpacing: 1.3),
                                ),
                            ],
                            ),
                        ],
                        )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              controller: LastNameController,
                              focusNode: myFocusNodeLastName,
                              decoration: InputDecoration(
                                hintText: ReciveJsonUSERLastName,
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.solidUser,
                                    color: ColorCode.TextColorCodeBlue,
                                    ),
                                  ),
                                ),
                              //enabled: !_status,
                              //autofocus: !_status,
                              ),
                            ),
                        ],
                        )),
//----------------------------------------------------------------------------------------------------------------//
/*                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Email*',
                                style: TextStyle(
                                    color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w600,fontSize: 15.0,
                                    letterSpacing: 1.3),
                                ),
                            ],
                            ),
                        ],
                        )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              controller: EmailController,
                              focusNode: myFocusNodeEmail,
                              decoration: InputDecoration(
                                hintText: ReciveJsonUSEREmail,
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    Icons.mail,
                                    color: ColorCode.TextColorCodeBlue,
                                    ),
                                  ),
                                ),
                              //enabled: !_status,
                              //autofocus: !_status,
                              ),
                            ),
                        ],
                        )),*/
//----------------------------------------------------------------------------------------------------------------//
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Mobile Number*',
                                style: TextStyle(
                                    color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w600,fontSize: 15.0,
                                    letterSpacing: 1.3),
                                ),
                            ],
                            ),
                        ],
                        )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              controller: MobileController,
                              focusNode: myFocusNodeMobile,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: ReciveJsonUSERMobile,
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.phone,
                                    color: ColorCode.TextColorCodeBlue,
                                    ),
                                  ),
                                ),
                              //enabled: !_status,
                              //autofocus: !_status,
                              ),
                            ),
                        ],
                        )),
//----------------------------------------------------------------------------------------------------------------//
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Organization*',
                                style: TextStyle(
                                    color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w600,fontSize: 15.0,
                                    letterSpacing: 1.3),
                                ),
                            ],
                            ),
                        ],
                        )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              controller: OrganizationController,
                              focusNode: myFocusNodeOrganization,
                              decoration: InputDecoration(
                                hintText: ReciveJsonUSEROrganization,
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.atlassian,
                                    color: ColorCode.TextColorCodeBlue,
                                    ),
                                  ),
                                ),
                              //enabled: !_status,
                              //autofocus: !_status,
                              ),
                            ),
                        ],
                        )),
                ],
                ),
              ),
            )
        ],
        ),
      );
//---------------------------------------------------------------------------------------------//
    return Scaffold(
        appBar: new AppBar(
          title: Text(GlobalString.ProfileUpdate.toUpperCase(),style: TextStyle(
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
        body: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            ProfileData,
          ],
          ),
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
                  icon: Icon(FontAwesomeIcons.fileExport,color: Colors.white,), //`Icon` to display
                    label: Text(GlobalString.UpdateProfileBtn.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                   onPressed: () {
                      /*setState(() {
                        uploadProfileUpadte();
                      });*/
                     uploadProfileUpadte();

                    },
                  ),

                ),
              //flex: 2,
              ),
          ],
          ),
        ),
        );
  }
}

//----------------------------------------------------------------------------------------------//