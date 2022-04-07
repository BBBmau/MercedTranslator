import 'package:cse155/imageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
late String imagePath;

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
        color: Colors.black,
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
            MaterialPageRoute(
                builder: (context) =>
                    ImageView(imagePath: file.path.toString())),
          );
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
      body: Column(
        children: [
          AspectRatio(
              aspectRatio: 1 / controller.value.aspectRatio,
              child: CameraPreview(controller)),
          Expanded(child: controlRow()),
        ],
      ),
    );
  }
}
