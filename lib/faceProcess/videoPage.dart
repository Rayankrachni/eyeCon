
import 'dart:typed_data';

import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


import '../provider/userProvider.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
  final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();

  VideoPage({Key? key, required this.filePath, }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer(BuildContext context) async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    final recordingProvider = context.read<RecordingProvider>();
    recordingProvider.startRecording = false;
    recordingProvider.eyesinbox = false;
    recordingProvider.stopRecord = true;


    final landmarksList = context.read<UserProvider>().allLandmarks;
    print("landmarksList $landmarksList");
    final newList =await context.read<UserProvider>().generateFile(landmarksList);
    print("newList $newList");
    print("newList ${newList.length}");
  }



  Future<void> _exportVideoToGallery() async {
    try {
      bool? result = await GallerySaver.saveVideo(widget.filePath);
      print("GallerySaver result: $result");
      ToastHelper.showToast(msg: "Video saved", backgroundColor: Colors.green);
    } catch (e) {
      ToastHelper.showToast(msg: "Can't save the video", backgroundColor: Colors.red);
    }
  }
  List<Uint8List> extractedFrames = [];


  Stream<Uint8List> getVideoFrameStream(String videoPath) async* {
    final framesDirectory = await getTemporaryDirectory();
    final extractedFramesDirectory = Directory('${framesDirectory.path}/extracted_frames');

    if (!extractedFramesDirectory.existsSync()) {
      print('Frames directory does not exist.');
      return;
    }

    final frames = extractedFramesDirectory.listSync();

    for (final frame in frames) {
      if (frame is File) {
        try {
          final frameBytes = await frame.readAsBytes();
          yield Uint8List.fromList(frameBytes);
        } catch (e) {
          print('Error reading frame file: $e');
        }
      }
    }
  }

  Future<void> extractFrames(String videoPath) async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    final framesDirectory = await getTemporaryDirectory();
    final extractedFramesDirectory = Directory('${framesDirectory.path}/extracted_frames');

    extractedFramesDirectory.createSync();

    final outputPattern = '${extractedFramesDirectory.path}/frame%04d.jpg';

    final arguments = '-i $videoPath -vf fps=30 $outputPattern';

    final rc = await _flutterFFmpeg.execute(arguments);

    if (rc == 0) {
      // Frames have been extracted successfully
      print('Frames have been extracted successfully.');
    } else {
      // Error during frame extraction
      print('Error during frame extraction: $rc');
    }
  }



  Future<void> processVideo() async {
    final videoPath = widget.filePath;

    await extractFrames(videoPath);
    final frameStream = getVideoFrameStream(videoPath);
    final faces = <Face>[]; // Initialize the list to store faces
    final videoWidth = _videoPlayerController.value.size.width;
    final videoHeight = _videoPlayerController.value.size.height;
    await for (final frameBytes in frameStream) {
      final inputImage = InputImage.fromBytes(
        bytes: frameBytes,
        metadata: InputImageMetadata(
          size: Size(videoWidth, videoHeight), // Set the actual size of the frame
          format: InputImageFormat.nv21, // Set the format based on your frame's format
          rotation: InputImageRotation.rotation0deg, // Set the rotation based on your frame's rotation
          bytesPerRow: videoWidth.toInt(), // Set the bytes per row based on your frame's bytes per row
        ),
      );

      final detectedFaces = await widget.faceDetector.processImage(inputImage);
      faces.addAll(detectedFaces);
    }

    // Now you have all the faces detected in the video frames
    for (final face in faces) {
      final leftEyeLandmark = face.landmarks[FaceLandmarkType.leftEye];
      final rightEyeLandmark = face.landmarks[FaceLandmarkType.rightEye];

      if (leftEyeLandmark != null && rightEyeLandmark != null) {
        final leftEyeX = leftEyeLandmark.position.x;
        final leftEyeY = leftEyeLandmark.position.y;
        final rightEyeX = rightEyeLandmark.position.x;
        final rightEyeY = rightEyeLandmark.position.y;

        // Now you have the coordinates of the left and right eyes for each frame
        print("Left Eye X: $leftEyeX, Left Eye Y: $leftEyeY");
        print("Right Eye X: $rightEyeX, Right Eye Y: $rightEyeY");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.read<UserProvider>();
    final RecordingProvider recordingProvider = context.read<RecordingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Page'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              userProvider.signout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _initVideoPlayer(context),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    height: 140,
                    child: Center(child: VideoPlayer(_videoPlayerController)),
                  ),
                ),

                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,

                      decoration:const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent
                      ),
                      child: IconButton(
                          onPressed: (){

                            bool val2= Provider.of<RecordingProvider>(context, listen: false).eyesinbox;
                            bool val3= Provider.of<RecordingProvider>(context, listen: false).startRecording;

                            if( !val2 && !val3){
                              pushAndRemove(context: context, screen:  FaceDetectorView(),);}


                          }, icon:const Icon(Icons.refresh,color: Colors.white,)),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent
                      ),
                      child: IconButton(
                          onPressed: (){
                            _exportVideoToGallery();



                          }, icon:const Icon(Icons.download ,color: Colors.white,)),
                    ),
                    const SizedBox(width: 10,),



                  ],
                ) ,
                const SizedBox(height: 40,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: ElevatedButton(
                      onPressed: (){

                        recordingProvider.sendData(widget.filePath, context);
                        /*if(!val2 && !val3){
                          pushAndRemove(context: context, screen:const  HomePage());
                        }*/
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Button border radius
                          ),
                          primary: Colors.blueAccent),

                      child: Text("Finish",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),
                ),

              ],
            );
          }
        },
      ),
    );

  }
}