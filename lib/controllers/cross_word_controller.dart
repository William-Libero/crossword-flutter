import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:crosswordflutter/models/boxWord.dart';
import 'package:crosswordflutter/models/boxWordRender.dart';

class CrossWordController extends GetxController {
  String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  RxList<String> _correctWords = ["DOG", "CROSS", "WORD", "DARK"].obs;
  // List<String> _correctWords = ["DARK"];
  RxList<dynamic> solvedWords = [].obs;
  String wordFormed = "";
  List<String> wordDirections = ["horizontal", "vertical"];
  final RxBool _buttonVisibility = false.obs;
  // Variaveis usadas na função que popula o array com as letras que
  // aparecem no quadro de letras
  final Random _randomNumber = new Random();
  RxList crossWordChars = [].obs;
  int crossWordRows = 48;
  int index = 0;
  int indexCorrectWord = 0;
  int indexWordDirection = 0;
  //Variaveis usadas na função que verifica a posição do elemento renderizado
  final boxWord = new BoxWord();
  final RxSet<int> selectedIndexes = Set<int>().obs;
  final RxSet<int> solvedIndexes = Set<int>().obs;
  final key = GlobalKey();
  // Cria uma array de RenderProxyBox que salvara os elementos quando os mesmos
  //forem pressionados
  final RxSet<BoxWordRender> _selectedElements = Set<BoxWordRender>().obs;
  final RxString _duration = ''.obs;
  Timer? _timer;

  set duration(String value) => this._duration.value = value;
  String get duration => this._duration.value;

  set buttonVisibility(bool value) => this._buttonVisibility.value = value;
  bool get buttonVisibility => this._buttonVisibility.value;

  set correctWords(List<String> value) => this._correctWords.value = value;
  List<String> get correctWords => this._correctWords.value;

  @override
  void onInit() async {
    super.onInit();
    getRandomString(1);
    _startTimer();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      Duration timerTick = Duration(hours: 0, minutes: 0, seconds: timer.tick);
      duration =
          "${timerTick.inHours.remainder(60).toString().padLeft(2, "0")}:${timerTick.inMinutes.remainder(60).toString().padLeft(2, "0")}:${timerTick.inSeconds.remainder(60).toString().padLeft(2, "0")}";
    });
  }

  _showMyDialog(BuildContext context) {
    return showDialog<Widget>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'Parabéns!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Seu tempo de conclusão foi: ' + duration),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  "Jogar Novamente",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  clearGameData();
                  _startTimer();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  detectTapedItem(PointerEvent event, BuildContext context) {
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
        if (target is BoxWordRender && !_selectedElements.contains(target)) {
          _selectedElements.add(target);
          // Adiciona o index do elemento a variavel selectedIndexes
          _selectIndex(target.index);
          takeCharsToFormCorrectWord(target.index, context);
        }
      }
    }
  }

  _selectIndex(int index) {
    selectedIndexes.add(index);
  }

  void clearSelection(PointerUpEvent event) {
    // Limpa o array de elementos _selectedElements
    _selectedElements.clear();
    // Limpa a palavra feita pelo movimento de deslize do usuário até o momento
    wordFormed = "";
    // Limpa o array de indices selecionados
    selectedIndexes.clear();
  }

  getRandomString(int length) {
    _correctWords.shuffle();
    while (index < crossWordRows) {
      if (index % 6 == 0 &&
          index != 0 &&
          indexCorrectWord < _correctWords.length) {
        var word;
        indexCorrectWord % 2 == 0
            ? word = _correctWords[indexCorrectWord]
                .toString()
                .split('')
                .reversed
                .join()
            : word = _correctWords[indexCorrectWord].toString();
        int i = 0;
        while (i < word.length) {
          crossWordChars.add(word[i]);
          i++;
          index++;
        }
        indexCorrectWord++;
        // indexWordDirection++;
      } else if (index % 6 == 0 &&
          index != 0 &&
          indexCorrectWord < _correctWords.length) {
        var word;
        indexCorrectWord % 2 == 0
            ? word = _correctWords[indexCorrectWord]
                .toString()
                .split('')
                .reversed
                .join()
            : word = _correctWords[indexCorrectWord].toString();
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

  void takeCharsToFormCorrectWord(index, context) {
    wordFormed += crossWordChars[index].toString();
    if (_correctWords.contains(wordFormed)) {
      solvedIndexes.addAll(selectedIndexes);
      solvedWords.add(wordFormed);
    }
    if (solvedWords.length == _correctWords.length) {
      buttonVisibility = true;
      _timer!.cancel();
      _showMyDialog(context);
    }
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

  clearGameData() {
    solvedIndexes.clear();
    solvedWords.clear();
    selectedIndexes.clear();
    crossWordChars.clear();
    buttonVisibility = false;
    getRandomString(1);
  }
}
