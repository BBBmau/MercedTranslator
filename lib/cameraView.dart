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

Widget controlRow() {
  return Padding(
      padding: const EdgeInsets.only(left: 40, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const <Widget>[
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.flash_auto,
              color: Colors.white,
            ),
            iconSize: 32,
          ),
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.circle,
                color: Colors.white,
              ),
              iconSize: 90),
          SizedBox(width: 88)
        ],
      ));
}
