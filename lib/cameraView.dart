import 'dart:io';
import 'package:flutter/services.dart';
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
  const ImageView({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Image.file(File(imagePath)),
      Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Image Okay?",
                  style: TextStyle(fontSize: 25.0),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]))
    ]));
  }
}
