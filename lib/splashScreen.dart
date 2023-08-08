

import 'dart:async';

import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      pushAndRemove(context: context, screen: FormPage());
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