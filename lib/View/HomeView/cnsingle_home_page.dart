import 'dart:async';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/toolview/flowing_line.dart';
import 'package:suncloudm/toolview/imports.dart';

class CnsingleHomePage extends StatefulWidget {
  const CnsingleHomePage({super.key});

  @override
  State<CnsingleHomePage> createState() => _CnsingleHomePageState();
}

class _CnsingleHomePageState extends State<CnsingleHomePage> {
  int _currentDateType = 1;
  int _incomeDateType = 1;
  String _status = S.current.normal;
  String? _itemPicUrl;

  Map<String, dynamic> topTotalData = {};
  Map<String, dynamic> runInfoData = {};
  Map<String, dynamic> incomeInfoData = {};

  Future<dynamic>? _cnSingleHomeTopInfoFuture;
  Future<dynamic>? _cnSingleHomePowerChartFuture;
  Future<dynamic>? _cnSingleHomeEnergyChartFuture;
  Future<dynamic>? _cnSingleHomeIncomeChartFuture;

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _cnSingleHomeTopInfoFuture = getCnSingleHomeTopInfo();
    _cnSingleHomePowerChartFuture = getCnSingleHomePowerChart();
    _cnSingleHomeEnergyChartFuture = getCnSingleHomeEnergyChart();
    _cnSingleHomeIncomeChartFuture = getCnSingleHomeIncomeChart();
    // _cnSingleHomeRunInfoFuture = getCnSingleHomeRunInfo();
    getCnSingleHomeRunInfo();
    getCnSingleHomeStatus();
    getCnSingleHomeIncomeInfo();
    getItemUrlInfo();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getCnSingleHomeRunInfo();
      getCnSingleHomeStatus();
    });
  }

  Future<Map<String, dynamic>> getCnSingleHomeTopInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnSingleHomeTopInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topTotalData = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCnSingleHomePowerChart() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnSingleHomePowerChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCnSingleHomeEnergyChart() async {
    Map<String, dynamic> params = {};
    params['timeType'] = _currentDateType;
    var data = await IndexDao.getCnSingleHomeEnergyChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCnSingleHomeIncomeChart() async {
    Map<String, dynamic> params = {};
    params['timeType'] = _incomeDateType;
    var data = await IndexDao.getCnSingleHomeIncomeChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  getCnSingleHomeRunInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnSingleHomeRunInfo(params: params);
    if (data["code"] == 200) {
      runInfoData = data['data'];
      setState(() {});
    } else {}
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

  getCnSingleHomeIncomeInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnSingleHomeIncomeInfo(params: params);
    if (data["code"] == 200) {
      incomeInfoData = data['data'];
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _cnSingleHomeTopInfoFuture = getCnSingleHomeTopInfo();
      _cnSingleHomePowerChartFuture = getCnSingleHomePowerChart();
      _cnSingleHomeEnergyChartFuture = getCnSingleHomeEnergyChart();
      _cnSingleHomeIncomeChartFuture = getCnSingleHomeIncomeChart();
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
                          future: _cnSingleHomeTopInfoFuture,
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
                                            "${topTotalData['stationName'] ?? '--'}(${topTotalData['power'] ?? '--'}MW/${topTotalData['capacity'] ?? '--'}MWh)",
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
                                            Text(S.current.running_data,
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
                                                "${S.current.total_charging}(MWh)",
                                                "${topTotalData['chargeTotal'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            _cellView(
                                                "${S.current.total_discharge}(MWh)",
                                                "${topTotalData['dischargeTotal'] ?? '--'}"),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _cellView(
                                                "${S.current.charging_capacity}(kWh)",
                                                "${topTotalData['chargeAvailable'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            _cellView(
                                                "${S.current.discharging_capacity}(kWh)",
                                                "${topTotalData['dischargeAvailable'] ?? '--'}"),
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
                                height: (runInfoData['loadPower'] ?? 0) > 0 ||
                                        runInfoData['status']?.toString() ==
                                            '3' ||
                                        (runInfoData['gridOutPower'] ?? 0) > 0
                                    ? 5
                                    : 0,
                                lineColor: Colors.grey[400]!,
                                currentColor: const Color(0xFF24C18F),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HorizontaLine(
                                    width: 100,
                                    height:
                                        (runInfoData['gridOutPower'] ?? 0) == 0
                                            ? 0
                                            : 5,
                                    direction:
                                        (runInfoData['gridOutPower'] ?? 0) > 0
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
                                        runInfoData['status']?.toString() == '1'
                                            ? 0
                                            : 5,
                                    direction:
                                        runInfoData['status']?.toString() == '2'
                                            ? CurrentDirection.leftToRight
                                            : CurrentDirection.rightToLeft,
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
                                    direction:
                                        (runInfoData['gridOutPower'] ?? 0) > 0
                                            ? CurrentXDirection.bottomToTop
                                            : CurrentXDirection.topToBottom,
                                    width: 80,
                                    height:
                                        (runInfoData['gridOutPower'] ?? 0) == 0
                                            ? 0
                                            : 5,
                                    lineColor: Colors.grey[400]!,
                                    currentColor: const Color(0xFF24C18F),
                                  ),
                                  const SizedBox(width: 200),
                                  CurrentLine(
                                    direction:
                                        runInfoData['status']?.toString() == '2'
                                            ? CurrentXDirection.topToBottom
                                            : CurrentXDirection.bottomToTop,
                                    width: 80,
                                    height:
                                        runInfoData['status']?.toString() == '1'
                                            ? 0
                                            : 5,
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
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/cninfoIcon.png')),
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
                                  width: 130,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  "${runInfoData['loadPower'] ?? '--'}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
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
                                      child: IntrinsicHeight(
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
                                                  S.current
                                                      .electricity_consumption_today,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  S.current.monthly_peak_demand,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF8693AB)),
                                                ),
                                                Text(
                                                  S.current.occurrence_time,
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
                                                        "${runInfoData['gridOutPower'] ?? '--'}",
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
                                                        "${runInfoData['gridOutDaily'] ?? '--'}",
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
                                                        "${runInfoData['gridMeterMaximumdemand'] ?? '--'}",
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
                                                        "${runInfoData['maximumdemandTime'] ?? '--'}",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "",
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
                                  Transform.translate(
                                    offset: const Offset(30, -10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      width: 150,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/qp09.png'),
                                              fit: BoxFit.fill)),
                                      child: Row(
                                        children: [
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "状态",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                "功率",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                "SOC",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                "日充电量",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                "日放电量",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                "总充电量",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                "总放电量",
                                                style: TextStyle(
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final currentValue =
                                                            runInfoData['status']
                                                                    ?.toString() ??
                                                                '--';
                                                        Color textColor;
                                                        switch (currentValue) {
                                                          case '1':
                                                            textColor =
                                                                Colors.grey;
                                                            return Text(
                                                                S.current
                                                                    .standby,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor));
                                                          case '2':
                                                            textColor =
                                                                Colors.blue;
                                                            return Text(
                                                                S.current
                                                                    .charge,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor));
                                                          case '3':
                                                            textColor =
                                                                Colors.green;
                                                            return Text(
                                                                S.current
                                                                    .discharge,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor));
                                                          default:
                                                            textColor =
                                                                Colors.black;
                                                            return Text("--",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor));
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Text(" ",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      "${runInfoData['p'] ?? '--'}",
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
                                                      "${runInfoData['soc'] ?? '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                      "${runInfoData['edc'] ?? '--'}",
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
                                                      "${runInfoData['edf'] ?? '--'}",
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
                                                      "${runInfoData['ec'] ?? '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${runInfoData['ecUnit'] ?? '--'}",
                                                    style: const TextStyle(
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
                                                      "${runInfoData['ef'] ?? '--'}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${runInfoData['efUnit'] ?? '--'}",
                                                    style: const TextStyle(
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
                                  width: 95,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    S.current.enterprise_load,
                                    style: const TextStyle(
                                        color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 190),
                              Transform.translate(
                                offset: const Offset(-100, 0),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    S.current.grid,
                                    style: const TextStyle(
                                        color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 0),
                              Transform.translate(
                                offset: const Offset(170, 0),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    S.current.ess,
                                    style: const TextStyle(
                                        color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                          future: _cnSingleHomePowerChartFuture,
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
                              List yaxis = lineChartData['ydata1'] ?? [];
                              List yaxis1 = lineChartData['ydata2'] ?? [];
                              List yaxis2 =
                                  lineChartData['ydataYesTodayGk'] ?? [];
                              List yaxis3 = lineChartData['ydataGk'] ?? [];
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
                                        Text(S.current.power_curve,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
                                            S.current.yesterday,
                                            S.current.today,
                                            S.current.yesterday_grid,
                                            S.current.today_grid
                                          ],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 40,
                                          "left": 45,
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
                                          },
                                          {
                                            "type": 'value',
                                            "name": 'kW',
                                          },
                                        ],
                                        "series": [
                                          {
                                            'name': S.current.yesterday,
                                            "data": yaxis,
                                            "type": 'line',
                                            "smooth": true, // 是否让线条圆滑显示
                                            "yAxisIndex": 0,
                                            "symbol": 'none',
                                            "color": '#0F9CFF',
                                          },
                                          {
                                            'name': S.current.today,
                                            "data": yaxis1,
                                            "type": 'line',
                                            "smooth": true, // 是否让线条圆滑显示
                                            "yAxisIndex": 0,
                                            "symbol": 'none',
                                            "color": '#C666DE',
                                          },
                                          {
                                            'name': S.current.yesterday_grid,
                                            "data": yaxis2,
                                            "type": "line",
                                            "smooth": true,
                                            "symbol": 'none',
                                            "yAxisIndex": 1,
                                            "color": '#61A643',
                                          },
                                          {
                                            'name': S.current.today_grid,
                                            "data": yaxis3,
                                            "type": "line",
                                            "smooth": true,
                                            "symbol": 'none',
                                            "yAxisIndex": 1,
                                            "color": '#F6864E',
                                          }
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
                          future: _cnSingleHomeEnergyChartFuture,
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
                              List yaxis = lineChartData['ydataCharge'] ?? [];
                              List yaxis1 =
                                  lineChartData['ydataDisCharge'] ?? [];
                              List yaxis2 =
                                  lineChartData['ydataChargeRatio'] ?? [];
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
                                        Text(S.current.electricity_index,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    // const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width: 120,
                                        child: MaterialSegmentedControl(
                                          verticalOffset: 5,
                                          children: {
                                            1: Text(S.current.month),
                                            2: Text(S.current.year)
                                          },
                                          selectionIndex: _currentDateType,
                                          borderColor: const Color.fromRGBO(
                                              36, 193, 143, 1),
                                          selectedColor: const Color.fromRGBO(
                                              36, 193, 143, 1),
                                          unselectedColor: Colors.white,
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.white),
                                          unselectedTextStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  36, 193, 1435, 1)),
                                          borderWidth: 0.7,
                                          borderRadius: 32.0,
                                          onSegmentTapped: (index) {
                                            switch (index) {
                                              case 1:
                                                {
                                                  _currentDateType = 1;

                                                  setState(() {
                                                    _cnSingleHomeEnergyChartFuture =
                                                        getCnSingleHomeEnergyChart();
                                                  });
                                                }
                                              case 2:
                                                {
                                                  _currentDateType = 2;
                                                  setState(() {
                                                    _cnSingleHomeEnergyChartFuture =
                                                        getCnSingleHomeEnergyChart();
                                                  });
                                                }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${(_currentDateType == 1 ? S.current.charge_discharge_ratio_this_month : S.current.charge_discharge_ratio_this_year)}  ',
                                          style: const TextStyle(
                                              color: Color(0xFF8693AB)),
                                        ),
                                        Text(
                                          "${lineChartData['chargeRatio'] ?? '--'}%",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF000000),
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
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
                                            S.current.charging_amount,
                                            S.current.discharging_amount,
                                            S.current.charge_discharge_ratio
                                          ],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 30,
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
                                            "name": _currentDateType == 1
                                                ? 'kWh'
                                                : 'MWh',
                                          },
                                          {
                                            "type": 'value',
                                            "name": '%',
                                          }
                                        ],
                                        "series": [
                                          {
                                            'name': S.current.charging_amount,
                                            "data": yaxis,
                                            "type": 'bar',
                                            "yAxisIndex": 0,
                                            "symbol": 'none',
                                            "color": '#61A643'
                                          },
                                          {
                                            'name':
                                                S.current.discharging_amount,
                                            "data": yaxis1,
                                            "type": 'bar',
                                            "yAxisIndex": 0,
                                            "symbol": 'none',
                                            "color": '#0F9CFF'
                                          },
                                          {
                                            'name': S
                                                .current.charge_discharge_ratio,
                                            "data": yaxis2,
                                            "type": "line",
                                            "yAxisIndex": 1,
                                            "smooth": true,
                                            "symbol": 'none',
                                            "color": '#E9B815'
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
                          future: _cnSingleHomeIncomeChartFuture,
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
                              List xdata = lineChartData['xlist'];
                              List yaxis = lineChartData['incomeList'] ?? [];
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
                                                "${incomeInfoData['lastMonthImcoe'] ?? '--'}",
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
                                                "${incomeInfoData['currentMonthImcoe'] ?? '--'}",
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
                                                "${incomeInfoData['totalIncome'] ?? '--'}",
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
                                        width: 120,
                                        child: MaterialSegmentedControl(
                                          verticalOffset: 5,
                                          children: {
                                            1: Text(S.current.to_month),
                                            2: Text(S.current.to_year)
                                          },
                                          selectionIndex: _incomeDateType,
                                          borderColor: const Color.fromRGBO(
                                              36, 193, 143, 1),
                                          selectedColor: const Color.fromRGBO(
                                              36, 193, 143, 1),
                                          unselectedColor: Colors.white,
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.white),
                                          unselectedTextStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  36, 193, 1435, 1)),
                                          borderWidth: 0.7,
                                          borderRadius: 32.0,
                                          onSegmentTapped: (index) {
                                            switch (index) {
                                              case 1:
                                                {
                                                  _incomeDateType = 1;

                                                  setState(() {
                                                    _cnSingleHomeIncomeChartFuture =
                                                        getCnSingleHomeIncomeChart();
                                                  });
                                                }
                                              case 2:
                                                {
                                                  _incomeDateType = 2;
                                                  setState(() {
                                                    _cnSingleHomeIncomeChartFuture =
                                                        getCnSingleHomeIncomeChart();
                                                  });
                                                }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
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
                                          "data": [S.current.revenue],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 20,
                                          "left": 40,
                                          "bottom": 30,
                                        },
                                        "xAxis": {
                                          "type": 'category',
                                          "data": xdata,
                                        },
                                        "yAxis": [
                                          {
                                            "type": 'value',
                                            "name": _incomeDateType == 1
                                                ? S.current.yuan
                                                : S.current.tenk_RMB,
                                          },
                                        ],
                                        "series": [
                                          {
                                            'name': S.current.revenue,
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
                                ),
                              );
                            }
                            return Container();
                          }),
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
        padding: const EdgeInsets.all(10),
        // height: 70,
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
