import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/toolview/imports.dart';

class YysHomePage extends StatefulWidget {
  const YysHomePage({super.key});

  @override
  State<YysHomePage> createState() => _YysHomePageState();
}

class _YysHomePageState extends State<YysHomePage> {
  // Map<String, dynamic> topGeneralData = {};
  // Map<String, dynamic> topTotalData = {};
  int _currentDateType = 0;
  int _currentChartType = 0;

  int _compareDateType = 0;
  int _compareChartType = 0;

  Future<dynamic>? _indexNumFuture;
  Future<dynamic>? _yysHomeTopInfoFuture;
  Future<dynamic>? _yysHomeIncomeInfoFuture;
  Future<dynamic>? _yysHomeIncomeCompareFuture;
  // Future<dynamic>? _yysHomeDeviceListFuture;

  @override
  void initState() {
    super.initState();
    _indexNumFuture = getYysIndexNum();
    _yysHomeTopInfoFuture = getYysHomeTopInfo();
    _yysHomeIncomeInfoFuture = getYysHomeIncomeInfo();
    _yysHomeIncomeCompareFuture = getYysHomeIncomeCompare();
  }

  Future<Map<String, dynamic>> getYysIndexNum() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getYysIndexNum(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getYysHomeTopInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getYysHomeTopInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getYysHomeIncomeInfo() async {
    Map<String, dynamic> params = {};
    if (_currentDateType == 0) {
      params['type'] = 1;
    } else {
      params['type'] = 2;
    }
    var data = await IndexDao.getYysHomeIncomeInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getYysHomeIncomeCompare() async {
    Map<String, dynamic> params = {};
    if (_compareDateType == 0) {
      params['type'] = 1;
    } else {
      params['type'] = 2;
    }
    var data = await IndexDao.getYysHomeIncomeCompare(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _indexNumFuture = getYysIndexNum();
      _yysHomeTopInfoFuture = getYysHomeTopInfo();
      _yysHomeIncomeInfoFuture = getYysHomeIncomeInfo();
      _yysHomeIncomeCompareFuture = getYysHomeIncomeCompare();
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
                                Map topGeneralData = snapshot.data;
                                return Column(
                                  children: [
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
                                                          'assets/gfnumIcon.png')),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        S.current.project_num,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['totalNumber'] ?? "0"}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '',
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
                                          const SizedBox(width: 10),
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
                                                          'assets/gfnumIcon.png')),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        S.current.pv_num,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['pvNumber'] ?? "0"}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${topGeneralData['pvPower'] ?? "0"}MWp',
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
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    IntrinsicHeight(
                                      child: Row(
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
                                                          style: TextStyle(
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
                                                          style: TextStyle(
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
                            future: _yysHomeTopInfoFuture,
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
                                Map topTotalData = snapshot.data;
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
                                          Text(S.current.data_overview,
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
                                          _cellView(
                                              "${S.current.monitoring_load}(MW)",
                                              "${topTotalData['totalPower'] ?? '--'}"),
                                          const SizedBox(width: 15),
                                          _cellView(
                                              "${S.current.pv_today_total_generation}(kWh/MWh)",
                                              "${topTotalData['pvDayElect'] ?? '--'}/${topTotalData['pvTotalElect'] ?? '--'}"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _cellView(
                                              "${S.current.ess_charging_discharge_today}(kWh)",
                                              "${topTotalData['storageDayCharge'] ?? '--'}/${topTotalData['storageDayDischarge'] ?? '--'}"),
                                          const SizedBox(width: 15),
                                          _cellView(
                                              "${S.current.ess_total_charging_discharge}(MWh)",
                                              "${topTotalData['storageTotalCharge'] ?? '--'}/${topTotalData['storageTotalDischarge'] ?? '--'}"),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _cellView(
                                              "${S.current.today_total_revenue}(${S.current.yuan_per_tenk_RMB})",
                                              "${topTotalData['todayIncome'] ?? '--'}/${topTotalData['totalIncome'] ?? '--'}"),
                                          const SizedBox(width: 15),
                                          const Spacer(),
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
                            future: _yysHomeIncomeInfoFuture,
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
                                Map lineChartData = snapshot.data;
                                List xdata = lineChartData['xdata'];
                                List yaxis = lineChartData['pvData'] ?? [];
                                List yaxis1 =
                                    lineChartData['storageData'] ?? [];
                                List yaxis2 = lineChartData['chargeData'] ?? [];
                                if (yaxis2.isEmpty) {
                                  yaxis2 = yaxis.map((e) => 0).toList();
                                }
                                return Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 18,
                                          child: VerticalDivider(
                                            thickness: 3,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(S.current.revenue_overview,
                                            style: TextStyle(
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
                                                style: TextStyle(
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
                                                style: TextStyle(
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
                                                style: TextStyle(
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
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _currentChartType = 0;
                                              });
                                            },
                                            icon: const Icon(Icons.bar_chart),
                                            color: _currentChartType == 0
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _currentChartType = 1;
                                              });
                                            },
                                            icon: const Icon(Icons.table_chart),
                                            color: _currentChartType == 1
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: 120,
                                            child: MaterialSegmentedControl(
                                              verticalOffset: 5,
                                              children: {
                                                0: Text(S.current.month),
                                                1: Text(S.current.year)
                                              },
                                              selectionIndex: _currentDateType,
                                              borderColor: const Color.fromRGBO(
                                                  36, 193, 143, 1),
                                              selectedColor:
                                                  const Color.fromRGBO(
                                                      36, 193, 143, 1),
                                              unselectedColor: Colors.white,
                                              selectedTextStyle:
                                                  const TextStyle(
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
                                                        _yysHomeIncomeInfoFuture =
                                                            getYysHomeIncomeInfo();
                                                      });
                                                    }
                                                  case 1:
                                                    {
                                                      _currentDateType = 1;
                                                      setState(() {
                                                        _yysHomeIncomeInfoFuture =
                                                            getYysHomeIncomeInfo();
                                                      });
                                                    }
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _currentChartType == 0
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                  S.current.PV_revenue,
                                                  S.current.ESS_revenue,
                                                  S.current.Charger_revenue
                                                ],
                                                "inactiveColor": '#ccc'
                                              },
                                              "grid": {
                                                "right": 20,
                                                "bottom": 30,
                                              },
                                              "xAxis": {
                                                'nameGap': '5',
                                                "name": _currentDateType == 0
                                                    ? S.current.day
                                                    : S.current.month,
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
                                                  'name': S.current.PV_revenue,
                                                  "data": yaxis,
                                                  "type": 'bar',
                                                  // "smooth": true, // 是否让线条圆滑显示
                                                  "color": '#61A643'
                                                },
                                                {
                                                  'name': S.current.ESS_revenue,
                                                  "data": yaxis1,
                                                  "type": 'bar',
                                                  // "smooth": true, // 是否让线条圆滑显示
                                                  "color": '#0F9CFF'
                                                },
                                                {
                                                  'name':
                                                      S.current.Charger_revenue,
                                                  "data": yaxis2,
                                                  "type": "bar",
                                                  "color": '#EC8674'
                                                },
                                              ]
                                            })),
                                          )
                                        : Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: Text(
                                                      _currentDateType == 0
                                                          ? "日期"
                                                          : "月份",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      "${S.current.pv}(万元)",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      "${S.current.ess}(万元)",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      "${S.current.charger}(万元)",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFF8693AB)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 200,
                                                child: Scrollbar(
                                                  child: ListView.builder(
                                                    itemCount: xdata.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: 40,
                                                                  child: Text(
                                                                    "${xdata[index] ?? "--"}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 80,
                                                                  child: Text(
                                                                    "${yaxis[index] ?? "--"}",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 80,
                                                                  child: Text(
                                                                    "${yaxis1[index] ?? "--"}",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 80,
                                                                  child: Text(
                                                                    "${yaxis2[index] ?? "--"}",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 3),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                  ]),
                                );
                              }
                              return Container();
                            }),
                        const SizedBox(height: 10),
                        FutureBuilder(
                            future: _yysHomeIncomeCompareFuture,
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
                                Map lineChartData = snapshot.data;
                                List xdata = lineChartData['xdata'];
                                List yaxis = lineChartData['incomeList'] ?? [];
                                List yaxis1 =
                                    lineChartData['operationList'] ?? [];
                                List yaxis2 = lineChartData['addList'] ?? [];
                                List yaxis3 =
                                    lineChartData['offlineList'] ?? [];
                                return Container(
                                  padding: const EdgeInsets.all(6.0),
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
                                          Text(
                                              S.current
                                                  .revenue_YoY_MoM_analysis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _compareChartType = 0;
                                                });
                                              },
                                              icon: const Icon(Icons.bar_chart),
                                              color: _compareChartType == 0
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _compareChartType = 1;
                                                });
                                              },
                                              icon:
                                                  const Icon(Icons.table_chart),
                                              color: _compareChartType == 1
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            SizedBox(
                                              width: 120,
                                              child: MaterialSegmentedControl(
                                                verticalOffset: 5,
                                                children: {
                                                  0: Text(S.current.to_month),
                                                  1: Text(S.current.to_year)
                                                },
                                                selectionIndex:
                                                    _compareDateType,
                                                borderColor:
                                                    const Color.fromRGBO(
                                                        36, 193, 143, 1),
                                                selectedColor:
                                                    const Color.fromRGBO(
                                                        36, 193, 143, 1),
                                                unselectedColor: Colors.white,
                                                selectedTextStyle:
                                                    const TextStyle(
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
                                                        _compareDateType = 0;
                                                        setState(() {
                                                          _yysHomeIncomeCompareFuture =
                                                              getYysHomeIncomeCompare();
                                                        });
                                                      }
                                                    case 1:
                                                      {
                                                        _compareDateType = 1;
                                                        setState(() {
                                                          _yysHomeIncomeCompareFuture =
                                                              getYysHomeIncomeCompare();
                                                        });
                                                      }
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _compareChartType == 0
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 220,
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
                                                    S.current.revenue,
                                                    S.current
                                                        .operational_projects,
                                                    S.current.new_projects,
                                                    S.current.retired_projects,
                                                  ],
                                                  "inactiveColor": '#ccc'
                                                },
                                                "grid": {
                                                  "right": 30,
                                                  "left": 40,
                                                  "bottom": 30,
                                                  // "top": 60,
                                                },
                                                "xAxis": [
                                                  {
                                                    "type": 'category',
                                                    "data": xdata,
                                                    'nameGap': '5',
                                                  }
                                                ],
                                                "yAxis": [
                                                  {
                                                    "type": 'value',
                                                    "name": S.current.tenk_RMB,
                                                  },
                                                  {
                                                    "type": 'value',
                                                    "name": S.current.num,
                                                  }
                                                ],
                                                "series": [
                                                  {
                                                    'name': S.current.revenue,
                                                    "data": yaxis,
                                                    "type": 'line',
                                                    "smooth": true,
                                                    "yAxisIndex": 0,
                                                    "symbol": 'none',
                                                    "color": '#61A643'
                                                  },
                                                  {
                                                    'name': S.current
                                                        .operational_projects,
                                                    "data": yaxis1,
                                                    "type": "bar",
                                                    "yAxisIndex": 1,
                                                    "color": '#0F9CFF',
                                                    'stack': 'project',
                                                  },
                                                  {
                                                    'name':
                                                        S.current.new_projects,
                                                    "data": yaxis2,
                                                    "type": "bar",
                                                    "yAxisIndex": 1,
                                                    "color": '#E9B815',
                                                    'stack': 'project',
                                                  },
                                                  {
                                                    'name': S.current
                                                        .retired_projects,
                                                    "data": yaxis3,
                                                    "type": "bar",
                                                    "yAxisIndex": 1,
                                                    "color": '#EC8674',
                                                    'stack': 'project',
                                                  },
                                                ]
                                              })),
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 40,
                                                      child: Text(
                                                        _compareDateType == 0
                                                            ? "日期"
                                                            : "月份",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        "收益(万元)",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        "投运项目(个)",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        "项目新增(个)",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        "下线项目(个)",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF8693AB)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 200,
                                                  child: Scrollbar(
                                                    child: ListView.builder(
                                                      itemCount: xdata.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 40,
                                                                    child: Text(
                                                                      "${xdata[index] ?? "--"}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: Text(
                                                                      "${yaxis[index] ?? "--"}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: Text(
                                                                      "${yaxis1[index] ?? "--"}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: Text(
                                                                      "${yaxis2[index] ?? "--"}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: Text(
                                                                      "${yaxis3[index] ?? "--"}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 3),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }),
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
