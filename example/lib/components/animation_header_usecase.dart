import 'package:flutter/material.dart';
import 'package:learning_lab/learning_lab.dart';
import 'package:widgetbook/widgetbook.dart';


class AnimationHeaderUsecase extends WidgetbookUseCase {
  AnimationHeaderUsecase() : super(name: 'Animation Header', builder: _builder);

  static Widget _builder(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AnimationHeaderPage()
      ),
    );
  }
}
