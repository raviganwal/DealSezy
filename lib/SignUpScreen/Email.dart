import 'dart:io';
import 'package:dealsezy/SignUpScreen/Organization.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:dealsezy/LoginScreen/widgets/custom_shape.dart';
import 'package:dealsezy/LoginScreen/widgets/customappbar.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
void main() => runApp(new Email());
//-----------------------------------------------------------------------------//
class Email extends StatefulWidget {
  static String tag = 'Email';
  final String SendFirstName;
  final String SendLastName;
  final String SendMobileNumber;
  final String SendPassword;
  final String SendOrganization;
  Email({Key key, this.SendFirstName, this.SendLastName, this.SendMobileNumber, this.SendPassword, this.SendOrganization}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
//------------------------------------------------------------------------------//
class _MyAppState extends State<Email> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String Email;
  String status = '';
  String errMessage = 'Error Send Data';
  TextEditingController SignupEmailController = new TextEditingController();
  final FocusNode myFocusNodeEmail = FocusNode();
  String ReciveJsonStatus ='';
  String ReciveJsonMSG ='';

//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(Organization.tag);
  }
//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/Registration.php';
  upload() {
    http.post(url, body: {
      "FirstName": widget.SendFirstName.toString(),
      "LastName": widget.SendLastName.toString(),
      "Email": SignupEmailController.text.toString(),
      "Mobile": widget.SendMobileNumber.toString(),
      "Password": widget.SendPassword.toString(),
      "OrgID": widget.SendOrganization.toString(),
      "Token": GlobalString.Token
    }).then((result) {
     // print("uploadEndPoint"+url.toString());
      print("FirstName" + widget.SendFirstName.toString());
      print("LastName" +  widget.SendLastName.toString());
      print("Email" + SignupEmailController.text.toString());
      print("Mobile" + widget.SendMobileNumber.toString());
      print("Password" + widget.SendPassword.toString());
      print("OrgID" + widget.SendOrganization.toString());
      print("Token" + GlobalString.Token);
      print("statusCode" + result.statusCode.toString());
     print("resultbody" + result.body);
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var data = json.decode(result.body);
      ReciveJsonStatus = data["Status"].toString();
      ReciveJsonMSG = data["MSG"].toString();

      print("Status     " + ReciveJsonStatus.toString());
      print("MSG   " + ReciveJsonMSG.toString());
     _handleSubmitted();

    }).catchError((error) {
      setStatus(error);
    });
  }
//------------------------------------------------------------------------------------------------------------//
  void _handleSubmitted() {
    if(ReciveJsonStatus == "false"){
      _SignupAlert();
    }else if(ReciveJsonStatus == "true"){
      _SignupSuccessAlert();
      print(ReciveJsonMSG);
    }
  }
//------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return new WillPopScope(
      onWillPop: BackScreen,
      child: new Scaffold(
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
                  SizedBox(height:15.0),
                  WhatName(),
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
  Widget WhatName() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            //color: ColorCode.AppColorCode,
            child: Text(
              GlobalString.Email,style: TextStyle(color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
      );
  }
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
                maxLength: 32,
                validator: validateEmail,
                onSaved: (String val) {
                  Email = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Email',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Email Address',labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.email,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//---------------------------------------------------------------------------------------------------------------//
              SizedBox(height: 0.0),
              new RaisedButton(
                color: ColorCode.AppColorCode,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                textColor: Colors.white,
                padding: EdgeInsets.all(0.0),
                onPressed: _sendToServer,
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
                    GlobalString.FormSubmit, style: TextStyle(color:ColorCode.TextColorCode,fontSize: _large? 14: (_medium? 12: 10)),),
                  ),
                ),
            ],
            ),
          ),
      ],
      );
  }
  //----------------------------------------------------------------------------------------------------------------------//
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
//-------------------------------------------------------------------------------------------------------------------//
  _sendToServer() async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
              print("true");
      upload();
    } else {
      // validation error
      setState(() {
        print("Faield");
        _validate = true;
      });
    }
  }
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _SignupAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something Wrong Try Again.. ', textAlign: TextAlign.center,
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
  Future<void> _SignupSuccessAlert() async {
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
              child: Text('Cancel', style: new TextStyle(fontSize: 15.0,
                                                         color: ColorCode.TextColorCodeBlue,
                                                         fontWeight: FontWeight
                                                             .bold),),
              ),
            FlatButton(
              onPressed: () {
                //("hello123"+id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                      )),
                  );
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
}
//--------------------------------------------------------------------------------------------------------//