import 'package:crosswordflutter/models/boxWord.dart';
import 'package:flutter/material.dart';
import 'package:crosswordflutter/controllers/cross_word_controller.dart';
import 'package:get/get.dart';

class LetterTiles extends StatelessWidget {
  final CrossWordController _crossWordController =
      Get.find<CrossWordController>();
  LetterTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GridView.builder(
        key: _crossWordController.key,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 6,
        ),
        itemCount: _crossWordController.crossWordRows,
        itemBuilder: (context, index) {
          return Obx(
            () => ValueListenableBuilder(
              valueListenable: ValueNotifier(
                  _crossWordController.crossWordChars[index].toString()),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Listener(
                  onPointerDown: (e) =>
                      _crossWordController.detectTapedItem(e, context),
                  onPointerMove: (e) =>
                      _crossWordController.detectTapedItem(e, context),
                  onPointerUp: _crossWordController.clearSelection,
                  child: BoxWord(
                    index: index,
                    child: Obx(
                      () => Container(
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
                        color: _crossWordController.defineColor(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
