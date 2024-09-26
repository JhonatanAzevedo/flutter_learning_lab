import 'package:flutter/cupertino.dart';
import 'package:learning_lab/learning_lab.dart';

mixin LearningOverflowDelegate<T extends StatefulWidget> on State<T> {
  bool get overflowOpened => _overflowOpened;

  bool _overflowOpened = false;

  Widget overlayBuilder(BuildContext context);

  LearningOverlayConstraints getOverlayConstraints(BuildContext context);

  LearningOverlayPosition get position;

  LearningOverlayPadding get padding;

  void onOverlayPositionChanged(LearningOverlayPosition newPosition) {}

  @mustCallSuper
  void onOverlayUpdated(bool isOpen) {
    setState(() {
      _overflowOpened = isOpen;
    });
  }
}
