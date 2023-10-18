import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/sharedPre.dart';
import 'package:eyedetector/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class ShowWebView extends StatefulWidget {
  final String? initUrl;
  const ShowWebView({super.key, this.initUrl});
  @override
  State<ShowWebView> createState() => _ShowWebViewState();
}

class _ShowWebViewState extends State<ShowWebView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.initUrl!)),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    decoration: BoxDecoration(
                      // Background color
                      borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                      boxShadow:const [
                        BoxShadow(
                          color: Colors.black, // Shadow color
                          blurRadius: 5, // Spread radius
                          offset: Offset(0, 3), // Offset from top (vertical) and right (horizontal)
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        String? userToken = await SharedPreferencesHelper.getString(token);

                        if (userToken == null || userToken.isEmpty) {
                          push(context: context, screen:  FormPage());
                        } else {
                          push(context: context, screen: HomePage());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        backgroundColor: Colors.lightBlueAccent, // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Button border radius
                        ),
                        elevation: 5, // Adjust the elevation value as needed
                        shadowColor: Colors.black, // Adjust the shadow color as needed
                      ),

                      child: const Text(
                        "Accept",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




