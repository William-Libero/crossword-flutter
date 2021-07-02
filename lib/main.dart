import 'package:crosswordflutter/components/letterTiles.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CrossWord());
}

class CrossWord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Caça Palavras"),
        ),
        body: LetterTiles(),
      ),
    );
  }
}
