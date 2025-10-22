import 'dart:convert';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:suncloudm/View/HomeView/OldHomeView/photovoltaicview_page.dart';
import 'package:suncloudm/View/HomeView/OldHomeView/storageview_page.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/toolview/language_resource.dart';
import '../../../dao/storage.dart';
import '../../../utils/screentool.dart';
import '../overview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController mController;

  List<String> _tabs = [];
  Map userInfo = jsonDecode(
      GlobalStorage.getLoginInfo()!); //"项目类型 1：微网项目 2：储能项目 3：光伏项目 4: 充电桩项目")
  String? singleId = GlobalStorage.getSingleId();
  Map<String, dynamic> generalData = {};
  Map<String, dynamic> statusData = {};
  String status = "运行正常";
  int todayCount = 0;

  getindexStatusInfo() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getindexStatusInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        statusData = data['data'];
      } else {}
    } else {}
  }

  getTodayCount() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params['itemId'] = singleId;
    }
    var data = await AlarmDao.getTodayCount(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        print("数据数据数${data['data']}");
        todayCount = data['data'];
        setState(() {});
      } else {}
    }
  }

  @override
  void initState() {
    super.initState();
    if (singleId != null) {
      getTodayCount();
    }
    getindexStatusInfo();
    if (isOperator == true && singleId == null) {
      _tabs = ["总览", "光伏", "储能"];
      mController = TabController(initialIndex: 0, length: 3, vsync: this);
    } else {
      print(loginType);
      if (userInfo['itemType'] == 1 || loginType == 1) {
        _tabs = ["总览", "光伏", "储能"];
        mController = TabController(initialIndex: 0, length: 3, vsync: this);
      } else if (userInfo['itemType'] == 2 || loginType == 2) {
        _tabs = ["储能"];
        mController = TabController(initialIndex: 0, length: 1, vsync: this);
      } else if (userInfo['itemType'] == 3 || loginType == 3) {
        _tabs = ["光伏"];
        mController = TabController(initialIndex: 0, length: 1, vsync: this);
      } else {
        _tabs = [];
        mController = TabController(initialIndex: 0, length: 0, vsync: this);
      }
    }
  }

  Future<Map<String, dynamic>> getindexGeneralView() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    print('参数${params}');
    var data = await IndexDao.getindexGeneralView(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return generalData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    mController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('本机尺寸');
    print(ScreenDimensions.screenWidth(context));
    print(ScreenDimensions.screenHeight(context));

    return FutureBuilder<Object>(
        future: getindexGeneralView(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map itemTopVo = {};
            if (generalData['itemTopVo'] != null) {
              itemTopVo = generalData['itemTopVo'];
            }

            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/gradientbg.png'),
                      fit: BoxFit.fill)),
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: (isOperator == true && singleId == null)
                          ? Column(
                              children: [
                                Transform.translate(
                                  offset: const Offset(-10, 0),
                                  child: Image(
                                      height: 50,
                                      image: AssetImage(
                                          LanguageResource.getImagePath(
                                              'assets/logintext'))),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Row(
                                      // 必须指定文本基线类型
                                      children: [
                                        const Image(
                                            image: AssetImage(
                                                'assets/xmnumIcon.png')),
                                        const SizedBox(width: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Center(
                                              child: Text(
                                                '项目(个)',
                                                style: TextStyle(
                                                    color: Color(0xFF8693AB)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Center(
                                              child: Text(
                                                '${itemTopVo['itemNum'] ?? "0"}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Center(
                                              child: Text(
                                                '${itemTopVo['totalPower'] ?? "0"}MW/${itemTopVo['totalCapacity'] ?? "0"}MWh',
                                                style: const TextStyle(
                                                    color: Color(0xFF8693AB),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            const Image(
                                                image: AssetImage(
                                                    'assets/microgrid.png')),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '微电网(个)',
                                                  style: TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  '${itemTopVo['microgridNumber'] ?? "0"}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${itemTopVo['microgridPower'] ?? "0"}MW/${itemTopVo['microgridCapacity'] ?? "0"}MWh',
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB),
                                                      fontSize: 10),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            const Image(
                                                image: AssetImage(
                                                    'assets/gfnumIcon.png')),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '光伏(座)',
                                                  style: TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  '${itemTopVo['pvNum'] ?? "0"}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${itemTopVo['pvRatePower'] ?? "0"}MWp',
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB),
                                                      fontSize: 12),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              const Image(
                                                  image: AssetImage(
                                                      'assets/cnnumIcon.png')),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      '储能(座)',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                    Text(
                                                      '${itemTopVo['storageNum'] ?? "0"}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${itemTopVo['storageRatePower'] ?? "0"}MW/${itemTopVo['storageVolume'] ?? "0"}MWh',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF8693AB),
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                const Image(
                                                    image: AssetImage(
                                                        'assets/cdznumIcon.png')),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      '充电桩(座)',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                    Text(
                                                      '${itemTopVo['chargeNum'] ?? "0"}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${itemTopVo['chargeRatePower'] ?? "0"}MWh',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF8693AB),
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Transform.translate(
                                  offset: const Offset(-10, 0),
                                  child: Image(
                                      height: 50,
                                      image: AssetImage(
                                          LanguageResource.getImagePath(
                                              'assets/logintext'))),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        getTextColor(generalData['itemType']),
                                        const SizedBox(width: 6),
                                        Text('${generalData['itemName']}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (isOperator == true &&
                                            singleId != null) {
                                          Routes.instance!.navigateTo(
                                              context,
                                              Routes.alarmRLPage,
                                              singleId.toString());
                                        } else {
                                          Routes.instance!.navigateTo(
                                              context, Routes.alarmRLPage);
                                        }
                                      },
                                      child: Badge(
                                        label: todayCount > 0
                                            ? Text(todayCount.toString())
                                            : null,
                                        child: const Icon(Icons.add_alert),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Image(
                                        image: AssetImage(
                                            'assets/location_green.png')),
                                    const SizedBox(width: 3),
                                    Text(
                                        '${generalData['detailAddress'] ?? "--"}',
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      width: 120,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                          child: Text(status,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF24C18F))))),
                                ),
                                const SizedBox(height: 15),
                                const Image(
                                    image: AssetImage(
                                        'assets/overviewtopImage.png')),
                              ],
                            ),
                    ),
                    Visibility(
                      visible:
                          (userInfo['itemType'] == 1) || (isOperator == true)
                              ? true
                              : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          height: 32.0,
                          child: ButtonsTabBar(
                            width:
                                (ScreenDimensions.screenWidth(context) - 30) /
                                    3,
                            contentCenter: true,
                            tabs: _tabs.map((e) => Tab(text: e)).toList(),
                            onTap: (index) {
                              if (index == 0) {
                                status = statusData['micStatusMsg'];
                              } else if (index == 0) {
                                status = statusData['pvStatusMsg'];
                              } else {
                                status = statusData['cnStatusMsg'];
                              }
                              setState(() {});
                            },
                            controller: mController,
                            backgroundColor: const Color(0xFF24C18F),
                            unselectedBackgroundColor: Colors.white,
                            labelStyle: const TextStyle(color: Colors.white),
                            unselectedLabelStyle:
                                const TextStyle(color: Color(0xFF8693AB)),
                            buttonMargin:
                                const EdgeInsets.only(right: 20, left: 20),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            elevation: 0.5,
                            radius: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 1200,
                      child: TabBarView(
                          controller: mController, children: _getChild()),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('页面开发中!', style: TextStyle(fontSize: 20)));
          } else {
            return const SizedBox(
                height: 280, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  getTextColor(int itemType) {
    if (itemType == 1) {
      return Container(
          width: 50,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFEEEEFD)),
          child: const Text('微网项目',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Color(0xFF545DE9))));
    } else if (itemType == 2) {
      return Container(
          width: 50,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFE9F9F4)),
          child: const Text('储能项目',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Color(0xFF24C18F))));
    } else {
      return Container(
          width: 50,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFFFF2E6)),
          child: const Text('光伏项目',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Color(0xFFFB8209))));
    }
  }

  _getChild() {
    if ((isOperator == true && singleId == null)) {
      return [
        OverViewPage(pageData: generalData),
        PhotovoltaicViewPage(pageData: generalData),
        StorageViewPage(pageData: generalData)
      ];
    } else {
      if (userInfo['itemType'] == 1 || loginType == 1) {
        return [
          OverViewPage(pageData: generalData),
          PhotovoltaicViewPage(pageData: generalData),
          StorageViewPage(pageData: generalData)
        ];
      } else if (userInfo['itemType'] == 2 || loginType == 2) {
        return [StorageViewPage(pageData: generalData)];
      } else if (userInfo['itemType'] == 3 || loginType == 3) {
        return [PhotovoltaicViewPage(pageData: generalData)];
      } else {
        return [
          OverViewPage(pageData: generalData),
          PhotovoltaicViewPage(pageData: generalData),
          StorageViewPage(pageData: generalData)
        ];
      }
    }
  }
}
