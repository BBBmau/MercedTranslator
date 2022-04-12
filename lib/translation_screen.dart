import 'dart:io';
import 'package:cse155/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'imageView.dart'
    as IV; // Grabbing variables and methods from imageView.dart
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:direct_select/direct_select.dart';
import 'textPainter.dart';

class translationScreen extends StatefulWidget {
  const translationScreen(
      {Key? key, required this.takenImagePath, required this.textRecognized})
      : super(key: key);
  final RecognisedText textRecognized;
  final String takenImagePath;
  @override
  State<translationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<translationScreen> {
  late Image takenImage;

  @override
  void initState() {
    super.initState();
    takenImage = Image.file(File(widget.takenImagePath));
  }

  Widget _buildResults(RecognisedText scanResults) {
    CustomPainter painter;
    // print(scanResults);
    //log("buildResults");
    if (scanResults != null) {
      //log("Paint in progress");
      Size imageSize = Size(
          (takenImage.width) ?? MediaQuery.of(context).size.width,
          (takenImage.height) ?? MediaQuery.of(context).size.height);
      painter = translatedTextPainter(imageSize, scanResults);

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
        backgroundColor: Colors.black,
        body: Column(children: [
          _buildResults(widget.textRecognized),
          //Image.file(File(widget.takenImagePath)),
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
                    // DropDownMenu(),
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
  String? _value = LanguageList()._langs[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      menuMaxHeight: 200,
      value: _value,
      icon: const Icon(Icons.arrow_downward_outlined),
      elevation: 8,
      style: const TextStyle(color: Colors.amber),
      onChanged: (String? newValue) {
        setState(() {
          _value = newValue!;
        });
      },
      items: LanguageList()
          ._langs
          .map((description, value) {
            return MapEntry(
                description,
                DropdownMenuItem<String>(
                  value: value,
                  child: Text(description),
                ));
          })
          .values
          .toList(),
    );
  }
}

class LanguageList {
  final _langs = {
    'auto': 'Automatic',
    'af': 'Afrikaans',
    'sq': 'Albanian',
    'am': 'Amharic',
    'ar': 'Arabic',
    'hy': 'Armenian',
    'az': 'Azerbaijani',
    'eu': 'Basque',
    'be': 'Belarusian',
    'bn': 'Bengali',
    'bs': 'Bosnian',
    'bg': 'Bulgarian',
    'ca': 'Catalan',
    'ceb': 'Cebuano',
    'ny': 'Chichewa',
    'zh-cn': 'Chinese Simplified',
    'zh-tw': 'Chinese Traditional',
    'co': 'Corsican',
    'hr': 'Croatian',
    'cs': 'Czech',
    'da': 'Danish',
    'nl': 'Dutch',
    'en': 'English',
    'eo': 'Esperanto',
    'et': 'Estonian',
    'tl': 'Filipino',
    'fi': 'Finnish',
    'fr': 'French',
    'fy': 'Frisian',
    'gl': 'Galician',
    'ka': 'Georgian',
    'de': 'German',
    'el': 'Greek',
    'gu': 'Gujarati',
    'ht': 'Haitian Creole',
    'ha': 'Hausa',
    'haw': 'Hawaiian',
    'iw': 'Hebrew',
    'hi': 'Hindi',
    'hmn': 'Hmong',
    'hu': 'Hungarian',
    'is': 'Icelandic',
    'ig': 'Igbo',
    'id': 'Indonesian',
    'ga': 'Irish',
    'it': 'Italian',
    'ja': 'Japanese',
    'jw': 'Javanese',
    'kn': 'Kannada',
    'kk': 'Kazakh',
    'km': 'Khmer',
    'ko': 'Korean',
    'ku': 'Kurdish (Kurmanji)',
    'ky': 'Kyrgyz',
    'lo': 'Lao',
    'la': 'Latin',
    'lv': 'Latvian',
    'lt': 'Lithuanian',
    'lb': 'Luxembourgish',
    'mk': 'Macedonian',
    'mg': 'Malagasy',
    'ms': 'Malay',
    'ml': 'Malayalam',
    'mt': 'Maltese',
    'mi': 'Maori',
    'mr': 'Marathi',
    'mn': 'Mongolian',
    'my': 'Myanmar (Burmese)',
    'ne': 'Nepali',
    'no': 'Norwegian',
    'ps': 'Pashto',
    'fa': 'Persian',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'pa': 'Punjabi',
    'ro': 'Romanian',
    'ru': 'Russian',
    'sm': 'Samoan',
    'gd': 'Scots Gaelic',
    'sr': 'Serbian',
    'st': 'Sesotho',
    'sn': 'Shona',
    'sd': 'Sindhi',
    'si': 'Sinhala',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'so': 'Somali',
    'es': 'Spanish',
    'su': 'Sundanese',
    'sw': 'Swahili',
    'sv': 'Swedish',
    'tg': 'Tajik',
    'ta': 'Tamil',
    'te': 'Telugu',
    'th': 'Thai',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'uz': 'Uzbek',
    'ug': 'Uyghur',
    'vi': 'Vietnamese',
    'cy': 'Welsh',
    'xh': 'Xhosa',
    'yi': 'Yiddish',
    'yo': 'Yoruba',
    'zu': 'Zulu'
  };
}

// class Select extends StatefulWidget {
//   const Select({Key? key}) : super(key: key);

//   @override
//   State<Select> createState() => _SelectState();
// }

// class _SelectState extends State<Selct> {



//   Widget build(BuildContext context) {
//     return DirectSelect(
//       items: items, 
//       onSelectedItemChanged: onSelectedItemChanged, 
//       itemExtent: 35.0, 
//       child: child)
//   }
// }