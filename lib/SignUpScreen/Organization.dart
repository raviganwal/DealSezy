import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:dealsezy/SignUpScreen/Email.dart';
import 'package:dealsezy/SignUpScreen/MobileNumber.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/widgets/custom_shape.dart';
import 'package:dealsezy/LoginScreen/widgets/customappbar.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/Components/ColorCode.dart';
import 'package:dealsezy/Components/GlobalString.dart';
//----------------------------------------------------------------------------------------------//
class Organization extends StatefulWidget {
  static String tag = 'Organization';
  final String SendFirstName;
  final String SendLastName;
  final String SendMobileNumber;
  final String SendPassword;
  Organization({Key key, this.SendFirstName, this.SendLastName, this.SendMobileNumber, this.SendPassword}) : super(key: key);
  @override
  _OrganizationState createState() => _OrganizationState();
}
//----------------------------------------------------------------------------------------------//
class _OrganizationState extends State<Organization> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  String GetDropDownValue = "";
  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),

          ),
        );
    }
    //print(_selectedCompany.name.toString());
    return items;

  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      //GetDropDownValue =_selectedCompany.toString();
      print(_selectedCompany.name.toString());
    });
  }
//----------------------------------------------------------------------------------------------//

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }
//---------------------------------------------------------------------------------------------------//
  Future<Null> BackScreen() async {
    Navigator.of(context).pushNamed(MobileNumber.tag);
  }
//--------------------------------------------------------------------------------------------------------//
  Future<void> _SignupAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ThanknYou.. ', textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 15.0,
                                                 color: ColorCode.TextColorCodeBlue,
                                                 fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We Have Recived Your Details',
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color: ColorCode.TextColorCodeBlue,
                                                fontWeight: FontWeight.bold),),
                Text('And Your Account Will be Actived in 24Hrs',
                       textAlign: TextAlign.center,
                       style: new TextStyle(fontSize: 12.0,
                                                color: ColorCode.TextColorCodeBlue,
                                                fontWeight: FontWeight.bold),),
              ],
              ),
            ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pushNamed(LoginScreen.tag),
              child: Text('CLOSE', style: new TextStyle(fontSize: 15.0,
                                                         color: ColorCode.TextColorCodeBlue,
                                                         fontWeight: FontWeight
                                                             .bold),),
              )
          ],
          );
      },
      );
  }
//----------------------------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return new WillPopScope(
      onWillPop: BackScreen,
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88,child: CustomAppBar()),
                clipShape(),
                form(),
                // SizedBox(height: _height/55,),
                // infoTextRow(),
                // socialIconsRow(),
                //signInTextRow(),
              ],
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
//----------------------------------------------------------------------------------------------//
  Widget form() {
    return Container(
      margin: EdgeInsets.only(
        left:_width/ 12.0,
        right: _width / 12.0,
        ),
      child: Form(
        child: Column(
          children: <Widget>[
            SizedBox(height: _height / 10.0),
            OrganizationTitle(),
            SizedBox(height: _height / 20.0),
            OrganizationDropdownButton(),
            SizedBox(height: _height / 30.0),
            button(),
          ],
          ),
        ),
      );
  }
//-----------------------------------------------------------------------------------------------//
  Widget OrganizationTitle() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            //color: ColorCode.AppColorCode,
            child: Text(
              GlobalString.OrganizationTitle,style: TextStyle(color: ColorCode.TextColorCodeBlue,fontWeight: FontWeight.bold,),
              ),
            ),
          ),
      ],
      );
  }
//----------------------------------------------------------------------------------------------//
  Widget OrganizationDropdownButton() {
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0, right: 25.0),
      child: Container(

        padding: const EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            borderRadius:BorderRadius.all(Radius.circular(30.0)),
            border: new Border.all(color: ColorCode.TextColorCodeBlue)
            ),
        child: DropdownButton(
          isExpanded: true,
          value: _selectedCompany,
          items: _dropdownMenuItems,
          onChanged: onChangeDropdownItem,
          style: TextStyle(
              fontFamily: "WorkSansSemiBold",
              fontSize: 16.0,
              color: ColorCode.TextColorCodeBlue),
          ),

        ),
      );


  }
//----------------------------------------------------------------------------------------------//
  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
       /* print("SendFirstName"+widget.SendFirstName.toString());
        print("SendLastName"+widget.SendLastName.toString());
        print("MobileNumber"+widget.SendMobileNumber.toString());
        print("Password"+widget.SendPassword.toString());
        print("SendOrganization"+_selectedCompany.name.toString());*/
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Email(
                SendFirstName: widget.SendFirstName.toString(),
                SendLastName: widget.SendLastName.toString(),
                SendMobileNumber: widget.SendMobileNumber.toString(),
                SendPassword: widget.SendPassword.toString(),
                SendOrganization: _selectedCompany.name.toString(),
                ),
              ));
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
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
      );
  }
//----------------------------------------------------------------------------------------------//
}
class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, '1'),
      Company(2, '2'),
    ];
  }
}
