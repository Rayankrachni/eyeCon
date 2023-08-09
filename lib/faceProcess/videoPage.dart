
import 'dart:io';

import 'package:eyedetector/Form.dart';
import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
   final UserModel user;

  const VideoPage({Key? key, required this.filePath,required this.user}) : super(key: key);

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

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
     // ignore: use_build_context_synchronously
     Provider.of<RecordingProvider>(context, listen: false).startRecording = false;
     // ignore: use_build_context_synchronously
     Provider.of<RecordingProvider>(context, listen: false).eyeinbox = false;
     // ignore: use_build_context_synchronously
     Provider.of<RecordingProvider>(context,listen: false).stopRecord=true;
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Preview'),
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.black26,
    ),
    extendBodyBehindAppBar: true,
    body: FutureBuilder(
      future: _initVideoPlayer(),
      builder: (context, state) {
        if (state.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [

              const SizedBox(height: 200,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 100,
                  child: Center(child: VideoPlayer(_videoPlayerController))),  ),
              const SizedBox(height: 30,),  

              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey,
                    child: IconButton(
                    onPressed: (){
                      bool val2= Provider.of<RecordingProvider>(context, listen: false).eyeinbox;
                      bool val3= Provider.of<RecordingProvider>(context, listen: false).startRecording;
                    
                     print("val----${ widget.user.birthday} ${ widget.user.name}-  $val3 $val2");
                     if( !val2 && !val3){
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>  FaceDetectorView(userModel: widget.user,),
                        ),
                      );
                     }
                              
                                
                    }, icon: Icon(Icons.refresh,color: Colors.white,)),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    height: 50,
                    width: 50,
                    color: primaryColor,
                    child: IconButton(onPressed: (){
                  
                                  
                      
                    // bool val= Provider.of<RecordingProvider>(context, listen: false).stopRecord;
                    bool val2= Provider.of<RecordingProvider>(context, listen: false).eyeinbox;
                    bool val3= Provider.of<RecordingProvider>(context, listen: false).startRecording;
                     // Provider.of<RecordingProvider>(context, listen: false).eyeinbox = false;
                    
                     print("val-----  $val3 $val2");
                     if(!val2 && !val3){
                        Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>  FormPage(),
                        ),
                      );
                     }
                                   
                    }, icon: Icon(Icons.check,color: Colors.white,)),
                  ),
                ],
              )  
            ],
          );
        }
      },
    ),
  );

}
}