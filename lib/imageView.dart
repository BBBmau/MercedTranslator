import 'dart:developer';
import 'dart:io';
import 'package:cse155/cameraView.dart';
import 'package:cse155/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'boxPainter.dart';
import 'cameraView.dart' as CV;

class ImageView extends StatefulWidget {
  const ImageView({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late final TextDetector _textDetector;
  RecognisedText? textRecognized;
  late Image takenImage;

  @override
  void initState() {
    super.initState();
    takenImage = Image.file(File(widget.imagePath));
    CV.isLoading = false;
    // Initializing the text detector
    _textDetector = GoogleMlKit.vision.textDetector();
    _recognizeTexts();
  }

  void _recognizeTexts() async {
    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    // Retrieving the RecognisedText from the InputImage
    final text = await _textDetector.processImage(inputImage);
    // Finding text String(s)
    log("In RecognizedTexts!");
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        log("${line.text}");
      }
    }

    setState(() {
      textRecognized = text;
    });
  }

  Widget _buildResults(RecognisedText scanResults) {
    CustomPainter painter;
    // print(scanResults);
    log("buildResults");
    if (scanResults != null) {
      log("Paint in progress");
      Size imageSize = Size(
          (takenImage.width) ?? MediaQuery.of(context).size.width,
          (takenImage.height) ?? MediaQuery.of(context).size.height);
      painter = TextDetectorPainter(imageSize, scanResults);

      log("$imageSize");
      return CustomPaint(
        child: takenImage,
        foregroundPainter: painter,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      if (textRecognized != null) _buildResults(textRecognized!),
      Expanded(
          child: Ink(
        color: Colors.black,
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: const Icon(
                    Icons.close_outlined,
                    color: Color.fromARGB(255, 255, 223, 127),
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Image Okay?",
                  style: TextStyle(
                      fontFamily: 'Arial', fontSize: 25.0, color: Colors.white),
                ),
                FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 100, 181, 246),
                  child: const Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 255, 223, 127),
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => translationScreen(
                                  takenImagePath: widget.imagePath,
                                  textRecognized: textRecognized!,
                                ))));
                  },
                )
              ]),
        ),
      ))
    ]));
  }
}
