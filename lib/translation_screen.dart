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
        backgroundColor: Colors.black,
        body: Column(children: [
          Image.file(takenImage),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(

                  //mainAxisAlignment: MainAxisAlignment,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 40),
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                        )),
                    const Text(
                      "English to Spanish",
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    DropDownMenu(),
                  ]))
        ]));
  }
}
class DropDownMenu extends StatefulWidget {
  const DropDownMenu({Key? key}) : super(key: key);

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String _value = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _value,
      icon: const Icon(
        Icons.arrow_downward_outlined
      ),
      elevation: 16,
      style: const TextStyle(
        color: Colors.deepPurple
      ),
      onChanged: (String? newValue) {
        setState(() {
          _value = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      );
  }
}
