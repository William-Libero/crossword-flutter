import 'package:flutter/material.dart';
import 'package:crosswordflutter/models/boxWordRender.dart';

class BoxWord extends SingleChildRenderObjectWidget {
  // Index do elemento
  final int index;

  BoxWord({Widget? child, this.index = 0, Key? key})
      : super(child: child, key: key);

  // Cria uma instancia do RenderObject que o indice do elemento renderizado
  // representa
  @override
  BoxWordRender createRenderObject(BuildContext context) {
    // Atribui ao index de BoxWordRender o index passado a BoxWord
    return BoxWordRender()..index = index;
  }

  // Altera o indice de BoxWordRender de acordo com o indice passado
  @override
  void updateRenderObject(BuildContext context, BoxWordRender renderObject) {
    renderObject..index = index;
  }
}
