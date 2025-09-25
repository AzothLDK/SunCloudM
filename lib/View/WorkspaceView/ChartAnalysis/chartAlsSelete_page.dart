import 'package:flutter/material.dart';
import '../../../routes/Routes.dart';
import '../../../toolview/custom_view.dart';

class ChartAlsSeletePage extends StatefulWidget {
  const ChartAlsSeletePage({super.key});

  @override
  State<ChartAlsSeletePage> createState() => _ChartAlsSeletePageState();
}

class _ChartAlsSeletePageState extends State<ChartAlsSeletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '曲线分析',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [],
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: Column(
        children: [
          CommonButton.build(context: context, text: '企业用电曲线', imageAssetPath: 'assets/qyydqx.png', routeName: Routes.chartAlsPage),
          const SizedBox(height: 10),
          CommonButton.build(context: context, text: '组串历史曲线', imageAssetPath: 'assets/zclsqx.png', routeName: Routes.chartAlsZPage),
          const SizedBox(height: 10),
          CommonButton.build(context: context, text: '电网功率因数曲线', imageAssetPath: 'assets/dwglysqx.png', routeName: Routes.chartAlsWPage),
        ],
      ),
    );
  }
}
