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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var data;
  var loading = false;
  String imageurl = 'http://gravitinfosystems.com/Dealsezy/dealseazyApp/';
  final FocusNode myFocusNode = FocusNode();
  var ReciveUserID="";
  String errMessage = 'Error Send Data';
  String status = '';
  GlobalKey<FormState> _key = new GlobalKey();
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
  bool _validate = false;

  String Title= "";
  String Price= "";
  String Description= "";
  String Features= "";
  String Condition= "";
  String Reason= "";

  ScrollController _scrollController = new ScrollController();
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
        print("ReciveData"+data.toString());

        ReciveJsonAdv_ID = data[0]["Adv_ID"].toString();
        ReciveJsonCat_ID = data[0]["Cat_ID"].toString();
        ReciveJsonSubCat_ID = data[0]["SubCat_ID"].toString();
        ReciveTitle = data[0]["Title"].toString();
        RecivePrice = data[0]["Price"].toString();
        ReciveDescription = data[0]["Description"].toString();
        ReciveFeatures = data[0]["Features"].toString();
        ReciveCondition = data[0]["Condition"].toString();
        ReciveReasonofSelling = data[0]["Reason_of_Selling"].toString();
        JsonReciveUser_ID = data[0]["User_ID"].toString();
        RecivePost_Time = data[0]["Post_Time"].toString();
        ReciveVisible_To = data[0]["Visible_To"].toString();
        ReciveStatus = data[0]["Publish_Status"].toString();
        setState(){
                TitleController.text=ReciveTitle;
          }

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
      print("URL"+UpdatePostEdit.toString());
      print("Token"+GlobalString.Token);
      print("Adv_ID"+widget.value.toString());
      print("Title"+TitleController.text.toString());
      print("Price" +PriceController.text.toString());
      print("Description" +DescriptionController.text.toString());
      print("Features" +FeaturesController.text.toString());
      print("Condition" +ConditionController.text.toString());
      print("Reason" +ReasonController.text.toString());
      print("statusCode" + resultUpadte.statusCode.toString());
      print("resultbody" + resultUpadte.body);
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
  //------------------------------------------------------------------------------------------------------------//
  void  _displaySnackbar(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text('Please Wait........',style: TextStyle(color: ColorCode.TextColorCode),),
      backgroundColor: ColorCode.AppColorCode,
      ));
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

    Widget FormUI() {
      return new Column(
        children: <Widget>[
          new Container(
            height: _height,
            child: new ListView(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              controller: _scrollController,
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
                new TextFormField(
                  focusNode: myFocusNodeTitle,
                  controller: TitleController,
                  validator: validateTitle,
                  onSaved: (String val) {
                    Title = val;
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter Title',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                    //helperText: 'Keep it short, this is just a demo.',
                    labelText: ReciveTitle.toString(),labelStyle:
                  new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(FontAwesomeIcons.adn,  color:Color(0xFF0B3D57),),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)
                    ),
                  ),
                SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
                TextFormField(
                  focusNode: myFocusNodePrice,
                  controller: PriceController,
                  validator: validatePrice,
                  keyboardType: TextInputType.number,
                  onSaved: (String val) {
                    Price = val;
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter Price',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                    //helperText: 'Keep it short, this is just a demo.',
                    labelText: RecivePrice.toString(),labelStyle:
                  new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(FontAwesomeIcons.rupeeSign, color:Color(0xFF0B3D57),),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)
                    ),
                  ),
                SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
                new TextFormField(
                  focusNode: myFocusNodeDescription,
                  controller: DescriptionController,
                  keyboardType: TextInputType.text,
                  validator: validateDescription,
                  onSaved: (String val) {
                    Description = val;
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter Description',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                    //helperText: 'Keep it short, this is just a demo.',
                    labelText: ReciveDescription.toString(),labelStyle:
                  new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(FontAwesomeIcons.info,  color:Color(0xFF0B3D57),),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)
                    ),
                  ),
                SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
                new TextFormField(
                  focusNode: myFocusNodeFeatures,
                  controller: FeaturesController,
                  keyboardType: TextInputType.text,
                  validator: validateFeatures,
                  onSaved: (String val) {
                    Features = val;
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter Features',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                    //helperText: 'Keep it short, this is just a demo.',
                    labelText: ReciveFeatures.toString(),labelStyle:
                  new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(FontAwesomeIcons.solidQuestionCircle,  color:Color(0xFF0B3D57),),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)
                    ),
                  ),
                SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
                new TextFormField(
                  focusNode: myFocusNodeCondition,
                  controller: ConditionController,
                  keyboardType: TextInputType.text,
                  validator: validateCondition,
                  onSaved: (String val) {
                    Condition = val;
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter Condition',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                    //helperText: 'Keep it short, this is just a demo.',
                    labelText: ReciveCondition.toString(),labelStyle:
                  new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(FontAwesomeIcons.solidQuestionCircle,  color:Color(0xFF0B3D57),),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)
                    ),
                  ),
                SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------------------//
                new TextFormField(
                  focusNode: myFocusNodeReason,
                  controller: ReasonController,
                  keyboardType: TextInputType.text,
                  validator: validateReason,
                  onSaved: (String val) {
                    Reason = val;
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter Reason of Selling',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                    //helperText: 'Keep it short, this is just a demo.',
                    labelText: ReciveReasonofSelling.toString(),labelStyle:
                  new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(FontAwesomeIcons.atlassian,  color:Color(0xFF0B3D57),),
                    prefixText: ' ',
                    //suffixText: 'USD',
                    //suffixStyle: const TextStyle(color: Colors.green)
                    ),
                  ),
              ],
              ),
            ),
        ],
        );
    }
//---------------------------------------------------------------------------------------------//
    return Scaffold(
      key:_scaffoldKey,
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
      //-------------------------------------------------------------------------------------//
      body: new Container(
        child: SingleChildScrollView(
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                  ),
                FormUI(),
              ],
              ),
            //child: FormUI(),
            ),
          ),
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
                      _sendToServer(context);
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
  _sendToServer(BuildContext context) async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("true");
    _displaySnackbar(context);
      EditPostUpadte();
    } else {
      // validation error
      setState(() {
        print("Faield");
        _validate = true;
      });
    }
  }
//-------------------------------------------------------------------------------------------------//
  String validateTitle(String value) {
    String patttern = '';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Title is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Title must be Need";
    }
    return null;
  }
//-------------------------------------------------------------------------------------------------//
  String validatePrice(String value) {
    String patttern = '';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Price is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Price must be Need";
    }
    return null;
  }
  //-------------------------------------------------------------------------------------------------//
  String validateDescription(String value) {
    String patttern = '';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Description is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Description must be Need";
    }
    return null;
  }
  //-------------------------------------------------------------------------------------------------//
  String validateFeatures(String value) {
    String patttern = '';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Features is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Features must be Need";
    }
    return null;
  }
  //-------------------------------------------------------------------------------------------------//
  String validateCondition(String value) {
    String patttern = '';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Condition is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Condition must be Need";
    }
    return null;
  }
  //-------------------------------------------------------------------------------------------------//
  String validateReason(String value) {
    String patttern = '';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Reason of Selling is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Reason of Selling must be Need";
    }
    return null;
  }
}

//----------------------------------------------------------------------------------------------//
