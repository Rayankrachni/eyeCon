import 'dart:async';
import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/sharedPre.dart';
import 'package:eyedetector/homePage.dart';
import 'package:eyedetector/model/user.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? my_token = await SharedPreferencesHelper.getString(token);

      if (my_token == null || my_token.isEmpty) {
        pushAndRemove(context: context, screen: FormPage());
      } else {
        pushAndRemove(context: context, screen: HomePage());

      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:primaryColor,
      body:  Center(child: Text("Face Detector",style: TextStyle(fontSize: 22,color: Colors.white),)),
    );
  }
}