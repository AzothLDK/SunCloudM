import 'dart:convert';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/toolview/appColor.dart';
import 'package:suncloudm/toolview/deviceTypeToName.dart';
import 'package:suncloudm/toolview/language_resource.dart';

class BossHomePage extends StatefulWidget {
  const BossHomePage({super.key});

  @override
  State<BossHomePage> createState() => _BossHomePageState();
}

class _BossHomePageState extends State<BossHomePage> {
  Map userInfo = jsonDecode(
      GlobalStorage.getLoginInfo()!); //"项目类型 1：微网项目 2：储能项目 3：光伏项目 4: 充电桩项目")
  String? singleId = GlobalStorage.getSingleId();
  Map<String, dynamic> topGeneralData = {};
  Map<String, dynamic> topTotalData = {};
  Map<String, dynamic> topIncomeData = {};
  int _currentDateType = 0;
  // int _deviceType = 3;
  int todayCount = 0;

  Future<dynamic>? _indexNumFuture;
  Future<dynamic>? _bossHomeTopInfoFuture;
  Future<dynamic>? _bossHomeIncomeInfoFuture;
  Future<dynamic>? _bossHomeInvestInfoFuture;
  Future<dynamic>? _bossHomeDeviceListFuture;
  Future<dynamic>? _bossHomeDevicedetailFuture;

  @override
  void initState() {
    super.initState();
    _indexNumFuture = getIndexNum();
    _bossHomeTopInfoFuture = getBossHomeTopInfo();
    _bossHomeIncomeInfoFuture = getBossHomeIncomeInfo();
    _bossHomeInvestInfoFuture = getBossHomeInvestInfo();
    _bossHomeDeviceListFuture = getBossHomeDeviceList();
    _bossHomeDevicedetailFuture = getDeviceModelDistribution();
  }

