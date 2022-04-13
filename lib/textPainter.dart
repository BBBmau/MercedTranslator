import 'dart:developer';
import 'dart:ui';

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

    var translatedText = ParagraphStyle(
      fontSize: 200,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    log("TRANSLATING");

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        paint.color = Colors.blue;
        canvas.drawRect(line.rect, paint);

        // adds text
        // translator.translate(line.text).then((translation) {
        //   // ignore: unnecessary_new
        //   var translatedText = ParagraphStyle(
        //     textAlign: TextAlign.left,
        //     textDirection: TextDirection.ltr,
        //   );
        //   log("TRANSLATING");
        //   var textBuilder = ParagraphBuilder(translatedText);
        //   textBuilder.addText(translation.text);
        //   var readyParagraph = textBuilder.build();
        //   canvas.drawParagraph(readyParagraph, line.cornerPoints[0]);
        // });
      }
    }

    Future<Translation> fetchTranslation(TextLine line) async {}

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        translator.translate(line.text).then((translation) {
          // ignore: unnecessary_new
          var translatedText = ParagraphStyle(
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          log("TRANSLATING");
          var textBuilder = ParagraphBuilder(translatedText);
          textBuilder.addText(translation.text);
          var readyParagraph = textBuilder.build();
          canvas.drawParagraph(readyParagraph, line.cornerPoints[0]);
        });
      }
    }
  }

  @override
  bool shouldRepaint(translatedTextPainter oldDelegate) {
    return true;
  }
}
