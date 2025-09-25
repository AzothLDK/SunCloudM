import 'package:suncloudm/toolview/imports.dart';

typedef ImgBtnFunc = void Function(String);

class ImageButton extends StatelessWidget {
  double? width;
  double? height;
  double? iconSize;
  Color? iconColor;

  String assetPath;
  String text;

  TextStyle? textStyle;
  ImgBtnFunc func;

  ImageButton(this.assetPath,
      {this.width,
      this.height,
      this.iconSize,
      required this.text,
      this.textStyle,
      required this.func});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(text),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(assetPath),
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child:
                    Text(text, style: textStyle, textAlign: TextAlign.center),
              )
            ]),
      ),
    );
  }
}

class ImageTextCell extends StatelessWidget {
  String assetPath;
  String title;
  String subtitle;

  ImageTextCell(this.assetPath, this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 70,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage(assetPath),
//              width: iconSize,
//              height: iconSize,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Text(subtitle, style: TextStyle(fontSize: 14,color: Colors.grey[700]))
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey)
          ],
        ));
  }
}

class CommonButton {
  static Widget build({
    required BuildContext context,
    required String text,
    required String imageAssetPath,
    required String routeName,
    String? num,
    EdgeInsetsGeometry? padding,
    double? height,
    double? fontSize,
    double? iconSize,
  }) {
    return InkWell(
      onTap: () {
        if ((GlobalStorage.getSingleId()) != null) {
          Routes.instance!.navigateTo(
              context, routeName, (GlobalStorage.getSingleId()).toString());
        } else {
          Routes.instance!.navigateTo(context, routeName);
        }
      },
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: height ?? 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image(image: AssetImage(imageAssetPath)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: fontSize ?? 16),
                  ),
                ),
              ),
              if (num != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    num,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(
                width: 8,
              ),
              Icon(Icons.arrow_forward_ios, size: iconSize ?? 14),
            ],
          ),
        ),
      ),
    );
  }
}

getTextColor(int? itemType) {
  if (itemType == 1) {
    return Container(
        width: 50,
        height: 15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFEEEEFD)),
        child: Text(S.current.mg,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Color(0xFF545DE9))));
  } else if (itemType == 2) {
    return Container(
        width: 50,
        height: 15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFE9F9F4)),
        child: Text(S.current.ess,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Color(0xFF24C18F))));
  } else if (itemType == 3) {
    return Container(
        width: 50,
        height: 15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFFFF2E6)),
        child: Text(S.current.pv,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Color(0xFFFB8209))));
  } else if (itemType == 4) {
    return Container(
        width: 60,
        height: 15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFEAF2FD)),
        child: Text(S.current.charge,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Color(0xFF327DEE))));
  } else {
    return const SizedBox(
      width: 50,
      height: 15,
    );
  }
}

class TextTile extends StatelessWidget {
  final String title;

  const TextTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}

enum CurrentXDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

Widget addImageVideoBtn(String btnTitle, Color bgColor) {
  return Container(
    width: 70,
    height: 70,
    // padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(10)),
    child: Image(
      image: AssetImage(
        'assets/takephoto.png'
        '',
      ),
      fit: BoxFit.fill,
    ),
  );
}

class CurrentLine extends StatefulWidget {
  final double width;
  final double height;
  final Color lineColor;
  final Color currentColor;
  final CurrentXDirection direction;
  final double currentSize;
  final Duration animationDuration;
  final int currentCount;
  final double amplitude;
  final double frequency;

  const CurrentLine({
    Key? key,
    this.width = 4,
    this.height = 200,
    this.lineColor = Colors.grey,
    this.currentColor = Colors.yellow,
    this.direction = CurrentXDirection.topToBottom,
    this.currentSize = 12,
    this.animationDuration = const Duration(seconds: 2),
    this.currentCount = 3,
    this.amplitude = 2.0,
    this.frequency = 0.1,
  }) : super(key: key);

  @override
  State<CurrentLine> createState() => _CurrentLineState();
}

class _CurrentLineState extends State<CurrentLine>
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
      width: widget.direction.isHorizontal ? widget.width : widget.height,
      height: widget.direction.isHorizontal ? widget.height : widget.width,
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

                // 根据方向计算流动点位置
                Widget currentWidget = Container(
                  width: widget.direction.isHorizontal
                      ? widget.currentSize
                      : widget.width,
                  height: widget.direction.isHorizontal
                      ? widget.height
                      : widget.currentSize,
                  decoration: BoxDecoration(
                    gradient: widget.direction.isHorizontal
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              widget.currentColor.withOpacity(0),
                              widget.currentColor.withOpacity(0.8),
                              widget.currentColor,
                              widget.currentColor.withOpacity(0.8),
                              widget.currentColor.withOpacity(0),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.currentColor.withOpacity(0),
                              widget.currentColor.withOpacity(0.8),
                              widget.currentColor,
                              widget.currentColor.withOpacity(0.8),
                              widget.currentColor.withOpacity(0),
                            ],
                          ),
                  ),
                );

                // 根据方向设置流动点位置
                if (widget.direction.isHorizontal) {
                  return Positioned(
                    left: widget.direction == CurrentXDirection.leftToRight
                        ? progress *
                                (widget.direction.isHorizontal
                                    ? widget.width
                                    : widget.height) -
                            widget.currentSize / 2
                        : (1 - progress) *
                                (widget.direction.isHorizontal
                                    ? widget.width
                                    : widget.height) -
                            widget.currentSize / 2,
                    child: currentWidget,
                  );
                } else {
                  return Positioned(
                    top: widget.direction == CurrentXDirection.topToBottom
                        ? progress *
                                (widget.direction.isHorizontal
                                    ? widget.height
                                    : widget.width) -
                            widget.currentSize / 2
                        : (1 - progress) *
                                (widget.direction.isHorizontal
                                    ? widget.height
                                    : widget.width) -
                            widget.currentSize / 2,
                    child: currentWidget,
                  );
                }
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
  final CurrentXDirection direction;

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

    if (direction.isHorizontal) {
      canvas.drawLine(Offset(0, size.height / 2),
          Offset(size.width, size.height / 2), paint);
    } else {
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.direction != direction;
  }
}

// 扩展枚举添加方向判断方法
extension DirectionExtension on CurrentXDirection {
  bool get isHorizontal =>
      this == CurrentXDirection.leftToRight ||
      this == CurrentXDirection.rightToLeft;

  bool get isVertical =>
      this == CurrentXDirection.topToBottom ||
      this == CurrentXDirection.bottomToTop;
}