  Future<Map<String, dynamic>> getIndexNum() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getIndexNum(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topGeneralData = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getBossHomeTopInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getBossHomeTopInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topTotalData = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getBossHomeIncomeInfo() async {
    Map<String, dynamic> params = {};
    if (_currentDateType == 0) {
      params['time'] = date_format
          .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
    } else {
      params['time'] = DateTime.now().year.toString();
    }
    var data = await IndexDao.getBossHomeIncomeInfo(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getBossHomeInvestInfo({int? deviceType}) async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getBossHomeInvestInfo(params: params);
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
      _indexNumFuture = getIndexNum();
      _bossHomeTopInfoFuture = getBossHomeTopInfo();
      _bossHomeIncomeInfoFuture = getBossHomeIncomeInfo();
      _bossHomeInvestInfoFuture = getBossHomeInvestInfo();
      _bossHomeDeviceListFuture = getBossHomeDeviceList();
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
                            future: _indexNumFuture,
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
                                                Center(
                                                  child: Text(
                                                    S.current.project_num,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Center(
                                                  child: Text(
                                                    '${topGeneralData['totalNumber'] ?? "0"}',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Center(
                                                  child: Text(
                                                    '${topGeneralData['totalPower'] ?? "0"}MW/${topGeneralData['totalCapacity'] ?? "0"}MWh',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF8693AB),
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
                                                    Text(
                                                      S.current.mg_num,
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                    Text(
                                                      '${topGeneralData['microgridNumber'] ?? "0"}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${topGeneralData['microgridPower'] ?? "0"}MW/${topGeneralData['microgridCapacity'] ?? "0"}MWh',
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
                                                    Text(
                                                      S.current.pv_num,
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                    Text(
                                                      '${topGeneralData['pvNumber'] ?? "0"}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${topGeneralData['pvPower'] ?? "0"}MWp',
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
                                                      BorderRadius.circular(
                                                          10)),
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
                                                        Text(
                                                          S.current.ess_num,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF8693AB)),
                                                        ),
                                                        Text(
                                                          '${topGeneralData['storageNumber'] ?? "0"}',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${topGeneralData['storagePower'] ?? "0"}MW/${topGeneralData['storageCapacity'] ?? "0"}MWh',
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
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                        Text(
                                                          S.current.charger_num,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF8693AB)),
                                                        ),
                                                        Text(
                                                          '${topGeneralData['chargeNumber'] ?? "0"}',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${topGeneralData['chargePower'] ?? "0"}MW',
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
                        FutureBuilder(
                            future: _bossHomeTopInfoFuture,
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
                                          const SizedBox(
                                            height: 18,
                                            child: VerticalDivider(
                                              thickness: 3,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Text(S.current.data_overview,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _cellView(
                                              "${S.current.generation_power}(MW)",
                                              "${topTotalData['powerLoad'] ?? '--'}"),
                                          const SizedBox(width: 10),
                                          _cellView(
                                              "${S.current.monitoring_load}(MW)",
                                              "${topTotalData['totalPower'] ?? '--'}"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _cellView(
                                              "${S.current.adjustable_load}(MW)",
                                              "${topTotalData['adjustPower'] ?? '--'}"),
                                          const SizedBox(width: 10),
                                          _cellView(S.current.todayTotalRevenue,
                                              "${topTotalData['todayIncome'] ?? '--'}/${topTotalData['totalIncome'] ?? '--'}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }),
                        const SizedBox(height: 10),
                        FutureBuilder(
                            future: _bossHomeIncomeInfoFuture,
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
                              } else if (snapshot.hasData) {
                                Map lineChartData = snapshot.data;
                                List xdata = lineChartData['xdata'];
                                List yaxis = lineChartData['pvData'] ?? [];
                                List yaxis1 =
                                    lineChartData['storageData'] ?? [];
                                List yaxis2 = lineChartData['chargeData'] ?? [];
                                return Container(
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
                                          Text(S.current.revenue_overview,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S.current
                                                      .Last_Month_revenue_10k,
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  "${lineChartData['lastMonthIncome'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S.current
                                                      .This_Month_revenue_10k,
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  "${lineChartData['thisMonthIncome'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S.current.Total_revenue_10k,
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  "${lineChartData['totalIncome'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          width: 130,
                                          child: MaterialSegmentedControl(
                                            verticalOffset: 5,
                                            children: {
                                              0: Text(S.current.month),
                                              1: Text(S.current.year)
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

                                                    setState(() {
                                                      _bossHomeIncomeInfoFuture =
                                                          getBossHomeIncomeInfo();
                                                    });
                                                  }
                                                case 1:
                                                  {
                                                    _currentDateType = 1;
                                                    setState(() {
                                                      _bossHomeIncomeInfoFuture =
                                                          getBossHomeIncomeInfo();
                                                    });
                                                  }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 220,
                                        child: Echarts(
                                            option: jsonEncode({
                                          "zlevel": 11,
                                          "tooltip": {"trigger": 'axis'},
                                          "legend": {
                                            "itemWidth": 10,
                                            "itemHeight": 10,
                                            "textStyle": {
                                              "fontSize": 12,
                                              "color": '#333'
                                            },
                                            "itemGap": 10,
                                            "data": [
                                              S.current.pv,
                                              S.current.ess,
                                              S.current.charger
                                            ],
                                            "inactiveColor": '#ccc'
                                          },
                                          "grid": {
                                            "right": 10,
                                            "bottom": 30,
                                          },
                                          "xAxis": {
                                            "type": 'category',
                                            "data": xdata,
                                          },
                                          "yAxis": [
                                            {
                                              "type": 'value',
                                              "name": S.current.tenk_RMB,
                                            }
                                          ],
                                          "series": [
                                            {
                                              'name': S.current.pv,
                                              "data": yaxis,
                                              "type": 'bar',
                                              // "smooth": true, // 是否让线条圆滑显示
                                              "color": '#61A643'
                                            },
                                            {
                                              'name': S.current.ess,
                                              "data": yaxis1,
                                              "type": 'bar',
                                              // "smooth": true, // 是否让线条圆滑显示
                                              "color": '#0F9CFF'
                                            },
                                            {
                                              'name': S.current.charger,
                                              "data": yaxis2,
                                              "type": "bar",
                                              "color": '#EC8674'
                                            },
                                          ]
                                        })),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }),
                        const SizedBox(height: 10),
                        FutureBuilder(
                            future: _bossHomeInvestInfoFuture,
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
                              } else if (snapshot.hasData) {
                                Map lineChartData = snapshot.data;
                                List xdata = lineChartData['xdata'];
                                List yaxis = lineChartData['tzData'] ?? [];
                                List yaxis1 = lineChartData['tzAddData'] ?? [];
                                List yaxis2 = lineChartData['xmData'] ?? [];
                                List yaxis3 = lineChartData['xmAddData'] ?? [];
                                List yaxis4 = lineChartData['tyData'] ?? [];
                                return Container(
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
                                          Text(S.current.investment_summary,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 250,
                                        child: Echarts(
                                            option: jsonEncode({
                                          "zlevel": 11,
                                          "tooltip": {"trigger": 'axis'},
                                          "legend": {
                                            "itemWidth": 10,
                                            "itemHeight": 10,
                                            "textStyle": {
                                              "fontSize": 11,
                                              "color": '#333'
                                            },
                                            "itemGap": 5,
                                            "data": [
                                              S.current.investment_amount,
                                              S.current.amount_increase,
                                              S.current.operational_projects,
                                              S.current.new_projects,
                                              S.current.retired_projects
                                            ],
                                            "inactiveColor": '#ccc'
                                          },
                                          "grid": {
                                            "right": 40,
                                            "left": 45,
                                            "bottom": 30,
                                            // "top": 70,
                                          },
                                          "xAxis": {
                                            "type": 'category',
                                            "data": xdata,
                                          },
                                          "yAxis": [
                                            {
                                              "type": 'value',
                                              "name": S.current.tenk_RMB,
                                            },
                                            {
                                              "type": 'value',
                                              "name": '个',
                                            }
                                          ],
                                          "series": [
                                            {
                                              'name':
                                                  S.current.investment_amount,
                                              "data": yaxis,
                                              "type": 'bar',
                                              "yAxisIndex": 0,
                                              "smooth": true, // 是否让线条圆滑显示
                                              "color": '#0F9CFF',
                                              'stack': 'money',
                                            },
                                            {
                                              'name': S.current.amount_increase,
                                              "data": yaxis1,
                                              "type": 'bar',
                                              "yAxisIndex": 0,
                                              // "smooth": true, // 是否让线条圆滑显示
                                              "color": '#C666DE',
                                              'stack': 'money',
                                            },
                                            {
                                              'name': S
                                                  .current.operational_projects,
                                              "data": yaxis2,
                                              "type": "bar",
                                              "yAxisIndex": 1,
                                              "color": '#61A643',
                                              'stack': 'project',
                                            },
                                            {
                                              'name': S.current.new_projects,
                                              "data": yaxis3,
                                              "type": "bar",
                                              "yAxisIndex": 1,
                                              "color": '#F6864E',
                                              'stack': 'project',
                                            },
                                            {
                                              'name':
                                                  S.current.retired_projects,
                                              "data": yaxis4,
                                              "type": "bar",
                                              "yAxisIndex": 1,
                                              "color": '#84C7ED',
                                              'stack': 'project',
                                            },
                                          ]
                                        })),
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
                                            child:
                                                CircularProgressIndicator()));
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
                                                        "value":
                                                            e['deviceCount'],
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      S.current.Device_No,
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
                                                          .symmetric(
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
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
                                                                  style: const TextStyle(
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
                                            child:
                                                CircularProgressIndicator()));
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
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back),
                                                onPressed: () {
                                                  setState(() {
                                                    isShowDetail = false;
                                                  });
                                                },
                                              ),
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
                                                        "name": e[
                                                            'deviceModelName'],
                                                        "value":
                                                            e['deviceCount'],
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                            BorderRadius
                                                                .circular(10)),
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
                                                                  style: const TextStyle(
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

                        // FloatingActionButton(
                        //   child: const Icon(Icons.refresh),
                        //   onPressed: () {
                        //     // 刷新数据
                        //     setState(() {
                        //       // _indexNumFuture = getIndexNum();
                        //       // _bossHomeTopInfoFuture = getBossHomeTopInfo();
                        //       _bossHomeInvestInfoFuture = getBossHomeInvestInfo();
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  )),
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

class ProgressIndicatorDotPainter extends CustomPainter {
  final Color progressColor;
  final Color dotColor;
  final double progressValue;

  ProgressIndicatorDotPainter({
    this.progressColor = Colors.blue,
    this.dotColor = Colors.red,
    this.progressValue = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double progressWidth = size.width * progressValue;

    final Paint progressPaint2 = Paint()
      ..color = const Color(0xFFEDF1F7)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(6),
        ),
        progressPaint2);

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, progressWidth, size.height),
          const Radius.circular(6),
        ),
        progressPaint);

    final Paint borderPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // 计算圆点的位置
    // final double dotRadius = 6;
    // final Offset dotOffset =
    //     Offset(progressWidth - dotRadius / 2 + 5, size.height / 2);

    // canvas.drawCircle(dotOffset, dotRadius, borderPaint);
    // canvas.drawCircle(dotOffset, dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
