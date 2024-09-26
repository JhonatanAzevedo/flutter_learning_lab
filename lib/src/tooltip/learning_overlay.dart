import 'package:flutter/material.dart';
import 'package:learning_lab/src/tooltip/learning_overlay_painter.dart';
import 'package:learning_lab/src/utils/learning_colors.dart';
import 'package:learning_lab/src/utils/learning_spacing.dart';


class LearningOverlay extends StatelessWidget {
  const LearningOverlay._(
    this.title,
    this.description,
    this.arrowPosition,
    this.dataItems,
    this.isHighlighted,
    this.tooltipColor,
    bool isPopover,
    bool isData, {
    required this.padding,
    required this.titleStyle,
    String labelLink = '',
    String dismissLabelButton = '',
    String labelButton = '',
    VoidCallback? onTapLink,
    VoidCallback? onTapDismiss,
    VoidCallback? onTapButton,
    this.textStyle,
    super.key,
  })  : _onTapDismiss = onTapDismiss,
        _dismissLabelButton = dismissLabelButton,
        _onTapButton = onTapButton,
        _labelButton = labelButton,
        _isData = isData;

  factory LearningOverlay.tooltipData({
    String title = '',
    required List<DataItem> dataItems,
    ArrowPosition arrowPosition = ArrowPosition.bottomCenter,
    EdgeInsets padding = const EdgeInsets.all(LearningSpacing.s02),
    TextStyle? textStyle,
    TextStyle? titleStyle,
    Key? key,
  }) =>
      LearningOverlay._(
        title,
        '',
        arrowPosition,
        dataItems,
        false,
        LearningColors.darkGrey,
        false,
        true,
        padding: padding,
        textStyle: textStyle,
        titleStyle: titleStyle,
        key: key,
      );

  factory LearningOverlay.tooltip({
    String title = '',
    required String description,
    bool isHighlighted = false,
    ArrowPosition arrowPosition = ArrowPosition.bottomCenter,
    Color backgroundColor = Colors.white,
    EdgeInsets padding = const EdgeInsets.all(LearningSpacing.s04),
    TextStyle? textStyle,
    TextStyle? titleStyle,
    Key? key,
  }) =>
      LearningOverlay._(
        title,
        description,
        arrowPosition,
        const [],
        isHighlighted,
        backgroundColor,
        false,
        false,
        padding: padding,
        textStyle: textStyle,
        titleStyle: titleStyle,
        key: key,
      );

  factory LearningOverlay.popover({
    String title = '',
    required String description,
    ArrowPosition arrowPosition = ArrowPosition.topLeft,
    String labelLink = '',
    String dismissLabelButton = '',
    String labelButton = '',
    VoidCallback? onTapLink,
    VoidCallback? onTapDismiss,
    VoidCallback? onTapButton,
    bool isHighlighted = false,
    EdgeInsets padding = const EdgeInsets.all(LearningSpacing.s04),
    TextStyle? textStyle,
    TextStyle? titleStyle,
    Key? key,
  }) =>
      LearningOverlay._(
        title,
        description,
        arrowPosition,
        const [],
        isHighlighted,
        LearningColors.white,
        true,
        false,
        labelLink: labelLink,
        dismissLabelButton: dismissLabelButton,
        onTapLink: onTapLink,
        onTapDismiss: onTapDismiss,
        labelButton: labelButton,
        onTapButton: onTapButton,
        padding: padding,
        textStyle: textStyle,
        titleStyle: titleStyle,
        key: key,
      );

  final String title;
  final String description;
  final ArrowPosition arrowPosition;
  final String _dismissLabelButton;
  final String _labelButton;
  final VoidCallback? _onTapDismiss;
  final VoidCallback? _onTapButton;
  final bool _isData;
  final List<DataItem> dataItems;
  final bool isHighlighted;
  final Color tooltipColor;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF474747).withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: const Color(0xFF474747).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: _buildCustomPaint(),
    );
  }

  List<Widget> _buildDataList() {
    return List.generate(dataItems.length, (index) {
      final DataItem dataItem = dataItems[index];
      return _buildData(dataItem, dataItems.length - 1 == index);
    });
  }

  Widget _buildData(DataItem item, bool isLast) {
    return Padding(
      padding: isLast ? EdgeInsets.zero : const EdgeInsets.only(bottom: LearningSpacing.s02),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.isIndicator)
            Padding(
              padding: const EdgeInsets.only(right: LearningSpacing.s01),
              child: SizedBox(
                height: 8,
                width: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.indicatorColor,
                  ),
                ),
              ),
            ),
          item.label,
          const SizedBox(width: LearningSpacing.s02),
        ],
      ),
    );
  }

  Widget _buildCustomPaint() => CustomPaint(
        painter: LearningOverlayPainter(_backgroundColor, arrowPosition),
        child: Container(
          padding: padding,
          margin: _isMargin ? const EdgeInsets.only(bottom: 10) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title.isNotEmpty) _buildTitle(),
              if (_isData) ..._buildDataList(),
              _buildDescription(),
              _buildButtonList(),
            ],
          ),
        ),
      );

  double get spacing => _isData ? LearningSpacing.s02 : LearningSpacing.s04;

  Widget _buildTitle() => Padding(
        padding: const EdgeInsets.only(bottom: LearningSpacing.s02),
        child: Text(
          title,
        ),
      );

  Widget _buildDescription() => _isData
      ? const Offstage()
      : Text(
          description,
        );

  Widget _buildButtonList() => Padding(
        padding: const EdgeInsets.only(
          top: LearningSpacing.s02,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: ElevatedButton(
                onPressed: _onTapButton,
                child: Text(_labelButton),
              ),
            ),
            const SizedBox(width: LearningSpacing.s04),
            TextButton(
              onPressed: _onTapDismiss,
              child: Text(_dismissLabelButton),
            )
          ],
        ),
      );

  Color get _backgroundColor => _isData
      ? LearningColors.darkGrey
      : isHighlighted
          ? LearningColors.lighterSky
          : tooltipColor;

  bool get _isMargin =>
      arrowPosition == ArrowPosition.bottomCenter ||
      arrowPosition == ArrowPosition.bottomLeft ||
      arrowPosition == ArrowPosition.bottomRight;
}

enum ArrowPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  none,
}

class DataItem {
  final Widget label;
  final Color indicatorColor;
  final bool isIndicator;

  DataItem({
    required this.label,
    this.indicatorColor = LearningColors.blue,
    this.isIndicator = true,
  });
}
