import 'package:eyedetector/cameraRecording.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecordingProvider(),
      child: MaterialApp(
        title: 'Camera App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FaceDetectorView(),
        
        //(),
      ),
    );
  }
}
