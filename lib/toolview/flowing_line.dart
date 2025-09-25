import 'package:flutter/material.dart';

enum CurrentDirection {
  leftToRight,
  rightToLeft,
}

class HorizontaLine extends StatefulWidget {
  final double width;
  final double height;
  final Color lineColor;
  final Color currentColor;
  final CurrentDirection direction;
  final double currentSize;
  final Duration animationDuration;
  final int currentCount;
  final double amplitude;
  final double frequency;

  const HorizontaLine({
    Key? key,
    this.width = 200,
    this.height = 4,
    this.lineColor = Colors.grey,
    this.currentColor = Colors.yellow,
    this.direction = CurrentDirection.leftToRight,
    this.currentSize = 12,
    this.animationDuration = const Duration(seconds: 2),
    this.currentCount = 3,
    this.amplitude = 2.0,
    this.frequency = 0.1,
  }) : super(key: key);

  @override
  State<HorizontaLine> createState() => _CurrentLineState();
}

class _CurrentLineState extends State<HorizontaLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.direction == CurrentDirection.leftToRight ||
              widget.direction == CurrentDirection.rightToLeft
          ? widget.width
          : widget.height,
      height: widget.height,
      child: CustomPaint(
        painter: LinePainter(
          lineColor: widget.lineColor,
          direction: widget.direction,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: List.generate(widget.currentCount, (index) {
                final progress =
                    (_controller.value + index / widget.currentCount) % 1.0;
                return Positioned(
                  left: widget.direction == CurrentDirection.leftToRight
                      ? progress * widget.width - widget.currentSize / 2
                      : widget.direction == CurrentDirection.rightToLeft
                          ? (1 - progress) * widget.width -
                              widget.currentSize / 2
                          : null,
                  right: null,
                  top: null,
                  bottom: null,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      width: widget.currentSize,
                      height: widget.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            widget.currentColor.withOpacity(0),
                            widget.currentColor.withOpacity(0.8),
                            widget.currentColor,
                            widget.currentColor.withOpacity(0.8),
                            widget.currentColor.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Color lineColor;
  final CurrentDirection direction;

  LinePainter({
    required this.lineColor,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (direction == CurrentDirection.leftToRight ||
        direction == CurrentDirection.rightToLeft) {
      canvas.drawLine(Offset(0, size.height / 2),
          Offset(size.width, size.height / 2), paint);
    } else {
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
