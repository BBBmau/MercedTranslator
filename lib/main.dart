import 'package:cse155/cameraView.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:splashscreen/splashscreen.dart';
// ignore: import_of_legacy_library_into_null_safe

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Could not fetch camera: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraView()
      //    SplashScreen(
      //   seconds: 4,
      //   navigateAfterSeconds: const CameraView(),
      //   title: const Text(
      //     'BLEACH',
      //     style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         fontSize: 20.0,
      //         color: Colors.amber),
      //   ),
      //   backgroundColor: Colors.black,
      //   loaderColor: Colors.black,
      // )
      /*
      return MaterialApp(
        initialRoute: '/'
        routes: {
          '/': (context) => const CameraView(),
          '/confirm': (context) => const ImageView(),
          '/translation': (context) => const TranslationScreen(),
          '/final': (context) => const FinalScreen(),
        },
      );
      */
    );
  }
}
