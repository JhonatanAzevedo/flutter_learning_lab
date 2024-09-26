import 'package:flutter/material.dart';
import 'package:learning_lab/learning_lab.dart';

class LearningOverlayBuilder extends StatefulWidget {
  const LearningOverlayBuilder({
    required this.delegate,
    required this.child,
    this.focusNode,
    this.controller,
    this.scrollController,
    super.key,
  });

  final LearningOverflowDelegate delegate;
  final Widget child;
  final FocusNode? focusNode;
  final OverlayPortalController? controller;
  final ScrollController? scrollController;

  @override
  State<LearningOverlayBuilder> createState() => _LearningOverlayBuilderState();
}

class _LearningOverlayBuilderState extends State<LearningOverlayBuilder> {
  FocusNode? _internalFocusNode;
  OverlayPortalController? _internalController;
  late FocusNode overlayFocusNode;

  FocusNode get effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  OverlayPortalController get effectiveController =>
      widget.controller ?? (_internalController ??= OverlayPortalController());

  @override
  void initState() {
    overlayFocusNode = FocusNode();

    if (widget.scrollController != null) {
      widget.scrollController?.addListener((listenerToScroll));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: effectiveFocusNode,
      onFocusChange: (bool gained) {
        if (gained) {
          if (!effectiveController.isShowing) effectiveController.show();
        } else {
          effectiveController.hide();
        }

        widget.delegate.onOverlayUpdated(gained);
      },
      child: TapRegion(
        groupId: widget.key,
        onTapInside: (_) {
          effectiveFocusNode.requestFocus();
        },
        child: OverlayPortal(
          controller: effectiveController,
          overlayChildBuilder: (BuildContext context) => TapRegion(
            onTapOutside: (_) => effectiveFocusNode.unfocus(),
            groupId: widget.key,
            child: getOverflow(context),
          ),
          child: widget.child,
        ),
      ),
    );
  }

  Widget getOverflow(BuildContext overflowContext) {
    if (!effectiveFocusNode.hasFocus) {
      effectiveFocusNode.requestFocus();
    }

    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(Offset.zero,
            ancestor: Navigator.of(context).context.findRenderObject()) &
        itemBox.size;

    final keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom;

    return _OverflowPage(
      overlayConstraints: widget.delegate.getOverlayConstraints(context),
      buttonRect: itemRect,
      parentFocusNode: effectiveFocusNode,
      overflowFocusNode: overlayFocusNode,
      keyboardHeight: keyboardHeight,
      position: widget.delegate.position,
      overlayPadding: widget.delegate.padding,
      onOverlayPositionChanged: widget.delegate.onOverlayPositionChanged,
      child: widget.delegate.overlayBuilder(overflowContext),
    );
  }

  void listenerToScroll() {
    effectiveFocusNode.unfocus();
  }

  void _removeOverflowRoute() {
    if (effectiveController.isShowing) {
      effectiveController.hide();
    }
    effectiveFocusNode.unfocus();
  }

  @override
  void dispose() {
    _removeOverflowRoute();
    _internalFocusNode?.dispose();
    _internalFocusNode = null;

    if (widget.scrollController != null) {
      widget.scrollController?.removeListener(listenerToScroll);
    }

    super.dispose();
  }
}

class _OverflowBoxRouteLayout extends SingleChildLayoutDelegate {
  const _OverflowBoxRouteLayout({
    required this.buttonRect,
    required this.keyboardHeight,
    required this.overlayConstraints,
    required this.overlayPadding,
    required this.position,
    required this.scrollPosition,
    required this.mediaQueryData,
    required this.onOverlayPositionChanged,
  });

  final Rect buttonRect;
  final double keyboardHeight;
  final LearningOverlayConstraints overlayConstraints;
  final LearningOverlayPosition position;
  final LearningOverlayPadding overlayPadding;
  final ScrollPosition? scrollPosition;
  final MediaQueryData mediaQueryData;
  final ValueChanged<LearningOverlayPosition> onOverlayPositionChanged;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    if (!overlayConstraints.shouldStrictlyUseFatherWidth) {
      return overlayConstraints;
    }

