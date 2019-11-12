import 'package:dealsezy/AboutUs/AboutUsScreen.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/Model/ChatReciveDataModel.dart';
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
import 'package:toast/toast.dart';
//--------------------------------------------------------------------------------------//
class ChatMessage extends StatefulWidget {
  static String tag = 'ChatMessage';

  final String value1;
  final String value2;
  final String value3;
  final String value4;

  ChatMessage({Key key, this.value1, this.value2, this.value3,this.value4}) : super(key: key);
  @override
  State createState() => new ChatMessageState();
}
//--------------------------------------------------------------------------------------//
class ChatMessageState extends State<ChatMessage> {
  final TextEditingController _textController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String AppReciveUserID="";
  String AppReciveUserFullName="";
  String ReciveUserEmail="";
  String errMessage = 'Error Send Data';
  String status = '';
  var data;
  var ReciveDataFromJson;
  var FinalReciveFrom_ID;
  var FinalReciveMessage;
  var FinalReciveNotEqualMessage;
  List<ChatReciveDataModel> _ChatListMessage = [];
  var loading = true;
  ScrollController _scrollController = new ScrollController();
  var ChangePageFinalReciveNotEqualMessage;
  var ChangePageFinalReciveMessage;
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
      "To_ID": widget.value3.toString(),
      "To_Name": widget.value2.toString(),
      "Message": _textController.text.toString(),
      "Adv_ID": widget.value4.toString(),
      "Adv_Title": widget.value1.toString()
    }).then((resultUpadte) {
    print("URL"+UpdatePostEdit.toString());
      print("Token"+GlobalString.Token);
      print("statusCode" + resultUpadte.statusCode.toString());
      print("resultbody" + resultUpadte.body);

      print("AppUserID" + AppReciveUserID.toString());
      print("AppUserFullName" + AppReciveUserFullName.toString());
      print("PostUserID" + widget.value3.toString());
      print("PostUserName" +widget.value2.toString());
      print("Message" + _textController.text.toString());
      print("Adv_ID" + widget.value4.toString());
      print("Adv_Title" + widget.value1.toString());
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(resultUpadte.statusCode == 200 ? resultUpadte.body : errMessage);
      var data = json.decode(resultUpadte.body);
      //ReciveJsonStatus = data["STATUS"].toString();
      //print("STATUS" + ReciveJsonStatus.toString());
      _textController.clear();
     // _textController.text;
    }).catchError((error) {
      setStatus(error);
    });
  }
//---------------------------------------------------------------------------------------------------//
  String ReciveChatDataurl ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/ViewChatMsgs.php';
  ReciveChatData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    ReciveUserEmail = prefs.getString(Preferences.KEY_Email).toString();
    AppReciveUserFullName = prefs.getString(Preferences.KEY_FullName).toString();
    // print("ReciveUserID"+prefs.getString(Preferences.KEY_UserID).toString());
    http.post(ReciveChatDataurl, body: {
      "Token": GlobalString.Token,
      "From_ID": AppReciveUserID.toString(),
      "To_ID": widget.value3.toString(),
      "Adv_ID": widget.value4.toString()
    }).then((ResultReciveChatData) {
//------------------------------------------------------------------------------------------------------------//
      setStatus(ResultReciveChatData.statusCode == 200 ? ResultReciveChatData.body : errMessage);
      //print("jsonresp ${ResultReciveChatData.body}");
      data = json.decode(ResultReciveChatData.body);
     print("ReciveData ${data.toString()}");
      ReciveDataFromJson =data["data"];
      //print("ReciveDataFromJson ${ReciveDataFromJson.toString()}");

      setState(() {
        for (Map i in ReciveDataFromJson) {
          _ChatListMessage.add(ChatReciveDataModel.formJson(i));
          loading = false;
        }
      });
    }).catchError((error) {
      setStatus(error);
    });
  }
  @override
  void dispose() {
    // SendChatController.dispose();
    super.dispose();
  }
//-------------------------------------------------------------------------------------------//
  @override
  void initState() {
  // this._checkInternetConnectivity();
    super.initState();
    this.ReciveChatData();
  }
//---------------------------------------------------------------------------------------------------//
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
  //---------------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Timer(Duration(milliseconds: 1), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    Widget _textComposerWidget() {
      return new IconTheme(
        data: new IconThemeData(color: ColorCode.TextColorCodeBlue),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                  controller: _textController,
                  //onSubmitted: _handleSubmitted,
                  //onSubmitted: EditPostUpadte(),
                  ),
                ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: new Icon(Icons.send,color: ColorCode.AppColorCode,),
                  onPressed: () {
                    EditPostUpadte();
                    Toast.show("Message Sent   "+_textController.text.toString(), context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  }
                  ),
                )
            ],
            ),
          ),
        );
    }
//--------------------------------------------------------------------------------------//
    return   Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(widget.value2.toString().toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
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
      //body: ChatLayOut,
      //body: ChatLayOut,
      body: new  Column(
        children: <Widget>[
          /*loading
              ? Center(
            child: CircularProgressIndicator(),
            ):*/
          new Flexible(
            child: new ListView.builder(
              controller: _scrollController,
              padding: new EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _ChatListMessage == null ? 0 : _ChatListMessage.length,
              itemBuilder: (BuildContext context, i) {
                final ChatUserMessage = _ChatListMessage[i];
                FinalReciveFrom_ID = ChatUserMessage.From_ID;
                FinalReciveMessage = ChatUserMessage.Message;
                //print("AppReciveUserID= "+AppReciveUserID);
                //print("FinalReciveFrom_ID= "+FinalReciveFrom_ID);

                if(AppReciveUserID == FinalReciveFrom_ID ){
                  // print("FinalReciveEqualMessage");
                  FinalReciveMessage = ChatUserMessage.Message.toString();
                  // print("FinalReciveEqualMessage= "+FinalReciveMessage.toString());



                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text(
                          ChatUserMessage.Message_TIME,
                          style:
                          TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        Bubble(
                          message:FinalReciveMessage.toString(),
                          isMe: false,
                          ),
                      ],
                      ),
                    );
                }


//-----------------------------------------------------------------------------------------------//
                else if(AppReciveUserID != FinalReciveFrom_ID){
                  FinalReciveNotEqualMessage = ChatUserMessage.Message.toString();
                  //print("FinalReciveNotEqualMessage"+FinalReciveNotEqualMessage);
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text(
                          ChatUserMessage.Message_TIME,
                          style:
                          TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        Bubble(
                          message:FinalReciveNotEqualMessage.toString(),
                          isMe: true,
                          ),
                      ],
                      ),
                    );
                }
              },

              ),
            ),
          new Divider(
            height: 1.0,
            ),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
              ),
            child: _textComposerWidget(),
            ),
        ],
        ),
      );
  }
//--------------------------------------------------------------------------------------//
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