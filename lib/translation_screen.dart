import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:translator/translator.dart';
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
  late CustomPainter painter;
  String languageDetected = "";

  @override
  void initState() {
    super.initState();
    for (TextBlock block in widget.textRecognized.blocks) {
      for (TextLine line in block.lines) {
        // String translation;

        // translator.translate(line.text).then(((value) {
        //   translation = value.text;
        //   setState(() {
        //     languageDetected = value.sourceLanguage.name;
        //   });
        //   log("$translation");
        //   textList
        //       .add(translatedBox(translation, line.rect, line.cornerPoints[0]));
        // }));
      }
      String translation;

      translator.translate(block.text).then(((value) {
        translation = value.text;
        setState(() {
          languageDetected = value.sourceLanguage.name;
        });
        log("$translation");
        textList
            .add(translatedBox(translation, block.rect, block.cornerPoints[0]));
      }));
    }

    takenImage = Image.file(File(widget.takenImagePath));
  }

  var translator = GoogleTranslator();

  Future<Widget> _buildResults(RecognisedText scanResults) async {
    log("Paint in progress");
    await Future.delayed(Duration(seconds: 2));
    painter =
        filledBoxPainter(textList: textList, visionText: widget.textRecognized);

    return Container();
  }

  // Widget paintedText() {
  //   CustomPainter textPainter = translatedPainter(textList);
  //   return RepaintBoundary(
  //       child: CustomPaint(
  //           child: _buildResults(widget.textRecognized),
  //           foregroundPainter: textPainter));
  // }

  final Future<Widget> _waiting = Future<Widget>.delayed(
    const Duration(seconds: 4),
    () => Container(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          // FutureBuilder<Widget>(
          //   initialData: Container(),
          //   builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const CircularProgressIndicator();
          //     } else if (snapshot.connectionState == ConnectionState.done) {
          //       return paintedText();
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
          FutureBuilder<Widget>(
              future: _buildResults(widget.textRecognized),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomPaint(
                    child: takenImage,
                    foregroundPainter: painter,
                    isComplex: true,
                  );
                } else {
                  return SizedBox(
                    child: Column(children: const [
                      SizedBox(
                        height: 300,
                      ),
                      CircularProgressIndicator(
                          strokeWidth: 10.0,
                          backgroundColor: Color.fromARGB(255, 100, 181, 246),
                          color: Color.fromARGB(255, 255, 223, 127)),
                      SizedBox(height: 200)
                    ]),
                    width: 395,
                    height: 700,
                  );
                }
              }),
          //Image.file(File(widget.takenImagePath)),
          Row(

              //mainAxisAlignment: MainAxisAlignment,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 17),
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 100, 181, 246),
                        size: 40,
                      ),
                      onPressed: () {
                        textList.clear();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    )),
                if (languageDetected == "")
                  const Padding(
                      padding: EdgeInsets.only(left: 20, top: 25, right: 17),
                      child: Text(
                        "No Text Detected",
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ))
                else if (languageDetected == "Automatic")
                  const Padding(
                      padding: EdgeInsets.only(left: 10, top: 25, right: 17),
                      child: Text(
                        "No Language Detected",
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ))
                else
                  Row(children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 9),
                              child: Text("Detected Language",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 223, 127),
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                languageDetected,
                                style: const TextStyle(
                                    fontFamily: "Arial",
                                    decorationStyle: TextDecorationStyle.dashed,
                                    fontSize: 25.0,
                                    color: Colors.white),
                              )),
                        ]),
                    const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Icon(
                          Icons.arrow_right_alt_rounded,
                          color: Colors.white,
                          size: 50,
                        )),
                    const Padding(
                        padding: EdgeInsets.only(top: 30, left: 20),
                        child: Text(
                          "English",
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ))
                  ])
                // DropDownMenu(),
              ])
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