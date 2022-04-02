import 'dart:io';
import 'package:cse155/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

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
        child: Center(
          //margin: const EdgeInsets.only(),
          heightFactor: 1,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            
            
            children: <Widget>[
              const IconButton(
                
                padding: EdgeInsets.only(right: 30), // right 30
                
                onPressed: null,
                icon: Icon(
                  Icons.flash_auto,
                  color: Colors.white,
                  

                ),
                iconSize: 50,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lens_outlined,
                    color: Colors.white,
                  ),
                  iconSize: 90),
              const SizedBox(width: 50, height: 25) // w - 50 h - 25
            ],
          ),
        ));
  }

 /* Widget controlRow() {
    return Ink(
        color: Colors.black,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const IconButton(
             
              onPressed: null,
              
              icon: Icon(
              
                //Icons.margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                Icons.flash_auto,
                color: Colors.yellow,
              ),
              iconSize: 50,
            ),

            IconButton( // circle button
                // padding: new EdgeInsets.all(0.0),
                onPressed: takePicPressed,
                icon: const Icon( // icon: const Icon( 
                  Icons.lens_outlined,
                  color: Colors.red,

                  
                  
                
                ),
                iconSize: 90),

            const SizedBox(width: 50, height: 25) // 50 and 25
          ],
        ));
  } */

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => translationScreen(
                                  takenImage: File(imagePath),
                                ))));
                  },
                )
              ]))
    ]));
  }
}
