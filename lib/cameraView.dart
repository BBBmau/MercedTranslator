import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

class cameraView extends StatefulWidget {
  const cameraView({Key? key}) : super(key: key);

  @override
  State<cameraView> createState() => _cameraViewState();
}

class _cameraViewState extends State<cameraView> {
  late CameraController controller;
  XFile? imageFile;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget controlRow() {
    return Padding(
        padding: const EdgeInsets.only(left: 40, bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.flash_auto,
                color: Colors.white,
              ),
              iconSize: 32,
            ),
            IconButton(
                onPressed: takePicPressed,
                icon: const Icon(
                  Icons.lens_outlined,
                  color: Colors.white,
                ),
                iconSize: 90),
            const SizedBox(width: 88)
          ],
        ));
  }

  void takePicPressed() {
    controller.takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          print("PICTURE TAKEN IN ${file.path}");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageView(
              imagePath : file.path.toString()
            )),
            );
        }
      }
    });
  }

// void onTakePictureButtonPressed() {
//   takePicture().then((XFile? file) {
//     if (mounted) {
//       setState(() {
//         imageFile = file;
//         videoController = null;
//       });
//       if (file != null) {
//         showInSnackBar('Picture saved to ${file.path}');
//       }
//     }
//   });
// }

// Future<XFile?> takePicture() async {
//   final CameraController? cameraController = controller;
// }


  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
          Expanded(child: CameraPreview(controller)),
          Expanded(child: controlRow())
        ]));
  }
}

class ImageView extends StatelessWidget {
  final String imagePath;
  const ImageView({Key? key, required this.imagePath})
   : super(key : key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Picture')),
      body: Image.file(File(imagePath)),
      );
  }
}
