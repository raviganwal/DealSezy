import 'package:dealsezy/CategoriesScreen/Categories.dart';
import 'package:dealsezy/EditPostImageScreen/EditPostImage.dart';
import 'package:dealsezy/EditPostImageScreen/ImageUpload.dart';
import 'package:dealsezy/HomeScreen/HomeScreen.dart';
import 'package:dealsezy/HomeScreenSubCategory/HomeScreenPost.dart';
import 'package:dealsezy/HomeScreenSubCategory/HomeScreenSubCategory.dart';
import 'package:dealsezy/HomeScreenTabController/ChatScreen.dart';
import 'package:dealsezy/HomeScreenTabController/ExploreScreen.dart';
import 'package:dealsezy/HomeScreenTabController/MyAccount.dart';
import 'package:dealsezy/HomeScreenTabController/MyAdv.dart';
import 'package:dealsezy/HomeScreenTabController/SellScreen.dart';
import 'package:dealsezy/LoginScreen/LoginScreen.dart';
import 'package:dealsezy/ProfileUpdate/ProfileUpdate.dart';
import 'package:dealsezy/SellScreenDetails/DiplaySellAddPostScreen.dart';
import 'package:dealsezy/SellScreenDetails/SellAddPostScreen.dart';
import 'package:dealsezy/SignUpScreen/Email.dart';
import 'package:dealsezy/SignUpScreen/MobileNumber.dart';
import 'package:dealsezy/SignUpScreen/Organization.dart';
import 'package:dealsezy/SignUpScreen/SetUpPassword.dart';
import 'package:dealsezy/SignUpScreen/SignUpScreen.dart';
import 'package:dealsezy/SubCategoryScreen/SubCategoryItem.dart';
import 'package:flutter/material.dart';
import 'package:dealsezy/SplashScreen/SplashScreen.dart';

final routes = {
  '/Splash': (BuildContext context) => new SplashScreen(),
  '/': (BuildContext context) => new SplashScreen(),
  SplashScreen.tag: (context) => SplashScreen(),
  LoginScreen.tag: (context) => LoginScreen(),
  SignUpScreen.tag: (context) => SignUpScreen(),
  SetUpPassword.tag: (context) => SetUpPassword(),
  MobileNumber.tag: (context) => MobileNumber(),
  Organization.tag: (context) => Organization(),
  HomeScreen.tag: (context) => HomeScreen(),
  ChatScreen.tag: (context) => ChatScreen(),
  ExploreScreen.tag: (context) => ExploreScreen(),
  SellScreen.tag: (context) => SellScreen(),
  MyAdv.tag: (context) => MyAdv(),
  MyAccount.tag: (context) => MyAccount(),
  Email.tag: (context) => Email(),
  SellAddPostScreen.tag: (context) => SellAddPostScreen(),
  Categories.tag: (context) => Categories(),
  SubCategoryItem.tag: (context) => SubCategoryItem(),
  DiplaySellAddPostScreen.tag: (context) => DiplaySellAddPostScreen(),
  EditPostImage.tag: (context) => EditPostImage(),
  ImageUpload.tag: (context) => ImageUpload(),
  ProfileUpdate.tag: (context) => ProfileUpdate(),
  HomeScreenSubCategory.tag: (context) => HomeScreenSubCategory(),
  HomeScreenPost.tag: (context) => HomeScreenPost()
};
