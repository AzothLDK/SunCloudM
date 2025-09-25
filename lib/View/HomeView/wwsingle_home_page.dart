import 'dart:async';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/toolview/flowing_line.dart';

import 'package:suncloudm/toolview/imports.dart';

class WwsingleHomePage extends StatefulWidget {
  const WwsingleHomePage({super.key});

  @override
  State<WwsingleHomePage> createState() => _WwsingleHomePageState();
}

class _WwsingleHomePageState extends State<WwsingleHomePage> {
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String seletetime =
      date_format.formatDate(DateTime.now(), [date_format.yyyy]);
  String _status = S.current.normal;

  Map<String, dynamic> topTotalData = {};
  Map<String, dynamic> stationTotalData = {};
  Map<String, dynamic> runInfoData = {};

  Future<dynamic>? _wwSingleHomeTopInfoFuture;
  Future<dynamic>? _wwSingleHomeStationInfoFuture;
  Future<dynamic>? _wwSingleHomePowerChartFuture;
  Future<dynamic>? _wwSingleHomeEnergyChartFuture;
  String? _itemPicUrl;

  int _deviceType = 1;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _wwSingleHomeTopInfoFuture = getWwSingleHomeTopInfo();
    _wwSingleHomeStationInfoFuture = getWwSingleHomeStationInfo();
    _wwSingleHomePowerChartFuture = getWwSingleHomePowerChart();
    _wwSingleHomeEnergyChartFuture = getWwSingleHomeEnergyChart();
    getWwSingleHomeRunInfo();
    getWwSingleHomeStatus();
    getItemUrlInfo();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      getWwSingleHomeRunInfo();
      getWwSingleHomeStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> getWwSingleHomeTopInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getWwSingleHomeTopInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return topTotalData = data["data"];
    }
    return {};
  }

  Future<Map<String, dynamic>> getWwSingleHomeStationInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getWwSingleHomeStationInfo(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return stationTotalData = data["data"];
    }
    return {};
  }

  Future<Map<String, dynamic>> getWwSingleHomePowerChart() async {
    Map<String, dynamic> params = {};
    params['startTime'] = date_format.formatDate(DateTime.now(),
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    params['endTime'] = date_format.formatDate(DateTime.now(),
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    var data = await IndexDao.getWwSingleHomePowerChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data["data"];
    }
    return {};
  }

  Future<Map<String, dynamic>> getWwSingleHomeEnergyChart() async {
    Map<String, dynamic> params = {};
    params['time'] = seletetime;
    params['deviceType'] = _deviceType;
    var data = await IndexDao.getWwSingleHomeEnergyChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data["data"];
    }
    return {};
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

  getWwSingleHomeRunInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getWwSingleHomeRunInfo(params: params);
    if (data["code"] == 200) {
      runInfoData = data['data'];
      setState(() {});
    } else {}
  }

  getWwSingleHomeStatus() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnSingleHomeStatus(params: params);
    if (data["code"] == 200) {
      _status = data['data'];
      setState(() {});
    } else {}
  }

  Future<void> _refreshData() async {
    setState(() {
      _wwSingleHomeTopInfoFuture = getWwSingleHomeTopInfo();
      _wwSingleHomeStationInfoFuture = getWwSingleHomeStationInfo();
      _wwSingleHomePowerChartFuture = getWwSingleHomePowerChart();
      _wwSingleHomeEnergyChartFuture = getWwSingleHomeEnergyChart();
    });
  }

  // 转换时间格式的方法
  List convertTimeFormat(List originalTimes) {
    return originalTimes.map((timeStr) {
      // 分割日期和时间部分（"2025-08-04" 和 "00:00:00"）
      final parts = timeStr.split(' ');
      if (parts.length < 2) {
        return timeStr; // 格式异常时返回原始值
      }

      // 取时间部分并截取前5个字符（"00:00:00" → "00:00"）
      final timePart = parts[1];
      return timePart.substring(0, 5);
    }).toList();
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
                      FutureBuilder(
                          future: _wwSingleHomeStationInfoFuture,
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
                                            "${userInfo['title'] ?? '--'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 65,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                S.current.pv,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${stationTotalData['pvRatePower'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const Text(
                                                    "MWp",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 65,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                S.current.ess,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${stationTotalData['cnRatePower'] ?? '--'}/${stationTotalData['volume'] ?? '--'}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const Text(
                                                    "MW/MWh",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF8693AB)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      FutureBuilder(
                          future: _wwSingleHomeTopInfoFuture,
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                                "${S.current.total_energy_consumption}(${S.current.tce})",
                                                "${topTotalData['energyConsumption'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            _cellView(
                                                "${S.current.carbon_emission}(${S.current.t})",
                                                "${topTotalData['carbonEmission'] ?? '--'}"),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _cellView(
                                                "${S.current.carbon_reduction}(${S.current.t})",
                                                "${topTotalData['emissionReduction'] ?? '--'}"),
                                            const SizedBox(width: 15),
                                            _cellView(
                                                "${S.current.zero_carbon_index}(%)",
                                                "${topTotalData['ltRatio'] ?? '--'}"),
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
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  width: 120,
                                  height: 90,
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/gfinfoIcon.png')),
                              CurrentLine(
                                direction: CurrentXDirection.topToBottom,
                                width: 80,
                                height: (runInfoData['gfEp'] ?? 0) <= 0 ? 0 : 5,
                                lineColor: Colors.grey[400]!,
                                currentColor: const Color(0xFF24C18F),
                              ),
                              const Image(
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/wdwicon.png')),
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
                                        runInfoData['workStatus']?.toString() ==
                                                '待机'
                                            ? 0
                                            : 5,
                                    direction:
                                        runInfoData['workStatus']?.toString() ==
                                                '充电'
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
                                    direction:
                                        runInfoData['workStatus']?.toString() ==
                                                '充电'
                                            ? CurrentXDirection.topToBottom
                                            : CurrentXDirection.bottomToTop,
                                    width: 80,
                                    height:
                                        runInfoData['workStatus']?.toString() ==
                                                '待机'
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
                              const SizedBox(height: 70),
                              Transform.translate(
                                offset: const Offset(-110, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 160,
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
                                          Text(
                                            S.current.gen_today,
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
                                                        horizontal: 5),
                                                child: Text(
                                                  "${runInfoData['gfEp'] ?? '--'}",
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Text(
                                                  "${runInfoData['gfEle'] ?? '--'}",
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
                              const SizedBox(height: 100),
                              Transform.translate(
                                offset: const Offset(-110, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 150,
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
                                          Text(
                                            S.current.ele_usage_today,
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
                                                        horizontal: 5),
                                                child: Text(
                                                  "${runInfoData['companyEp'] ?? '--'}",
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Text(
                                                  "${runInfoData['companyEle'] ?? '--'}",
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
                                                S.current.ele_usage_today,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              )
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
                                          horizontal: 10, vertical: 10),
                                      width: 150,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/qp09.png'),
                                              fit: BoxFit.fill)),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                S.current.status,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                S.current.power,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              const Text(
                                                "SOC",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                S.current.discharge,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF8693AB)),
                                              ),
                                              Text(
                                                S.current.charge,
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
                                                            runInfoData['workStatus']
                                                                    ?.toString() ??
                                                                '--';
                                                        Color textColor;
                                                        switch (currentValue) {
                                                          case '待机':
                                                            textColor =
                                                                Colors.grey;
                                                            return Text('待机',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor));
                                                          case '充电':
                                                            textColor =
                                                                Colors.blue;
                                                            return Text('充电',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor));
                                                          case '放电':
                                                            textColor =
                                                                Colors.green;
                                                            return Text('放电',
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
                                                      "${runInfoData['ep'] ?? '--'}",
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
                                                      "${runInfoData['eleCharge'] ?? '--'}",
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
                                                      "${runInfoData['eleDisCharge'] ?? '--'}",
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
                                              )
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
                                offset: const Offset(100, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    S.current.pv,
                                    style: const TextStyle(
                                        color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 160),
                              Transform.translate(
                                offset: const Offset(100, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    S.current.mg,
                                    style: const TextStyle(
                                        color: Color(0xFF8693AB)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 165),
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
                          future: _wwSingleHomePowerChartFuture,
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
                              List yaxis = lineChartData['yList1'] ?? [];
                              List yaxis1 = lineChartData['yList2'] ?? [];
                              List yaxis2 = lineChartData['yList3'] ?? [];
                              List yaxis3 = lineChartData['yList4'] ?? [];
                              List yaxis4 = lineChartData['yList5'] ?? [];

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
                                          "itemWidth": 10,
                                          "itemHeight": 1,
                                          "textStyle": {
                                            "fontSize": 11,
                                            "color": '#333'
                                          },
                                          "itemGap": 5,
                                          "data": [
                                            S.current.grid,
                                            S.current.pv,
                                            S.current.ess,
                                            S.current.loadd
                                          ],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 20,
                                          "left": 45,
                                          "bottom": 30,
                                          // "top": 60,
                                        },
                                        "xAxis": {
                                          "type": 'category',
                                          "data": convertTimeFormat(xdata),
                                        },
                                        "yAxis": [
                                          {
                                            "type": 'value',
                                            "name": 'kW',
                                          },
                                        ],
                                        "series": [
                                          {
                                            'name': S.current.grid,
                                            "data": yaxis,
                                            "type": 'line',
                                            "smooth": true, // 是否让线条圆滑显示
                                            "symbol": 'none',
                                            "color": '#0F9CFF',
                                          },
                                          {
                                            'name': S.current.pv,
                                            "data": yaxis1,
                                            "type": 'line',
                                            "smooth": true, // 是否让线条圆滑显示
                                            "symbol": 'none',
                                            "color": '#C666DE',
                                          },
                                          {
                                            'name': S.current.ess,
                                            "data": yaxis2,
                                            "type": "line",
                                            "smooth": true,
                                            "symbol": 'none',
                                            "color": '#61A643',
                                          },
                                          {
                                            'name': S.current.loadd,
                                            "data": yaxis3,
                                            "type": "line",
                                            "smooth": true,
                                            "symbol": 'none',
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
                          future: _wwSingleHomeEnergyChartFuture,
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
                              List yaxis = lineChartData['dataList1'] ?? [];
                              List yaxis1 = lineChartData['dataList2'] ?? [];
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
                                        Text(S.current.monthly_energy,
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
                                            verticalOffset: 5,
                                            children: {
                                              1: Text(S.current.grid),
                                              2: Text(S.current.ess),
                                              3: Text(S.current.pv),
                                              4: Text(S.current.charge)
                                            },
                                            selectionIndex: _deviceType,
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
                                                    _deviceType = 1;
                                                    setState(() {
                                                      _wwSingleHomeEnergyChartFuture =
                                                          getWwSingleHomeEnergyChart();
                                                    });
                                                  }
                                                case 2:
                                                  {
                                                    _deviceType = 2;
                                                    setState(() {
                                                      _wwSingleHomeEnergyChartFuture =
                                                          getWwSingleHomeEnergyChart();
                                                    });
                                                  }
                                                case 3:
                                                  {
                                                    _deviceType = 3;
                                                    setState(() {
                                                      _wwSingleHomeEnergyChartFuture =
                                                          getWwSingleHomeEnergyChart();
                                                    });
                                                  }
                                                case 4:
                                                  {
                                                    _deviceType = 4;
                                                    setState(() {
                                                      _wwSingleHomeEnergyChartFuture =
                                                          getWwSingleHomeEnergyChart();
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
                                                            firstDate: DateTime(
                                                                2000, 5),
                                                            lastDate: DateTime(
                                                                2050, 5),
                                                            selectedDate:
                                                                DateTime.now(),
                                                            onChanged: (DateTime
                                                                value) {
                                                              seletetime =
                                                                  date_format
                                                                      .formatDate(
                                                                          value,
                                                                          [
                                                                    date_format
                                                                        .yyyy
                                                                  ]);
                                                              setState(() {
                                                                _wwSingleHomeEnergyChartFuture =
                                                                    getWwSingleHomeEnergyChart();
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            }, //最大可选日期
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
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      child: Echarts(
                                          option: jsonEncode({
                                        "zlevel": 11,
                                        "tooltip": {"trigger": 'axis'},
                                        "legend": {
                                          'show': false,
                                          // "itemWidth": 10,
                                          // "itemHeight": 10,
                                          "textStyle": {
                                            "fontSize": 11,
                                            "color": '#333'
                                          },
                                          "itemGap": 5,
                                          "data": [
                                            S.current.use,
                                            S.current.discharging
                                          ],
                                          "inactiveColor": '#ccc'
                                        },
                                        "grid": {
                                          "right": 10,
                                          "left": 45,
                                          "bottom": 30,
                                          "top": 40,
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
                                        ],
                                        "series": [
                                          {
                                            'name': S.current.use,
                                            "data": yaxis,
                                            "type": 'bar',
                                            // "smooth": true, // 是否让线条圆滑显示
                                            "color": '#0F9CFF',
                                          },
                                          {
                                            'name': S.current.discharging,
                                            "data": yaxis1,
                                            "type": 'bar',
                                            // "smooth": true, // 是否让线条圆滑显示
                                            "color": '#C666DE',
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
                          future: _wwSingleHomeTopInfoFuture,
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
                              List dataList = topTotalData['incomeVoList'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  S.current.revenue_type,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF8693AB)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  "${S.current.yearly_revenue}(${S.current.tenk_RMB})",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF8693AB)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  "${S.current.monthly_revenue}(${S.current.tenk_RMB})",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF8693AB)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 120,
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              itemCount: dataList.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFF2F8F9),
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
                                                            width: 120,
                                                            child: Text(
                                                              dataList[index][
                                                                      'type'] ??
                                                                  '--',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 80,
                                                            child: Text(
                                                              "${dataList[index]['totalIncome'] ?? '--'}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 80,
                                                            child: Text(
                                                              "${dataList[index]['monthIncome'] ?? '--'}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
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
        height: 75,
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
