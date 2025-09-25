import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart' as date_format;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/toolview/custom_view.dart';
import 'package:suncloudm/toolview/flowing_line.dart';
import 'package:suncloudm/toolview/language_resource.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class GgHomePage extends StatefulWidget {
  const GgHomePage({super.key});

  @override
  State<GgHomePage> createState() => _GgHomePageState();
}

class _GgHomePageState extends State<GgHomePage> {
  String? singleId = GlobalStorage.getSingleId();

  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  Map<String, dynamic> projectData = {};
  Map<String, dynamic> topData = {};
  Map<String, dynamic> picData = {};
  Future<void> getProjectInfoUrl() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getProjectInfoUrl(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        List datalist = data['data']['items'];
        if (datalist.isNotEmpty) {
          projectData = datalist[0];
          if (mounted) {
            setState(() {});
          }
        }
      } else {}
    } else {}
  }

  getSingleTopInfo() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getSingleTopInfo(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        topData = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  Timer? _timer;

  getSingleCenter() async {
    Map<String, dynamic> params = {};
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getSingleCenter(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        picData = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  String beginDate = date_format.formatDate(
      DateTime.now(), [date_format.yyyy, date_format.mm, date_format.dd]);
  String endDate = date_format.formatDate(
      DateTime.now(), [date_format.yyyy, date_format.mm, date_format.dd]);

  Future<dynamic>? _ggSinglePowerChartFuture;

  @override
  void initState() {
    super.initState();
    getSingleTopInfo();
    getSingleCenter();
    getProjectInfoUrl();
    _ggSinglePowerChartFuture = getggSinglePowerChart();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getSingleCenter();
    });
  }

  Future<dynamic> getggSinglePowerChart() async {
    Map<String, dynamic> params = {};
    params["beginDate"] = beginDate;
    params["endDate"] = endDate;
    var data = await IndexDao.getggSinglePowerChart(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return data['data'];
      } else {}
    } else {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: SafeArea(
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(-10, 0),
              child: Image(
                  height: 50,
                  image: AssetImage(
                      LanguageResource.getImagePath('assets/logintext'))),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                projectData['itemName'] ?? "--",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Image(
                                  image:
                                      AssetImage('assets/location_green.png')),
                              Text(
                                projectData['detailAddress'] ?? "--",
                                style: const TextStyle(fontSize: 12),
                              ),
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
                                  child: Text(projectData['statusMsg'] ?? "--",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF24C18F)))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Image(
                        image: AssetImage('assets/overviewtopImage.png')),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                SizedBox(
                                  height: 18,
                                  child: VerticalDivider(
                                    thickness: 3,
                                    color: Colors.green,
                                  ),
                                ),
                                Text('光伏收益',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView("光伏今日/累计发电量(kWh)",
                                    "${topData['pvTodayQuantity'] ?? '--'} /${topData['pvTotalQuantity'] ?? '--'}"),
                                const SizedBox(width: 15),
                                _cellView("储能今日充/放电量(kWh)",
                                    "${topData['storageTodayCharge'] ?? '--'} /${topData['storageTodayDischarge'] ?? '--'}"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView("储能累计充/放电量(kWh)",
                                    "${topData['storageTotalCharge'] ?? '--'} /${topData['storageTotalDischarge'] ?? '--'}"),
                                const SizedBox(width: 15),
                                _cellView("储能转换效率(%)",
                                    "${topData['percent'] ?? '--'}"),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    const CLConnectView(),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Image(
                                width: 50,
                                height: 60,
                                fit: BoxFit.fill,
                                image: AssetImage('assets/gfzj.png')),
                            CurrentLine(
                              direction: CurrentXDirection.topToBottom,
                              width: 80,
                              height:
                                  (picData['generatePower'] ?? 0) <= 0 ? 0 : 5,
                              lineColor: Colors.grey[400]!,
                              currentColor: const Color(0xFF24C18F),
                            ),
                            // const Image(
                            //     width: 50,
                            //     height: 80,
                            //     fit: BoxFit.fill,
                            //     image: AssetImage('assets/zlhlgzj.png')),
                            // CurrentLine(
                            //   direction: CurrentXDirection.topToBottom,
                            //   width: 80,
                            //   height:
                            //       (picData['generatePower'] ?? 0) <= 0 ? 0 : 5,
                            //   lineColor: Colors.grey[400]!,
                            //   currentColor: const Color(0xFF24C18F),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                    width: 35,
                                    height: 50,
                                    fit: BoxFit.fill,
                                    image: AssetImage('assets/dczj.png')),
                                HorizontaLine(
                                  width: 100,
                                  height: picData['status']?.toString() ==
                                              '0.0' ||
                                          picData['status']?.toString() == null
                                      ? 0
                                      : 5,
                                  direction:
                                      picData['status']?.toString() == '1.0'
                                          ? CurrentDirection.leftToRight
                                          : CurrentDirection.rightToLeft,
                                  lineColor: Colors.grey[400]!,
                                  currentColor: const Color(0xFF24C18F),
                                  currentCount: 4,
                                  animationDuration: const Duration(seconds: 3),
                                ),
                                const Image(
                                    width: 45,
                                    height: 80,
                                    fit: BoxFit.fill,
                                    image: AssetImage('assets/nbqzj.png')),
                                const SizedBox(
                                  width: 140,
                                ),
                              ],
                            ),
                            CurrentLine(
                              direction: CurrentXDirection.topToBottom,
                              width: 80,
                              height: (picData['acLoad'] ?? 0) > 1 ? 5 : 0,
                              lineColor: Colors.grey[400]!,
                              currentColor: const Color(0xFF24C18F),
                            ),
                            const Image(
                                width: 42,
                                height: 67.5,
                                fit: BoxFit.fill,
                                image: AssetImage('assets/bpqzj.png')),
                            CurrentLine(
                              direction: CurrentXDirection.topToBottom,
                              width: 80,
                              height: (picData['acLoad'] ?? 0) > 1 ? 5 : 0,
                              lineColor: Colors.grey[400]!,
                              currentColor: const Color(0xFF24C18F),
                            ),
                            const Image(
                                width: 100,
                                height: 95,
                                fit: BoxFit.fill,
                                image: AssetImage('assets/sbzj.png')),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                          children: [
                            Transform.translate(
                              offset: const Offset(-110, 0),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: 160,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/qp01.png'),
                                        fit: BoxFit.fill)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "发电功率",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "电流",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "电压",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "环境温度",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "限额功率",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['generatePower'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "kW",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                  "${picData['current'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const Text(
                                              "A",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['voltage'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "V",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['envTemp'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "℃",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['envTempLimitPower'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "kW",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.translate(
                                  offset: const Offset(-20, 0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 160,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage('assets/qp05.png'),
                                            fit: BoxFit.fill)),
                                    child: Row(
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "功率",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "状态",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "SOC",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "最高单体电压",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "平均电压",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "最低单体电压",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF8693AB)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    "${picData['power'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Text(
                                                  "kW",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Builder(
                                                    builder: (context) {
                                                      final currentValue =
                                                          picData['status']
                                                                  ?.toString() ??
                                                              '--';
                                                      Color textColor;
                                                      switch (currentValue) {
                                                        case '0.0':
                                                          textColor =
                                                              Colors.grey;
                                                          return Text('静置',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      textColor));
                                                        case '1.0':
                                                          textColor =
                                                              Colors.blue;
                                                          return Text('放电',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      textColor));
                                                        case '2.0':
                                                          textColor =
                                                              Colors.green;
                                                          return Text('充电',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      textColor));
                                                        default:
                                                          textColor =
                                                              Colors.black;
                                                          return Text(
                                                              currentValue,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      textColor));
                                                      }
                                                    },
                                                  ),
                                                ),
                                                const Text(
                                                  " ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    "${picData['soc'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Text(
                                                  "%",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    "${picData['uh'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Text(
                                                  "V",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    "${picData['avgVoltage'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Text(
                                                  "V",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    "${picData['ul'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Text(
                                                  "V",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(20, -15),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 160,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage('assets/qp06.png'),
                                            fit: BoxFit.fill)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "交流负载",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            "${picData['acLoad'] ?? '--'}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Text(
                                          "kW",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Transform.translate(
                              offset: const Offset(100, -40),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                width: 140,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/qp02.png'),
                                        fit: BoxFit.fill)),
                                child: Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "功率",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "频率",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "电流",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "电压",
                                          style: TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['bpqPower'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "kW",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                  "${picData['bpqFrequency'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const Text(
                                              "Hz",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['bpqCurrent'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "A",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                "${picData['bpqVoltage'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              "V",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Transform.translate(
                              offset: const Offset(65, 0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const Text(
                                  "光伏组件",
                                  style: TextStyle(color: Color(0xFF8693AB)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                            // Transform.translate(
                            //   offset: const Offset(70, 0),
                            //   child: Container(
                            //     padding: const EdgeInsets.all(10),
                            //     width: 100,
                            //     decoration: const BoxDecoration(
                            //       color: Colors.transparent,
                            //     ),
                            //     child: const Text(
                            //       "直流汇流柜",
                            //       style: TextStyle(color: Color(0xFF8693AB)),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 100),
                            Transform.translate(
                              offset: const Offset(-110, 0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const Text(
                                  "电池",
                                  style: TextStyle(color: Color(0xFF8693AB)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 0),
                            Transform.translate(
                              offset: const Offset(80, 0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 120,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const Text(
                                  "光储一体逆变器",
                                  style: TextStyle(color: Color(0xFF8693AB)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 130),
                            Transform.translate(
                              offset: const Offset(-50, 0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const Text(
                                  "变频器",
                                  style: TextStyle(color: Color(0xFF8693AB)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                            Transform.translate(
                              offset: const Offset(60, 0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const Text(
                                  "水泵",
                                  style: TextStyle(color: Color(0xFF8693AB)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8), //功率趋势
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
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
                              Text(S.current.power_curve,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  width: 300,
                                                  height: 400,
                                                  child: SfDateRangePicker(
                                                    confirmText: '确定',
                                                    cancelText: '取消',
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    showActionButtons: true,
                                                    // initialSelectedRange: PickerDateRange(
                                                    //     DateTime(2020), DateTime(2050)),
                                                    selectionMode:
                                                        DateRangePickerSelectionMode
                                                            .range,
                                                    view: DateRangePickerView
                                                        .month,
                                                    allowViewNavigation: false,
                                                    headerStyle:
                                                        const DateRangePickerHeaderStyle(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent),
                                                    startRangeSelectionColor:
                                                        const Color.fromRGBO(
                                                            36, 193, 143, 1),
                                                    endRangeSelectionColor:
                                                        const Color.fromRGBO(
                                                            36, 193, 143, 1),
                                                    rangeSelectionColor:
                                                        const Color.fromRGBO(
                                                            36, 193, 143, 0.3),
                                                    onCancel: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    onSubmit: (Object? value) {
                                                      // print(value);
                                                      if (value
                                                          is PickerDateRange) {
                                                        List<String> formats = [
                                                          date_format.yyyy,
                                                          '-',
                                                          date_format.mm,
                                                          '-',
                                                          date_format.dd
                                                        ];
                                                        beginDate = date_format
                                                            .formatDate(
                                                                value
                                                                    .startDate!,
                                                                formats);

                                                        if (value.endDate ==
                                                            null) {
                                                          endDate = date_format
                                                              .formatDate(
                                                                  value
                                                                      .startDate!,
                                                                  formats);
                                                        } else {
                                                          endDate = date_format
                                                              .formatDate(
                                                                  value
                                                                      .endDate!,
                                                                  formats);
                                                        }
                                                        setState(() {
                                                          _ggSinglePowerChartFuture =
                                                              getggSinglePowerChart();
                                                        });
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    onSelectionChanged:
                                                        (DateRangePickerSelectionChangedArgs
                                                            args) {
                                                      if (args.value
                                                          is PickerDateRange) {
                                                        // startDate = formatDate(args.value.startDate, [yyyy]);
                                                        // endDate = formatDate(args.value.endDate, [yyyy]);
                                                        // print(args.value.startDate);
                                                        // seleteDate=formatDate(args.value.startDate, [yyyy])+formatDate(args.value.endDate, [yyyy]);
                                                        setState(() {});
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        minimumSize: const Size(0, 40),
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "$beginDate",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black26),
                                          ),
                                          const Text('-'),
                                          Text(
                                            "$endDate",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black26),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder(
                              future: _ggSinglePowerChartFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                      height: 300,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                } else if (snapshot.hasError) {
                                  return SizedBox(
                                      height: 80,
                                      child: Center(
                                          child: Text(S.current.no_data)));
                                  ;
                                } else if (snapshot.hasData) {
                                  Map lineChartData = snapshot.data;
                                  List xdata = lineChartData['xaxis'];
                                  List yaxis = lineChartData['yaxis1'] ?? [];
                                  List yaxis1 = lineChartData['yaxis2'] ?? [];
                                  List yaxis2 = lineChartData['yaxis3'] ?? [];
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 250,
                                        child: Echarts(
                                            option: jsonEncode({
                                          "zlevel": 11,
                                          "tooltip": {"trigger": 'axis'},
                                          "legend": {
                                            // "itemWidth": 10,
                                            // "itemHeight": 10,
                                            "textStyle": {
                                              "fontSize": 11,
                                              "color": '#333'
                                            },
                                            "itemGap": 5,
                                            "data": [
                                              S.current.pv,
                                              S.current.ess,
                                              S.current.loadd
                                            ],
                                            "inactiveColor": '#ccc'
                                          },
                                          "grid": {
                                            "right": 15,
                                            "left": 40,
                                            "bottom": 30,
                                            // "top": 60,
                                          },
                                          "xAxis": {
                                            "type": 'category',
                                            "data": xdata,
                                          },
                                          "yAxis": [
                                            {
                                              "type": 'value',
                                              "name": 'kW',
                                            }
                                          ],
                                          "series": [
                                            {
                                              'name': S.current.pv,
                                              "data": yaxis,
                                              "type": 'line',
                                              "smooth": true, // 是否让线条圆滑显示
                                              "symbol": 'none',
                                              "color": '#0F9CFF',
                                            },
                                            {
                                              'name': S.current.ess,
                                              "data": yaxis1,
                                              "type": 'line',
                                              "smooth": true,
                                              "symbol": 'none', // 是否让线条圆滑显示
                                              "color": '#C666DE',
                                            },
                                            {
                                              'name': S.current.loadd,
                                              "data": yaxis2,
                                              "type": "line",
                                              "smooth": true,
                                              "symbol": 'none',
                                              "color": '#61A643',
                                            }
                                          ]
                                        })),
                                      )
                                    ],
                                  );
                                }
                                return Container();
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cellView(String title, String num) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 80,
        decoration: BoxDecoration(
            color: const Color(0xFFF2F8F9),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8693AB)),
            ),
            Text(
              num,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

class CLConnectView extends StatefulWidget {
  const CLConnectView({super.key});

  @override
  State<CLConnectView> createState() => _CLConnectViewState();
}

class _CLConnectViewState extends State<CLConnectView> {
  String? _selectedOption = 'A';

  // 添加一个方法来生成 DropdownButtonFormField2 的装饰器
  InputDecoration getDropdownDecoration(bool isGrey) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            BorderSide(color: isGrey ? Colors.grey : const Color(0xFF8693AB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            BorderSide(color: isGrey ? Colors.grey : const Color(0xFF8693AB)),
      ),
    );
  }

  String deviceCode = '';
  int _counter = 50; // 新增计数器状态变量

  bool _isExpanded = false;
  bool _isGrey = true;

  int iotSingleDebug = 0;
  List strategyVoList = [];
  String strategyVoName = '';
  int strategyVoId = 0;

  List conList = []; //控制参数
  // 初始化时间段列表，默认添加一条 00:00 至 02:00 的记录
  Map peakStrategy = {}; //水泵map
  List peakStrategyList = []; //时间列表

  late int runControlvalue;
  late int ski_ao1value;
  List issueMap = []; //控制参数

  Future<void> _selectTime(BuildContext context, int index, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: type == 'start'
          ? stringToTimeOfDay(peakStrategyList[index]['startTime']!)!
          : stringToTimeOfDay(peakStrategyList[index]['endTime']!)!,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:'
            '${picked.minute.toString().padLeft(2, '0')}';
        if (type == 'start') {
          peakStrategyList[index]['startTime'] = formattedTime;
        } else {
          peakStrategyList[index]['endTime'] = formattedTime;
        }
      });
    }
  }

  Widget _buildExpandButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Text(_isExpanded ? '收起' : '展开'),
    );
  }

//策略详情
  getStrategyInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getStrategyInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      Map<String, dynamic> map = data['data'];
      strategyVoList = map['strategyVoList'];
      iotSingleDebug = map['iotSingleDebug'];
      if (iotSingleDebug == 0) {
        _selectedOption = 'A';
      } else {
        _selectedOption = 'B';
      }
      for (var item in strategyVoList) {
        if (item['status'] == 1) {
          strategyVoName = item['strategyName'];
          strategyVoId = item['id'];
          getSinglestrategy(item['id']);
        }
      }
      setState(() {});
    } else {}
  }

  getAirLoopList() async {
    Map<String, dynamic> params = {};
    params['deviceType'] = 67;
    var data = await IndexDao.getAirLoopList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      List airLoopList = data['data'];
      if (airLoopList.isNotEmpty) {
        Map bpq = airLoopList[0];
        deviceCode = bpq['deviceCode'];
        getMonitorInfo(deviceCode);
      }
    } else {}
  }

  getMonitorInfo(String deviceCode) async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = deviceCode;
    params['fieldType'] = 4;
    var data = await IndexDao.getMonitorInfo(params: params);
    if (data["code"] == 200) {
      conList = data['data'];
      Map<String, dynamic> item1 =
          conList.firstWhere((item) => item['name'] == '变频器运行控制');
      if (item1['value'] == null) {
        // runControlvalue = 0;
      } else {
        runControlvalue = item1['value'].round();
      }

      Map<String, dynamic> item2 =
          conList.firstWhere((item) => item['name'] == '变频器频率');
      if (item2['value'] == null) {
        // ski_ao1value = 0;
      } else {
        ski_ao1value = item2['value'].round();
        _counter = item2['value'].round();
      }

      setState(() {});
    } else {}
  }

//获取单击调试策略
  getSinglestrategy(int id) async {
    Map<String, dynamic> params = {};
    params['id'] = id;
    var data = await IndexDao.getSelectPeak(params: params);
    if (data["code"] == 200) {
      Map<String, dynamic> map = data['data'];
      peakStrategy = map;
      peakStrategyList = map['peakStrategyList'];
      setState(() {});
    } else {}
  }

//下发策略
  postIssue() async {
    if (_selectedOption == 'B') {
      Map<String, dynamic> params = {};
      params['deviceCode'] = deviceCode;
      Map<String, dynamic> issueMap1 = {
        'field': 'run_control',
        'value': shutdownEnabled == true ? 3 : runControlvalue
      };
      Map<String, dynamic> issueMap2 = {'field': 'ski_ao1', 'value': _counter};
      List issueMap = [issueMap1, issueMap2];
      params['issueMap'] = issueMap;
      var data = await IndexDao.postIssue(params: params);
      debugPrint(data.toString());
      if (data["code"] == 200) {
        SVProgressHUD.showSuccess(status: '下发成功');
        setState(() {
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
            getStrategyInfo();
          });
          _isGrey = true;
        });
      } else {
        SVProgressHUD.showError(status: '下发失败');
        setState(() {});
      }
    } else if (_selectedOption == 'A') {
      Map<String, dynamic> params = {};
      params['id'] = peakStrategy['id'];
      params['strategyName'] = peakStrategy['strategyName'];
      params['peakStrategyList'] = peakStrategyList;
      debugPrint(params.toString());
      var data = await IndexDao.insertOrUpdate(params: params);
      debugPrint(data.toString());
      if (data["code"] == 200) {
        SVProgressHUD.showSuccess(status: '下发成功');
        setState(() {
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
            getStrategyInfo();
          });
          _isGrey = true;
        });
      } else {
        SVProgressHUD.showError(status: '下发失败');
        setState(() {});
      }
    }
  }

  TimeOfDay? stringToTimeOfDay(String timeString) {
    try {
      // 分割小时和分钟
      List<String> parts = timeString.split(':');
      if (parts.length != 2) {
        return null; // 格式不正确
      }
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      // 验证范围
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      // 处理解析错误
      return null;
    }
  }

  bool shutdownEnabled = false;

  Widget _singledebug(List conList) {
    bool isExist = conList.any((item) => item['name'] == '变频器运行控制');
    if (!isExist) {
      return Container();
    } else {
      Map<String, dynamic> item =
          conList.firstWhere((item) => item['name'] == '变频器运行控制');
      List defineList = item['defineList'];
      return Expanded(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: TextStyle(
                color: _isGrey ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // 关机单选框按钮
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: CheckboxMenuButton(
                  value: shutdownEnabled,
                  onChanged: (bool? newValue) {
                    if (_isGrey) {
                      return;
                    }
                    setState(() {
                      shutdownEnabled = newValue!;
                    });
                  },
                  child: Text(
                    '关机',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isGrey ? Colors.grey : Colors.black,
                    ),
                  )),
            ),
            // SizedBox(
            //   width: 120,
            //   height: 40,
            //   child: DropdownButtonFormField2<String>(
            //       isExpanded: true,
            //       // enabled: !_isGrey,
            //       decoration: getDropdownDecoration(_isGrey),
            //       hint: Text(
            //         item['label'] ?? '--',
            //         style: TextStyle(
            //           fontSize: 14,
            //           color: _isGrey ? Colors.grey : Colors.black,
            //         ),
            //       ),
            //       items: defineList
            //           .map((unit) => DropdownMenuItem<String>(
            //                 value: unit['value'].toString(),
            //                 child: Text(
            //                   unit['describe'],
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     color: _isGrey ? Colors.grey : Colors.black,
            //                   ),
            //                 ),
            //               ))
            //           .toList(),
            //       onChanged: _isGrey
            //           ? null
            //           : (value) {
            //               debugPrint(value);
            //               runControlvalue = int.parse(value!);
            //             },
            //       buttonStyleData: const ButtonStyleData(
            //           padding: EdgeInsets.only(right: 10)),
            //       iconStyleData: IconStyleData(
            //           icon: Icon(Icons.arrow_drop_down,
            //               color: _isGrey ? Colors.grey : Colors.black45),
            //           iconSize: 24),
            //       dropdownStyleData: DropdownStyleData(
            //         decoration:
            //             BoxDecoration(borderRadius: BorderRadius.circular(15)),
            //       ),
            //       menuItemStyleData: const MenuItemStyleData(
            //           padding: EdgeInsets.symmetric(horizontal: 15))),
            // ),
          ],
        ),
      );
    }
  }

  Widget _singleHzdebug(List conList) {
    bool isExist = conList.any((item) => item['name'] == '变频器频率');
    if (!isExist) {
      return Container();
    } else {
      return Expanded(
        child: Column(
          children: [
            Text(
              '变频器频率(Hz)',
              style: TextStyle(
                color: _isGrey ? Colors.grey : Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _isGrey
                      ? null
                      : () {
                          setState(() {
                            _counter++;
                          });
                        },
                  color: _isGrey ? Colors.grey : null,
                ),
                Text(
                  '$_counter',
                  style: TextStyle(
                    color: _isGrey ? Colors.grey : Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _isGrey
                      ? null
                      : () {
                          setState(() {
                            _counter--;
                          });
                        },
                  color: _isGrey ? Colors.grey : null,
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getAirLoopList();
    getStrategyInfo();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getStrategyInfo();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              // 横向排布时的对齐方式
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 第一个选项
                InkWell(
                  // 点击整个区域触发选择
                  onTap: _isGrey
                      ? null
                      : () => setState(() => _selectedOption = 'A'),
                  // 自定义点击反馈
                  splashColor: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    // 控制整体内边距，减小占用空间
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          height: 20,
                          child: Radio(
                            value: 'A',
                            fillColor: _isGrey
                                ? WidgetStateProperty.all(Colors.grey)
                                : WidgetStateProperty.all(Colors.green),
                            groupValue: _selectedOption,
                            onChanged: _isGrey
                                ? null
                                : (value) =>
                                    setState(() => _selectedOption = 'A'),
                            // 缩小单选按钮大小
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        Text(
                          '运行策略',
                          style: TextStyle(
                              fontSize: 14,
                              color: _isGrey ? Colors.grey : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 5),
                // 第二个选项
                InkWell(
                  onTap: _isGrey
                      ? null
                      : () {
                          setState(() {
                            if (_selectedOption == 'A') {
                              _openDialog(context);
                            }
                            _selectedOption = 'B';
                          });
                        },
                  splashColor: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Row(children: [
                      SizedBox(
                        width: 25,
                        height: 20,
                        child: Radio(
                          fillColor: _isGrey
                              ? WidgetStateProperty.all(Colors.grey)
                              : WidgetStateProperty.all(Colors.green),
                          value: 'B',
                          groupValue: _selectedOption,
                          onChanged: _isGrey
                              ? null
                              : (value) {
                                  if (_selectedOption == 'A') {
                                    _openDialog(context);
                                    setState(() => _selectedOption = 'B');
                                  }
                                },
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Text(
                        '单机调试',
                        style: TextStyle(
                            fontSize: 14,
                            color: _isGrey ? Colors.grey : Colors.black),
                      ),
                      IconButton(
                          onPressed: () {
                            _openDialog(context);
                          },
                          icon: const Icon(
                            Icons.warning,
                            color: Colors.red,
                          ))
                    ]),
                  ),
                ),
                const Spacer(),
                Visibility(
                    visible: !_isGrey,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('提示'),
                              content: const Text('现场设备满足下发条件，是否下发'),
                              actions: [
                                TextButton(
                                  child: const Text('取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('确定'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    postIssue();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        // padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xFF24C18F)),
                      ),
                      child: const Text('保存',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    )),
                const SizedBox(width: 10),
                TextButton(
                    style: ButtonStyle(
                      // padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFF24C18F)),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isGrey == false) {
                          getStrategyInfo();
                          _timer = Timer.periodic(const Duration(minutes: 1),
                              (timer) {
                            getStrategyInfo();
                          });
                          setState(() {
                            _isGrey = !_isGrey;
                          });
                        } else {
                          _timer!.cancel();
                          setState(() {
                            _isGrey = !_isGrey;
                          });
                        }
                      });
                    },
                    child: Text(
                      _isGrey ? '编辑' : '取消',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            ),
            _isExpanded
                ? _selectedOption == 'A'
                    ? Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '当前运行策略:',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Color(0xFF8693AB)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 40,
                            child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                // enabled: !_isGrey,
                                decoration: getDropdownDecoration(_isGrey),
                                hint: Text(
                                  strategyVoName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _isGrey ? Colors.grey : Colors.black,
                                  ),
                                ),
                                items: strategyVoList
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item['id'].toString(),
                                          child: Text(
                                            item['strategyName'],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: _isGrey
                                    ? null
                                    : (value) {
                                        debugPrint(value);
                                        getSinglestrategy(int.parse(value!));
                                      },
                                buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.only(right: 20)),
                                iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.black45),
                                    iconSize: 24),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16))),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: peakStrategyList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        // 开始时间选择
                                        Expanded(
                                          child: InkWell(
                                            onTap: _isGrey
                                                ? null
                                                : () => _selectTime(
                                                    context, index, 'start'),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: _isGrey
                                                    ? Colors.grey[300]
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '开始时间: ${peakStrategyList[index]['startTime']!}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: _isGrey
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // 结束时间选择
                                        Expanded(
                                          child: InkWell(
                                            onTap: _isGrey
                                                ? null
                                                : () => _selectTime(
                                                    context, index, 'end'),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: _isGrey
                                                    ? Colors.grey[300]
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '结束时间: ${peakStrategyList[index]['endTime']!}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: _isGrey
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // 删除图标
                                        IconButton(
                                          icon: Icon(
                                            Icons.do_not_disturb_sharp,
                                            color: _isGrey
                                                ? Colors.grey
                                                : Colors.red,
                                            size: 14,
                                          ),
                                          onPressed: _isGrey
                                              ? null
                                              : () {
                                                  setState(() {
                                                    peakStrategyList
                                                        .removeAt(index);
                                                  });
                                                },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // 新增按钮
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: TextButton(
                                  onPressed: _isGrey
                                      ? null
                                      : () {
                                          setState(() {
                                            peakStrategyList.add({
                                              'startTime': '00:00',
                                              'endTime': '02:00'
                                            });
                                          });
                                        },
                                  child: Text(
                                    '新增',
                                    style: TextStyle(
                                      color: _isGrey ? Colors.grey : null,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    : Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _singledebug(conList),
                          // _singleHzdebug(conList),
                        ],
                      )
                : SizedBox(
                    // 收起时高度固定
                    height: 0,
                    child: Container(
                      color: Colors.pinkAccent,
                    ),
                  ),
            _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: 300,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                        ),
                        Text(
                          '警示',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      '1.除非紧急停机、水泵维护，禁止手动控制。',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      '2.修改抽水时间请到转到运行策略。',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      '3.手动关机后，点击运行策略即可恢复开机。',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    size: 30,
                    Icons.close_outlined,
                    color: Colors.white,
                  ))
            ],
          ),
        );
      },
    );
  }
}
