import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// Paints rectangles around all the text in the image.
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.visionText);

  final Size absoluteImageSize;
  final RecognisedText visionText;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color.fromARGB(255, 12, 123, 220);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Color.fromARGB(255, 255, 194, 10);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {}

        //paint.color = Colors.blue;
        //canvas.drawRect(line.rect, paint);
      }
      Rect borderRect = block.rect.inflate(2);
      canvas.drawRect(borderRect, borderPaint);
      canvas.drawRect(block.rect, paint);
      //paint.color = Colors.blue;
      //canvas.drawRect(block.rect, paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
