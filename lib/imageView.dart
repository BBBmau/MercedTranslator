import 'dart:developer';
import 'dart:io';
import 'package:cse155/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImageView extends StatefulWidget {
  const ImageView({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late final TextDetector _textDetector;

  @override
  void initState() {
    super.initState();
    // Initializing the text detector
    _textDetector = GoogleMlKit.vision.textDetector();
    log("In init State!");
    _recognizTexts();
  }

  void _recognizTexts() async {
    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    // Retrieving the RecognisedText from the InputImage
    final text = await _textDetector.processImage(inputImage);
    // Finding text String(s)
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        log("${line.text}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Image.file(File(widget.imagePath)), // THIS PART
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
                                  takenImage: File(widget.imagePath),
                                ))));
                  },
                )
              ]))
    ]));
  }
}
