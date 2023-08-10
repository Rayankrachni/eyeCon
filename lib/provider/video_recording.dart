
import 'package:dio/dio.dart';
import 'package:eyedetector/model/user.dart';
import 'package:flutter/material.dart';


class RecordingProvider extends ChangeNotifier {
  bool _startRecording=false;

  set startRecording(bool value) {
    _startRecording = value;
    notifyListeners();
  }

  bool get startRecording => _startRecording;



    bool _eyeinbox=false;

  set eyeinbox(bool value) {
      _eyeinbox = value;
    //notifyListeners();
  }

  bool get eyeinbox => _eyeinbox;


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

 Future<void> sendData(UserModel user, String path) async {
  _setLoading(true);
  try {
    // Create a FormData object
    FormData formData = FormData.fromMap({
      "title": user.name,
      "surname": user.surname,
      "email": user.email,
      "birthday": user.birthday,
      "gender": user.gender,
      "phone": user.phone,
      'video': await MultipartFile.fromFile(path, filename: 'video.mp4'),
  
     
    });

    /*Response response = await sendData(formData);

    if (response.statusCode == 200) {
    } else {
    }*/
  } catch (e) {
    // Handle error here
    if (e is DioError) {
    }
  }
  _setLoading(false);
}


 




  
}
