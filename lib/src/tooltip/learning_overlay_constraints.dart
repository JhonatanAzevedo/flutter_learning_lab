import 'package:flutter/rendering.dart';


class LearningOverlayConstraints extends BoxConstraints {
  const LearningOverlayConstraints({
    required this.shouldStrictlyUseFatherWidth,
    super.maxHeight,
    super.maxWidth,
    super.minHeight,
    super.minWidth,
  });

  LearningOverlayConstraints.fromBoxConstraints(
    BoxConstraints constraints, {
    required this.shouldStrictlyUseFatherWidth,
  }) : super(
    maxWidth: constraints.maxWidth,
    minWidth: constraints.minWidth,
    maxHeight: constraints.maxHeight,
    minHeight: constraints.minHeight
  );

  final bool shouldStrictlyUseFatherWidth;
}