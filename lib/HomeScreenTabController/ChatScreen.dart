import 'package:dealsezy/AboutUs/AboutUsScreen.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/TermAndCondition/TermAndCondition.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/ChatScreen/ChatMessage.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
//--------------------------------------------------------------------------------------//
class ChatScreen extends StatefulWidget {
  static String tag = 'ChatScreen';
  @override
  State createState() => new ChatScreenState();
}
//--------------------------------------------------------------------------------------//
class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController SendChatController = new TextEditingController();
  final FocusNode myFocusNodeSendChat = FocusNode();
  String AppReciveUserID="";
  String AppReciveUserFullName="";
  String errMessage = 'Error Send Data';
  String status = '';
//--------------------------------------------------------------------------------------//
  //---------------------------------------------------------------------------------------------------//
  String UpdatePostEdit ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/AddChatMsg.php';
  EditPostUpadte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    AppReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    AppReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();

    http.post(UpdatePostEdit, body: {
      "Token": GlobalString.Token,
      "From_ID": AppReciveUserID.toString(),
      "From_Name": AppReciveUserFullName.toString(),
      "To_ID": AppReciveUserFullName.toString(),
    }).then((resultUpadte) {
      print("URL"+UpdatePostEdit.toString());
      print("Token"+GlobalString.Token);
      print("statusCode" + resultUpadte.statusCode.toString());
      print("resultbody" + resultUpadte.body);
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(resultUpadte.statusCode == 200 ? resultUpadte.body : errMessage);
      var data = json.decode(resultUpadte.body);
      //ReciveJsonStatus = data["STATUS"].toString();
      //print("STATUS" + ReciveJsonStatus.toString());


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
  @override
  Widget build(BuildContext context) {
//--------------------------------------------------------------------------------------//
    final ChatLayOut =  new  Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Today',
                            style:
                            TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          Bubble(
                            message: 'i am fine !',
                            isMe: false,
                            ),
                          Bubble(
                            message: 'yes i\'ve seen the docs',
                            isMe: false,
                            ),
                          Text(
                            'Feb 25, 2018',
                            style:
                            TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          Bubble(
                            message: 'Hi How are you ?',
                            isMe: true,
                            ),
                          Bubble(
                            message: 'have you seen the docs yet?',
                            isMe: true,
                            ),
                        ],
                        ),
                      );
                  },
                  ),
                ),
            ],
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(-2, 0),
                blurRadius: 5,
                ),
            ]),
            child: Row(
              children: <Widget>[
                /*IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera,
                    color: Color(0xff3E8DF3),
                    ),
                  ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.image,
                    color: Color(0xff3E8DF3),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  ),*/
                Expanded(
                  child: TextFormField(
                    controller: SendChatController,
                    focusNode: myFocusNodeSendChat,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                      border: InputBorder.none,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Color(0xff3E8DF3),
                    ),
                  ),
              ],
              ),
            ),
          )
      ],
      );
//--------------------------------------------------------------------------------------//
    return new WillPopScope(
        onWillPop: () async {
      Future.value(
          false); //return a `Future` with false value so this route cant be popped or closed.
    },
    child:  Scaffold(
      drawer: _drawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(GlobalString.CHAT.toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
        centerTitle: true,
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(
                padding: new EdgeInsets.all(15.0),
                icon: new Icon(
                  Icons.notifications,
                  color: Colors.white,
                  ),
                /*onPressed: () {
                    //print("hello"+id.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryTotalAddList(
                            value: Userid.toString(),
                            )),
                      );
                  },*/
                ),
              new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      new Icon(null),
                      new Positioned(
                          top: 5.0,
                          right: 5,
                          child: new Center(
                            child: new Text(
                              "".toString(),
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                              ),
                            )),
                    ],
                    )),
            ],
            ),
        ],
        ),
      backgroundColor: Colors.white,
      body: ChatLayOut,),
        );
  }
//--------------------------------------------------------------------------------------//
  Widget _drawer() {
    return new Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text("Mr. "+"".toUpperCase(),style: TextStyle(
                  fontSize: 16.0,
                  color: ColorCode.TextColorCode,
                  letterSpacing: 1.4,
                  backgroundColor: Colors.transparent,
                  fontWeight: FontWeight.bold),),
              accountEmail: Text("".toString(),style: TextStyle(
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
                //TapMessage(context, "Logout!");
              },
              ),
            Divider(
              height: 2.0,
              ),
          ],
          ));
  }
//--------------------------------------------------------------------------------------//
}
class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        1
                      ],
                      colors: [
                        Color(0xFFF6D365),
                        Color(0xFFFDA085),
                      ])
                      : LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        1
                      ],
                      colors: [
                        Color(0xFFEBF5FC),
                        Color(0xFFEBF5FC),
                      ]),
                  borderRadius: isMe
                      ? BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    )
                      : BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(0),
                    ),
                  ),
                child: Column(
                  crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.grey,
                        ),
                      )
                  ],
                  ),
                ),
            ],
            )
        ],
        ),
      );
  }
}