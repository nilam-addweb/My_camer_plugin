import 'dart:io';

import 'package:my_camera/my_camera.dart';
import 'package:flutter/material.dart';

void main() {
  String id = DateTime.now().toIso8601String();
  runApp(MaterialApp(home: MyApp(id: id)));
}

class MyApp extends StatefulWidget {
  final String id;

  const MyApp({Key key, this.id}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> pictureSizes = [];
  String imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [



               Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.flash_off_outlined,color: Colors.black,),
                          onPressed: () {
                            cameraController.setFlashType(FlashType.off);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.flash_on,color: Colors.black,),

                          onPressed: () {
                            cameraController.setFlashType(FlashType.torch);
                          },
                        ),

                       /* FlatButton(

                          child: Text("Off"),
                          onPressed: () {
                            cameraController.setFlashType(FlashType.off);
                          },
                        ),*/
                       /* FlatButton(
                          child: Text("Torch"),
                          onPressed: () {
                            cameraController.setFlashType(FlashType.torch);
                          },
                        ),*/
                      ],
                    ),
                  ),



                Expanded(
                    child: Container(
                      child: MyCamera(
                        onCameraCreated: _onCameraCreated,
                        onImageCaptured: (String path) {
                          print("onImageCaptured => " + path);
                          if (this.mounted)
                            setState(() {
                              imagePath = path;
                            });
                        },
                        cameraPreviewRatio: CameraPreviewRatio.r16_9,
                      ),
                    )),
              ],
            ),
           /* Positioned(
              bottom: 16.0,
              left: 16.0,
              child: imagePath != null
                  ? Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.file(File(imagePath)))
                  : Icon(Icons.image),
            )*/
          ],
        ),
      ),
      floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
             // heroTag: "test1",
              child: Icon(Icons.switch_camera),
              onPressed: () async {
                await cameraController.switchCamera();
                List<FlashType> types = await cameraController.getFlashType();


              },
            ),
            Container(height: 16.0),
            FloatingActionButton(
               // heroTag: "test2",
                child: Icon(Icons.camera_alt),
                onPressed: () {
                  cameraController.captureImage();
                }),
          ]),

    );
  }
  MyCameraController cameraController;

  _onCameraCreated(MyCameraController controller) {
    this.cameraController = controller;

    this.cameraController.getPictureSizes().then((pictureSizes) {
      setState(() {
        this.pictureSizes = pictureSizes;
      });
    });
  }
}