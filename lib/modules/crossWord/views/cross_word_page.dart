import 'package:crosswordflutter/modules/crossWord/components/correct_words_display.dart';
import 'package:crosswordflutter/modules/crossWord/components/letter_tiles.dart';
import 'package:crosswordflutter/modules/crossWord/components/timer.dart';
import 'package:flutter/material.dart';

class CrossWordPage extends StatelessWidget {
  CrossWordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Caça Palavras"),
      ),
      body: Column(
        children: [
          Timer(),
          LetterTiles(),
          CorrectWordsDisplay(),
        ],
      ),
    );
  }
}
