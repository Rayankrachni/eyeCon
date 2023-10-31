
import 'dart:typed_data';

import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<String?> saveFileToDownloadsDirectory(String sourcePath, String fileName) async {
    try {
      final targetPath = sourcePath;
      final sourceFile = File(sourcePath);
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      print('Error saving file to downloads: $e');
      return null;
    }
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
    print("landmarksList ${landmarksList.length}");
    final newList =await context.read<UserProvider>().generateFile(landmarksList);
    final csvPath =await context.read<UserProvider>().generateCsvFile(newList, 'landMarks');
    print("CSV saved at: $csvPath");
    print("newList $newList");
    print("newList ${newList.length}");
  }



  Future<String> moveToDownloads(String localFilePath, String newFileName) async {
    bool permissionGranted = await requestStoragePermission();
    if (!permissionGranted) {
      throw Exception('Storage permission not granted');
    }



      // For Android versions below 10
      final externalDir = await getExternalStorageDirectory();
      final downloadsDirPath = '${externalDir?.path}/Download';
      final downloadsDir = Directory(downloadsDirPath);

      // Check if downloads directory exists, if not create it
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync();
      }

      final newFilePath = '$downloadsDirPath/$newFileName.csv';
      final newFile = await File(localFilePath).copy(newFilePath);

      return newFile.path;

  }


  Future<void> exportFile() async {
    try {

      final landmarksList = context.read<UserProvider>().allLandmarks;
      print("landmarksList ${landmarksList.length}");
      final newList =await context.read<UserProvider>().generateFile(landmarksList);
      print("landmarksList ${newList.length}");
      final localCsvPath =await context.read<UserProvider>().generateCsvFile(newList, 'landMarks');
      print("csvPath ${localCsvPath}");

      // Move the file to the Downloads folder
      final newFilePath = await moveToDownloads(localCsvPath, 'landMarks');
      ToastHelper.showToast(msg: "File exported to: $newFilePath", backgroundColor: Colors.green);

      // Optionally, show a success message to the user
      // ...
    } catch (e) {
      // Handle exceptions or show an error message to the user
      print(e.toString());
    }
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
                      decoration:const BoxDecoration(
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

                SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: ElevatedButton(
                      onPressed: () async{

                        exportFile();


                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Button border radius
                          ),
                          primary: Colors.blueAccent),

                      child: Text("landMarkData",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),
                ),
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