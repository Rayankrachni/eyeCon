



import 'package:dio/dio.dart';
import 'package:eyedetector/helpers/sharedPre.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/homePage.dart';
import 'package:http_parser/http_parser.dart';

import 'package:eyedetector/provider/dio.dart';
import 'package:flutter/material.dart';

import '../const/appConsts.dart';
import '../helpers/navigator.dart';


class RecordingProvider extends ChangeNotifier { 


  
  ApiProvider _apiProvider =ApiProvider();

  bool _startRecording=false;

  set startRecording(bool value) {
    _startRecording = value;
    notifyListeners();
  }

  bool get startRecording => _startRecording;
 
  bool _eyesinbox=false;

  set eyesinbox(bool value) {
      _eyesinbox = value;
      //notifyListeners();
  }

  bool get eyesinbox => _eyesinbox;

  bool _stopRecord=false;

  set stopRecord(bool value) {
      _stopRecord = value;
    notifyListeners();
  }

  bool get stopRecord => _stopRecord;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendData(String videopath, BuildContext context) async {
    try {
      String? mtoken = await SharedPreferencesHelper.getString(token);
      if (mtoken == null) {
        print("Token is null");
        return;
      }

      // Create a FormData object
      FormData formData = FormData.fromMap({
        "File": await MultipartFile.fromFile(videopath, contentType: MediaType("video", "mp4"),),
        "Coords": "empty",
        // Replace this with the appropriate coordinates.
      });

      // Ensure your _apiProvider.uploadVideoFile is setting the correct headers, etc.
      Response response = await _apiProvider.uploadVideoFile(mtoken, formData);
      if (response.statusCode == 200) {
        // Handle the post data here if needed
        print(response.data);
        ToastHelper.showToast(msg: "Upload Success", backgroundColor: Colors.green);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } else {
        print("Error with status code: ${response.statusCode}");
        ToastHelper.showToast(msg: "Upload Failed", backgroundColor: Colors.red);
        print(response.data);
      }
    } catch (e) {
      // Handle the error here
      print("Error: $e");
      if (e is DioError) {
        ToastHelper.showToast(msg: "Upload Failed", backgroundColor: Colors.red);
        print("DioError: ${e.message}");
        if (e.response != null) {
          print("Error Response Status Code: ${e.response?.statusCode}");

        }
        print("Error Type: ${e.type}");
      }
    }
  }
}
