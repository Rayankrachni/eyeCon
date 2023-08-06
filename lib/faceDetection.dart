import 'dart:async';

import 'package:camera/camera.dart';
import 'package:eyedetector/face_painter.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:eyedetector/view_detector.dart';
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
  bool _message2 = false;

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
    
       
            
  
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {

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
      setState(() {});
    }
  }


  _showMessage2(){
  
  Timer(const Duration(seconds: 2), () {

  ToastHelper.showToast(msg: "Keep your eyes in the box",backgroundColor: Colors.green);
  setState(() {
    _message2=true;
  });


    
  
    });

}

}