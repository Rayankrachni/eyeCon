import 'dart:async';
import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/sharedPre.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/contentHtml_provider.dart';
import 'package:eyedetector/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage  extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await fetchData();
      String? my_token = await SharedPreferencesHelper.getString(token);

      if (my_token == null || my_token.isEmpty) {
        print("no token");
      } else {
        print("my_token $my_token");

      }
    });}
  final ContentHtmlProvider provide = ContentHtmlProvider();
  Future<void> fetchData() async {
    try {
      await provide.fetchData();

    } catch (error) {
      // Handle any potential errors here
      print("Error fetching data: $error");
    }
  }


  var userModel = UserModel(
      name: "name.text",
      email: "email.text",
      surname: "surname.text",
      phone: "phone.text",
      gender: "selectedItem",
      birthday: "birthday.text",
      eyeColor: "selectedColor"
  );
  @override
  Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor:Colors.blueAccent,
        actions: [
          IconButton(onPressed: (){ provider.signout(context);},icon: Icon(Icons.logout),) ,
        ],
      ),

      body:  Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          const Text("Start Detection",style: TextStyle(fontSize: 22,color: Colors.black)),
          const SizedBox(height: 10,),
          SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: ElevatedButton(
                  onPressed: (){
                      pushAndRemove(context: context, screen: FaceDetectorView(userModel: userModel,));
                  },

                  style: ElevatedButton.styleFrom(
                      padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 15), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Button border radius
                      ),
                      primary: Colors.blue),

                  child: Text("Start",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
            ),




          ],
        )),
    );
  }
}