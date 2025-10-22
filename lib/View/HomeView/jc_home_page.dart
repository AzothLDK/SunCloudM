import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/toolview/appColor.dart';
import 'package:suncloudm/utils/deviceTypeToName.dart';
import 'package:suncloudm/toolview/imports.dart';

class JcHomePage extends StatefulWidget {
  const JcHomePage({super.key});

  @override
  State<JcHomePage> createState() => _JcHomePageState();
}

class _JcHomePageState extends State<JcHomePage> {
  Map<String, dynamic> topGeneralData = {};
  Map<String, dynamic> topTotalData = {};

  String seletetime = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  int _currentDateType = 0;
  int _stationType = 3;
  int _itemType = 1;

  Future<dynamic>? _JCNumFuture;
  Future<dynamic>? _JCHomeTopInfoFuture;
  Future<dynamic>? _JCHomeEfficiencyInfoFuture;
  Future<dynamic>? _JCHomeDistributionFuture;
  Future<dynamic>? _bossHomeDeviceListFuture;
  Future<dynamic>? _bossHomeDevicedetailFuture;

  @override
  void initState() {
    super.initState();
    _JCNumFuture = getJCTopNum();
    _JCHomeTopInfoFuture = getJCHomeTopInfo();
    _JCHomeEfficiencyInfoFuture = getJCHomeEfficiencyInfo();
    _JCHomeDistributionFuture = getJCHomeDistribution();
    _bossHomeDeviceListFuture = getBossHomeDeviceList();
    _bossHomeDevicedetailFuture = getDeviceModelDistribution();
  }

