import 'dart:async';
import 'package:camera/camera.dart';
import 'package:eyedetector/faceProcess/face_painter.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/userProvider.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:eyedetector/faceProcess/view_detector.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';




class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({Key? key}) : super(key: key);

  @override
  _FaceDetectorViewState createState() => _FaceDetectorViewState();
}


class _FaceDetectorViewState extends State<FaceDetectorView> with WidgetsBindingObserver {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  bool _canProcess = true;
  bool _isBusy = false;

  CustomPaint? _customPaint;
  
  String? _text;

  bool face_out= false;

  bool forground= true;

  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void initState() {
   
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _canProcess = false;


    _faceDetector.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        forground=true;
      });
    } else if (state == AppLifecycleState.paused) {

      setState(() {
        forground=false;
      });
      Fluttertoast.cancel(); // Hide any existing toast when the app goes into the background
    }
  }

  @override
  Widget build(BuildContext context) {

    
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    
       
    final bool startDetection = Provider.of<RecordingProvider>(context, listen: false).eyesinbox;
    final faces = await _faceDetector.processImage(inputImage);


  // Define the position and dimensions of the area where you want to detect faces
  const double targetX = -5; // Define your desired x position
  const double targetY = 200; // Define your desired y position
  const double targetWidth = 2000; // Define your desired width
  const double targetHeight = 600; // Define your desired height
  
  List<Face> facesInTargetArea = [];

  for (final face in faces) {
    final boundingBox = face.boundingBox;
    final x = boundingBox.left;
    final y = boundingBox.top;
    final width = boundingBox.width;
    final height = boundingBox.height;
  
    // Check if the detected face is within the target area
    if (x >= targetX &&  y >= 120 &&  y <= targetY  && x + width <= targetX + targetWidth && y + height <= targetY + targetHeight) {
      
      // ignore: use_build_context_synchronously
      Provider.of<RecordingProvider>(context,listen: false).stopRecord=false;

      setState(() {
        face_out=true;
      });
      

      if(forground) ToastHelper.showToast(msg: "Fix Your Position", backgroundColor: Colors.green);
      facesInTargetArea.add(face);

      if( Provider.of<RecordingProvider>(context,listen: false).startRecording==true){

        print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
        // Access landmarks for the left and right eyes
        final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
        final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];



        if (leftEyeLandmark != null && rightEyeLandmark != null) {
          final leftEyeX = leftEyeLandmark.position.x;
          final leftEyeY = leftEyeLandmark.position.y;
          final rightEyeX = rightEyeLandmark.position.x;
          final rightEyeY = rightEyeLandmark.position.y;

          // Now you have the coordinates of the left and right eyes
          print("Left Eye X: $leftEyeX, Left Eye Y: $leftEyeY");
          print("Right Eye X: $rightEyeX, Right Eye Y: $rightEyeY");



          Provider.of<UserProvider>(context, listen: false).addLandmark({
            'left': "leftEye",
            'XLeftEye': leftEyeX,
            'YLeftEye': leftEyeY,
            'right': "righttEye",
            'XRightEye': rightEyeX,
            'YRightEye': rightEyeY,
          });
          final list= Provider.of<UserProvider>(context, listen: false).allLandmarks;
          print("Landmarks added in ClassA: ${list}");




        }
      }



       

        }
    else{

      print("1111111111111111111111");
      
      facesInTargetArea=[];   
      // ignore: use_build_context_synchronously
      Provider.of<RecordingProvider>(context,listen: false).startRecording=false;
      // ignore: use_build_context_synchronously
      Provider.of<RecordingProvider>(context,listen: false).stopRecord=true;
      if(!face_out &&  forground)ToastHelper.showToast(msg: "Focus your eyes inside the box and wait a few seconds",backgroundColor: Colors.red);
     
    
    }

     
  }

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null&& startDetection &&facesInTargetArea.isNotEmpty)
         {

             
            final painter = FaceDetectorPainter(
              faces,
              inputImage.metadata!.size,
              inputImage.metadata!.rotation,
              _cameraLensDirection,
              context
            );

      
    
      _customPaint = CustomPaint(painter: painter);

      
     
    } else {
      
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {

     
    }
  }




}