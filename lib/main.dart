import 'package:eyedetector/provider/contentHtml_provider.dart';
import 'package:eyedetector/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/provider/video_recording.dart';
import 'package:eyedetector/splashScreen.dart';
import 'package:open_file/open_file.dart';
void main() async {

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecordingProvider>(
          create: (context) => RecordingProvider(),
        ),
        ChangeNotifierProvider<ContentHtmlProvider>(
          create: (context) => ContentHtmlProvider(),
        ),

        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        // Add more providers here if needed
      ],
      child: MaterialApp(
        title: 'Camera App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
