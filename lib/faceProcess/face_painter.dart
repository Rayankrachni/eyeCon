import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/faceProcess/cordinator.dart';
import 'package:eyedetector/provider/userProvider.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'dart:math' as math; 
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class FaceDetectorPainter extends CustomPainter {

  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
    this.context,
  );

  final List<Face> faces;
  final Size imageSize;

  final BuildContext context;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {

    final recordingProvider = Provider.of<RecordingProvider>(context, listen: false);
    final provider = Provider.of<UserProvider>(context, listen: false);


    final Paint leftEyePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final Paint rightEyePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

         final Paint eyeBoxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.transparent;

    for (final Face face in faces) 
    {
      double leftEyeLeft = double.infinity;
      double leftEyeTop = double.infinity;
      double leftEyeRight = double.negativeInfinity;
      double leftEyeBottom = double.negativeInfinity;

      double rightEyeLeft = double.infinity;
      double rightEyeTop = double.infinity;
      double rightEyeRight = double.negativeInfinity;
      double rightEyeBottom = double.negativeInfinity;

        for (final landmark in face.landmarks.values) {
        if (landmark != null && (landmark.type == FaceLandmarkType.leftEye || landmark.type == FaceLandmarkType.rightEye)) {
        
        
          final Offset eyePosition = Offset(
            translateX(
              landmark.position.x.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection),
            translateY(
              landmark.position.y.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection,),
          );

          if (landmark.type == FaceLandmarkType.leftEye) {
            leftEyeLeft = math.min(leftEyeLeft, eyePosition.dx);
            leftEyeTop = math.min(leftEyeTop, eyePosition.dy);
            leftEyeRight = math.max(leftEyeRight, eyePosition.dx);
            leftEyeBottom = math.max(leftEyeBottom, eyePosition.dy);
          } else if (landmark.type == FaceLandmarkType.rightEye) {
            rightEyeLeft = math.min(rightEyeLeft, eyePosition.dx);
            rightEyeTop = math.min(rightEyeTop, eyePosition.dy);
            rightEyeRight = math.max(rightEyeRight, eyePosition.dx);
            rightEyeBottom = math.max(rightEyeBottom, eyePosition.dy);


          }
        }
      }
  
      if (leftEyeLeft != double.infinity && leftEyeTop != double.infinity && rightEyeRight != double.negativeInfinity && rightEyeBottom != double.negativeInfinity) {
              
              final double boxHeight = (rightEyeBottom - leftEyeTop) * 3; // Increase the height factor as needed
              final Rect eyesBoundingBox = Rect.fromLTRB(
                leftEyeLeft,
                leftEyeTop - boxHeight,
                rightEyeRight,
                rightEyeBottom,
              );

              canvas.drawRect(eyesBoundingBox, eyeBoxPaint);
          }

      void paintEye(FaceLandmark landmark, Paint paint) {
              if (landmark.position != null) {
                recordingProvider?.stopRecord==false;
                  final double eyeRadius = 6.0;
                    final Offset eyeCenter = Offset(
                      translateX(
                        landmark.position.x.toDouble(),
                        size,
                        imageSize,
                        rotation,
                        cameraLensDirection,
                      ),
                      translateY(
                        landmark.position.y.toDouble(),
                        size,
                        imageSize,
                        rotation,
                        cameraLensDirection,
                      ),
                    );

                    // Draw bounding box for the eyes
                    canvas.drawCircle(eyeCenter, eyeRadius, paint);
                  }
                  Timer(const Duration(seconds: durationToTest), () {
                //  
                  if(recordingProvider.stopRecord==false) {

                    Timer( const Duration(seconds: durationToValid), () {



                      recordingProvider.startRecording=true;





                    });

                  }
                  else{
                    recordingProvider.startRecording=false;
                  }

              });
            }





      for (final type in face.landmarks.keys)
            {
              if (type == FaceLandmarkType.leftEye) {
                final landmark = face.landmarks[type];
                  if (landmark != null) {
                    paintEye(landmark, leftEyePaint);
                  }
              } else if (type == FaceLandmarkType.rightEye) {
                final landmark = face.landmarks[type];
                  if (landmark != null) {
                    paintEye(landmark, rightEyePaint);
                  }
              }
            }
          }
        }
        
        @override
        bool shouldRepaint(FaceDetectorPainter oldDelegate) {
          return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
        }




 }

