import 'package:get/get.dart';
import 'package:crosswordflutter/controllers/cross_word_controller.dart';

class CrossWordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrossWordController>(() => CrossWordController());
  }
}
