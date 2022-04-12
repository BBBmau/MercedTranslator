import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:translator/translator.dart';

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

    // init translator
    final translator = GoogleTranslator();

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          //paint.color = Colors.green;
          //canvas.drawRect(element.rect, paint);
        }

        paint.color = Colors.yellow;
        //canvas.drawRect(line.rect, paint);

        // adds text
        translator.translate(line.text).then((text) {
          // ignore: unnecessary_new
          log("$text");
          TextSpan tspan = TextSpan(
              style: TextStyle(color: Colors.grey[600]), text: text.text);
          TextPainter tpainter = TextPainter(
              text: tspan,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr);
          tpainter.layout();
          tpainter.paint(canvas, line.cornerPoints[0]);
          log("Corner points: ");
        });
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
