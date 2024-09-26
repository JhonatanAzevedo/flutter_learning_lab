enum LearningOverlayPosition {
  topToLeft,
  topToRight,
  topCenter,
  leftCenter,
  rightCenter,
  bottomToLeft,
  bottomToRight,
  bottomCenter;

  LearningOverlayPosition get invert => switch (this) {
        LearningOverlayPosition.topToLeft => LearningOverlayPosition.bottomToLeft,
        _ => LearningOverlayPosition.topToLeft
      };

  bool get isHorizontal =>
      [LearningOverlayPosition.leftCenter, LearningOverlayPosition.rightCenter].contains(this);
}
