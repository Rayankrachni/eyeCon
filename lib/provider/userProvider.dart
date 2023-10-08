


import 'package:dio/dio.dart';
import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/sharedPre.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/homePage.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/dio.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

   ApiProvider _apiProvider =ApiProvider();

   bool _isLoading = false;

   bool get isLoading => _isLoading;

   void _setLoading(bool value) {
     _isLoading = value;
     notifyListeners();
   }
   Future<void> register(UserModel user, BuildContext context) async {
     _setLoading(true);
     try {
       Response response =
       await _apiProvider.registerUser(user);
       if (response.statusCode == 200) {
         var data = response.data;
         print("data $data");

         await SharedPreferencesHelper.setString(token, data);
         ToastHelper.showToast(msg: "Login Success", backgroundColor: Colors.green);
         push(context: context, screen:HomePage());



       } else {
         String message = response.data['message'];
         print(message);
         ToastHelper.showToast(msg: "login failed", backgroundColor: Colors.red);
       }


     } catch (e) {
       // handle error here
       print(e);
       ToastHelper.showToast(msg: "login failed", backgroundColor: Colors.red);
     }
     _setLoading(false);
   }

   Future<void> signout(BuildContext context) async {
     await SharedPreferencesHelper.setString(token, ''); // Set the token to null
     pushAndRemove(context: context, screen: FormPage());
   }






}