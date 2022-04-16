import 'dart:io';
import 'package:cse155/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart'; // don't know if I need to add
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';


// camera: ^0.9.4+18 --> see if this needs to be added/updated 
List<CameraDescription> cameras = [];

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);
 

  @override
  State<CameraView> createState() => _CameraViewState();
}
/// added part

// class FlashPage extends StatefulWidget {
//   const FlashPage({Key? key}) : super(key: key);

//   @override
//   State<FlashPage> createState() => _FlashPageState();
// }

// class _FlashPageState extends State<FlashPage> {
//   late CameraController _cameraController;
// //   int flashStatus = 0;
// //   List<Icon> flash = [
// //     Icon(Icons.flash_on),
// //     Icon(Icons.flash_off),
// //     Icon(Icons.flash_auto)
// //   ];


// // // added this 
// //    List<FlashMode> flashMode = [
// //     FlashMode.always,
// //     FlashMode.off,
// //     FlashMode.auto
// //   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flash demo',
//       home: Scaffold(
//         body: Center(
//           child: IconButton(
//               icon: flash[flashStatus],
//               onPressed: () {
//                 setState(() {
//                   flashStatus = (flashStatus + 1) % 3;
//                   _cameraController.setFlashMode(flashMode[flashStatus]);
//                 });
//               }),
//         ),
//       ),
//     );
//   }
// }

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  XFile? imageFile;
  static bool flash = false;  // I don't know if this is the right place
  // int flashStatus = 0;
  FlashMode? _currentFlashMode;

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
            // const IconButton(
             
            //   onPressed: null,
              
            //   icon: Icon(
              
            //     //Icons.margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            //     Icons.flash_auto,
            //     color: Colors.yellow,
            //   ),
            //   iconSize: 50,
            // ),

            InkWell(
              onTap: () async {
                setState(() {
                  if(_currentFlashMode == FlashMode.off) {
                     _currentFlashMode = FlashMode.torch;
                  } else {
                    _currentFlashMode = FlashMode.off;
                  }
                 
                });
                await controller.setFlashMode(
                  _currentFlashMode!,
                );
              },

              child: Icon(
                Icons.flash_auto,
                color:
                  _currentFlashMode == FlashMode.torch
                    ? Colors.amber
                    : Colors.white,
                size: 90,
              )
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
  } 



















 /* Widget controlRow() {
    return Ink(
        color: Colors.black,
        child: Center(
          //margin: const EdgeInsets.only(),
          CameraController _cameraController;
          heightFactor: 1,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget> [
              IconButton( 
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lens_outlined,
                    color: Colors.pink,
                  ),
                  iconSize: 90),
                  
              IconButton(
                padding: EdgeInsets.only(right: 30), // right 30
                onPressed: null,
                icon: Icon(
                  
                  flash ? Icons.flash_on : Icons.flash_off,
                  
                  color: Colors.white,
                  
                ),
                iconSize: 50,
                onPressed: () {
                  _cameraController.setFlashMode(FlashMode.always);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.transparent),
                  child: Text(
                    "Flash On",
                  style: TextStyle(
                  color: Colors.white, backgroundColor: Colors.transparent),
                    ),
                  )  
                  /* setState(() {
                    flash = !flash;
                    }); */ 

                const SizedBox(width: 50, height: 25) // w - 50 h - 25

              
            ],
            
          ),
          
        ));
      
  } */

  // commented code goes here for reference 

//// take picture method here 
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


           /* 
            children: <Widget>[
              int flashStatus = 0,
              List<Icons> flash = [Icons.flash_on, Icons.flash_off, Icons.flash_auto];
              const IconButton(
                padding: EdgeInsets.only(right: 30), // right 30
                icon: flash[flashStatus],
                iconSize: 50,
                onPressed: () {
                    setState(() {
                      flashStatus = (flashStatus + 1) % 3;
                    });
                  }),
                ), */ 
        
              /* IconButton(
                padding: EdgeInsets.only(right: 30), // right 30
                onPressed: null,
                icon: Icon(
                  
                  flash ? Icons.flash_on : Icons.flash_off,
                  
                  color: Colors.white,
                  
                ),
                iconSize: 50,
                onPressed: () {
                  setState(() {
                    flash = !flash;
                    });
                    flash 
                      ? _cameraController.setFlashMode(FlashMode.torch) : _cameraController.set(FlashMode.off);
                }),
              ), */ 


              
  // }

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
