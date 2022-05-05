import 'dart:developer';
import 'imageView.dart';
import 'translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart'; // don't know if I need to add
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'dart:io' as IO;

// camera: ^0.9.4+18 --> see if this needs to be added/updated
List<CameraDescription> cameras = [];
late String imagePath;
late bool isLoading;
IconData ourIcon = Icons.flash_off_rounded;

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);
  @override
  State<CameraView> createState() => _CameraViewState();
}


class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  XFile? imageFile;
  static bool flash = false;
  FlashMode? _currentFlashMode;

  getPermission() async {
    await Permission.camera.request();
    PermissionStatus status = await Permission.camera.status;
  }

  @override
  void initState() {
    isLoading = false;
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    controller = CameraController(cameras[0], ResolutionPreset.max);
    _currentFlashMode = controller!.value.flashMode;
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
    return Ink(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 85, top: 25),
              child: InkWell(
                  onTap: () async {
                    setState(() {
                      if (_currentFlashMode == FlashMode.off) {
                        _currentFlashMode = FlashMode.torch;
                        ourIcon = Icons.flash_on_rounded;
                      } else {
                        _currentFlashMode = FlashMode.off;
                        ourIcon = Icons.flash_off_rounded;
                      }
                    });
                    await controller.setFlashMode(
                      _currentFlashMode!,
                    );
                  },
                  child: Icon(
                    ourIcon,
                    color: _currentFlashMode == FlashMode.torch
                        ? Colors.amber
                        : Colors.white,
                    size: 35,
                  )),
            ),

            IconButton(
                padding: new EdgeInsets.only(right: 75),
                onPressed: takePicPressed,
                icon: const Icon(
                  Icons.lens_outlined,
                  color: Colors.white,
                ),
                iconSize: 90),

            const SizedBox(width: 30, height: 20)
          ],
        ));
  }

  void imageResize() {
    var originalImage =
        img.decodeImage(IO.File(imageFile!.path).readAsBytesSync());

    var resizedImage = img.copyResize(originalImage!, width: 395, height: 700);

    IO.File(imageFile!.path)
        .writeAsBytesSync(img.encodePng(resizedImage), mode: IO.FileMode.write);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ImageView(imagePath: imageFile!.path)),
    );
  }

  void takePicPressed() {
    setState(() {
      isLoading = true;
    });
    controller.takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          imageResize();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          AspectRatio(
              aspectRatio: 1 / controller.value.aspectRatio,
              child: CameraPreview(controller)),
          Expanded(child: controlRow()),
        ],
      ),
      if (isLoading)
        Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode: BlendMode.saturation,
          ),
          child: Column(children: [
            Container(
              height: 300,
            ),
            const CircularProgressIndicator(
                strokeWidth: 10.0,
                backgroundColor: Color.fromARGB(255, 12, 123, 220),
                color: Color.fromARGB(255, 255, 194, 10)),
            Container(height: 360)
          ]),
          width: 395,
          height: 700,
        )
      else
        Container(),
    ]));
  }
}
