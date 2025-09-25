import 'package:suncloudm/toolview/imports.dart';

class SettlementseletePage extends StatefulWidget {
  const SettlementseletePage({super.key});

  @override
  State<SettlementseletePage> createState() => _SettlementseletePageState();
}

class _SettlementseletePageState extends State<SettlementseletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.settlement,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [],
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 结算单选项卡片
            Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  Routes.instance!.navigateTo(context, Routes.settlementlist);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 24.0),
                  child: Row(
                    children: [
                      // 图标部分
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xFFF0F5FF), // 浅蓝色背景
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.receipt_long,
                            size: 24.0,
                            color: Color(0xFF4080FF), // 蓝色图标
                          ),
                        ),
                      ),
                      // 中间文字部分
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.settlement,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                S.current.view_settlement_record,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 右侧箭头图标
                      Icon(
                        Icons.chevron_right,
                        size: 20.0,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 可以添加其他相关功能选项
            const SizedBox(height: 16.0),
            // 下面的代码是注释掉的部分，您可以根据需要恢复
            // Card(
            //   elevation: 3.0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            //   child: InkWell(
            //     borderRadius: BorderRadius.circular(12.0),
            //     onTap: () {
            //       Routes.instance!.navigateTo(context, Routes.settlementanalysis);
            //     },
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            //       child: Row(
            //         children: [
            //           Container(
            //             width: 48.0,
            //             height: 48.0,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(12.0),
            //               color: Color(0xFFF0FFF4), // 浅绿色背景
            //             ),
            //             child: Center(
            //               child: Icon(
            //                 Icons.bar_chart,
            //                 size: 24.0,
            //                 color: Color(0xFF36CFC9), // 青色图标
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: Container(
            //               margin: EdgeInsets.symmetric(horizontal: 16.0),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     '结算分析',
            //                     style: TextStyle(
            //                       fontSize: 18.0,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                   SizedBox(height: 4.0),
            //                   Text(
            //                     '查看结算数据统计与分析',
            //                     style: TextStyle(
            //                       fontSize: 14.0,
            //                       color: Colors.grey[500],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           Icon(
            //             Icons.chevron_right,
            //             size: 20.0,
            //             color: Colors.grey[400],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
