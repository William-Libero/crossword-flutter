import 'package:get/get.dart';
import 'package:crosswordflutter/bindings/cross_word_binding.dart';
import 'package:crosswordflutter/modules/crossWord/views/cross_word_page.dart';
part './app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => CrossWordPage(),
      binding: CrossWordBinding(),
    ),
    GetPage(
      name: Routes.CROSSWORD,
      page: () => CrossWordPage(),
      binding: CrossWordBinding(),
    ),
  ];
}
