import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/helpers/toast.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:eyedetector/faceProcess/videoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';




class CameraView extends StatefulWidget {

  CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      required this.user,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final UserModel? user;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  CameraController? _controller;
  int _cameraIndex = -1;
  double _currentZoomLevel = initialZoom;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;

  bool _changingCameraLens = false;
  bool _isRecording = false;
  bool startVideo= false;
  
  double? width;
  bool messag1=false;
  bool messag2=false;

  RecordingProvider provider =RecordingProvider();
  



  @override
  void initState() {
    super.initState();
    
      _initialize();
     _showMessages();
    
  }

void _initialize() async {
  if (_cameras.isEmpty) {
    _cameras = await availableCameras();
  }
  
  for (var i = 0; i < _cameras.length; i++) {
    if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
      _cameraIndex = i;
      break;
    }
  }
  
  if (_cameraIndex != -1) {
    _startLiveFeed();
  }
}

  @override
  void dispose() {
    _stopLiveFeed();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
     if(!messag1)
          // ignore: curly_braces_in_flow_control_structures
          ToastHelper.showToast(msg: "Fix Your Phone Please",   backgroundColor: Colors.black);
    
     if(Provider.of<RecordingProvider>(context,listen: false).startRecording==true){_recordVideo();}
     return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
         Center(
    child: _changingCameraLens 
            ?const  Center(child:  Text('Changing camera lens'),)
            : CameraPreview( _controller!, child: widget.customPaint, ),),
            _backButton(),
            _switchLiveCameraToggle(),
          if (messag2)  
          Positioned(
            top: 100,
            right: 20,
            left: 20,
            child: Container(
            
              height: 40,
              width:350,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20)  ),
              child:const Center(child:  Text("Ensure that your eyes are within the assigned region",style: TextStyle(color: Colors.white),)
            ),
          ),
          ),
      
      
          if (messag2)  
          Positioned(
            top: 200,
            right: 20,
            left: 20,
            child: Container(
           
            height: 100,
            width:MediaQuery.of(context).size.width*0.7,
            decoration: BoxDecoration(
               color: Colors.transparent,
              border: Border.all(
                width: 2,
                color: Colors.yellow,
              ),
            ),
        ),
      ),

         
       
      if(_isRecording  )
        Positioned(
          top: 10,
          right: 0,
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child:const  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              
            ],)   ),
        ),
      ],
    ),
  );
     
}

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.black54,
            child:const Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
          ),
        ),
      );




  Widget _detectionViewModeToggle() => Positioned(
        bottom: 8,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: widget.onDetectorViewModeChanged,
            backgroundColor: Colors.black54,
            child:const Icon(
              Icons.photo_library_outlined,
              size: 25,
            ),
          ),
        ),
      );
 
 
  Widget _videoRecording() => Positioned(
        bottom: 30,
        left:5,
        child: SizedBox(
          height:100.0,
          width:400.0,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
             
              child: Icon(_isRecording ? Icons.stop : Icons.circle ,size: 30,),
              onPressed: () => _recordVideo(),
            ),
          ),
        ),
      );    

  Widget _switchLiveCameraToggle() => Positioned(
        bottom: 8,
        right: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: _switchLiveCamera,
            backgroundColor: Colors.black54,
            child: Icon(
              Platform.isIOS
                  ? Icons.flip_camera_ios_outlined
                  : Icons.flip_camera_android_outlined,
              size: 25,
            ),
          ),
        ),
      );


  Widget _exposureControl() => Positioned(
        top: 40,
        right: 8,
        child: ConstrainedBox(
          constraints:const BoxConstraints(
            maxHeight: 250,
          ),
          child: Column(children: [
            Container(
              width: 55,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${_currentExposureOffset.toStringAsFixed(1)}x',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  height: 30,
                  child: Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentExposureOffset = value;
                      });
                      await _controller?.setExposureOffset(value);
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });

      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
   
   
   
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }
  

final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
      if (Platform.isIOS) {
        rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
      } else if (Platform.isAndroid) {
        var rotationCompensation =
            _orientations[_controller!.value.deviceOrientation];
        if (rotationCompensation == null) return null;
        if (camera.lensDirection == CameraLensDirection.front) {
          // front-facing
          rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
        } else {
          // back-facing
          rotationCompensation =
              (sensorOrientation - rotationCompensation + 360) % 360;
        }
        rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
        // print('rotationCompensation: $rotationCompensation');
      }
    if (rotation == null) return null;
   
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    
      if (format == null ||
          (Platform.isAndroid && format != InputImageFormat.nv21) ||
          (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

      // since format is constraint to nv21 or bgra8888, both only have one plane
      if (image.planes.length != 1) return null;
      final plane = image.planes.first;

  return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

bool recordingInProgress = false;
  
  
Future<void> _recordVideo() async {
  if (!recordingInProgress) {
    try {
      recordingInProgress = true;

      if (startVideo) {
         Provider.of<RecordingProvider>(context, listen: false).startRecording = false;
        Provider.of<RecordingProvider>(context, listen: false).eyesinbox = false;
         

        final file = await _controller!.stopVideoRecording(); 
            setState(() {
             startVideo = false;
           });
       
        final croppedFilePath = await getTemporaryDirectory().then((dir) {
          return '${dir.path}/cropped_video.mp4';
        });

      const croppingHeight = 150; 
        await _flutterFFmpeg
            .execute("-y -i ${file.path} -filter:v crop=in_w:$croppingHeight:0:280 -c:a copy $croppedFilePath")
            .then((rc) => print("FFmpeg process exited with rc $rc"));
         

        pushAndRemove(context: context, screen: VideoPage(filePath: croppedFilePath,user: widget.user!,), );
      } else {
        if (!_controller!.value.isRecordingVideo) {
          await _controller!.prepareForVideoRecording();
          await _controller!.startVideoRecording();

            setState(() {

            _isRecording = true;
          });
          ToastHelper.showToast(msg:"Recording in progress. Adjuste your focus, please." , backgroundColor: Colors.green);
        
          Timer(const Duration(seconds: durationOfRecording), () {
                 setState(() => startVideo = true);  
            });
        }
      }
    } finally {
      recordingInProgress = false;
    }
  }
}





_showMessages() {
  setState(() {
          messag1 = true;
          messag2 = true;
        });

  Provider.of<RecordingProvider>(context,listen: false).eyesinbox=true;
  }

}






