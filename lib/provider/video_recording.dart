import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordingProvider extends ChangeNotifier {
  bool _startRecording=false;

  set startRecording(bool value) {
    _startRecording = value;
    //notifyListeners();
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
    //notifyListeners();
  }

  bool get stopRecord => _stopRecord;
 
 


 




  
}
