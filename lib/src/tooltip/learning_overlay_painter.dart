import 'package:flutter/widgets.dart';
import 'package:learning_lab/src/tooltip/learning_overlay.dart';
import 'package:learning_lab/src/utils/learning_colors.dart';


class LearningOverlayPainter extends CustomPainter {
  final Color _backgroundColor;
  final ArrowPosition arrowPosition;

  LearningOverlayPainter(this._backgroundColor, this.arrowPosition);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = _backgroundColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = LearningColors.lightSky
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Path path = Path();
    const double arrowBase = 20.0;
    const double arrowHeight = 10.0;
    const double radius = 4.0;
    const double edgeDistance = 16.0;

    switch (arrowPosition) {
      case ArrowPosition.none:
        path.moveTo(radius, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height - radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);
        break;
      case ArrowPosition.topLeft:
        path.moveTo(radius, 0);
        path.lineTo(edgeDistance, 0);
        path.lineTo(edgeDistance + arrowBase / 2, -arrowHeight);
        path.lineTo(edgeDistance + arrowBase, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height - radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);
        break;
      case ArrowPosition.topCenter:
        path.moveTo(radius, 0);
        path.lineTo(size.width / 2 - arrowBase / 2, 0);
        path.lineTo(size.width / 2, -arrowHeight);
        path.lineTo(size.width / 2 + arrowBase / 2, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height - radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);
        break;
      case ArrowPosition.topRight:
        path.moveTo(radius, 0);
        path.lineTo(size.width - radius - edgeDistance - arrowBase, 0);
        path.lineTo(
            size.width - radius - edgeDistance - arrowBase / 2, -arrowHeight);
        path.lineTo(size.width - radius - edgeDistance, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height - radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);
        break;
      case ArrowPosition.bottomLeft:
        path.moveTo(radius, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius - arrowHeight);
        path.arcToPoint(Offset(size.width - radius, size.height - arrowHeight),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(edgeDistance + arrowBase, size.height - arrowHeight);
        path.lineTo(edgeDistance + arrowBase / 2, size.height);
        path.lineTo(edgeDistance, size.height - arrowHeight);
        path.lineTo(radius, size.height - arrowHeight);
        path.arcToPoint(Offset(0, size.height - radius - arrowHeight),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);
        break;
      case ArrowPosition.bottomCenter:
        path.moveTo(radius, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius - arrowHeight);
        path.arcToPoint(Offset(size.width - radius, size.height - arrowHeight),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width / 2 + arrowBase / 2, size.height - arrowHeight);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width / 2 - arrowBase / 2, size.height - arrowHeight);
        path.lineTo(radius, size.height - arrowHeight);
        path.arcToPoint(Offset(0, size.height - radius - arrowHeight),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);
        break;
      case ArrowPosition.bottomRight:
        path.moveTo(radius, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(size.width, size.height - radius - arrowHeight);
        path.arcToPoint(Offset(size.width - radius, size.height - arrowHeight),
            radius: const Radius.circular(radius), clockwise: true);

        path.lineTo(size.width - edgeDistance - arrowBase / 10,
            size.height - arrowHeight);
        path.lineTo(size.width - edgeDistance - arrowBase / 1.7, size.height);
        path.lineTo(
          size.width - edgeDistance - arrowBase * 1.2,
          size.height - arrowHeight,
        );

        path.lineTo(radius, size.height - arrowHeight);
        path.arcToPoint(Offset(0, size.height - radius - arrowHeight),
            radius: const Radius.circular(radius), clockwise: true);
        path.lineTo(0, radius);
        path.arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius), clockwise: true);

        break;
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}