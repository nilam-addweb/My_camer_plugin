import 'package:flutter/services.dart';

class MyCameraPlugin {
  static const MethodChannel _channel = const MethodChannel('my_camera',);



  static Future<bool> checkForPermission() async {
    return await _channel.invokeMethod('checkForPermission');
  }
}