


import 'dart:io';

import 'package:csv/csv.dart';
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
import 'package:path_provider/path_provider.dart';

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


   final List<Map<String, dynamic>> _allLandmarks = [];

   List<Map<String, dynamic>> get allLandmarks => List.unmodifiable(_allLandmarks);

   void addLandmark(Map<String, dynamic> landmark) {
     _allLandmarks.add(landmark);
     print("Added landmark: $landmark");
     print("Current landmarks: $_allLandmarks");
     notifyListeners();
   }

   void clearLandmarks() {
     _allLandmarks.clear();
     print("Cleared all landmarks");
     notifyListeners();
   }

   void resetLandmarks(List<Map<String, dynamic>> newLandmarks) {
     _allLandmarks.clear();
     _allLandmarks.addAll(newLandmarks);
     print("Reset landmarks: $_allLandmarks");
     notifyListeners();
   }


   Future<List<List<String>>> generateFile(List<Map<String, dynamic>> landmarks) async {
     List<List<String>> rows = [];

     // Header row
     rows.add(['Frame',  'XLeft Coordinate', 'YLeft Coordinate','XRight Coordinate', 'YRight Coordinate']);
     int lR=0;
     int lL=0;
     int rL=0;
     int rR=0;
     for (int i = 0; i < 150; i++) {


       if (i < landmarks.length) {

         Map<String, dynamic> landmark = landmarks[i];
         lR=landmark['XLeftEye'];
         lL=landmark['YLeftEye'];
         rR=landmark['YLeftEye'];
         rL=landmark['YLeftEye'];
         rows.add([i.toString(),  landmark['XLeftEye'].toString(), landmark['YLeftEye'].toString(),landmark['XRightEye'].toString(), landmark['YRightEye'].toString()]);
       } else {
         rows.add([i.toString(), lL.toString(), lR.toString(),rL.toString(), rR.toString()]);

       }
     }

   return rows;
   }


   Future<File> generateCsv(List<Map<String, dynamic>> landmarks) async {
     List<List<String>> rows = [];

     // Header row
     rows.add(['Frame',  'XLeft Coordinate', 'YLeft Coordinate','XRight Coordinate', 'YRight Coordinate']);

     for (int i = 0; i < 150; i++) {
       if (i < landmarks.length) {
         Map<String, dynamic> landmark = landmarks[i];
         rows.add([i.toString(),  landmark['XLeftEye'].toString(), landmark['XLeftEye'].toString(),landmark['XRightEye'].toString(), landmark['YRightEye'].toString()]);
       } else {
         rows.add([i.toString(), 'No landmarks', '', '']);
       }
     }

     print("rows $rows");

     String csv = const ListToCsvConverter().convert(rows);

     // Saving the CSV string to a file
     final directory = await getApplicationDocumentsDirectory();
     final path = directory.path + "/landmarks.csv";
     final File file = File(path);


     // After writing to the file
     await file.writeAsString(csv);

     // Read and print the content
     String fileContent = await file.readAsString();
     print("fileContent $fileContent");
     return file.writeAsString(csv);
   }



}









