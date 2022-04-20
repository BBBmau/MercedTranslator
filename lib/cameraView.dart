import 'dart:developer';
import 'imageView.dart';
import 'translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'dart:io' as IO;

List<CameraDescription> cameras = [];
late String imagePath;
late bool isLoading;

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  XFile? imageFile;

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
        color: Color(0xFF64B5F6),
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
            const SizedBox(width: 50, height: 25)
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
        SizedBox(
          child: Column(children: [
            Container(
              foregroundDecoration: BoxDecoration(
                color: Colors.grey,
                backgroundBlendMode: BlendMode.saturation,
              ),
              height: 300,
            ),
            CircularProgressIndicator(
                strokeWidth: 10.0,
                backgroundColor: Colors.blue,
                color: Color.fromARGB(255, 255, 223, 127)),
            Container(
                foregroundDecoration: BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                ),
                height: 200)
          ]),
          width: 395,
          height: 700,
        )
      else
        Container(),
    ]));
  }
}
