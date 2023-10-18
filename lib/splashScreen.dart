import 'dart:async';
import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/sharedPre.dart';
import 'package:eyedetector/homePage.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/webViewPage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();

      Timer(Duration(seconds: 3),(){
        pushAndRemove(context: context, screen: const ShowWebView(initUrl: "http://eyes.live.net.mk/api/mobileuser/consentform",));
      });
    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? my_token = await SharedPreferencesHelper.getString(token);

      await Future.delayed(Duration(seconds: 3), () {
        if (my_token == null || my_token.isEmpty) {
          pushAndRemove(context: context, screen: FormPage());
        } else {
          pushAndRemove(context: context, screen: HomePage());
        }
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    return   SafeArea(

      child: Scaffold(
        backgroundColor: Color(0xF2282828),
        body:  Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                   padding: const EdgeInsets.only(top: 20.0,left: 5,right: 5),
                   child: Container(
                     height: 120,
                    width: double.maxFinite,
                    decoration:  BoxDecoration(
                      border: Border.all(color: Colors.white,width: 0.5),
                      image:const  DecorationImage(
                        image: AssetImage('assets/eyecon1.png'),
                        fit: BoxFit.cover, // You can adjust this to your needs (e.g., BoxFit.fill, BoxFit.fitWidth)
                      ),
                    ),
                ),
                 ),
                SizedBox(height: height*0.1,),
                Text("By VisOko",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.normal),),
                SizedBox(height: height*0.05,),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/eyecon.png'),
                      fit: BoxFit.cover, // You can adjust this to your needs (e.g., BoxFit.fill, BoxFit.fitWidth)
                    ),
                  ),
                  ),
                SizedBox(height: height*0.05,),
                Text("Supported by",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.normal),),
                SizedBox(height: height*0.05,),
               Image.asset("assets/FITD-ENG-White.png")
              ],
            ),
          ),
        ),
      ),
    );
  }
}