  Future<Map<String, dynamic>> getJCTopNum() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getJCTopNum(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topGeneralData = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getJCHomeTopInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getJCHomeTopInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topTotalData = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getJCHomeEfficiencyInfo() async {
    Map<String, dynamic> params = {};
    params['date'] = seletetime;
    params['type'] = _stationType;
    var data = await IndexDao.getJCHomeEfficiencyInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getJCHomeDistribution() async {
    Map<String, dynamic> params = {};
    params['itemType'] = _itemType;
    var data = await IndexDao.getJCHomeDistribution(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool isShowDetail = false;

  Future<List> getBossHomeDeviceList() async {
    Map<String, dynamic> params = {};
    // params['pageNum'] = 1;
    // params['pageSize'] = 100;
    // params['type'] = _deviceType;
    var data = await IndexDao.getBossHomeDeviceList(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getDeviceModelDistribution({int? deviceType}) async {
    Map<String, dynamic> params = {};
    params['deviceType'] = deviceType;
    var data = await IndexDao.getDeviceModelDistribution(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _JCNumFuture = getJCTopNum();
      _JCHomeTopInfoFuture = getJCHomeTopInfo();
      _JCHomeEfficiencyInfoFuture = getJCHomeEfficiencyInfo();
      _JCHomeDistributionFuture = getJCHomeDistribution();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      FutureBuilder(
                          future: _JCNumFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return SizedBox(
                                  height: 80,
                                  child:
                                      Center(child: Text(S.current.no_data)));
                              ;
                            } else if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                                  '${topGeneralData['itemNum'] ?? "0"}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Center(
                                                child: Text(
                                                  '${topGeneralData['ratePower'] ?? "0"}MW/${topGeneralData['volume'] ?? "0"}MWh',
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
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                  Text(
                                                    '${topGeneralData['micNum'] ?? "0"}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${topGeneralData['micRatePower'] ?? "0"}MW/${topGeneralData['micVolume'] ?? "0"}MWh',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF8693AB),
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
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                  Text(
                                                    '${topGeneralData['pvNum'] ?? "0"}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${topGeneralData['pvVolume'] ?? "0"}MWp',
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        '储能(座)',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['cnNum'] ?? "0"}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['cnRatePower'] ?? "0"}MW/${topGeneralData['cnVolume'] ?? "0"}MWh',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF8693AB),
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
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                children: [
                                                  const Image(
                                                      image: AssetImage(
                                                          'assets/cdznumIcon.png')),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        '充电桩(座)',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['chargeNum'] ?? "0"}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['chargeRatePower'] ?? "0"}MW',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFF8693AB),
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
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      // 运营数据
                      FutureBuilder(
                          future: _JCHomeTopInfoFuture,
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
                                  child:
                                      Center(child: Text(S.current.no_data)));
                              ;
                            } else if (snapshot.hasData) {
                              return Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
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
                                        Text(S.current.running_data,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cellView("当前光伏发电功率(MW)",
                                            "${topTotalData['currentPvPower'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("当前储能功率((MW)",
                                            "${topTotalData['currentCnPower'] ?? '--'}"),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cellView("光伏累计发电/上网电量(MWh)",
                                            "${topTotalData['totalGenerateNum'] ?? '--'}/${topTotalData['totalGridNum'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("储能累计充/放电量(MWh)",
                                            "${topTotalData['totalChargeNum'] ?? '--'}/${topTotalData['totalDisChargeNum'] ?? '--'}"),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      // 分布数据
                      FutureBuilder(
                          future: _JCHomeDistributionFuture,
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
                                  child:
                                      Center(child: Text(S.current.no_data)));
                              ;
                            } else if (snapshot.hasData) {
                              List stationList = snapshot.data;
                              int totalItemNum = 0;
                              for (var item in stationList) {
                                totalItemNum +=
                                    ((item['itemNum'] ?? 0) as num).toInt();
                              }

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
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
                                        const Text('项目分布',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        SizedBox(
                                          width: 220,
                                          child: MaterialSegmentedControl(
                                            horizontalPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            verticalOffset: 0,
                                            children: const {
                                              1: Text('微网'),
                                              3: Text('光伏'),
                                              2: Text('储能'),
                                              4: Text('充电站')
                                            },
                                            selectionIndex: _itemType,
                                            borderColor: const Color.fromRGBO(
                                                36, 193, 143, 1),
                                            selectedColor: const Color.fromRGBO(
                                                36, 193, 143, 1),
                                            unselectedColor: Colors.white,
                                            selectedTextStyle: const TextStyle(
                                                color: Colors.white),
                                            unselectedTextStyle:
                                                const TextStyle(
                                                    color: Color.fromRGBO(
                                                        36, 193, 1435, 1)),
                                            borderWidth: 0.7,
                                            borderRadius: 32.0,
                                            onSegmentTapped: (index) {
                                              switch (index) {
                                                case 1:
                                                  {
                                                    _itemType = 1;
                                                    setState(() {
                                                      _JCHomeDistributionFuture =
                                                          getJCHomeDistribution();
                                                    });
                                                  }
                                                case 3:
                                                  {
                                                    _itemType = 3;
                                                    setState(() {
                                                      _JCHomeDistributionFuture =
                                                          getJCHomeDistribution();
                                                    });
                                                  }
                                                case 2:
                                                  {
                                                    _itemType = 2;
                                                    setState(() {
                                                      _JCHomeDistributionFuture =
                                                          getJCHomeDistribution();
                                                    });
                                                  }
                                                case 4:
                                                  {
                                                    _itemType = 4;
                                                    setState(() {
                                                      _JCHomeDistributionFuture =
                                                          getJCHomeDistribution();
                                                    });
                                                  }
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        child: Echarts(
                                            option: jsonEncode({
                                          "zlevel": 11,
                                          "tooltip": {"trigger": 'item'},
                                          "grid": {
                                            "left": "3%",
                                            "right": "4%",
                                            'bottom': '3%',
                                            'top': '10%',
                                            "containLabel": true
                                          },
                                          "color": ColorList().lineColorList,
                                          "series": [
                                            {
                                              'type': 'pie',
                                              // 'center': ['30%', '50%'],
                                              // 'radius': ['40%', '80%'],
                                              'itemStyle': {
                                                'borderWidth': 0, //描边线宽
                                                'borderColor': '#fff',
                                              },
                                              'label': {
                                                'show': true,
                                              },
                                              'data': stationList
                                                  .map(
                                                    (e) => {
                                                      "name": e['provinceName'],
                                                      "value": e['itemNum'],
                                                    },
                                                  )
                                                  .toList(),
                                            },
                                          ]
                                        }))),
                                    const SizedBox(height: 10),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            "项目占比(%)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            "项目数(个)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 190,
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          itemCount: stationList.length,
                                          itemBuilder: (context, index) {
                                            var item = stationList[index];
                                            double proportion = totalItemNum > 0
                                                ? ((item['itemNum'] ?? 0) /
                                                        totalItemNum) *
                                                    100
                                                : 0;
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorList()
                                                              .hexToColor(
                                                                  ColorList()
                                                                          .lineColorList[
                                                                      index]),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          stationList[index]
                                                              ['provinceName'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                          proportion
                                                              .toStringAsFixed(
                                                                  2),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                          "${stationList[index]['itemNum'] ?? '--'}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 3),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      FutureBuilder(
                          future: _JCHomeEfficiencyInfoFuture,
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
                                  child:
                                      Center(child: Text(S.current.no_data)));
                              ;
                            } else if (snapshot.hasData) {
                              List stationList = snapshot.data;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
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
                                        const Text('电站效率TOP5',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        SizedBox(
                                          width: 180,
                                          child: MaterialSegmentedControl(
                                            horizontalPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            verticalOffset: 5,
                                            children: const {
                                              3: Text('光伏'),
                                              2: Text('储能'),
                                              4: Text('充电站')
                                            },
                                            selectionIndex: _stationType,
                                            borderColor: const Color.fromRGBO(
                                                36, 193, 143, 1),
                                            selectedColor: const Color.fromRGBO(
                                                36, 193, 143, 1),
                                            unselectedColor: Colors.white,
                                            selectedTextStyle: const TextStyle(
                                                color: Colors.white),
                                            unselectedTextStyle:
                                                const TextStyle(
                                                    color: Color.fromRGBO(
                                                        36, 193, 1435, 1)),
                                            borderWidth: 0.7,
                                            borderRadius: 32.0,
                                            onSegmentTapped: (index) {
                                              switch (index) {
                                                case 3:
                                                  {
                                                    _stationType = 3;
                                                    setState(() {
                                                      _JCHomeEfficiencyInfoFuture =
                                                          getJCHomeEfficiencyInfo();
                                                    });
                                                  }
                                                case 2:
                                                  {
                                                    _stationType = 2;
                                                    setState(() {
                                                      _JCHomeEfficiencyInfoFuture =
                                                          getJCHomeEfficiencyInfo();
                                                    });
                                                  }
                                                case 4:
                                                  {
                                                    _stationType = 4;
                                                    setState(() {
                                                      _JCHomeEfficiencyInfoFuture =
                                                          getJCHomeEfficiencyInfo();
                                                    });
                                                  }
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                if (_currentDateType == 0) {
                                                  DateTime? d =
                                                      await showMonthYearPicker(
                                                    context: context,
                                                    initialMonthYearPickerMode:
                                                        MonthYearPickerMode
                                                            .month,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2020),
                                                    lastDate: DateTime(2035),
                                                    locale: savedLanguage ==
                                                            'zh'
                                                        ? const Locale('zh')
                                                        : const Locale('en'),
                                                  );
                                                  if (d != null) {
                                                    seletetime = date_format
                                                        .formatDate(d, [
                                                      date_format.yyyy,
                                                      '-',
                                                      date_format.mm
                                                    ]);
                                                    setState(() {
                                                      _JCHomeEfficiencyInfoFuture =
                                                          getJCHomeEfficiencyInfo();
                                                    });
                                                  }
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width: 300,
                                                            height: 300,
                                                            color: Colors
                                                                .transparent,
                                                            child: YearPicker(
                                                              firstDate:
                                                                  DateTime(
                                                                      2000, 5),
                                                              lastDate:
                                                                  DateTime(
                                                                      2050, 5),
                                                              selectedDate:
                                                                  DateTime
                                                                      .now(),
                                                              onChanged:
                                                                  (DateTime
                                                                      value) {
                                                                seletetime =
                                                                    date_format
                                                                        .formatDate(
                                                                            value,
                                                                            [
                                                                      date_format
                                                                          .yyyy
                                                                    ]);
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              }, //最大可选日期
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                elevation: 0,
                                                minimumSize: const Size(0, 40),
                                                shape: const StadiumBorder(),
                                                side: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        212, 212, 212, 1),
                                                    width: 1),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    seletetime,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black26),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.black26,
                                                    size: 14,
                                                  )
                                                ],
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: MaterialSegmentedControl(
                                            horizontalPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            verticalOffset: 5,
                                            children: const {
                                              0: Text('月'),
                                              1: Text('年')
                                            },
                                            selectionIndex: _currentDateType,
                                            borderColor: const Color.fromRGBO(
                                                36, 193, 143, 1),
                                            selectedColor: const Color.fromRGBO(
                                                36, 193, 143, 1),
                                            unselectedColor: Colors.white,
                                            selectedTextStyle: const TextStyle(
                                                color: Colors.white),
                                            unselectedTextStyle:
                                                const TextStyle(
                                                    color: Color.fromRGBO(
                                                        36, 193, 1435, 1)),
                                            borderWidth: 0.7,
                                            borderRadius: 32.0,
                                            onSegmentTapped: (index) {
                                              switch (index) {
                                                case 0:
                                                  {
                                                    _currentDateType = 0;
                                                    seletetime = date_format
                                                        .formatDate(
                                                            DateTime.now(), [
                                                      date_format.yyyy,
                                                      '-',
                                                      date_format.mm
                                                    ]);
                                                    setState(() {
                                                      setState(() {
                                                        _JCHomeEfficiencyInfoFuture =
                                                            getJCHomeEfficiencyInfo();
                                                      });
                                                    });
                                                  }
                                                case 1:
                                                  {
                                                    _currentDateType = 1;
                                                    seletetime = date_format
                                                        .formatDate(
                                                            DateTime.now(),
                                                            [date_format.yyyy]);
                                                    setState(() {
                                                      setState(() {
                                                        _JCHomeEfficiencyInfoFuture =
                                                            getJCHomeEfficiencyInfo();
                                                      });
                                                    });
                                                  }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            "电站",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                            "效率(%)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            "额定功率/容量(kW/kWh)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: Text(
                                            "运行天数(天)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 190,
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          itemCount: stationList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          stationList[index]
                                                              ['stationName'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        child: Text(
                                                          "${(stationList[index]['efficiency'] * 100).toInt()}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                          "${stationList[index]['ratePower'].toInt() ?? '--'}/${stationList[index]['volume'].toInt() ?? '--'}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        child: Text(
                                                          "${stationList[index]['runDays'] ?? '--'}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 3),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      isShowDetail == false
                          ? FutureBuilder(
                              future: _bossHomeDeviceListFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                      height: 600,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                } else if (snapshot.hasError) {
                                  return SizedBox(
                                      height: 80,
                                      child: Center(
                                          child: Text(S.current.no_data)));
                                } else if (snapshot.hasData) {
                                  List record = snapshot.data;

                                  int totalDeviceCount = 0;
                                  for (var item in record) {
                                    // 确保deviceCount存在且是数字类型
                                    if (item.containsKey('deviceCount')) {
                                      try {
                                        totalDeviceCount += int.parse(
                                            item['deviceCount'].toString());
                                      } catch (e) {
                                        // 处理类型转换错误
                                        debugPrint(
                                            'Failed to parse deviceCount: ${item['deviceCount']}');
                                      }
                                    }
                                  }
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                            Text(
                                                S.current
                                                    .Device_Model_Distribution,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 180,
                                            child: Echarts(
                                                option: jsonEncode({
                                              "zlevel": 11,
                                              "tooltip": {"trigger": 'item'},
                                              "color":
                                                  ColorList().lineColorList,
                                              "series": [
                                                {
                                                  'type': 'pie',
                                                  'center': ['50%', '50%'],
                                                  'radius': ['0%', '60%'],
                                                  'avoidLabelOverlap': false,
                                                  'itemStyle': {
                                                    'borderRadius': 0,
                                                    'borderColor':
                                                        'transparent',
                                                    'borderWidth': 10,
                                                  },
                                                  'label': {
                                                    'show': true,
                                                    // 'formatter':
                                                    //     '{b}: {c}个 ({d}%)',
                                                    'formatter': '{d}%',
                                                  },
                                                  'data': record.map((e) {
                                                    return {
                                                      "name": e['deviceType']
                                                          .toString(),
                                                      "value": e['deviceCount'],
                                                    };
                                                  }).toList(),
                                                },
                                              ]
                                            }))),
                                        // const SizedBox(height: 10),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  S.current.Device_Model,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  S.current.Device_Percent,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(S.current.Device_No,
                                                    style: const TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                    S.current.Project_No,
                                                    style: const TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            ]),
                                        SizedBox(
                                          height: 200,
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              itemCount: record.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    debugPrint(record[index]
                                                            ['deviceType']
                                                        .toString());
                                                    setState(() {
                                                      isShowDetail = true;
                                                      _bossHomeDevicedetailFuture =
                                                          getDeviceModelDistribution(
                                                              deviceType: record[
                                                                      index][
                                                                  'deviceType']);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 6),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 80,
                                                          child: Row(
                                                            children: [
                                                              //写一个颜色圆点
                                                              Container(
                                                                width: 10,
                                                                height: 10,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorList()
                                                                          .SerColorList[
                                                                      index],
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                DeviceTypeToName()
                                                                    .getDeviceName(
                                                                        record[index]
                                                                            [
                                                                            'deviceType']),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                              "${(record[index]['deviceCount'] / totalDeviceCount * 100).toStringAsFixed(2)}%"),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                              "${record[index]['modelCount']}"),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                              "${record[index]['itemCount']}"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              })
                          : FutureBuilder(
                              future: _bossHomeDevicedetailFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                      height: 600,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                } else if (snapshot.hasError) {
                                  return SizedBox(
                                      height: 80,
                                      child: Center(
                                          child: Text(S.current.no_data)));
                                } else if (snapshot.hasData) {
                                  List record = snapshot.data;
                                  int totalDeviceCount = 0;
                                  for (var item in record) {
                                    // 确保deviceCount存在且是数字类型
                                    if (item.containsKey('deviceCount')) {
                                      try {
                                        totalDeviceCount += int.parse(
                                            item['deviceCount'].toString());
                                      } catch (e) {
                                        // 处理类型转换错误
                                        debugPrint(
                                            'Failed to parse deviceCount: ${item['deviceCount']}');
                                      }
                                    }
                                  }
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                            Text(
                                                S.current
                                                    .Device_Model_Distribution,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isShowDetail = false;
                                                });
                                              },
                                              child: Text(
                                                S.current.back,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 180,
                                            child: Echarts(
                                                option: jsonEncode({
                                              "zlevel": 11,
                                              "tooltip": {"trigger": 'item'},
                                              "color":
                                                  ColorList().lineColorList,
                                              "series": [
                                                {
                                                  'type': 'pie',
                                                  'center': ['50%', '50%'],
                                                  'radius': ['0%', '60%'],
                                                  'avoidLabelOverlap': false,
                                                  'itemStyle': {
                                                    'borderRadius': 0,
                                                    'borderColor':
                                                        'transparent',
                                                    'borderWidth': 10,
                                                  },
                                                  'label': {
                                                    'show': true,
                                                    // 'formatter':
                                                    //     '{b}: {c}个 ({d}%)',
                                                    'formatter': '{d}%',
                                                  },
                                                  'data': record.map((e) {
                                                    return {
                                                      "name":
                                                          e['deviceModelName'],
                                                      "value": e['deviceCount'],
                                                    };
                                                  }).toList(),
                                                },
                                              ]
                                            }))),
                                        // const SizedBox(height: 10),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  S.current.Device_Model,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  S.current.Device_Percent,
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                    S.current.Project_No,
                                                    style: const TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            ]),
                                        SizedBox(
                                          height: 200,
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              itemCount: record.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: Row(
                                                          children: [
                                                            //写一个颜色圆点
                                                            Container(
                                                              width: 10,
                                                              height: 10,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorList()
                                                                        .SerColorList[
                                                                    index],
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 3),
                                                            Expanded(
                                                              child: Text(
                                                                "${record[index]['deviceModelName']}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                            "${(record[index]['deviceCount'] / totalDeviceCount * 100).toStringAsFixed(2)}%"),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                            "${record[index]['itemCount']}"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              }),
                    ],
                  ),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
