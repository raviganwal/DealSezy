import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SignUpScreen/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/widgets/custom_shape.dart';
import 'package:dealsezy/LoginScreen/widgets/customappbar.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dealsezy/ConstantServerBasedUrl/ConstantURL.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(new LoginScreen());
//-----------------------------------------------------------------------------//
class LoginScreen extends StatefulWidget {
  static String tag = 'LoginScreen';
  @override
  _MyAppState createState() => _MyAppState();
}
//------------------------------------------------------------------------------//
class _MyAppState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String FirstName, LastName;
  TextEditingController SignupEmailController = new TextEditingController();
  TextEditingController SignupPasswordController = new TextEditingController();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  String Password;
  String errMessage = 'Error Send Data';
  String status = '';
  String ReciveJsonStatus ='';
  String ReciveJsonMSG ='';
  String ReciveJsonUserID ='';
  var ReciveUserStatus="";
  var ReciveUserID="";
  var data;
  var ReciveUserFirstName ="";
  var ReciveUserLastName ="";
  var ReciveUserEmail ="";
  var ReciveUserFullName ="";
//---------------------------------------------------------------------------------------------------//
  /*Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(LoginScreen.tag);
  }*/
//------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return new WillPopScope(
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  SizedBox(height:15.0),
                  Opacity(opacity: 0.88,child: CustomAppBar()),
                  clipShape(),
                  FormUI(),
                ],
                ),
              //child: FormUI(),
              ),
            ),
          ),
        ),
      );
  }
//----------------------------------------------------------------------------------------------//
  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/9 : _height/6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorCode.AppColorCode, ColorCode.AppColorCode],
                  ),
                ),
              ),
            ),
          ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorCode.AppColorCode, ColorCode.AppColorCode],
                  ),
                ),
              ),
            ),
          ),
      ],
      );
  }
//-----------------------------------------------------------------------------------------------//
  Widget FormUI() {
    return new Column(
      children: <Widget>[
        SizedBox(height: _height /20.0),
        new Container(
          height: _height,
          child: new ListView(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            //controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
//------------------------------------------------------------------------------------------------------------//
              new TextFormField(
                focusNode: myFocusNodeEmail,
                controller: SignupEmailController,
                maxLength: 50,
                validator: validateEmail,
                onSaved: (String val) {
                  FirstName = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter EmailID',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'EmailID',labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.envelope,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              //  SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
              new TextFormField(
                maxLength: 50,
                autocorrect: false,
                obscureText: true,
                focusNode: myFocusNodePassword,
                controller: SignupPasswordController,
                validator: (value) =>
                value.isEmpty ? "Password can't be empty" : null,
                onSaved: (val) => Password = val,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Password',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Password',labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.lock,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
//---------------------------------------------------------------------------------------------------------------//
              //SizedBox(height: 0.0),
              new RaisedButton(
                color: ColorCode.AppColorCode,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                textColor: Colors.white,
                padding: EdgeInsets.all(0.0),
                /*onPressed(){_sendToServer();_displaySnackbar();} ,*/
                onPressed: () {
                  _displaySnackbar(context);
                   _sendToServer();
                },
                child: Container(
                  alignment: Alignment.center,
//        height: _height / 20,
                  width:_large? _width/4 : (_medium? _width/3.75: _width/3.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                      colors: <Color>[ColorCode.AppColorCode,ColorCode.AppColorCode],
                      ),
                    ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    GlobalString.SigIn, style: TextStyle(color:ColorCode.TextColorCode,fontSize: _large? 14: (_medium? 12: 10)),),

                  ),
                ),
              //signUpButtonRow(),
              forgetPassTextRow(),
              SizedBox(height:20.0),
              // signUpTextRow(),
              //SizedBox(height:10.0),

            ],
            ),
          ),
      ],
      );
  }
//--------------------------------------------------------------------------------------------------------------------------------//
  Widget forgetPassTextRow() {
    return Container(
        margin: EdgeInsets.only(top: _height / 40.0),
        child: Row(children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: ColorCode.TextColorCode,
              child:  Text(
                GlobalString.Forgot,
                style: TextStyle(color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold,fontSize: _large? 14: (_medium? 12: 10)),
                ),
              onPressed: () => null,
              ),
            ),
          Expanded(
            child: RaisedButton(
              color: ColorCode.AppColorCode,
              child: Text(
                GlobalString.Signup, style: TextStyle(color:ColorCode.TextColorCode,fontSize: _large? 14: (_medium? 12: 10)),),
              onPressed: () => Navigator.of(context).pushNamed(SignUpScreen.tag),
              ),
            ),
        ])
        );
  }
