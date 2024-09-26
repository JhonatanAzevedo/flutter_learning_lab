import 'package:flutter/cupertino.dart';


@immutable
class LearningOverlayPadding {
  const LearningOverlayPadding({
    required this.horizontal,
    required this.vertical,
  });

  const LearningOverlayPadding.zero() : horizontal = 0, vertical = 0;

  final double horizontal;
  final double vertical;

  double applyHorizontal(double value) {
    if(horizontal.isNegative) {
      return value - horizontal;
    } else {
      return value + horizontal;
    }
  }
}