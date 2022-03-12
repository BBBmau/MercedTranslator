import 'package:flutter/material.dart';
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
                  Icons.circle,
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
