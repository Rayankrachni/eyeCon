
import 'dart:io';

import 'package:eyedetector/Form.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

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
      actions: [
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
             /*Provider.of<RecordingProvider>(context, listen: false).startRecording = false;
            
             Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext contexzt) =>  FaceDetectorView(),
              ),
            );*/
          },
        )
      ],
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

              SizedBox(height: 200,),
              SizedBox(

                height: 150,
                child: Center(child: VideoPlayer(_videoPlayerController))),

              Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: (){
                   // Provider.of<RecordingProvider>(context, listen: false).startRecording = false;
                    //Provider.of<RecordingProvider>(context, listen: false).eyeinbox = false;
                   // Provider.of<RecordingProvider>(context,listen: false).stopRecord=true;

                   // bool val= Provider.of<RecordingProvider>(context, listen: false).stopRecord;
                    bool val2= Provider.of<RecordingProvider>(context, listen: false).eyeinbox;
                    bool val3= Provider.of<RecordingProvider>(context, listen: false).startRecording;
                   // Provider.of<RecordingProvider>(context, listen: false).eyeinbox = false;
  
                   print("val-----  $val3 $val2");
                   if( !val2 && !val3){
                         Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>  FaceDetectorView(),
                      ),
                    );
                   }
            
              
                  }, child: Text("Retake")),
                  ElevatedButton(onPressed: (){


                    
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
                 
                  }, child: Text("Finish")),

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