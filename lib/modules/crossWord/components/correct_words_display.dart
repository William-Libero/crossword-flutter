import 'package:flutter/material.dart';
import 'package:crosswordflutter/controllers/cross_word_controller.dart';
import 'package:get/get.dart';

class CorrectWordsDisplay extends StatelessWidget {
  final CrossWordController _crossWordController =
      Get.find<CrossWordController>();
  CorrectWordsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 15,
        child: GridView.builder(
          shrinkWrap: true,
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossWordController.correctWords.length,
          ),
          itemCount: _crossWordController.correctWords.length,
          itemBuilder: (BuildContext context, int index) => Container(
            alignment: Alignment.topCenter,
            child: Obx(
              () => Text(
                _crossWordController.correctWords[index],
                style: TextStyle(
                    color: _crossWordController.defineCorrectWordColor(index),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