    return overlayConstraints.copyWith(
      maxWidth: buttonRect.width,
      minWidth: buttonRect.width,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    LearningOverlayPosition effectivePosition = position;

    final heightRequiredToFullyShowChild =
        (buttonRect.bottom + childSize.height + overlayPadding.vertical);

    final totalSizeOfScrollable = mediaQueryData.size.height +
        (scrollPosition?.maxScrollExtent ?? 0.0) -
        (scrollPosition?.pixels ?? 0.0);

    final screenHeightEnough = totalSizeOfScrollable > heightRequiredToFullyShowChild;

    if (!screenHeightEnough) {
      effectivePosition = effectivePosition.invert;
      onOverlayPositionChanged(effectivePosition);
    }

    final (double x, double y) rawOffset = switch (effectivePosition) {
      LearningOverlayPosition.topToLeft => (
          overlayPadding.applyHorizontal(buttonRect.right - childSize.width),
          buttonRect.top - childSize.height - overlayPadding.vertical,
        ),
      LearningOverlayPosition.topToRight => (
          overlayPadding.applyHorizontal(buttonRect.left),
          buttonRect.top - childSize.height - overlayPadding.vertical,
        ),
      LearningOverlayPosition.topCenter => (
          overlayPadding.applyHorizontal(buttonRect.center.dx - (childSize.width / 2)),
          buttonRect.top - childSize.height - overlayPadding.vertical,
        ),
      LearningOverlayPosition.bottomToLeft => (
          overlayPadding.applyHorizontal(buttonRect.right - childSize.width),
          buttonRect.bottom + overlayPadding.vertical,
        ),
      LearningOverlayPosition.bottomToRight => (
          overlayPadding.applyHorizontal(buttonRect.left),
          buttonRect.bottom + overlayPadding.vertical,
        ),
      LearningOverlayPosition.bottomCenter => (
          overlayPadding.applyHorizontal(buttonRect.center.dx - (childSize.width / 2)),
          buttonRect.bottom + overlayPadding.vertical,
        ),
      LearningOverlayPosition.leftCenter => (
          overlayPadding.applyHorizontal(buttonRect.left - childSize.width),
          (buttonRect.center.dy) - (childSize.height / 2)
        ),
      LearningOverlayPosition.rightCenter => (
          overlayPadding.applyHorizontal(buttonRect.right),
          (buttonRect.center.dy) - (childSize.height / 2)
        )
    };

    return Offset(rawOffset.$1, rawOffset.$2 - keyboardHeight);
  }

  @override
  bool shouldRelayout(covariant _OverflowBoxRouteLayout oldDelegate) {
    return oldDelegate.keyboardHeight != keyboardHeight ||
        oldDelegate.buttonRect != buttonRect ||
        oldDelegate.overlayConstraints != overlayConstraints;
  }
}

class _OverflowPage extends StatefulWidget {
  const _OverflowPage({
    required this.parentFocusNode,
    required this.overflowFocusNode,
    required this.buttonRect,
    required this.keyboardHeight,
    required this.child,
    required this.overlayConstraints,
    required this.overlayPadding,
    required this.position,
    required this.onOverlayPositionChanged,
  });

  final FocusNode parentFocusNode;
  final FocusNode overflowFocusNode;
  final Rect buttonRect;
  final double keyboardHeight;
  final LearningOverlayConstraints overlayConstraints;
  final Widget child;
  final LearningOverlayPadding overlayPadding;
  final LearningOverlayPosition position;
  final ValueChanged<LearningOverlayPosition> onOverlayPositionChanged;

  @override
  State<_OverflowPage> createState() => _OverflowPageState();
}

class _OverflowPageState extends State<_OverflowPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _OverflowBoxRouteLayout(
            overlayConstraints: widget.overlayConstraints,
            buttonRect: widget.buttonRect,
            keyboardHeight: widget.keyboardHeight,
            overlayPadding: widget.overlayPadding,
            position: widget.position,
            scrollPosition: Scrollable.maybeOf(context)?.position,
            mediaQueryData: MediaQuery.of(context),
            onOverlayPositionChanged: widget.onOverlayPositionChanged,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
