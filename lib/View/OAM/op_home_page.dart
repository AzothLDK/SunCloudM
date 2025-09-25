import 'package:flutter/material.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/generated/l10n.dart';

class OpHomePage extends StatefulWidget {
  const OpHomePage({super.key});

  @override
  State<OpHomePage> createState() => _OpHomePageState();
}

class _OpHomePageState extends State<OpHomePage> {
  int _selectedIndex = -1; // 初始化未选中任何按钮

  Map pageInfoData = {};

  @override
  void initState() {
    super.initState();
    getOplHomeInfo();
  }

  getOplHomeInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getOplHomeInfo(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        pageInfoData = data['data'];
        if (mounted) {
          setState(() {});
        }
      } else {}
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        getOplHomeInfo();
      });
    }
  }

  void navigateToPage(String status) async {
    await Routes.instance!.navigateTo(context, Routes.oplworklist, status);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/oamhomebg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
                child: SafeArea(
              child: Column(children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/homePersonIcon.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${pageInfoData['userName'] ?? '--'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              TextSpan(
                                  text:
                                      ' - ${pageInfoData['roleName'] ?? '--'}'),
                            ],
                          ),
                        ),
                        // 第二行所在运维团队浅绿色背景
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(5), // 设置内边距为 5
                          decoration: BoxDecoration(
                            color: const Color(0xFFAEE8D1),
                            borderRadius: BorderRadius.circular(8), // 设置圆角半径为 8
                          ),
                          child: Text(
                            "${pageInfoData['teamName'] ?? '--'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.home_work,
                              color: Color(0xFF48E299),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${pageInfoData['maintenanceCompanyName'] ?? '--'}",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${pageInfoData['monthPendingNumber'] ?? '--'}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              S.current.monthly_work_order,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${pageInfoData['workOrderMonthNumber'] ?? '--'}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              S.current.monthly_work_order_complete,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${pageInfoData['workOrderTimeoutNumber'] ?? '--'}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              S.current.monthly_work_order_timeout,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  // height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${pageInfoData['monthWorkingNumber'] ?? '--'}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              S.current.monthly_inspection_task,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${pageInfoData['inspectionMonthNumber'] ?? '--'}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              S.current.monthly_inspection_task_complete,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${pageInfoData['inspectionTimeoutNumber'] ?? '--'}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              S.current.monthly_inspection_task_timeout,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    navigateToPage('0');
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                height: 18,
                                child: VerticalDivider(
                                  thickness: 3,
                                  color: Colors.green,
                                ),
                              ),
                              Text(S.current.my_todo,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateToPage('1');
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "${pageInfoData['pendingNum'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF9C85FF),
                                                fontWeight: FontWeight.bold)),
                                        Text(S.current.pending,
                                            style: const TextStyle(
                                              color: Color(0xFF8693AB),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      navigateToPage('4');
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "${pageInfoData['returnedNum'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFFFFA94C),
                                                fontWeight: FontWeight.bold)),
                                        Text(S.current.confirming,
                                            style: const TextStyle(
                                              color: Color(0xFF8693AB),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateToPage('2');
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "${pageInfoData['suspendNum'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFFE68686),
                                                fontWeight: FontWeight.bold)),
                                        Text(S.current.returned,
                                            style: const TextStyle(
                                              color: Color(0xFF8693AB),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      navigateToPage('5');
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "${pageInfoData['completeNum'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF58D565),
                                                fontWeight: FontWeight.bold)),
                                        Text(S.current.completed,
                                            style: const TextStyle(
                                              color: Color(0xFF8693AB),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateToPage('3');
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "${pageInfoData['processingNum'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF1ED2A4),
                                                fontWeight: FontWeight.bold)),
                                        Text(S.current.received,
                                            style: const TextStyle(
                                              color: Color(0xFF8693AB),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      navigateToPage('6');
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "${pageInfoData['discardNum'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFFD8BCD5),
                                                fontWeight: FontWeight.bold)),
                                        Text(S.current.discarded,
                                            style: const TextStyle(
                                              color: Color(0xFF8693AB),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_inspection_task,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F8F9),
                            borderRadius:
                                BorderRadius.circular(10), // 设置圆角半径为 8
                          ),
                          child: Row(
                            children: [
                              const Image(image: AssetImage('assets/nbq.png')),
                              const SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.inspection_task,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const Text('---',
                                        style: TextStyle(
                                          color: Color(0xFF8693AB),
                                        )),
                                  ])
                            ],
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_shift,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F8F9),
                            borderRadius:
                                BorderRadius.circular(10), // 设置圆角半径为 8
                          ),
                          child: Row(
                            children: [
                              const Image(image: AssetImage('assets/nbq.png')),
                              const SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.shift_plan,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${S.current.monthly} ${pageInfoData['schedulingNum'] ?? '--'} ${S.current.shift_plan_num}',
                                        style: const TextStyle(
                                          color: Color(0xFF8693AB),
                                        )),
                                  ])
                            ],
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_station,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F8F9),
                            borderRadius:
                                BorderRadius.circular(10), // 设置圆角半径为 8
                          ),
                          child: Row(
                            children: [
                              const Image(image: AssetImage('assets/nbq.png')),
                              const SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.station_list,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${pageInfoData['itemNum'] ?? '--'} ${S.current.station_num}',
                                        style: const TextStyle(
                                          color: Color(0xFF8693AB),
                                        )),
                                  ])
                            ],
                          ),
                        )
                      ],
                    )),
              ]),
            )),
          ),
        ),
      ),
    );
  }
}
