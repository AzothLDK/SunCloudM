import 'package:flutter/material.dart';

class EleDetailReportPage extends StatefulWidget {
  const EleDetailReportPage({super.key});

  @override
  State<EleDetailReportPage> createState() => _EleDetailReportPageState();
}

class _EleDetailReportPageState extends State<EleDetailReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '报表明细',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: MediaQuery.of(context).size.width + 360,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/dlbb2.png'),
            )),
          ),
        ],
      ),
    );
  }
}
