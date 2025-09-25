import 'dart:async';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/toolview/flowing_line.dart';
import 'package:suncloudm/toolview/imports.dart';

class PvsingleHomePage extends StatefulWidget {
  const PvsingleHomePage({super.key});

  @override
  State<PvsingleHomePage> createState() => _PvsingleHomePageState();
}

class _PvsingleHomePageState extends State<PvsingleHomePage> {
  // int _powerDateType = 1;
  // int _incomeDateType = 1;
  String _status = '正常运行';

  Map<String, dynamic> topStationData = {};
  Map<String, dynamic> topInfoData = {};
  Map<String, dynamic> runInfoData = {};
  String? _itemPicUrl;

  String powerTime = date_format.formatDate(DateTime.now(),
      [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
  int powerTimeType = 0;

  String eleTime = date_format.formatDate(DateTime.now(),
      [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
  int eleTimeType = 0;

  String dfTime = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  int dfTimeType = 0;

  String icTime = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  int icTimeType = 0;

  Future<dynamic>? _pvSingleHomeTopInfoFuture;
  Future<dynamic>? _pvSingleHomePowerChartFuture;
  Future<dynamic>? _pvSingleHomeEnergyChartFuture;
  Future<dynamic>? _pvSingleHomeDayFullChartFuture;
  Future<dynamic>? _pvSingleHomeIncomeChartFuture;

  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _pvSingleHomeTopInfoFuture = getPvSingleHomeTopInfo();
    _pvSingleHomePowerChartFuture = getPvSingleHomePowerChart();
    _pvSingleHomeEnergyChartFuture = getPvSingleHomeEnergyChart();
    _pvSingleHomeDayFullChartFuture = getPvSingleHomeDayFullChart();
    _pvSingleHomeIncomeChartFuture = getPvSingleHomeIncomeChart();

    getHomeInfo();
    getCnSingleHomeStatus();
    getPvSingleHomeRunInfo();
    getItemUrlInfo();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getPvSingleHomeRunInfo();
      getCnSingleHomeStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> getPvSingleHomeTopInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getPvSingleHomeTopInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topInfoData = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPvSingleHomePowerChart() async {
    Map<String, dynamic> params = {};
    params['startTime'] = powerTime;
    var data = await IndexDao.getPvSingleHomePowerChart(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPvSingleHomeEnergyChart() async {
    Map<String, dynamic> params = {};
    params['startTime'] = eleTime;
    var data = await IndexDao.getPvSingleHomeEnergyChart(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPvSingleHomeDayFullChart() async {
    Map<String, dynamic> params = {};
    params['startTime'] = dfTime;
    var data = await IndexDao.getPvSingleHomeDayFullChart(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPvSingleHomeIncomeChart() async {
    Map<String, dynamic> params = {};
    params['startTime'] = icTime;
    var data = await IndexDao.getPvSingleHomeIncomeChart(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  getItemUrlInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getItemPicUrlInfo(params: params);
    if (data["code"] == 200) {
      List itemList = data['data'];
      if (itemList.isNotEmpty) {
        _itemPicUrl = itemList[0]['logoUrl'];
        setState(() {});
      }
    } else {}
  }

  getHomeInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getPvSingleHomeStationInfo(params: params);
    if (data["code"] == 200) {
      topStationData = data['data'];
      setState(() {});
    } else {}
  }

  getCnSingleHomeStatus() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnSingleHomeStatus(params: params);
    if (data["code"] == 200) {
      _status = data['data'];
      setState(() {});
    } else {}
  }

  getPvSingleHomeRunInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getPvSingleHomeRunInfo(params: params);
    if (data["code"] == 200) {
      runInfoData = data['data'];
      setState(() {});
    } else {}
  }

  Future<void> _refreshData() async {
    setState(() {
      _pvSingleHomeTopInfoFuture = getPvSingleHomeTopInfo();
      _pvSingleHomePowerChartFuture = getPvSingleHomePowerChart();
      _pvSingleHomeEnergyChartFuture = getPvSingleHomeEnergyChart();
      _pvSingleHomeDayFullChartFuture = getPvSingleHomeDayFullChart();
      _pvSingleHomeIncomeChartFuture = getPvSingleHomeIncomeChart();
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
                          future: _pvSingleHomeTopInfoFuture,
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.network(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'https://api.smartwuxi.com' +
                                              (_itemPicUrl ?? ''),
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container();
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                            "${topStationData['itemName'] ?? '--'}(${topStationData['installedCapacity'] ?? '--'})kWp",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Icon(
                                                _status == '正常运行'
                                                    ? Icons.gpp_good
                                                    : Icons.gpp_bad,
                                                color: _status == '正常运行'
                                                    ? Colors.green
                                                    : Colors.grey),
                                            const SizedBox(width: 3),
                                            Text(_status,
                                                style: TextStyle(
                                                  color: _status == '正常运行'
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  fontSize: 14,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
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
                                            Text(S.current.data_overview,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _cellView(
                                                "${S.current.today_toyear_PV_generation}(kWh)",
                                                "${topTotalData['daySum'] ?? '--'}/${topTotalData['yearSum'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            _cellView(
                                                "${S.current.total_generation_on_grid}(kWh)",
                                                "${topTotalData['totalSum'] ?? '--'}/${topTotalData['totalReverseSum'] ?? '--'}"),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _cellView(
                                                "${S.current.thismonth_total_carbon_reduction}(t)",
                                                "${topTotalData['monthCarbonReduction'] ?? '--'}/${topTotalData['totalCarbonReduction'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            _cellView(
                                                "${S.current.thismonth_total_Absorption_rate}(%)",
                                                "${topTotalData['monthRate'] ?? '--'}/${topTotalData['totalRate'] ?? '--'}"),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _cellView(
                                                "${S.current.revenue_today_toyear_total}(万元)",
                                                "${topTotalData['monthProfit'] ?? '--'}/${topTotalData['yearProfit'] ?? '--'}/${topTotalData['totalProfit'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            const Spacer()
                                          ],
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
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  width: 80,
                                  height: 130,
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/qyfh.png')),
                              CurrentLine(
                                direction: CurrentXDirection.bottomToTop,
                                width: 80,
                                height: (runInfoData['companyEp'] ?? 0) <= 0
                                    ? 0
                                    : 5,
                                lineColor: Colors.grey[400]!,
                                currentColor: const Color(0xFF24C18F),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HorizontaLine(
                                    width: 100,
                                    height:
                                        (runInfoData['dwEp'] ?? 0) == 0 ? 0 : 5,
                                    direction: (runInfoData['dwEp'] ?? 0) > 0
                                        ? CurrentDirection.leftToRight
                                        : CurrentDirection.rightToLeft,
                                    lineColor: Colors.grey[400]!,
                                    currentColor: const Color(0xFF24C18F),
                                    currentCount: 4,
                                    animationDuration:
                                        const Duration(seconds: 3),
                                  ),
                                  HorizontaLine(
                                    width: 100,
                                    height:
                                        (runInfoData['gfEp'] ?? 0) <= 0 ? 0 : 5,
                                    direction: (runInfoData['gfEp'] ?? 0) > 0
                                        ? CurrentDirection.rightToLeft
                                        : CurrentDirection.leftToRight,
                                    lineColor: Colors.grey[400]!,
                                    currentColor: const Color(0xFF24C18F),
                                    currentCount: 4,
                                    animationDuration:
                                        const Duration(seconds: 3),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CurrentLine(
                                    direction: (runInfoData['dwEp'] ?? 0) > 0
                                        ? CurrentXDirection.bottomToTop
                                        : CurrentXDirection.topToBottom,
                                    width: 80,
                                    height:
                                        (runInfoData['dwEp'] ?? 0) == 0 ? 0 : 5,
                                    lineColor: Colors.grey[400]!,
                                    currentColor: const Color(0xFF24C18F),
                                  ),
                                  const SizedBox(width: 200),
                                  CurrentLine(
                                    direction: (runInfoData['gfEp'] ?? 0) > 0
                                        ? CurrentXDirection.bottomToTop
                                        : CurrentXDirection.topToBottom,
                                    width: 80,
                                    height:
                                        (runInfoData['gfEp'] ?? 0) <= 0 ? 0 : 5,
                                    lineColor: Colors.grey[400]!,
                                    currentColor: const Color(0xFF24C18F),
                                  ),
                                ],
                              ),
                              Transform.translate(
                                offset: const Offset(0, -50),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                        width: 120,
                                        height: 150,
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/dwicon.png')),
                                    SizedBox(width: 120),
                                    Image(
                                        width: 120,
                                        height: 90,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/gfinfoIcon.png')),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                            children: [
                              const SizedBox(height: 50),
                              Transform.translate(
                                offset: const Offset(-110, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 140,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/qp07.png'),
                                          fit: BoxFit.fill)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            S.current.power,
                                            style: const TextStyle(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  "${runInfoData['companyEp'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const Text(
                                                "kW",
                                                style: TextStyle(
                                                  fontSize: 10,
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
                              const SizedBox(height: 300),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-20, 0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 170,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/qp08.png'),
                                              fit: BoxFit.fill)),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                S.current.power,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                S.current.energy_today,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                S.current.on_grid_today,
                                                style: const TextStyle(
                                                    fontSize: 10,
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
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      "${runInfoData['dwEp'] ?? '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "kW",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      "${runInfoData['dwEle'] ?? '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "kWh",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      "${runInfoData['gridEnergy'] ?? '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "kWh",
                                                    style: TextStyle(
                                                      fontSize: 10,
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
                                    offset: const Offset(30, -10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      width: 170,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/qp09.png'),
                                              fit: BoxFit.fill)),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    S.current.power,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                  Text(
                                                    S.current.gen_today,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                  Text(
                                                    S.current.ele_usage_today,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                  Text(
                                                    S.current
                                                        .absorption_rate_today,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                  Text(
                                                    S.current
                                                        .full_service_hours_today,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6),
                                                      child: Text(
                                                        "${runInfoData['gfEp'] ?? '--'}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "kW",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6),
                                                      child: Text(
                                                        "${runInfoData['gfEle'] ?? '--'}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "kWh",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6),
                                                      child: Text(
                                                        "${runInfoData['xnEnergy'] ?? '--'}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "kWh",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6),
                                                      child: Text(
                                                        "${runInfoData['todayRate'] ?? '--'}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "%",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6),
                                                      child: Text(
                                                        "${runInfoData['fullShippingHours'] ?? '--'}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "h",
                                                      style: TextStyle(
                                                        fontSize: 10,
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Transform.translate(
                                offset: const Offset(80, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: const Text(
                                    "负载",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 200),
                              Transform.translate(
                                offset: const Offset(-100, 0),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: const Text(
                                    "电网",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 0),
                              Transform.translate(
                                offset: const Offset(170, -10),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: const Text(
                                    "光伏",
                                    style: TextStyle(color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      //功率趋势
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
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        DateTime? d = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2030),
                                          locale: savedLanguage == 'zh'
                                              ? const Locale('zh')
                                              : const Locale('en'),
                                        );
                                        powerTime = date_format.formatDate(d!, [
                                          date_format.yyyy,
                                          '-',
                                          date_format.mm,
                                          '-',
                                          date_format.dd
                                        ]);
                                        setState(() {
                                          _pvSingleHomePowerChartFuture =
                                              getPvSingleHomePowerChart();
                                        });
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            powerTime,
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
                                const SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _pvSingleHomePowerChartFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                        height: 300,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  } else if (snapshot.hasError) {
                                    return SizedBox(
                                        height: 80,
                                        child: Center(
                                            child: Text(S.current.no_data)));
                                    ;
                                  } else if (snapshot.hasData) {
                                    Map lineChartData = snapshot.data;
                                    List xdata = lineChartData['dayXdata'];
                                    List yaxis =
                                        lineChartData['yesterdayData'] ?? [];
                                    List yaxis1 =
                                        lineChartData['todayData'] ?? [];
                                    List yaxis2 = lineChartData['sdData'] ?? [];
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
                                                S.current.yesterday_power,
                                                S.current.today_power,
                                                S.current.today_grid_power
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
                                                'name':
                                                    S.current.yesterday_power,
                                                "data": yaxis,
                                                "type": 'line',
                                                "smooth": true, // 是否让线条圆滑显示
                                                "symbol": 'none',
                                                "color": '#0F9CFF',
                                              },
                                              {
                                                'name': S.current.today_power,
                                                "data": yaxis1,
                                                "type": 'line',
                                                "smooth": true,
                                                "symbol": 'none', // 是否让线条圆滑显示
                                                "color": '#C666DE',
                                              },
                                              {
                                                'name':
                                                    S.current.today_grid_power,
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
                                Text(S.current.electricity_index,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (eleTimeType == 0) {
                                          DateTime? d = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2030),
                                            locale: savedLanguage == 'zh'
                                                ? const Locale('zh')
                                                : const Locale('en'),
                                          );
                                          if (d != null) {
                                            eleTime = date_format.formatDate(
                                                d, [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm,
                                              '-',
                                              date_format.dd
                                            ]);
                                            setState(() {
                                              _pvSingleHomeEnergyChartFuture =
                                                  getPvSingleHomeEnergyChart();
                                            });
                                          }
                                        } else if (eleTimeType == 1) {
                                          DateTime? d =
                                              await showMonthYearPicker(
                                            context: context,
                                            initialMonthYearPickerMode:
                                                MonthYearPickerMode.month,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2035),
                                            locale: savedLanguage == 'zh'
                                                ? const Locale('zh')
                                                : const Locale('en'),
                                          );
                                          if (d != null) {
                                            eleTime = date_format.formatDate(
                                                d, [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm
                                            ]);
                                            setState(() {
                                              _pvSingleHomeEnergyChartFuture =
                                                  getPvSingleHomeEnergyChart();
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
                                                    color: Colors.transparent,
                                                    child: YearPicker(
                                                      firstDate:
                                                          DateTime(2000, 5),
                                                      lastDate:
                                                          DateTime(2050, 5),
                                                      selectedDate:
                                                          DateTime.now(),
                                                      onChanged:
                                                          (DateTime value) {
                                                        eleTime = date_format
                                                            .formatDate(value, [
                                                          date_format.yyyy
                                                        ]);
                                                        setState(() {
                                                          _pvSingleHomeEnergyChartFuture =
                                                              getPvSingleHomeEnergyChart();
                                                        });
                                                        Navigator.pop(context);
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            eleTime,
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
                                  width: 120,
                                  child: MaterialSegmentedControl(
                                    horizontalPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 5),
                                    verticalOffset: 5,
                                    children: {
                                      0: Text(S.current.day),
                                      1: Text(S.current.month),
                                      2: Text(S.current.year)
                                    },
                                    selectionIndex: eleTimeType,
                                    borderColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    selectedColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    unselectedColor: Colors.white,
                                    selectedTextStyle:
                                        const TextStyle(color: Colors.white),
                                    unselectedTextStyle: const TextStyle(
                                        color:
                                            Color.fromRGBO(36, 193, 1435, 1)),
                                    borderWidth: 0.7,
                                    borderRadius: 32.0,
                                    onSegmentTapped: (index) {
                                      switch (index) {
                                        case 0:
                                          {
                                            eleTimeType = 0;
                                            eleTime = date_format.formatDate(
                                                DateTime.now(), [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm,
                                              '-',
                                              date_format.dd
                                            ]);
                                            setState(() {
                                              _pvSingleHomeEnergyChartFuture =
                                                  getPvSingleHomeEnergyChart();
                                            });
                                          }
                                        case 1:
                                          {
                                            eleTimeType = 1;
                                            eleTime = date_format.formatDate(
                                                DateTime.now(), [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm
                                            ]);
                                            setState(() {
                                              _pvSingleHomeEnergyChartFuture =
                                                  getPvSingleHomeEnergyChart();
                                            });
                                          }
                                        default:
                                          {
                                            eleTimeType = 2;
                                            eleTime = date_format.formatDate(
                                                DateTime.now(),
                                                [date_format.yyyy]);
                                            setState(() {
                                              _pvSingleHomeEnergyChartFuture =
                                                  getPvSingleHomeEnergyChart();
                                            });
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _pvSingleHomeEnergyChartFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                        height: 300,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  } else if (snapshot.hasError) {
                                    return SizedBox(
                                        height: 80,
                                        child: Center(
                                            child: Text(S.current.no_data)));
                                    ;
                                  } else if (snapshot.hasData) {
                                    Map lineChartData = snapshot.data;
                                    List xdata = lineChartData['xdata'];
                                    List yaxis = lineChartData['ydata'] ?? [];
                                    List yaxis1 = lineChartData['swData'] ?? [];
                                    List yaxis2 = lineChartData['xnData'] ?? [];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
                                            S.current.generation,
                                            S.current.on_grid,
                                            S.current.absorption_rate
                                          ],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 35,
                                          "left": 50,
                                          "bottom": 30,
                                        },
                                        "xAxis": {
                                          "type": 'category',
                                          "data": xdata,
                                        },
                                        "yAxis": [
                                          {
                                            "type": 'value',
                                            "name": 'kWh',
                                          },
                                          {
                                            "type": 'value',
                                            "name": '%',
                                          }
                                        ],
                                        "series": [
                                          {
                                            'name': S.current.generation,
                                            "data": yaxis,
                                            "type": 'bar',
                                            "yAxisIndex": 0,
                                            "color": '#61A643'
                                          },
                                          {
                                            'name': S.current.on_grid,
                                            "data": yaxis1,
                                            "type": 'bar',
                                            "yAxisIndex": 0,
                                            "color": '#0F9CFF'
                                          },
                                          {
                                            'name': S.current.absorption_rate,
                                            "data": yaxis2,
                                            "type": "line",
                                            "yAxisIndex": 1,
                                            "smooth": true,
                                            "symbol": 'none',
                                            "color": '#E9B815'
                                          },
                                        ]
                                      })),
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                Text(S.current.daily_full_generation_hours,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (dfTimeType == 0) {
                                          DateTime? d =
                                              await showMonthYearPicker(
                                            context: context,
                                            initialMonthYearPickerMode:
                                                MonthYearPickerMode.month,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2035),
                                            locale: savedLanguage == 'zh'
                                                ? const Locale('zh')
                                                : const Locale('en'),
                                          );
                                          if (d != null) {
                                            dfTime = date_format.formatDate(d, [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm
                                            ]);
                                            setState(() {
                                              _pvSingleHomeDayFullChartFuture =
                                                  getPvSingleHomeDayFullChart();
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
                                                    color: Colors.transparent,
                                                    child: YearPicker(
                                                      firstDate:
                                                          DateTime(2000, 5),
                                                      lastDate:
                                                          DateTime(2050, 5),
                                                      selectedDate:
                                                          DateTime.now(),
                                                      onChanged:
                                                          (DateTime value) {
                                                        dfTime = date_format
                                                            .formatDate(value, [
                                                          date_format.yyyy
                                                        ]);
                                                        setState(() {
                                                          _pvSingleHomeDayFullChartFuture =
                                                              getPvSingleHomeDayFullChart();
                                                        });
                                                        Navigator.pop(context);
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dfTime,
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
                                  width: 180,
                                  child: MaterialSegmentedControl(
                                    horizontalPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 5),
                                    verticalOffset: 5,
                                    children: {
                                      0: Text(S.current.month),
                                      1: Text(S.current.year),
                                    },
                                    selectionIndex: dfTimeType,
                                    borderColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    selectedColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    unselectedColor: Colors.white,
                                    selectedTextStyle:
                                        const TextStyle(color: Colors.white),
                                    unselectedTextStyle: const TextStyle(
                                        color:
                                            Color.fromRGBO(36, 193, 1435, 1)),
                                    borderWidth: 0.7,
                                    borderRadius: 32.0,
                                    onSegmentTapped: (index) {
                                      switch (index) {
                                        case 0:
                                          {
                                            dfTimeType = 0;
                                            dfTime = date_format.formatDate(
                                                DateTime.now(), [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm
                                            ]);
                                            setState(() {
                                              _pvSingleHomeDayFullChartFuture =
                                                  getPvSingleHomeDayFullChart();
                                            });
                                          }
                                        default:
                                          {
                                            dfTimeType = 1;
                                            dfTime = date_format.formatDate(
                                                DateTime.now(),
                                                [date_format.yyyy]);
                                            setState(() {
                                              _pvSingleHomeDayFullChartFuture =
                                                  getPvSingleHomeDayFullChart();
                                            });
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _pvSingleHomeDayFullChartFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                        height: 300,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  } else if (snapshot.hasError) {
                                    return SizedBox(
                                        height: 80,
                                        child: Center(
                                            child: Text(S.current.no_data)));
                                    ;
                                  } else if (snapshot.hasData) {
                                    Map lineChartData = snapshot.data;
                                    List xdata = lineChartData['xdata'];
                                    List yaxis =
                                        lineChartData['hourData'] ?? [];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 220,
                                      child: Echarts(
                                          option: jsonEncode({
                                        "zlevel": 11,
                                        "tooltip": {"trigger": 'axis'},
                                        "legend": {
                                          "show": false,
                                          "itemWidth": 10,
                                          "itemHeight": 10,
                                          "textStyle": {
                                            "fontSize": 12,
                                            "color": '#333'
                                          },
                                          "itemGap": 10,
                                          "data": ['日满发'],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 20,
                                          "left": 30,
                                          "bottom": 30,
                                        },
                                        "xAxis": {
                                          "type": 'category',
                                          "data": xdata,
                                        },
                                        "yAxis": [
                                          {
                                            "type": 'value',
                                            "name": 'h',
                                          },
                                        ],
                                        "series": [
                                          {
                                            'name': '日满发',
                                            "data": yaxis,
                                            "type": 'bar',
                                            "color": '#0F9CFF'
                                          }
                                        ]
                                      })),
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                Text(S.current.revenue_overview,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (icTimeType == 0) {
                                          DateTime? d =
                                              await showMonthYearPicker(
                                            context: context,
                                            initialMonthYearPickerMode:
                                                MonthYearPickerMode.month,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2035),
                                            locale: savedLanguage == 'zh'
                                                ? const Locale('zh')
                                                : const Locale('en'),
                                          );
                                          if (d != null) {
                                            icTime = date_format.formatDate(d, [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm
                                            ]);
                                            setState(() {
                                              _pvSingleHomeIncomeChartFuture =
                                                  getPvSingleHomeIncomeChart();
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
                                                    color: Colors.transparent,
                                                    child: YearPicker(
                                                      firstDate:
                                                          DateTime(2000, 5),
                                                      lastDate:
                                                          DateTime(2050, 5),
                                                      selectedDate:
                                                          DateTime.now(),
                                                      onChanged:
                                                          (DateTime value) {
                                                        icTime = date_format
                                                            .formatDate(value, [
                                                          date_format.yyyy
                                                        ]);
                                                        setState(() {
                                                          _pvSingleHomeIncomeChartFuture =
                                                              getPvSingleHomeIncomeChart();
                                                        });
                                                        Navigator.pop(context);
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            icTime,
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
                                  width: 120,
                                  child: MaterialSegmentedControl(
                                    horizontalPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 5),
                                    verticalOffset: 5,
                                    children: {
                                      0: Text(S.current.month),
                                      1: Text(S.current.year),
                                    },
                                    selectionIndex: icTimeType,
                                    borderColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    selectedColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    unselectedColor: Colors.white,
                                    selectedTextStyle:
                                        const TextStyle(color: Colors.white),
                                    unselectedTextStyle: const TextStyle(
                                        color:
                                            Color.fromRGBO(36, 193, 1435, 1)),
                                    borderWidth: 0.7,
                                    borderRadius: 32.0,
                                    onSegmentTapped: (index) {
                                      switch (index) {
                                        case 0:
                                          {
                                            icTimeType = 0;
                                            icTime = date_format.formatDate(
                                                DateTime.now(), [
                                              date_format.yyyy,
                                              '-',
                                              date_format.mm
                                            ]);
                                            setState(() {
                                              _pvSingleHomeIncomeChartFuture =
                                                  getPvSingleHomeIncomeChart();
                                            });
                                          }
                                        default:
                                          {
                                            icTimeType = 1;
                                            icTime = date_format.formatDate(
                                                DateTime.now(),
                                                [date_format.yyyy]);
                                            setState(() {
                                              _pvSingleHomeIncomeChartFuture =
                                                  getPvSingleHomeIncomeChart();
                                            });
                                          }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _pvSingleHomeIncomeChartFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                        height: 300,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  } else if (snapshot.hasError) {
                                    return SizedBox(
                                        height: 80,
                                        child: Center(
                                            child: Text(S.current.no_data)));
                                    ;
                                  } else if (snapshot.hasData) {
                                    Map lineChartData = snapshot.data;
                                    List xdata = lineChartData['xdata'];
                                    List yaxis =
                                        lineChartData['incomeData'] ?? [];
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
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
                                                  "${topInfoData['lastMonthProfit'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            Column(
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
                                                  "${topInfoData['monthProfit'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S.current.Total_revenue_10k,
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  "${topInfoData['totalProfit'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S.current
                                                      .dividend_revenue_10k,
                                                  style: const TextStyle(
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  "${lineChartData['fcProfit'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            )
                                          ],
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
                                              "itemHeight": 1,
                                              "textStyle": {
                                                "fontSize": 12,
                                                "color": '#333'
                                              },
                                              "itemGap": 10,
                                              "data": ['收益'],
                                              "inactiveColor": '#ccc'
                                            },
                                            "grid": {
                                              "right": 20,
                                              "left": 45,
                                              "bottom": 30,
                                            },
                                            "xAxis": {
                                              "type": 'category',
                                              "data": xdata,
                                            },
                                            "yAxis": [
                                              {
                                                "type": 'value',
                                                "name": '元',
                                                // "name":
                                                //     _incomeDateType == 1 ? '元' : '万元',
                                              },
                                            ],
                                            "series": [
                                              {
                                                'name': '收益',
                                                "data": yaxis,
                                                "type": "line",
                                                "smooth": true,
                                                "symbol": 'none',
                                                "color": '#E9B815'
                                              },
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
            ),
          ],
        ),
      ),
    );
  }

  _cellView(String title, String num) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
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
