import 'package:dealsezy/SignUpScreen/MobileNumber.dart';
import 'package:dealsezy/SignUpScreen/Mobilenumber.dart';
import 'package:dealsezy/SignUpScreen/SetUpPassword.dart';
import 'package:dealsezy/SignUpScreen/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:dealsezy/LoginScreen/widgets/custom_shape.dart';
import 'package:dealsezy/LoginScreen/widgets/customappbar.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/LoginScreen/widgets/textformfield.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(new MobileNumber());
//-----------------------------------------------------------------------------//
class MobileNumber extends StatefulWidget {
  static String tag = 'MobileNumber';

  final String SendFirstName;
  final String SendLastName;

  MobileNumber({Key key, this.SendFirstName, this.SendLastName}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
//------------------------------------------------------------------------------//
class _MyAppState extends State<MobileNumber> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String MobileNumber;
  TextEditingController SignupMobileNumberController = new TextEditingController();
  final FocusNode myFocusNodeMobileNumber = FocusNode();
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(SignUpScreen.tag);
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
              GlobalString.WhatMobileNumber,style: TextStyle(color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
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
                focusNode: myFocusNodeMobileNumber,
                controller: SignupMobileNumberController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: validateMobile,
                onSaved: (String val) {
                  MobileNumber = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Mobile Number',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Mobile Number',labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.phone_android,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
              /*TextFormField(
                focusNode: myFocusNodeMobileNumber,
                controller: SignupMobileNumberController,
                maxLength: 32,
                validator: validateFirstName,
                onSaved: (String val) {
                  MobileNumber = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Last Name',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Last Name',labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.person, color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),*/
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
                    GlobalString.Next, style: TextStyle(color:ColorCode.TextColorCode,fontSize: _large? 14: (_medium? 12: 10)),),

                  ),
                ),
            ],
            ),
          ),
      ],
      );
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if(value.length != 10){
      return "Mobile number must 10 digits";
    }else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
     /* print("sendToServerSendFirstName"+widget.SendFirstName.toString());
      print("sendToServerSendLastName"+widget.SendLastName.toString());
      print("sendToServerMobileNumber"+SignupMobileNumberController.text.toString());*/
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetUpPassword(
                SendFirstName: widget.SendFirstName.toString(),
                SendLastName: widget.SendLastName.toString(),
                SendMobileNumber: SignupMobileNumberController.text.toString(),
              ),
            ));
    } else {
      // validation error
      setState(() {
        _validate = true;
       /* print("MobileNumber"+widget.SendFirstName.toString());
        print("MobileNumber"+widget.SendLastName.toString());
        print("MobileNumber"+SignupMobileNumberController.text.toString());*/
      });
    }
  }
}