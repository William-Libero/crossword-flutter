import 'package:flutter/material.dart';
import 'package:crosswordflutter/controllers/cross_word_controller.dart';
import 'package:get/get.dart';

class Timer extends StatelessWidget {
  final CrossWordController _crossWordController =
      Get.find<CrossWordController>();
  Timer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Text("Tempo: " + _crossWordController.duration)),
    );
  }
}
