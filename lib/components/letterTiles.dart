import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LetterTiles extends StatefulWidget {
  @override
  _LetterTilesState createState() => _LetterTilesState();
}

class _LetterTilesState extends State<LetterTiles> {
  String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  List<String> _correctWords = ["DOG", "CROSS", "WORD", "DARK"];
  List<String> solvedWords = [];
  String wordFormed = "";
  bool buttonVisibility = false;
  // Variaveis usadas na função que popula o array com as letras que
  // aparecem no quadro de letras
  final Random _randomNumber = new Random();
  dynamic crossWordChars = [];
  int index = 0;
  int indexCorrectWord = 0;
  //Variaveis usadas na função que verifica a posição do elemento renderizado
  final Set<int> selectedIndexes = Set<int>();
  final Set<int> solvedIndexes = Set<int>();
  final key = GlobalKey();
  // Cria uma array de RenderProxyBox que salvara os elementos quando os mesmos
  //forem pressionados
  final Set<_BoxWord> _selectedElements = Set<_BoxWord>();

  @override
  void initState() {
    super.initState();
    getRandomString(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: GridView.builder(
            key: key,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 6,
            ),
            itemCount: 36,
            itemBuilder: (context, index) {
              return ValueListenableBuilder(
                valueListenable:
                    ValueNotifier(crossWordChars[index].toString()),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Listener(
                    onPointerDown: _detectTapedItem,
                    onPointerMove: _detectTapedItem,
                    onPointerUp: _clearSelection,
                    child: BoxWord(
                      index: index,
                      child: Container(
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            value,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        color: defineColor(index),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.only(top: 0, left: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 6,
          ),
          itemCount: _correctWords.length,
          itemBuilder: (BuildContext context, int index) => Container(
            alignment: Alignment.topCenter,
            child: Text(
              _correctWords[index],
              style: TextStyle(
                  color: defineCorrectWordColor(index),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Visibility(
          visible: buttonVisibility,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              child: Text(
                "Jogar Novamente",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _clearGameData,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _detectTapedItem(PointerEvent event) {
    // Recupera o objeto renderizado
    dynamic box = key.currentContext!.findRenderObject();
    // Cria uma instancia da classe BoxHitTestResult para que seja possível fazer
    // o hitTeste e recuperar a posição do objeto
    final result = BoxHitTestResult();
    // Converte a posição global para a posição local na tela
    Offset local = box.globalToLocal(event.position);
    // Recupera o objeto renderizado baseado na sua localizado local
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        // Atribui o elemento clicado junto de suas propriedades na variavel
        final target = hit.target;
        // Verifica se o elemento atribuido é do tipo _BoxWord que é do tipo
        // SingleChildRenderObjectWidget e verifica se o array _selectedElements
        // contem o elemento
        if (target is _BoxWord && !_selectedElements.contains(target)) {
          _selectedElements.add(target);
          // Adiciona o index do elemento a variavel selectedIndexes
          _selectIndex(target.index);
          takeCharsToFormCorrectWord(target.index);
        }
      }
    }
  }

  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  void _clearSelection(PointerUpEvent event) {
    // Limpa o array de elementos _selectedElements
    _selectedElements.clear();
    // Limpa a palavra feita pelo movimento de deslize do usuário até o momento
    wordFormed = "";
    setState(() {
      // Limpa o array de indices selecionados
      selectedIndexes.clear();
    });
  }

  getRandomString(int length) {
    while (index < 36) {
      if (index % 6 == 0 && index != 0 && indexCorrectWord < _correctWords.length) {
        var word = _correctWords[indexCorrectWord].toString();
        int i = 0;
        while (i < word.length) {
          crossWordChars.add(word[i]);
          i++;
          index++;
        }
        indexCorrectWord++;
      } else {
        crossWordChars.add(String.fromCharCodes(Iterable.generate(length,
            (_) => _chars.codeUnitAt(_randomNumber.nextInt(_chars.length)))));
        index++;
      }
    }
    index = 0;
    indexCorrectWord = 0;
  }

  void takeCharsToFormCorrectWord(index) {
    wordFormed += crossWordChars[index].toString();
    if (_correctWords.contains(wordFormed)) {
      solvedIndexes.addAll(selectedIndexes);
      solvedWords.add(wordFormed);
    }
    if (solvedWords.length == _correctWords.length) buttonVisibility = true;
  }

  defineColor(int index) {
    if (solvedIndexes.contains(index)) {
      return Colors.green;
    } else if (selectedIndexes.contains(index)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  defineCorrectWordColor(int index) {
    if (solvedWords.contains(_correctWords[index])) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  _clearGameData() {
    setState(() {
      solvedIndexes.clear();
      solvedWords.clear();
      crossWordChars.clear();
      buttonVisibility = false;
    });
    getRandomString(1);
  }
}

class BoxWord extends SingleChildRenderObjectWidget {
  // Index do elemento
  final int index;

  BoxWord({Widget? child, this.index = 0, Key? key})
      : super(child: child, key: key);

  // Cria uma instancia do RenderObject que o indice do elemento renderizado
  // representa
  @override
  _BoxWord createRenderObject(BuildContext context) {
    // Atribui ao index de _BoxWord o index passado a BoxWord
    return _BoxWord()..index = index;
  }

  // Altera o indice de _BoxWord de acordo com o indice passado
  @override
  void updateRenderObject(BuildContext context, _BoxWord renderObject) {
    renderObject..index = index;
  }
}

// Uma instancia da classe RenderProxyBox que imita todas as propriedades
// de seu "child"
class _BoxWord extends RenderProxyBox {
  late int index;
}
