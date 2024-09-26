import 'package:flutter/material.dart';
import 'package:learning_lab/learning_lab.dart';
import 'package:widgetbook/widgetbook.dart';

class TooltipUsecase extends WidgetbookUseCase {
  TooltipUsecase()
      : super(
          name: 'Tooltip',
          builder: _child,
        );

  static Widget _child(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _TooltipUsecase(
          tooltipTitle: context.knobs.string(
            label: 'Title',
            initialValue: 'This is a Title',
          ),
          description: context.knobs.string(
            label: 'Description',
            initialValue: "Here goes the body text of tooltip's information",
          ),
          highlighted: context.knobs.boolean(
            label: 'Is highlighted',
            initialValue: false,
          ),
          arrowPosition: context.knobs.list(
            label: 'Arrow position',
            options: ArrowPosition.values,
            initialOption: ArrowPosition.bottomRight,
          ),
          overlayPosition: context.knobs.list(
            label: 'Overlay Position',
            options: LearningOverlayPosition.values,
          ),
          overlayPadding: LearningOverlayPadding(
            vertical: context.knobs.int
                .input(
                  label: 'Overlay vertical adjustment',
                  description: 'Can be negative',
                  initialValue: 12,
                )
                .toDouble(),
            horizontal: context.knobs.int
                .input(
                  label: 'Overlay horizontal adjustment',
                  description: 'Can be negative',
                  initialValue: -12,
                )
                .toDouble(),
          ),
        ),
      ),
    );
  }
}

class _TooltipUsecase extends StatefulWidget {
  const _TooltipUsecase({
    required this.tooltipTitle,
    required this.description,
    required this.highlighted,
    required this.arrowPosition,
    required this.overlayPosition,
    required this.overlayPadding,
  });

  final String tooltipTitle;
  final String description;
  final bool highlighted;
  final ArrowPosition arrowPosition;
  final LearningOverlayPosition overlayPosition;
  final LearningOverlayPadding overlayPadding;

  @override
  State<_TooltipUsecase> createState() => _TooltipUsecaseState();
}

class _TooltipUsecaseState extends State<_TooltipUsecase> with LearningOverflowDelegate {
  late FocusNode internalFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LearningOverlayBuilder(
      delegate: this,
      focusNode: internalFocusNode,
      child: renderIcon(),
    );
  }

  Widget renderIcon() => GestureDetector(
        onTap: internalFocusNode.requestFocus,
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: overflowOpened ? LearningColors.lightSky : LearningColors.transparent,
          ),
          child: const Icon(
            Icons.more_vert,
            color: LearningColors.primary,
          ),
        ),
      );

  @override
  LearningOverlayConstraints getOverlayConstraints(BuildContext context) {
    return const LearningOverlayConstraints(
      shouldStrictlyUseFatherWidth: false,
      minHeight: 50,
      maxHeight: 400,
      minWidth: 50,
      maxWidth: 244,
    );
  }

  @override
  Widget overlayBuilder(BuildContext context) {
    return LearningOverlay.tooltip(
      title: widget.tooltipTitle,
      description: widget.description,
      isHighlighted: widget.highlighted,
      arrowPosition: widget.arrowPosition,
    );
  }

  @override
  LearningOverlayPosition get position => widget.overlayPosition;

  @override
  LearningOverlayPadding get padding => widget.overlayPadding;
}
