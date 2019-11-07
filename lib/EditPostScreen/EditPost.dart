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
class EditPost extends StatefulWidget {
  static String tag = 'EditPost';
  final String value;
  EditPost({Key key, this.value}) : super(key: key);
  @override
  EditPostState createState() => new EditPostState();
}
//----------------------------------------------------------------------------------------------//
class EditPostState extends State<EditPost> with SingleTickerProviderStateMixin{
  TextEditingController controller1 = new TextEditingController();
  var data;
  var loading = false;
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  final FocusNode myFocusNode = FocusNode();
  var ReciveUserID="";
  String errMessage = 'Error Send Data';
  String status = '';

  String ReciveTitle ='';
  String RecivePrice ='';
  String ReciveDescription ='';
  String ReciveFeatures ='';
  String ReciveCondition ='';
  String ReciveReasonofSelling ='';
  String RecivePost_Time ='';
  String ReciveVisible_To ='';
  String ReciveJsonAdv_ID ='';
  String ReciveJsonCat_ID ='';
  String ReciveJsonSubCat_ID ='';
  String JsonReciveUser_ID ='';
  String ReciveStatus ='';
  String AppReciveUserID="";
  var ReciveJsonStatus ='';

  TextEditingController TitleController = new TextEditingController();
  TextEditingController PriceController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  TextEditingController FeaturesController = new TextEditingController();
  TextEditingController ConditionController = new TextEditingController();
  TextEditingController ReasonController = new TextEditingController();

  final FocusNode myFocusNodeTitle = FocusNode();
  final FocusNode myFocusNodePrice = FocusNode();
  final FocusNode myFocusNodeDescription = FocusNode();
  final FocusNode myFocusNodeFeatures = FocusNode();
  final FocusNode myFocusNodeCondition = FocusNode();
  final FocusNode myFocusNodeReason = FocusNode();

//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/AdvView.php';

