import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ML;
import 'translation_screen.dart';

// Paints rectangles around all the text in the image.

List<translatedBox> textList = [];

class translatedBox {
  String translatedText;
  Rect rectangleCoords;
  Offset cornerPoints;

  translatedBox(this.translatedText, this.rectangleCoords, this.cornerPoints);
}

class filledBoxPainter extends CustomPainter with ChangeNotifier {
  final List<translatedBox> textList;
  final ML.RecognisedText visionText;

  filledBoxPainter({required this.textList, required this.visionText});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..color = Colors.blue;

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = Color.fromARGB(255, 255, 223, 127);

    log("The textList length: ${textList.length}");

    int i = 0;
    for (ML.TextBlock block in visionText.blocks) {
      for (ML.TextLine line in block.lines) {
        canvas.drawRect(textList[i].rectangleCoords.inflate(3), borderPaint);
        canvas.drawRect(textList[i].rectangleCoords, paint);

        i += 1;
      }
    }

    for (int i = 0; i < textList.length; i++) {
      TextSpan span = TextSpan(text: textList[i].translatedText);
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, textList[i].cornerPoints);
      log("Text Painted!");
    }
  }

  @override
  bool shouldRepaint(filledBoxPainter oldDelegate) {
    return oldDelegate == null;
  }
}
