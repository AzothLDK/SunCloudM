import 'package:suncloudm/toolview/imports.dart';

class SeleteReportPage extends StatefulWidget {
  const SeleteReportPage({super.key});

  @override
  State<SeleteReportPage> createState() => _SeleteReportPageState();
}

class _SeleteReportPageState extends State<SeleteReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.report,
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
            // 电量报表选项卡片
            Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  Routes.instance!.navigateTo(context, Routes.dlreport);
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
                            Icons.bolt,
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
                                S.current.energy_report,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                S.current.energy_report_content,
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
                      const Icon(
                        Icons.chevron_right,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // 收益报表选项卡片
            Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  Routes.instance!.navigateTo(context, Routes.rewardreport);
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
                          color: const Color(0xFFFFF7E6), // 浅黄色背景
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.attach_money,
                            size: 24.0,
                            color: Color(0xFFFFA940), // 橙色图标
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
                                S.current.revenue_report,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                S.current.revenue_report_content,
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
                      const Icon(
                        Icons.chevron_right,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 如果需要恢复原来注释掉的选项，可以取消下面的注释
            // const SizedBox(height: 16.0),
            // // 其他报表选项...
          ],
        ),
      ),
    );
  }
}
