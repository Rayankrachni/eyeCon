


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
     rows.add(['Frame', 'XLeft Coordinate', 'YLeft Coordinate', 'XRight Coordinate', 'YRight Coordinate']);

     int frameNumber = 0;

     for (int i = 0; i < landmarks.length; i++) {
       Map<String, dynamic> landmark = landmarks[i];

       // Insert each landmark 15 times
       for (int j = 0; j < 15; j++) {
         rows.add([
           frameNumber.toString(),
           landmark['XLeftEye'].toString(),
           landmark['YLeftEye'].toString(),
           landmark['XRightEye'].toString(),
           landmark['YRightEye'].toString()
         ]);
         frameNumber++;
       }
     }

     return rows;
   }



   Future<String> generateCsvFile(List<List<String>> rows, String fileName) async {


     // Get the Downloads directory
     Directory? downloadsDirectory = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first;

     if (downloadsDirectory == null) {
       throw Exception('Downloads directory not found');
     }

     final csvPath = '${downloadsDirectory.path}/$fileName.csv';
     final csvRows = rows.map((row) => row.join(',')).join('\n');
     final file = File(csvPath);
     await file.writeAsString(csvRows);

     return csvPath;  // This returns the path to the created CSV file
   }



}