  fetchPostEdit() async {
    http.post(url, body: {
      "Token": GlobalString.Token,
      "Adv_ID": widget.value.toString(),
    }).then((result) {
      // print("uploadEndPoint"+url.toString());
      //print("Token" + GlobalString.Token);
      //print("DisplayAdv_ID" + widget.value1.toString());
      //  print("statusCode" + result.statusCode.toString());
      //  print("resultbody" + result.body);
      //return result.body.toString();
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      setState(() {
        var extractdata = json.decode(result.body);
        data = extractdata["JSONDATA"];
        // print("ReciveData"+data.toString());

        ReciveJsonAdv_ID = data[0]["Adv_ID"].toString();
        ReciveJsonCat_ID = data[0]["Cat_ID"].toString();
        ReciveJsonSubCat_ID = data[0]["SubCat_ID"].toString();
        ReciveTitle = data[0]["Title"].toString();
        RecivePrice = data[0]["Price"].toString();
        ReciveDescription = data[0]["Description"].toString();
        ReciveFeatures = data[0]["Features"].toString();
        ReciveCondition = data[0]["Condition"].toString();
        ReciveReasonofSelling = data[0]["Reason of Selling"].toString();
        JsonReciveUser_ID = data[0]["User_ID"].toString();
        RecivePost_Time = data[0]["Post_Time"].toString();
        ReciveVisible_To = data[0]["Visible_To"].toString();
        ReciveStatus = data[0]["Publish_Status"].toString();

           /*print("ReciveJsonAdv_ID"+ReciveJsonAdv_ID.toString());
           print("ReciveJsonCat_ID"+ReciveJsonCat_ID.toString());
           print("ReciveJsonSubCat_ID"+ReciveJsonSubCat_ID.toString());
           print("ReciveTitle"+ReciveTitle.toString());
           print("RecivePrice"+RecivePrice.toString());
           print("ReciveDescription"+ReciveDescription.toString());
           print("ReciveFeatures"+ReciveFeatures.toString());
           print("ReciveCondition"+ReciveCondition.toString());
           print("ReciveReasonofSelling"+ReciveReasonofSelling.toString());
           print("ReciveUser_ID"+JsonReciveUser_ID.toString());
           print("RecivePost_Time"+RecivePost_Time.toString());
           print("ReciveVisible_To"+ReciveVisible_To.toString());
           print("ReciveStatus"+ReciveStatus.toString());*/
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
  String UpdatePostEdit ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/AdvUpdate.php';
  EditPostUpadte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(UpdatePostEdit, body: {
      "Token": GlobalString.Token,
      "Adv_ID": widget.value.toString(),
      "Title": TitleController.text.toString(),
      "Price": PriceController.text.toString(),
      "Description": DescriptionController.text.toString(),
      "Features": FeaturesController.text.toString(),
      "Condition": ConditionController.text.toString(),
      "Reason": ReasonController.text.toString(),
    }).then((resultUpadte) {
      /*print("URL"+UpdatePostEdit.toString());
      print("Token"+GlobalString.Token);
      print("Adv_ID"+widget.value.toString());
      print("Title"+TitleController.text.toString());
      print("Price" +PriceController.text.toString());
      print("Description" +DescriptionController.text.toString());
      print("Features" +FeaturesController.text.toString());
      print("Condition" +ConditionController.text.toString());
      print("Reason" +ReasonController.text.toString());
      print("statusCode" + resultUpadte.statusCode.toString());
      print("resultbody" + resultUpadte.body);*/
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(resultUpadte.statusCode == 200 ? resultUpadte.body : errMessage);
      var data = json.decode(resultUpadte.body);
      ReciveJsonStatus = data["STATUS"].toString();
      //print("STATUS" + ReciveJsonStatus.toString());

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
                Text("Post has benn Update Successfully".toString(),
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
  //----------------------------------------------------------------------------------------------------------//
  void _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(
          'No internet',
          "You're not connected to a network"
          );
    } /*else if (result == ConnectivityResult.mobile) {
      _showDialog(
          'Internet access',
          "You're connected over mobile data"
          );
    } else if (result == ConnectivityResult.wifi) {
      _showDialog(
          'Internet access',
          "You're connected over wifi"
          );
    }*/
  }
  //--------------------------------------------------------------------------------------------------------//
  Future<void> _showDialog(title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Internet Warning", textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(title.toString(),
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
              child: Text('Ok', style: new TextStyle(fontSize: 15.0,
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
    this._checkInternetConnectivity();
    super.initState();
    this.fetchPostEdit();
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
//------------------------------------------------------------------------------------------//
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
                                'Title'.toUpperCase(),
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
                              controller: TitleController,
                              focusNode: myFocusNodeTitle,
                              decoration: InputDecoration(
                                hintText: ReciveTitle.toString(),
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
                                'Price'.toUpperCase(),
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
                              keyboardType: TextInputType.number,
                              controller: PriceController,
                              focusNode: myFocusNodePrice,
                              decoration: InputDecoration(
                                hintText: RecivePrice.toString(),
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.rupeeSign,
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
                                'Description'.toUpperCase(),
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
                              controller:DescriptionController,
                              focusNode: myFocusNodeDescription,
                              decoration: InputDecoration(
                                hintText: ReciveDescription.toString(),
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.info,
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
                                'Feature'.toUpperCase(),
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
                              controller: FeaturesController,
                              focusNode: myFocusNodeFeatures,
                              decoration: InputDecoration(
                                hintText:ReciveFeatures.toString(),
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.solidQuestionCircle,
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
                                'Condition'.toUpperCase(),
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
                              controller: ConditionController,
                              focusNode: myFocusNodeCondition,
                              decoration: InputDecoration(
                                hintText: ReciveCondition.toString(),
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
//------------------------------------------------------------------------------------------//
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
                                'Reason of selling'.toUpperCase(),
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
                              controller: ReasonController,
                              focusNode: myFocusNodeReason,
                              decoration: InputDecoration(
                                hintText: ReciveReasonofSelling.toString(),
                                fillColor:ColorCode.TextColorCodeBlue,
                                hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    // _controller.clear();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.shopware,
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
//------------------------------------------------------------------------------------------//
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
        title: Text(GlobalString.PodtEdit.toUpperCase(),style: TextStyle(
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
                  icon: Icon(FontAwesomeIcons.solidEdit,color: Colors.white,), //`Icon` to display
                    label: Text(GlobalString.PodtEdit.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                    onPressed: () {
                      EditPostUpadte();
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