import 'package:flutter/material.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/generated/l10n.dart';

class OplHomePage extends StatefulWidget {
  const OplHomePage({super.key});

  @override
  State<OplHomePage> createState() => _OplHomePageState();
}

class _OplHomePageState extends State<OplHomePage> {
  // 假设这是从 API 或其他地方获取的班组列表
  int _selectedIndex = -1; // 初始化未选中任何按钮

  Map pageInfoData = {};

  Future<dynamic>? _OplGroupListFuture;

  @override
  void initState() {
    super.initState();
    getOplHomeInfo();
    _OplGroupListFuture = getOplGroupList();
  }

  // getOplGroupList() async {
  //   Map<String, dynamic> params = {};
  //   var data = await IndexDao.getOplHomeInfo(params: params);
  //   if (data["code"] == 200) {
  //     if (data['data'] != null) {
  //       pageInfoData = data['data'];
  //       setState(() {});
  //     } else {}
  //   }
  // }

  Future<List> getOplGroupList() async {
    Map<String, dynamic> params = {};
    params['id'] = pageInfoData['userId'];
    var data = await IndexDao.getOplGroupList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      List dataList = data['data'];
      List groupList = [];
      groupList = dataList
          .map((item) => {'id': item['id'], 'teamName': item['teamName']})
          .toList();
      groupList.insert(0, {'id': '', 'teamName': S.current.all});
      return groupList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  getOplHomeInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getOplHomeInfo(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        pageInfoData = data['data'];
        setState(() {});
      } else {}
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      getOplHomeInfo();
    });
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
                // 新增内容开始
                Row(
                  children: [
                    // 左边头像
                    Image.asset(
                      'assets/homePersonIcon.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 第一行人名和运维团队负责人
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${pageInfoData['userName'] ?? '--'}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                              borderRadius:
                                  BorderRadius.circular(8), // 设置圆角半径为 8
                            ),
                            child: Text(
                              "${pageInfoData['teamName'] ?? '--'}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          // 第三行公司图标和公司名称
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                    future: _OplGroupListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return SizedBox(
                            height: 80,
                            child: Center(child: Text(S.current.no_data)));
                      } else if (snapshot.hasData) {
                        List groupList = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: groupList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 40, // 设置高度为 40  ,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  textStyle: const TextStyle(
                                    fontSize: 14, // 设置字体大小为 16
                                  ),
                                  backgroundColor: _selectedIndex == index
                                      ? const Color(0xFF24C18F)
                                      : Colors.white,
                                  foregroundColor: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20), // 设置 20 圆角
                                  ),
                                  minimumSize:
                                      const Size(80, 20), // 设置长条形和高度 40
                                ),
                                child: Text(groupList[index]['teamName']),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    }),
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
                            Text(S.current.monthly_work_order,
                                textAlign: TextAlign.center),
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
                            Text(S.current.monthly_work_order_complete,
                                textAlign: TextAlign.center),
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
                      )
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
                            Text(S.current.monthly_inspection_task,
                                textAlign: TextAlign.center),
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
                            Text(S.current.monthly_inspection_task_complete,
                                textAlign: TextAlign.center),
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
                            Text(S.current.monthly_inspection_task_timeout,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    // height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_todo,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${pageInfoData['thNum'] ?? '--'}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(S.current.pending_return_work_order,
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${pageInfoData['zgdNum'] ?? '--'}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(S.current.pending_transfer_work_order,
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
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
                              SizedBox(
                                height: 18,
                                child: VerticalDivider(
                                  thickness: 3,
                                  color: Colors.green,
                                ),
                              ),
                              Text(S.current.my_work_order,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              Spacer(),
                              Icon(
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
                                            style: TextStyle(
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
                                            style: TextStyle(
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
                                            style: TextStyle(
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
                                            style: TextStyle(
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
                                            style: TextStyle(
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
                                            style: TextStyle(
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
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_inspection_task,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Icon(
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
                              Image(image: AssetImage('assets/nbq.png')),
                              SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.inspection_task,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text('---',
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
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_shift,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Icon(
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
                              Image(image: AssetImage('assets/nbq.png')),
                              SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.shift_plan,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '本月有${pageInfoData['schedulingNum'] ?? '--'}条排班计划',
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
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text(S.current.my_station,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Icon(
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
                              Image(image: AssetImage('assets/nbq.png')),
                              SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.current.station_list,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${pageInfoData['itemNum'] ?? '--'}个电站',
                                        style: TextStyle(
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
