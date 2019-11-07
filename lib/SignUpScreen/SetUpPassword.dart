import 'package:dealsezy/SignUpScreen/MobileNumber.dart';
import 'package:dealsezy/SignUpScreen/Organization.dart';
import 'package:dealsezy/SignUpScreen/SetUpPassword.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:dealsezy/LoginScreen/widgets/custom_shape.dart';
import 'package:dealsezy/LoginScreen/widgets/customappbar.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/LoginScreen/widgets/textformfield.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(new SetUpPassword());
//-----------------------------------------------------------------------------//
class SetUpPassword extends StatefulWidget {
  static String tag = 'SetUpPassword';
  final String SendFirstName;
  final String SendLastName;
  final String SendMobileNumber;
  SetUpPassword({Key key, this.SendFirstName, this.SendLastName, this.SendMobileNumber}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
//------------------------------------------------------------------------------//
class _MyAppState extends State<SetUpPassword> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String Password, ConfirmPassword;
  TextEditingController SignupPasswordController = new TextEditingController();
  final FocusNode myFocusNodePassword = FocusNode();
  var passKey = GlobalKey<FormFieldState>();
  GlobalKey<FormState> formKey = new GlobalKey();
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(LoginScreen.tag);
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
              autovalidate: true,
              key: formKey,
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
              GlobalString.SetuPassword,style: TextStyle(color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
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
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//

              TextFormField(
                autocorrect: false,
                obscureText: true,
                validator: (value) =>
                value.isEmpty ? "Password can't be empty" : null,
                onSaved: (val) => ConfirmPassword = val,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Confirm Password',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Confirm Password',labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.lock, color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
//---------------------------------------------------------------------------------------------------------------//
              SizedBox(height: 15.0),
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
//--------------------------------------------------------------------------------------------------------------//
  Future<void> _PasswordAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Alert.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your Password Does Not Match Try Again..',
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
               Navigator.of(context).pop();
              },
              child: Text('OK', style: new TextStyle(fontSize: 15.0,
                                                         color: ColorCode.TextColorCodeBlue
                                                           ,
                                                         fontWeight: FontWeight
                                                             .bold),),
              )
          ],
          );
      },
      );
  }
//---------------------------------------------------------------------------------------------------------//
  _sendToServer() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();  //this will cause the onSaved method to get called
      //you will need to do some additional validation here like matching passwords
      if(Password != ConfirmPassword) {
        print("Password Not Match");
        _PasswordAlert();
      } else {
        /*print("Password Match");
        print("SendFirstName"+widget.SendFirstName.toString());
        print("SendLastName"+widget.SendLastName.toString());
        print("MobileNumber"+widget.SendMobileNumber.toString());
        print("Password"+SignupPasswordController.text.toString());*/
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Organization(
                SendFirstName: widget.SendFirstName.toString(),
                SendLastName: widget.SendLastName.toString(),
                SendMobileNumber: widget.SendMobileNumber.toString(),
                SendPassword: SignupPasswordController.text.toString(),
                ),
              ));
      }
    }
  }

  equals(String val, String confirmPassword) {}
}