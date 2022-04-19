import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ML;
import 'package:translator/translator.dart';

// Paints rectangles around all the text in the image.

List<translatedBox> textList = [];

class translatedBox {
  String translatedText;
  Rect rectangleCoords;
  Offset cornerPoints;

  translatedBox(this.translatedText, this.rectangleCoords, this.cornerPoints);
}

class filledBoxPainter extends CustomPainter {
  filledBoxPainter(this.absoluteImageSize, this.visionText);

  final Size absoluteImageSize;
  final ML.RecognisedText visionText;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // TextSpan span = new TextSpan(text: 'TESTING');
    // TextPainter tp = new TextPainter(
    //     textScaleFactor: 20,
    //     text: span,
    //     textAlign: TextAlign.left,
    //     textDirection: TextDirection.ltr);
    // tp.layout();
    // tp.paint(canvas, new Offset(5.0, 5.0));

    final translator = GoogleTranslator();

    // translates text found in image and stores in
    for (ML.TextBlock block in visionText.blocks) {
      for (ML.TextLine line in block.lines) {
        String translation;

        translator.translate(line.text).then(((value) {
          translation = value.text;
          log("$translation");
          textList
              .add(translatedBox(translation, line.rect, line.cornerPoints[0]));
        }));
      }
    }

    for (int i = 0; i < textList.length; i++) {
      paint.color = Colors.blue;
      canvas.drawRect(textList[i].rectangleCoords, paint);
      TextSpan span = TextSpan(text: textList[i].translatedText);
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, textList[i].cornerPoints);
    }
  }

  @override
  bool shouldRepaint(filledBoxPainter oldDelegate) {
    return true;
  }
}
