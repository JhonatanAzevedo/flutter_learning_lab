import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class HomeUsecase extends WidgetbookUseCase {
  HomeUsecase() : super(name: 'Learning DS', builder: _builder);

  static Widget _builder(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(height: 24),
            Text(
              'Learning DS',
            ),
            Text(
              'widgetbook library',
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
