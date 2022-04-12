import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// Paints rectangles around all the text in the image.
class translatedTextPainter extends CustomPainter {
  translatedTextPainter(this.absoluteImageSize, this.visionText);

  final Size absoluteImageSize;
  final RecognisedText visionText;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          //paint.color = Colors.green;
          //canvas.drawRect(element.rect, paint);
        }

        paint.color = Colors.yellow;
        canvas.drawRect(line.rect, paint);
      }
      //paint.color = Colors.blue;
      //canvas.drawRect(block.rect, paint);
    }
  }

  @override
  bool shouldRepaint(translatedTextPainter oldDelegate) {
    return true;
  }
}
