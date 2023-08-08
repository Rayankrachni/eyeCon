import 'dart:async';

import 'package:camera/camera.dart';
import 'package:eyedetector/faceProcess/face_painter.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:eyedetector/faceProcess/view_detector.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';





class FaceDetectorView extends StatefulWidget {


  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
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

  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
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
    
       
    final bool startDetection = Provider.of<RecordingProvider>(context, listen: false).eyeinbox;
    print("eyes are in the box");
    final faces = await _faceDetector.processImage(inputImage);


  // Define the position and dimensions of the area where you want to detect faces
  const double targetX = -5; // Define your desired x position
  const double targetY = 240; // Define your desired y position
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
      
      Provider.of<RecordingProvider>(context,listen: false).stopRecord=false;
      ToastHelper.showToast(msg: "${Provider.of<RecordingProvider>(context,listen: false).stopRecord}", backgroundColor: Colors.green);
      //ToastHelper.showToast(msg: "-----face in xis $x $targetX y  $y  $targetY  $y >= 100 width $width ${targetX + targetWidth} height $height ${targetY + targetHeight} -----",backgroundColor: Colors.green);
      print("-----face in xis >= $x $targetX y <= $y  $targetY width $width  < ${targetX + targetWidth} height $height < ${targetY + targetHeight} -----");
      facesInTargetArea.add(face);
     
       

        }
    else{
      
      facesInTargetArea=[];   
      ToastHelper.showToast(msg: "record false",backgroundColor: Colors.blue);
      Provider.of<RecordingProvider>(context,listen: false).startRecording=false;
      Provider.of<RecordingProvider>(context,listen: false).stopRecord=true;

      print("face out xis $x > = $targetX y  $y < $targetY width $width < ${targetX + targetWidth} height $height < ${targetY + targetHeight} ");
      ToastHelper.showToast(msg: "You are not in the correct zoon fix you eyes",backgroundColor: Colors.red);
     
    
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

      //Provider.of<RecordingProvider>(context, listen: false).eyeinbox=false;
      setState(() {});
    }
  }




}