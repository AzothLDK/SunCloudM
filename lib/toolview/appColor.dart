import 'package:flutter/material.dart';

class ColorList {
  // 定义一个私有变量来存储颜色列表
  final List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('FF');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  List<String> lineColorList = [
    '#3D71FD',
    '#FBAF38',
    '#91CC75',
    '#EE6666',
    '#4ECCDF',
    '#8552a1',
    '#f23222',
    '#563624',
    '#f36c21',
    '#ea66a6',
    '#3D71FD',
    '#FBAF38',
    '#91CC75',
    '#EE6666',
    '#4ECCDF',
    '#8552a1',
    '#c7a252',
    '#563624',
    '#f36c21',
    '#ea66a6',
    '#3D71FD',
    '#FBAF38',
    '#91CC75',
    '#EE6666',
    '#4ECCDF',
    '#8552a1',
    '#c7a252',
    '#563624',
    '#f36c21',
    '#ea66a6',
    '#3D71FD',
    '#FBAF38',
    '#91CC75',
    '#EE6666',
    '#4ECCDF',
    '#8552a1',
    '#c7a252',
    '#563624',
    '#f36c21',
    '#ea66a6',
    '#3D71FD',
    '#FBAF38',
    '#91CC75',
    '#EE6666',
    '#4ECCDF',
    '#8552a1',
    '#c7a252',
    '#563624',
    '#f36c21',
    '#ea66a6',
    '#3D71FD',
    '#FBAF38',
    '#91CC75',
    '#EE6666',
    '#4ECCDF',
    '#8552a1',
    '#c7a252',
    '#563624',
    '#f36c21',
    '#ea66a6',
  ];

  // ignore: non_constant_identifier_names
  List<Color> SerColorList = [
    Color(0xFF3D71FD),
    Color(0xFFFBAF38),
    Color(0xFF91CC75),
    Color(0xFFEE6666),
    Color(0xFF4ECCDF),
    Color(0xFF8552a1),
    Color(0xFFf23222),
    Color(0xFF563624),
    Color(0xFFf36c21),
    Color(0xFFea66a6),
    Color(0xFF3D71FD),
    Color(0xFFFBAF38),
    Color(0xFF91CC75),
    Color(0xFFEE6666),
    Color(0xFF4ECCDF),
    Color(0xFF8552a1),
    Color(0xFFc7a252),
    Color(0xFF563624),
    Color(0xFFf36c21),
    Color(0xFFea66a6),
    Color(0xFF3D71FD),
    Color(0xFFFBAF38),
    Color(0xFF91CC75),
    Color(0xFFEE6666),
    Color(0xFF4ECCDF),
    Color(0xFF8552a1),
    Color(0xFFc7a252),
    Color(0xFF563624),
    Color(0xFFf36c21),
    Color(0xFFea66a6),
    Color(0xFF3D71FD),
    Color(0xFFFBAF38),
    Color(0xFF91CC75),
    Color(0xFFEE6666),
    Color(0xFF4ECCDF),
    Color(0xFF8552a1),
    Color(0xFFc7a252),
    Color(0xFF563624),
    Color(0xFFf36c21),
    Color(0xFFea66a6),
    Color(0xFF3D71FD),
    Color(0xFFFBAF38),
    Color(0xFF91CC75),
    Color(0xFFEE6666),
    Color(0xFF4ECCDF),
    Color(0xFF8552a1),
    Color(0xFFc7a252),
    Color(0xFF563624),
    Color(0xFFf36c21),
    Color(0xFFea66a6),
  ];

  // 提供一个方法供外部获取颜色列表
  List<Color> getColorList() {
    return colorList;
  }
}
