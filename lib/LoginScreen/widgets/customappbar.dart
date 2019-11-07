import 'package:flutter/material.dart';
import 'package:dealsezy/Components/ColorCode.dart';
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: height/10,
        width: width,
        padding: EdgeInsets.only(left:0, top: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:[ColorCode.AppColorCode, ColorCode.AppColorCode]
          ),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back,color: ColorCode.TextColorCode,),
                onPressed: (){
                  print("pop");
                  Navigator.of(context).pop();
            })
          ],
        ),
      ),
    );
  }
}
