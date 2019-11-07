import 'dart:io';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
import 'package:dealsezy/SignUpScreen/Organization.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:dealsezy/LoginScreen/widgets/custom_shape.dart';
import 'package:dealsezy/LoginScreen/widgets/customappbar.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:dealsezy/Preferences/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(new SellAddPostScreen());
//-----------------------------------------------------------------------------//
class SellAddPostScreen extends StatefulWidget {
  static String tag = 'SellAddPostScreen';

  final String value1;
  final String value2;

  SellAddPostScreen({Key key ,this.value1, this.value2}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
//------------------------------------------------------------------------------//
class _MyAppState extends State<SellAddPostScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String status = '';
  String errMessage = 'Error Send Data';
  TextEditingController TitleController = new TextEditingController();
  TextEditingController DescriptionController = new TextEditingController();
  TextEditingController FeaturesController = new TextEditingController();
  TextEditingController ConditionController = new TextEditingController();
  TextEditingController ReasonofSellingController = new TextEditingController();
  TextEditingController PriceController = new TextEditingController();
  TextEditingController Visible_ToController = new TextEditingController();

  final FocusNode myFocusNodeTitle = FocusNode();
  final FocusNode myFocusNodeDescription = FocusNode();
  final FocusNode myFocusNodeFeatures = FocusNode();
  final FocusNode myFocusNodeCondition = FocusNode();
  final FocusNode myFocusNodeReasonofSelling = FocusNode();
  final FocusNode myFocusNodePrice = FocusNode();
  final FocusNode myFocusNodeVisible_To = FocusNode();

  String ReciveJsonStatus ='';
  String ReciveJsonMSG ='';
  String ReciveJsonRECID ='';

  String Title;
  String Description;
  String Features;
  String Condition;
  String ReasonofSelling;
  String Price;
  String Visible_To;
  String ReciveUserID ='';

  ScrollController _scrollController = new ScrollController();

//---------------------------------------------------------------------------------------------------//
  String url ='http://gravitinfosystems.com/Dealsezy/dealseazyApp/NewAdvPost.php';
  upload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ReciveUserID = prefs.getString(Preferences.KEY_UserID).toString();
    http.post(url, body: {
      "Title": TitleController.text.toString(),
      "Description": DescriptionController.text.toString(),
      "Features": FeaturesController.text.toString(),
      "Condition": ConditionController.text.toString(),
      "Reason_of_Selling": ReasonofSellingController.text.toString(),
      "Price": PriceController.text.toString(),
      "CAT_ID": widget.value2.toString(),
      "SubCat_ID": widget.value1.toString(),
      "User_ID": ReciveUserID.toString(),
      "Visible_To": Visible_ToController.text.toString(),
      "Token": GlobalString.Token
    }).then((result) {
      print("User_ID"+ReciveUserID.toString());
      print("Visible_To"+Visible_ToController.text.toString());
      // print("uploadEndPoint"+url.toString());
    //  print("Title"+TitleController.text.toString());
    //  print( "Description"+ DescriptionController.text.toString());
     // print( "Features"+ FeaturesController.text.toString());
     // print( "Condition"+ ConditionController.text.toString());
       print("Reason_of_selling "+ ReasonofSellingController.text.toString());
     // print( "Price"+ PriceController.text.toString());
      //print( "CAT_ID"+ widget.value2.toString());
      //print( "SubCat_ID"+ widget.value1.toString());
      //print("Token" + GlobalString.Token);
      //print("Visible_To" + "");
      //print("statusCode" + result.statusCode.toString());
        print("resultbody" + result.body);
      //return result.body.toString();
//------------------------------------------------------------------------------------------------------------//
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      var data = json.decode(result.body);
      ReciveJsonStatus = data["STATUS"].toString();
      ReciveJsonMSG = data["MSG"].toString();
      ReciveJsonRECID = data["RECID"].toString();

     // print("Status     " + ReciveJsonStatus.toString());
     // print("MSG   " + ReciveJsonMSG.toString());
        print("ReciveJsonRECID   " + ReciveJsonRECID.toString());
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
     // print(ReciveJsonMSG);
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

      return new Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(GlobalString.AddPost.toUpperCase(),style: TextStyle(color: ColorCode.TextColorCode),),
          centerTitle: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
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
                               "",
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

        body: new SingleChildScrollView (
          child: SingleChildScrollView(
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
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
                    icon: Icon(Icons.send,color: Colors.white,), //`Icon` to display
                      label: Text(GlobalString.FormSubmit.toUpperCase(),style: TextStyle(fontSize: 15.0, color: Colors.white,fontWeight: FontWeight.bold,)), //`Text` to display
                      onPressed: _sendToServer,
                    ),

                  ),
                flex: 1,
                ),
            ],
            ),
          ),
        );
  }
  //--------------------------------------------------------------------------------------------------------------//
  Widget FormUI() {
    return new Column(
      children: <Widget>[
        SizedBox(height: _height /20.0),
        new Container(
          height: _height,
          child: new ListView(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
//------------------------------------------------------------------------------------------------------------//
              new TextFormField(
                maxLines: 2,
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
                  labelText: 'Enter Title'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.heading,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------//
              new TextFormField(
                maxLines: 2,
                focusNode: myFocusNodeDescription,
                controller: DescriptionController,
                validator: validateDescription,
                onSaved: (String val) {
                  Description = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Description',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Enter Description'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.solidCommentDots,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------//
              new TextFormField(
                maxLines: 2,
                focusNode: myFocusNodeFeatures,
                controller: FeaturesController,
                validator: validateFeatures,
                onSaved: (String val) {
                  Features = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Features',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Enter Features'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.solidFlag,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------//
              new TextFormField(
                maxLines: 2,
                focusNode: myFocusNodeCondition,
                controller: ConditionController,
                validator: validateCondition,
                onSaved: (String val) {
                  Condition = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Condition',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Enter Condition'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.solidQuestionCircle,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------//
              new TextFormField(
                maxLines: 2,
                focusNode: myFocusNodeReasonofSelling,
                controller: ReasonofSellingController,
                validator: validateReasonofSelling,
                onSaved: (String val) {
                  ReasonofSelling = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Reason of Selling',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Enter Reason of Selling'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.sellcast,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------//
              new TextFormField(
                focusNode: myFocusNodePrice,
                controller: PriceController,
                keyboardType:TextInputType.numberWithOptions(),
                validator: validateReasonofPrice,
                onSaved: (String val) {
                  Price = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Price',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Enter Price'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.rupeeSign,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
//---------------------------------------------------------------------------------------------------------------//
              SizedBox(height: 15.0),
//------------------------------------------------------------------------------------------------//
              new TextFormField(
                focusNode: myFocusNodeVisible_To,
                controller: Visible_ToController,
                //keyboardType:TextInputType.numberWithOptions(),
                validator: validateVisible_To,
                onSaved: (String val) {
                  Visible_To = val;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  hintText: 'Enter Visible',hintStyle: TextStyle(fontSize: 12.0, color:ColorCode.TextColorCodeBlue),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Enter Visible'.toUpperCase(),labelStyle:
                new TextStyle(fontSize: 14.0, color:ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(FontAwesomeIcons.solidEye,  color:Color(0xFF0B3D57),),
                  prefixText: ' ',
                  //suffixText: 'USD',
                  //suffixStyle: const TextStyle(color: Colors.green)
                  ),
                ),
              /*SizedBox(height: 25.0),
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
                ),*/
            ],
            ),
          ),
      ],
      );
  }
//-------------------------------------------------------------------------------------------------------------------//
  _sendToServer() async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
     // print("true");
      upload();
    } else {
      // validation error
      setState(() {
       // print("Faield");
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
                setState(() {
                  ReciveJsonRECID =ReciveJsonRECID.toString(); //if you want to assign the index somewhere to check//if you want to assign the index somewhere to check
                  // print("CatID"+widget.value2.toString());
                   print("ReciveJsonRECID"+ReciveJsonRECID);
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new DiplaySellAddPostScreen(
                      value1: " ${ReciveJsonRECID.toString()}"),
                  );
                Navigator.of(context).push(route);
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
//----------------------------------------------------------------------------------------------------------------------//
  String validateTitle(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Title is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Title must be a-z and A-Z";
    }
    return null;
  }
//----------------------------------------------------------------------------------------------------------------------//
  String validateDescription(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Description is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Description must be a-z and A-Z";
    }
    return null;
  }
//----------------------------------------------------------------------------------------------------------------------//
  String validateFeatures(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Features is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Features must be a-z and A-Z";
    }
    return null;
  }
//----------------------------------------------------------------------------------------------------------------------//
  String validateCondition(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Condition is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Condition must be a-z and A-Z";
    }
    return null;
  }
//----------------------------------------------------------------------------------------------------------------------//
  String validateReasonofSelling(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Reason of Selling is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Reason of Selling must be a-z and A-Z";
    }
    return null;
  }
  String validateVisible_To(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Reason of Visible_To is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Reason of Visible_To must be a-z and A-Z";
    }
    return null;
  }
//----------------------------------------------------------------------------------------------------------------------//
  String validateReasonofPrice(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Reason of Selling is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Reason of Selling must be 0-9";
    }
    return null;
  }
}
//--------------------------------------------------------------------------------------------------------//