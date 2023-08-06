import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordingProvider extends ChangeNotifier {
  bool _startRecording=false;

  set startRecording(bool value) {
    _startRecording = value;
    //notifyListeners();
  }

  bool get startRecording => _startRecording;
}