//----------------------------------------------------------------------------------------------//
  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            GlobalString.DontHave,
            style: TextStyle(color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
            ),
        ],
        ),
      );
  }
//-----------------------------------------------------------------------------------------------------------------------------------------//
  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
      return null;
    }
  }
  void  _displaySnackbar(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text('Please Wait........',style: TextStyle(color: ColorCode.TextColorCode),),
      backgroundColor: ColorCode.AppColorCode,
      ));
  }
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/Login.php';
  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    ReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    //print("ReciveUserFullName"+prefs.getString(Preferences.KEY_FullName).toString());
    http.post(url, body: {
      "Email": SignupEmailController.text,
      "Password": SignupPasswordController.text,
      "Token": GlobalString.Token
    }).then((result) {
      //print("uploadEndPoint"+url.toString());
      //print("FirstName" + SignupEmailController.text);
      //print("LastName" +   SignupPasswordController.text);
      //print("Token" + GlobalString.Token);
      //print("statusCode" + result.statusCode.toString());
      //print("resultbody" + result.body);
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      data = json.decode(result.body);

      //print("ReciveData"+data.toString());


      ReciveJsonStatus = data["Status"].toString();
      ReciveJsonMSG = data["MSG"].toString();

      ReciveUserStatus =data["JSONDATA"]["Status"].toString();
      ReciveUserID =data["JSONDATA"]["USER_ID"].toString();

      ReciveUserFirstName =data["JSONDATA"]["First Name"].toString();
      ReciveUserLastName =data["JSONDATA"]["Last Name"].toString();
      ReciveUserFullName =data["JSONDATA"]["First Name"].toString()+ " "+data["JSONDATA"]["Last Name"].toString();
      ReciveUserEmail =data["JSONDATA"]["Email"].toString();


      /*    print("ReciveUserStatus" + ReciveUserStatus.toString());
      print("ReciveUserID" + ReciveUserID.toString());*/
      /* print("ReciveUserFirstName" + ReciveUserFirstName.toString());
      print("ReciveUserLastName" + ReciveUserLastName.toString());
      print("ReciveUserEmail" + ReciveUserEmail.toString());
      print("ReciveUserFullName" + ReciveUserFullName.toString());*/

      _handleSubmitted();

    }).catchError((error) {
      setStatus(error);
    });
  }
//------------------------------------------------------------------------------------------------------------//
  void _handleSubmitted() {
    if(ReciveJsonStatus == "true"){
      //print("kk"+ReciveJsonStatus);
      if(ReciveUserStatus == 'Active'){
        new Preferences().storeDataAtLogin(data);
        //print("jjj"+ReciveJsonMSG);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
              )),
          );
      }
    }else if(ReciveJsonStatus == "false"){
      _SignInFailedAlert();
      print(ReciveJsonMSG);
    }
  }
//------------------------------------------------------------------------------------------------------------//
  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      /*print("True");
      print("sendToServerSignupEmail"+SignupEmailController.text);
      print("sendToServerSignupPassword"+SignupPasswordController.text);*/
      GetLogin();
    } else {
      // validation error
      setState(() {
        _validate = true;
        /*print("False");
         print("Email"+SignupEmailController.text.toString());
         print("Password"+SignupPasswordController.text.toString());*/
      });
    }
  }
//------------------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//-------------------------------------------------------------------------------------------------------------//
  Future<void> _SignInFailedAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something Went Wrong.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(ReciveJsonMSG.toString(),
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
              child: Text('Try Again', style: new TextStyle(fontSize: 15.0,
                                                                color: ColorCode.TextColorCodeBlue,
                                                                fontWeight: FontWeight
                                                                    .bold),),
              ),
          ],
          );
      },
      );
  }
}
//------------------------------------------------------------------------------------------------------------//