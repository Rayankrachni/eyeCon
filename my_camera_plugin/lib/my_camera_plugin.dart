// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/services.dart';

import 'my_camera_plugin_platform_interface.dart';

class MyCameraPlugin {
  Future<String?> getPlatformVersion() {
    return MyCameraPluginPlatform.instance.getPlatformVersion();
  }
  static const MethodChannel _channel = MethodChannel('MyCameraPlugin');

  // Define a method to set video frame rate
  static Future<void> setVideoFrameRate(int frameRate) async {
    await _channel.invokeMethod('setVideoFrameRate', frameRate);
  }
}
