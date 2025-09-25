import 'package:flutter/material.dart';
class SettlementanalysisPage extends StatefulWidget {
  const SettlementanalysisPage({super.key});

  @override
  State<SettlementanalysisPage> createState() => _SettlementanalysisPageState();
}

class _SettlementanalysisPageState extends State<SettlementanalysisPage> {

  int type = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            '结算分析',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,// 移除AppBar的阴影
          centerTitle: true,
        ),
          body: const Center(child: Text('页面开发中!',style: TextStyle(fontSize: 20)))
        // body: ListView(
        //   scrollDirection: Axis.horizontal,
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width+360,
        //       decoration: const BoxDecoration(
        //           image: DecorationImage(
        //             image: AssetImage('assets/jsd2.png'),
        //           )),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
