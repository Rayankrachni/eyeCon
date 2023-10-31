import 'dart:async';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/webViewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  String splashHtml = '';  // Assign a default empty string

  Future<void> _loadSplashFromAsset() async {
    try {
      String val = await rootBundle.loadString('assets/splash/splash.html');
      setState(() {
        splashHtml = val;
      });
    } catch (ex) {
      print (ex);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSplashFromAsset();
    Timer(const Duration(seconds: 5), () {
      pushAndRemove(context: context, screen: const ShowWebView(initUrl: "http://eyes.live.net.mk/api/mobileuser/consentform",));

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xF2282828),
        body: Center(
          child: splashHtml.isNotEmpty ? // Check if splashHtml is not empty
          InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true, // Enable JavaScript
              ),
            ),
            initialData: InAppWebViewInitialData(data: splashHtml),
          ) :
          CircularProgressIndicator(), // Show a loader until HTML is loaded
        ),
      ),
    );
  }

}







/*  Timer(Duration(seconds: 3),(){
        pushAndRemove(context: context, screen: const ShowWebView(initUrl: "http://eyes.live.net.mk/api/mobileuser/consentform",));
      });*/