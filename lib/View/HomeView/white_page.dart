import 'package:flutter/material.dart';
import 'package:suncloudm/toolview/flowing_line.dart';

class WhitePage extends StatefulWidget {
  const WhitePage({super.key});

  @override
  State<WhitePage> createState() => _WhitePageState();
}

class _WhitePageState extends State<WhitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '--',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [],
          // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: HorizontaLine(
          direction: CurrentDirection.leftToRight,
          lineColor: Colors.grey[800]!,
          currentColor: Color(0xFF24C18F),
          currentCount: 4,
          animationDuration: Duration(seconds: 3),
        ));
  }
}
