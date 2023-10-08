
import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/homePage.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../provider/userProvider.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
   final UserModel user;

  const VideoPage({Key? key, required this.filePath,required this.user}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  bool downloading = false;
  var progressString = "";



  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future _initVideoPlayer(BuildContext context) async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    Provider.of<RecordingProvider>(context, listen: false).startRecording = false;
    // ignore: use_build_context_synchronously
    Provider.of<RecordingProvider>(context, listen: false).eyesinbox = false;
    // ignore: use_build_context_synchronously
    Provider.of<RecordingProvider>(context,listen: false).stopRecord=true;



  }



  Future<void> _exportVideoToGallery() async {
    try {
      bool? result = await GallerySaver.saveVideo(widget.filePath);
      print("GallerySaver result: $result");
      ToastHelper.showToast(msg: "video save", backgroundColor: Colors.green);
    } catch (e) {
      ToastHelper.showToast(msg: "can't save the video", backgroundColor: Colors.red);
    }

    }


@override
Widget build(BuildContext context) {
  final UserProvider provider = Provider.of<UserProvider>(context);
  return Scaffold(
    appBar: AppBar(
      title: const Text('Video Page'),
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      backgroundColor:Colors.blueAccent,
      actions: [
        IconButton(onPressed: (){ provider.signout(context);},icon: Icon(Icons.logout),) ,
      ],
    ),

    body:FutureBuilder(
          future: _initVideoPlayer(context),
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [

                  const SizedBox(height: 70,),
                  /*Container(
                    height: 150,
                    decoration:const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/eyecon1.jpg")
                      )
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      height: 140,
                      child: Center(child: VideoPlayer(_videoPlayerController))),  ),
                  const SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent
                        ),
                        child: IconButton(
                        onPressed: (){

                         bool val2= Provider.of<RecordingProvider>(context, listen: false).eyesinbox;
                         bool val3= Provider.of<RecordingProvider>(context, listen: false).startRecording;

                         if( !val2 && !val3){
                          pushAndRemove(context: context, screen:  FaceDetectorView(userModel: widget.user,),);}


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
                          bool val2= Provider.of<RecordingProvider>(context, listen: false).eyesinbox;
                          bool val3= Provider.of<RecordingProvider>(context, listen: false).startRecording;

                          if(!val2 && !val3){
                            pushAndRemove(context: context, screen:const  HomePage());
                          }
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