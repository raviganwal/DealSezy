import 'dart:async';
import 'package:dealsezy/AboutUs/AboutUsScreen.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealsezy/ProfileUpdate/ProfileUpdate.dart';
import 'package:dealsezy/SplashScreen/SplashScreen.dart';
import 'package:dealsezy/TermAndCondition/TermAndCondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
//----------------------------------------------------------------------------------------------//
class MyAccount extends StatefulWidget {
  static String tag = 'MyAccount';
  final String value;
  MyAccount({Key key, this.value}) : super(key: key);
  @override
  MyAccountState createState() => new MyAccountState();
}
//----------------------------------------------------------------------------------------------//
class MyAccountState extends State<MyAccount> with SingleTickerProviderStateMixin{
  TextEditingController controller1 = new TextEditingController();
  var data;
  var loading = false;
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  var ReciveUserID="";
  final FocusNode myFocusNode = FocusNode();
  String errMessage = 'Error Send Data';
  String status = '';
  String ReciveJsonStatus ='';
  String ReciveJsonUSER_ID ='';
  String ReciveJsonUSERFirstName ='';
  String ReciveJsonUSERLastName ='';
  String ReciveJsonUSEREmail ='';
  String ReciveJsonUSERMobile ='';
  String ReciveJsonUSERPassword ='';
  String ReciveJsonUSEROrganization ='';
  String ReciveJsonUSERProfilePIC='';
  String ReciveJsonUSERStatus='';
  String ReciveJsonUSERFullName='';
  var ReciveUserEmail='';
  var ReciveUserFullName='';
//----------------------------------------------------------------------------------------------//
  String MyProfileurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/MyProfile.php';
  fetchMyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    ReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(MyProfileurl, body: {
      "Token": GlobalString.Token,
      "User_ID": ReciveUserID.toString()
    }).then((resultMyProfile) {
      //print("uploadEndPoint"+MyProfileurl.toString());
      //print("Token" + GlobalString.Token);
      //print("User_ID" +  ReciveUserID.toString());
      //print("statusCode" + resultMyProfile.statusCode.toString());
     // print("resultbody" + resultMyProfile.body);
      //return result.body.toString();
      setStatus(resultMyProfile.statusCode == 200 ? resultMyProfile.body : errMessage);
      setState(() {
        var extractdata = json.decode(resultMyProfile.body);
        data = extractdata["JSONDATA"];
         print("ReciveData"+data.toString());

        ReciveJsonUSER_ID = data[0]["USER_ID"].toString();
        ReciveJsonUSERFirstName = data[0]["First Name"].toString();
        ReciveJsonUSERLastName = data[0]["Last Name"].toString();
        ReciveJsonUSEREmail = data[0]["Email"].toString();
        ReciveJsonUSERMobile = data[0]["Mobile"].toString();
        ReciveJsonUSERPassword = data[0]["Password"].toString();
        ReciveJsonUSEROrganization = data[0]["Organization"].toString();
        ReciveJsonUSERProfilePIC = data[0]["ProfilePIC"].toString();
        ReciveJsonUSERStatus = data[0]["Status"].toString();
        ReciveJsonUSERFullName= data[0]["First Name"]+ " " +data[0]["Last Name"].toString();

           print("ReciveJsonUSER_ID"+ReciveJsonUSER_ID.toString());
           print("ReciveJsonUSERFirstName"+ReciveJsonUSERFirstName.toString());
           print("ReciveJsonUSERLastName"+ReciveJsonUSERLastName.toString());
           print("ReciveJsonUSEREmail"+ReciveJsonUSEREmail.toString());
           print("ReciveJsonUSERMobile"+ReciveJsonUSERMobile.toString());
           print("ReciveJsonUSERPassword"+ReciveJsonUSERPassword.toString());
           print("ReciveJsonUSEROrganization"+ReciveJsonUSEROrganization.toString());
           print("ReciveJsonUSERProfilePIC"+ReciveJsonUSERProfilePIC.toString());
           print("ReciveJsonUSERStatus"+ReciveJsonUSERStatus.toString());
           print("ReciveJsonUSERFullName"+ReciveJsonUSERFullName.toString());
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
  @override
  void initState() {
    super.initState();
    this.fetchMyProfile();
  }
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
//---------------------------------------------------------------------------------------------------//
    final ProfileImagetab = new  Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
                         SizedBox(
                        // height: 210,
                           child: Column(
                             children: [
                               ListTile(
                                 title: Text(ReciveJsonUSERFullName.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
                                 leading: new Container(
                                   height: 80.0,
                                   width: 80.0,
                                   /*decoration: new BoxDecoration(
                                     //color: const Color(0xff7c94b6),
                                     borderRadius: BorderRadius.all(const Radius.circular(00.0)),
                                     border: Border.all(color: const Color(0xFF28324E)),
                                     ),*/
                                   child: new Image.network(imageurl+ReciveJsonUSERProfilePIC)
                                 ),
                                 subtitle: Text(GlobalString.Edit.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
                                 onTap: () {
                                   print("d");
                                   Navigator.of(context).pushNamed(ProfileUpdate.tag);
                                   // do something
                                 },
                                 ),
                             ],

                           ),
                       ),
      ]),
      );
//---------------------------------------------------------------------------------------------------//
    final ProfileData = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white70,
            child: ListTile(
              title: Text(GlobalString.FisrtName.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
              subtitle: Text(
                ReciveJsonUSERFirstName,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                ),
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.solidUser, color: ColorCode.TextColorCodeBlue),
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
              title: Text(GlobalString.LastNames.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
              subtitle: Text(
                ReciveJsonUSERLastName,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                ),
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.solidUser, color: ColorCode.TextColorCodeBlue),
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
              title: Text(GlobalString.Emails.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
              subtitle: Text(
                ReciveJsonUSEREmail.toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                ),
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.solidEnvelope, color: ColorCode.TextColorCodeBlue),
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
              title: Text(GlobalString.Mobile.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
              subtitle: Text(
                ReciveJsonUSERMobile,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                ),
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.phone, color: ColorCode.TextColorCodeBlue),
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
              title: Text(GlobalString.Organization.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
              subtitle: Text(
                ReciveJsonUSEROrganization,style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                ),
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.industry, color: ColorCode.TextColorCodeBlue),
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
              title: Text(GlobalString.Status.toUpperCase().toString(),style: TextStyle(fontSize: 13.0, color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold)),
              subtitle: Text(
                ReciveJsonUSERStatus,style: TextStyle(fontSize: 13.0, color: ColorCode.AppColorCode,fontWeight: FontWeight.bold),
                ),
              leading: IconButton(
                icon: Icon(FontAwesomeIcons.infoCircle, color: ColorCode.TextColorCodeBlue),
                onPressed: () {
                  //  _launchCaller(phoneNumber);
                },
                ),
              ),
            ),
        ],
        ),
      );
//---------------------------------------------------------------------------------------------//
    return new WillPopScope(
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: Scaffold(
        drawer: _drawer(),
        appBar: new AppBar(
          title: Text(GlobalString.MyAccount.toUpperCase(),style: TextStyle(
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
            ProfileImagetab,
            ProfileData,
            //Register,
          ],
          ),
        ),
      );
  }
  Widget _drawer() {
    return new Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text("Mr. "+ReciveUserFullName.toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: ColorCode.TextColorCode,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text(ReciveUserEmail,style: TextStyle(
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
                Navigator.of(context).pushNamed(AboutUsScreen.tag);
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
                Navigator.of(context).pushNamed(TermAndCondition.tag);
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
              removeData(context);
            },
            child: new Text('OK'))
      ],
      );
    showDialog(context: context, child: alert);
  }
//---------------------------------------------------------------------------------------------------//
  removeData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Preferences.KEY_UserStatus);
    Navigator.of(context).pushNamed(SplashScreen.tag);
  }
}
//----------------------------------------------------------------------------------------------//