import 'package:flutter/material.dart';
import 'package:learning_lab/learning_lab.dart';

class PinTheme {
  /// Colors of the input fields which have inputs.
  final Color activeColor;

  /// Color of the input field which is currently selected.
  final Color selectedColor;

  /// Colors of the input fields which don't have inputs.
  final Color inactiveColor;

  /// Color of the input field when in error mode.
  final Color errorBorderColor;

  /// Width of the input fields which have inputs.
  final double activeBorderWidth;

  /// Width of the input field which is currently selected.
  final double selectedBorderWidth;

  /// Width of the input fields which don't have inputs.
  final double inactiveBorderWidth;

  /// Width of the input field when in error mode.
  final double errorBorderWidth;

  /// [height] for the pin code field. default is [48.0]
  final double fieldHeight;

  /// [width] for the pin code field. default is [32.0]
  final double fieldWidth;

  /// Border width for the each input fields. Default is [1.0]
  final double borderWidth;

  /// Cursor animation duration
  final Duration? cursorAnimationDuration;

  const PinTheme.defaults({
    this.fieldHeight = 48,
    this.fieldWidth = 32,
    this.borderWidth = 1,
    this.activeColor = LearningColors.mediumSky,
    this.selectedColor = LearningColors.darkTurquoise,
    this.inactiveColor = LearningColors.mediumSky,
    this.errorBorderColor = LearningColors.ruby,
    this.activeBorderWidth = 1,
    this.selectedBorderWidth = 2,
    this.inactiveBorderWidth = 1,
    this.errorBorderWidth = 1,
    this.cursorAnimationDuration = const Duration(milliseconds: 1000),
  });

  factory PinTheme({
    Color? activeColor,
    Color? selectedColor,
    Color? inactiveColor,
    Color? disabledColor,
    Color? activeFillColor,
    Color? selectedFillColor,
    Color? inactiveFillColor,
    Color? errorBorderColor,
    BorderRadius? borderRadius,
    double? fieldHeight,
    double? fieldWidth,
    double? borderWidth,
    double? activeBorderWidth,
    double? selectedBorderWidth,
    double? inactiveBorderWidth,
    double? disabledBorderWidth,
    double? errorBorderWidth,
    EdgeInsetsGeometry? fieldOuterPadding,
    List<BoxShadow>? activeBoxShadow,
    List<BoxShadow>? inActiveBoxShadow,
    final Duration? cursorAnimationDuration,
  }) {
    const defaultValues = PinTheme.defaults();
    return PinTheme.defaults(
      cursorAnimationDuration:
          cursorAnimationDuration ?? defaultValues.cursorAnimationDuration,
      activeColor: activeColor ?? defaultValues.activeColor,
      borderWidth: borderWidth ?? defaultValues.borderWidth,
      fieldHeight: fieldHeight ?? defaultValues.fieldHeight,
      fieldWidth: fieldWidth ?? defaultValues.fieldWidth,
      inactiveColor: inactiveColor ?? defaultValues.inactiveColor,
      errorBorderColor: errorBorderColor ?? defaultValues.errorBorderColor,
      selectedColor: selectedColor ?? defaultValues.selectedColor,
      activeBorderWidth: activeBorderWidth ?? defaultValues.activeBorderWidth,
      inactiveBorderWidth:
          inactiveBorderWidth ?? defaultValues.inactiveBorderWidth,
      selectedBorderWidth:
          selectedBorderWidth ?? defaultValues.selectedBorderWidth,
      errorBorderWidth: errorBorderWidth ?? defaultValues.errorBorderWidth,
    );
  }
}