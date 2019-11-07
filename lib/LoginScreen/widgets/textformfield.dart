import 'package:dealsezy/main.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:dealsezy/LoginScreen/widgets/responsive_ui.dart';
import 'package:dealsezy/Components/ColorCode.dart';
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextEditingController signupFirstNameController;
  final TextEditingController signupLastNameController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  int mobilenumber;



  CustomTextField(
    {this.hint,
      this.textEditingController,
      this.signupFirstNameController,
      this.signupLastNameController,
      this.keyboardType,
      this.icon,
      this.obscureText= false,
      this.mobilenumber

     });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large? 12 : (medium? 10 : 8),
      child: TextFormField(
        maxLength: mobilenumber,
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: ColorCode.TextColorCodeBlue,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorCode.TextColorCodeBlue, size: 20),
          hintText: hint,hintStyle: TextStyle(color: ColorCode.TextColorCodeBlue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
