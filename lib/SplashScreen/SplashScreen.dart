import 'dart:async';
import 'package:dealsezy/EditPostImageScreen/EditPostImage.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';

//----------------------------------------------------------------------------------------------//
class SplashScreen extends StatefulWidget {
  static String tag = 'SplashScreen';

  @override
  SplashScreenState createState() => new SplashScreenState();
}
//----------------------------------------------------------------------------------------------//
class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  /*AnimationController animationController;
  Animation<double> animation;*/
  void handleTimeout() async {
    print("hello");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("KEY_UserID"+prefs.getString(Preferences.KEY_UserID.toString()));
    if (prefs.getString(Preferences.KEY_UserStatus) != null) {
      if (prefs.getString(Preferences.KEY_UserStatus) == 'Active') {
        print("Preferences.KEY_UserID"+Preferences.KEY_UserStatus);
        Navigator.of(context).pushNamed(HomeScreen.tag);
      }
    } else {
      Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (_) => new LoginScreen()));
    }
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }


//----------------------------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    startTimeout();
  }
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorCode.TextColorCode,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: new Text(
                  GlobalString.AppDeveloperName,style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600,color:ColorCode.TextColorCodeBlue),
                  ),
                )
            ],
            ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
              /*  width: animation.value * 250,
                height: animation.value * 250,*/
                fit: BoxFit.contain,
                ),
            ],
            ),
        ],
        ),
      );
  }
}
//----------------------------------------------------------------------------------------------//