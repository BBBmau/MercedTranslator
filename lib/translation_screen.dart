import 'dart:io';
import 'package:cse155/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

class translationScreen extends StatelessWidget {
  final File takenImage;
  const translationScreen({Key? key, required this.takenImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Image.file(takenImage),
      Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(
                  "English to Spanish",
                  style: TextStyle(fontSize: 25.0),
                ),
              ]))
    ]));
  }
}
