part of my_camera;

/// Controller for a single GoogleMap instance running on the host platform.
class MyCameraController {
  MyCameraController._(
    this.channel,
    this._myCameraState,
  ) : assert(channel != null) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<MyCameraController> init(
    int id,
    _MyCameraState myCameraState,
  ) async {
    assert(id != null);
    final MethodChannel channel = MethodChannel('plugins.flutter.io/my_camera/$id');
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    await channel.invokeMethod('waitForCamera');
    return MyCameraController._(
      channel,
      myCameraState,
    );
  }

  @visibleForTesting
  final MethodChannel channel;

  final _MyCameraState _myCameraState;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onImageCaptured":
        String path = call.arguments['path'] as String;
        _myCameraState.onImageCaptured(path);
        break;
      case "onFlashTypeChanged":
        String types = call.arguments['types'] as String;
        _myCameraState.onImageCaptured(types);
        break;
      default:
        throw MissingPluginException();
    }
  }

  Future<void> setSessionPreset( cameraSessionPreset) async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    if (Platform.isAndroid) return;

    String sessionPreset;


    await channel.invokeMethod('setSessionPreset', <String, dynamic>{
      'sessionPreset': sessionPreset,
    });


    _myCameraState.setState(() {});
  }

  Future<void> setPreviewRatio(CameraPreviewRatio cameraPreviewRatio) async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    if (Platform.isIOS) return;

    String previewRatio;

    switch (cameraPreviewRatio) {
      case CameraPreviewRatio.r16_9:
        previewRatio = "16:9";
        break;
      case CameraPreviewRatio.r11_9:
        previewRatio = "11:9";
        break;
      case CameraPreviewRatio.r4_3:
        previewRatio = "4:3";
        break;
      case CameraPreviewRatio.r1:
        previewRatio = "1:1";
        break;
    }

    bool success = await channel.invokeMethod('setPreviewRatio', <String, dynamic>{
      'previewRatio': previewRatio,
    });

    if (success) {
      _myCameraState._cameraPreviewRatio = cameraPreviewRatio;
      _myCameraState.setState(() {});
    }
  }

  Future<void> captureImage({int maxSize}) async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    await channel.invokeMethod('captureImage', <String, dynamic>{
      'maxSize': maxSize,
    });
  }

  Future<void> switchCamera() async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    await channel.invokeMethod('switchCamera', null);
  }

  Future<void> turnOffCamera() async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    await channel.invokeMethod('turnOff', null);
  }

  Future<List<String>> getPictureSizes() async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    var result = await channel.invokeMethod('getPictureSizes', null);

    if (result == null) return null;

    return List<String>.from(result);
  }

  Future<void> setPictureSize(int width, int height) async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    var x = await channel
        .invokeMethod('setPictureSize', {"pictureWidth": width, "pictureHeight": height});

    print("setPictureSize => $x");
  }

  Future<void> setSavePath(String savePath) async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    if (Platform.isIOS) return;

    var x = await channel.invokeMethod('setSavePath', {"savePath": savePath});

    print("setSavePath => $x");
  }

  Future<void> setFlashType(FlashType flashType) async {
    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
    // https://github.com/flutter/flutter/issues/26431
    // ignore: strong_mode_implicit_dynamic_method
    String flashTypeString;

    switch (flashType) {
      case FlashType.auto:
        flashTypeString = "auto";
        break;
      case FlashType.on:
        flashTypeString = "on";
        break;
      case FlashType.off:
        flashTypeString = "off";
        break;
      case FlashType.torch:
        flashTypeString = "torch";
        break;
    }
    var x = await channel.invokeMethod('setFlashType', {"flashType": flashTypeString});

    print("setFlashType => $x");
  }

  Future<List<FlashType>> getFlashType() async {
    final types = await channel.invokeMethod('getFlashType');
print("getFlashType => $types");
    List<FlashType> finalTypes = [];

    if (types == null) return finalTypes;

    if (types is List) {
      for (var each in types) {
        if (each == "on") {
          finalTypes.add(FlashType.on);
        } else if (each == "off") {
          finalTypes.add(FlashType.off);
        } else if (each == "torch") {
          finalTypes.add(FlashType.torch);
        } else if (each == "auto") {
          finalTypes.add(FlashType.auto);
        }
      }
    }

    return finalTypes;
  }

//  Future<void> changeCamera() async {
//    // TODO(amirh): remove this on when the invokeMethod update makes it to stable Flutter.
//    // https://github.com/flutter/flutter/issues/26431
//    // ignore: strong_mode_implicit_dynamic_method
//    await channel.invokeMethod('setMaxImage', <String, dynamic>{
//      'maxImage': maxImage,
//    });
//  }
}
