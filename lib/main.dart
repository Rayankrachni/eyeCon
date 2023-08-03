import 'package:eyedetector/faceDetection.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart'; // Import Google ML Kit

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceDetectorView(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _availableCameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    final CameraDescription camera = _availableCameras.last;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _cameraController.initialize();

    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true, // Enable face contours
        enableLandmarks: true,

      ),
    );

    _cameraController.startImageStream((CameraImage image) {
      _detectFaces(image, faceDetector);
    });
  }

  void _detectFaces(CameraImage image, FaceDetector faceDetector) {
    final InputImage visionImage = InputImage.fromBytes( // Correct import
      bytes: image.planes[0].bytes,
  
       metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation270deg, bytesPerRow: 10, format: image.format.raw,
      ),
    );

    faceDetector.processImage(visionImage).then((List<Face> faces) {
      setState(() {
        _drawOverlaysOnCameraPreview(faces);
      });
    }).catchError((error) {
      print("Error: $error");
    });
  }

  void _drawOverlaysOnCameraPreview(List<Face> faces) {
    // Similar to the previous code snippet
    // ...
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title:const Text('Camera App'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
            // Overlay drawing code here
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}

class FaceContoursPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
  // Similar to the previous custom painter code snippet
  // ...
}
