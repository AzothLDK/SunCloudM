import 'dart:convert';
import 'package:date_format/date_format.dart' as date_format;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/toolview/appColor.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/toolview/language_resource.dart';

class CnHomePage extends StatefulWidget {
  const CnHomePage({super.key});

  @override
  State<CnHomePage> createState() => _CnHomePageState();
}

class _CnHomePageState extends State<CnHomePage> {
  int _currentDateType = 1;
  int _incomeDateType = 1;
  List projectList = [];
  Map incomeInfo = {};

  int _rankType = 1;
  int _rankDateType = 1;

  String powerStationId = '';
  String eleStationId = '';

  getstationList() async {
    Map<String, dynamic> params = {};
    var data = await AlarmDao.getAlarmStationList(params: params);
    if (data["code"] == 200) {
      List dataList = data['data'];
      projectList = [];
      projectList = dataList
          .map((item) => {'id': item['id'], 'stationName': item['stationName']})
          .toList();
      projectList.insert(0, {'id': '', 'stationName': '全部'});
      setState(() {});
    } else {}
  }

  getIncomeInfo() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnIncomeInfo(params: params);
    if (data["code"] == 200) {
      incomeInfo = data['data'];
      setState(() {});
    } else {}
  }

  Future<dynamic>? _CNNumFuture;
  Future<dynamic>? _CNPowerChartFuture;
  Future<dynamic>? _CNEnergyChartFuture;
  Future<dynamic>? _CNIncomeChartFuture;
  Future<dynamic>? _CNRankListFuture;

  @override
  void initState() {
    super.initState();
    getstationList();
    getIncomeInfo();
    _CNNumFuture = getCNTopNum();
    _CNPowerChartFuture = getCNPowerChart();
    _CNEnergyChartFuture = getCNEnergyChart();
    _CNIncomeChartFuture = getCNIncomeChart();
    _CNRankListFuture = getCNRankList();
  }

  Future<Map<String, dynamic>> getCNTopNum() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getCnTopNum(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCNPowerChart() async {
    Map<String, dynamic> params = {};
    params['stationId'] = powerStationId;
    var data = await IndexDao.getCnPowerChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCNEnergyChart() async {
    Map<String, dynamic> params = {};
    params['stationId'] = eleStationId;
    params['timeType'] = _currentDateType;
    var data = await IndexDao.getCnEnergyChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getCNIncomeChart() async {
    Map<String, dynamic> params = {};
    // params['stationId'] = 1;
    if (_incomeDateType == 1) {
      params['time'] = date_format
          .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
    } else {
      params['time'] = DateTime.now().year.toString();
    }
    var data = await IndexDao.getCnIncomeChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getCNRankList() async {
    Map<String, dynamic> params = {};
    params['dimensionType'] = _rankDateType;
    params['type'] = _rankType;
    var data = await IndexDao.getCnRankList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _CNNumFuture = getCNTopNum();
      _CNPowerChartFuture = getCNPowerChart();
      _CNEnergyChartFuture = getCNEnergyChart();
      _CNIncomeChartFuture = getCNIncomeChart();
      _CNRankListFuture = getCNRankList();
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
                      // 储能电站状态概览
                      FutureBuilder(
                          future: _CNNumFuture,
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
                                        Text(S.current.ESS_status_overview,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 55,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFF2F8F9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          // 必须指定文本基线类型
                                          children: [
                                            const Image(
                                                image: AssetImage(
                                                    'assets/cnnumIcon.png')),
                                            const SizedBox(width: 10),
                                            Center(
                                              child: Text(
                                                S.current.ESS_Num,
                                                style: TextStyle(
                                                    color: Color(0xFF8693AB)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Center(
                                              child: Text(
                                                '${topTotalData['cnCount'] ?? "0"}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        child: Echarts(
                                            option: jsonEncode({
                                          "zlevel": 20,
                                          "tooltip": {"trigger": 'item'},
                                          'legend': {
                                            'orient': 'vertical',
                                            'right': '10%',
                                            'top': 'middle',
                                            'icon': 'circle',
                                            'itemGap': 20,
                                            // "formatter":
                                            //     "function(name) { return name + '  百分比:' + (value / total * 100).toFixed(2) + '%'; }",
                                            'textStyle': {
                                              'color': '#000',
                                            }
                                          },
                                          "color": ColorList().lineColorList,
                                          "series": [
                                            {
                                              'type': 'pie',
                                              'center': ['35%', '50%'],
                                              'radius': ['40%', '60%'],
                                              'avoidLabelOverlap': false,
                                              'itemStyle': {
                                                'borderRadius': 0,
                                                'borderColor': 'transparent',
                                                'borderWidth': 10,
                                              },
                                              'label': {
                                                'show': true,
                                                'formatter': '{b}: {c}个 ({d}%)',
                                              },
                                              'data': [
                                                {
                                                  "name": S.current.Access,
                                                  "value": topTotalData[
                                                      'dischargeCount'],
                                                },
                                                {
                                                  "name": S.current.Malfunction,
                                                  "value": topTotalData[
                                                      'alarmCount'],
                                                },
                                                {
                                                  "name": S.current.Offline,
                                                  "value": topTotalData[
                                                      'standbyCount'],
                                                },
                                                {
                                                  "name":
                                                      S.current.To_be_connected,
                                                  "value": topTotalData[
                                                      'operationCount'],
                                                },
                                              ],
                                            },
                                          ]
                                        }))),
                                    // const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      // 运营数据
                      FutureBuilder(
                          future: _CNNumFuture,
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
                                        Text(S.current.operational_data,
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
                                        _cellView("总投运容量(MWh)",
                                            "${topTotalData['operationCapacity'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("总在建容量(MWh)",
                                            "${topTotalData['underTotalCapacity'] ?? '--'}"),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cellView("日充电量(kWh)",
                                            "${topTotalData['chargeToday'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("日放电量(kWh)",
                                            "${topTotalData['dischargeToday'] ?? '--'}"),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cellView("总充电量(MWh)",
                                            "${topTotalData['chargeTotal'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("总放电量(MWh)",
                                            "${topTotalData['dischargeTotal'] ?? '--'}"),
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
                          future: _CNPowerChartFuture,
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
                              // List yaxis2 = lineChartData['ydataYesTodayGk'] ?? [];
                              // List yaxis3 = lineChartData['ydataGk'] ?? [];
                              return Container(
                                padding: const EdgeInsets.all(6.0),
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
                                        Text('功率曲线',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 40,
                                      child: DropdownButtonFormField2<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // borderSide: BorderSide.none,
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF8693AB)),
                                            ),
                                          ),
                                          hint: const Text(
                                            '全部',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          items: projectList
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        item['id'].toString(),
                                                    child: Text(
                                                      item['stationName'],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            debugPrint(value);
                                            powerStationId = value!;
                                            setState(() {
                                              _CNPowerChartFuture =
                                                  getCNPowerChart();
                                            });
                                          },
                                          buttonStyleData:
                                              const ButtonStyleData(
                                                  padding: EdgeInsets.only(
                                                      right: 20)),
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(Icons.arrow_drop_down,
                                                  color: Colors.black45),
                                              iconSize: 24),
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16))),
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
                                          "data": ['昨日', '今日'],
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
                                          }
                                        ],
                                        "series": [
                                          {
                                            'name': '昨日',
                                            "data": yaxis,
                                            "type": 'line',
                                            "smooth": true, // 是否让线条圆滑显示
                                            "symbol": 'none',
                                            "color": '#0F9CFF',
                                          },
                                          {
                                            'name': '今日',
                                            "data": yaxis1,
                                            "type": 'line',
                                            "smooth": true,
                                            "symbol": 'none', // 是否让线条圆滑显示
                                            "color": '#61A643',
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
                      //电量指标
                      Container(
                        padding: const EdgeInsets.all(6.0),
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
                                Text('电量指标',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: DropdownButtonFormField2<String>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // borderSide: BorderSide.none,
                                            borderSide: const BorderSide(
                                                color: Color(0xFF8693AB)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF8693AB)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF8693AB)),
                                          ),
                                        ),
                                        hint: const Text(
                                          '全部',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        items: projectList
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item['id'].toString(),
                                                  child: Text(
                                                    item['stationName'],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          debugPrint(value);
                                          eleStationId = value!;
                                          setState(() {
                                            _CNEnergyChartFuture =
                                                getCNEnergyChart();
                                          });
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                            padding:
                                                EdgeInsets.only(right: 20)),
                                        iconStyleData: const IconStyleData(
                                            icon: Icon(Icons.arrow_drop_down,
                                                color: Colors.black45),
                                            iconSize: 24),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16))),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 120,
                                    child: MaterialSegmentedControl(
                                      verticalOffset: 5,
                                      children: const {
                                        1: Text('当月'),
                                        2: Text('当年')
                                      },
                                      selectionIndex: _currentDateType,
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
                                          case 1:
                                            {
                                              _currentDateType = 1;

                                              setState(() {
                                                _CNEnergyChartFuture =
                                                    getCNEnergyChart();
                                              });
                                            }
                                          case 2:
                                            {
                                              _currentDateType = 2;
                                              setState(() {
                                                _CNEnergyChartFuture =
                                                    getCNEnergyChart();
                                              });
                                            }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _CNEnergyChartFuture,
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
                                        lineChartData['ydataCharge'] ?? [];
                                    List yaxis1 =
                                        lineChartData['ydataDisCharge'] ?? [];
                                    List yaxis2 =
                                        lineChartData['ydataChargeRatio'] ?? [];
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              '当月充放电比  ',
                                              style: TextStyle(
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
                                              "data": ['充电量', '放电量', '充放电比'],
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
                                                'name': '充电量',
                                                "data": yaxis,
                                                "type": 'bar',
                                                "yAxisIndex": 0,
                                                "color": '#61A643'
                                              },
                                              {
                                                'name': '放电量',
                                                "data": yaxis1,
                                                "type": 'bar',
                                                "yAxisIndex": 0,
                                                "color": '#0F9CFF'
                                              },
                                              {
                                                'name': '充放电比',
                                                "data": yaxis2,
                                                "type": "line",
                                                "symbol": 'none',
                                                "yAxisIndex": 1,
                                                "smooth": true,
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
                      //收益概览
                      Container(
                        padding: const EdgeInsets.all(6.0),
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
                                Text('收益概览',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '上月收益(万元)',
                                      style:
                                          TextStyle(color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      "${incomeInfo['lastMonthImcoe'] ?? '--'}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '本月收益(万元)',
                                      style:
                                          TextStyle(color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      "${incomeInfo['currentMonthImcoe'] ?? '--'}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '累计收益(万元)',
                                      style:
                                          TextStyle(color: Color(0xFF8693AB)),
                                    ),
                                    Text(
                                      "${incomeInfo['totalIncome'] ?? '--'}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
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
                                  children: const {
                                    1: Text('当月'),
                                    2: Text('当年')
                                  },
                                  selectionIndex: _incomeDateType,
                                  borderColor:
                                      const Color.fromRGBO(36, 193, 143, 1),
                                  selectedColor:
                                      const Color.fromRGBO(36, 193, 143, 1),
                                  unselectedColor: Colors.white,
                                  selectedTextStyle:
                                      const TextStyle(color: Colors.white),
                                  unselectedTextStyle: const TextStyle(
                                      color: Color.fromRGBO(36, 193, 1435, 1)),
                                  borderWidth: 0.7,
                                  borderRadius: 32.0,
                                  onSegmentTapped: (index) {
                                    switch (index) {
                                      case 1:
                                        {
                                          _incomeDateType = 1;

                                          setState(() {
                                            _CNIncomeChartFuture =
                                                getCNIncomeChart();
                                          });
                                        }
                                      case 2:
                                        {
                                          _incomeDateType = 2;
                                          setState(() {
                                            _CNIncomeChartFuture =
                                                getCNIncomeChart();
                                          });
                                        }
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _CNIncomeChartFuture,
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
                                    List xdata = lineChartData['xlist'];
                                    List yaxis =
                                        lineChartData['incomeList'] ?? [];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
                                                ? '元'
                                                : '万元',
                                          },
                                        ],
                                        "series": [
                                          {
                                            'name': '收益',
                                            "data": yaxis,
                                            "type": "line",
                                            "symbol": 'none',
                                            "smooth": true,
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

                      //排名
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                                Text('储能电站排名',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Spacer(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: MaterialSegmentedControl(
                                    verticalOffset: 5,
                                    children: const {
                                      1: Text('充放电效率'),
                                      2: Text('收益'),
                                    },
                                    selectionIndex: _rankType,
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
                                        case 1:
                                          {
                                            _rankType = 1;
                                            setState(() {
                                              _CNRankListFuture =
                                                  getCNRankList();
                                            });
                                          }
                                        case 2:
                                          {
                                            _rankType = 2;
                                            setState(() {
                                              _CNRankListFuture =
                                                  getCNRankList();
                                            });
                                          }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: MaterialSegmentedControl(
                                    verticalOffset: 5,
                                    children: const {
                                      1: Text('当月'),
                                      2: Text('当年'),
                                    },
                                    selectionIndex: _rankDateType,
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
                                        case 1:
                                          {
                                            _rankDateType = 1;
                                            setState(() {
                                              _CNRankListFuture =
                                                  getCNRankList();
                                            });
                                          }
                                        case 2:
                                          {
                                            _rankDateType = 2;
                                            setState(() {
                                              _CNRankListFuture =
                                                  getCNRankList();
                                            });
                                          }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _CNRankListFuture,
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
                                    List record = snapshot.data;
                                    return Column(
                                      children: [
                                        _rankType == 1
                                            ? SizedBox(
                                                height: 200,
                                                child: Scrollbar(
                                                  child: ListView.builder(
                                                    itemCount: record.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
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
                                                                _getRankIcon(
                                                                    index),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(record[
                                                                        index][
                                                                    'stationName']),
                                                                const Spacer(),
                                                                Text(
                                                                    "${record[index]['value']}%"),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 3),
                                                            CustomPaint(
                                                              size: Size(
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  10),
                                                              painter:
                                                                  ProgressIndicatorDotPainter(
                                                                progressColor:
                                                                    const Color(
                                                                        0xFF0F9CFF),
                                                                dotColor: Colors
                                                                    .white,
                                                                progressValue: ((record[index]['value'] ??
                                                                                0) /
                                                                            100) >
                                                                        1
                                                                    ? 1
                                                                    : ((record[index]['value'] ??
                                                                            0) /
                                                                        100), // 0.0 to 1.0
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 250,
                                                child: Scrollbar(
                                                  child: ListView.builder(
                                                    itemCount: record.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
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
                                                                _getRankIcon(
                                                                    index),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(record[
                                                                        index][
                                                                    'stationName']),
                                                                const Spacer(),
                                                                Text(
                                                                    "${record[index]['value']}万元"),
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
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ),
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

  _getRankIcon(int num) {
    switch (num) {
      case 0:
        return const Image(image: AssetImage('assets/rank1.png'));
      case 1:
        return const Image(image: AssetImage('assets/rank2.png'));
      case 2:
        return const Image(image: AssetImage('assets/rank3.png'));
      default:
        return Text((num + 1).toString());
    }
  }

  _cellView(String title, String num) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 70,
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

  String getEchartsOption(Map topTotalData) {
    final option = {
      "zlevel": 11,
      "tooltip": {"trigger": 'item'},
      "grid": {
        "left": "3%",
        "right": "4%",
        'bottom': '3%',
        'top': '20%',
        "containLabel": true
      },
      'legend': {
        'orient': 'vertical',
        'right': '15%',
        'top': 'middle',
        'itemWidth': 13,
        'itemHeight': 13,
        'icon': 'circle',
        'itemGap': 20,
        // "formatter": "__FORMATTTER_PLACEHOLDER__",
        'textStyle': {
          'color': '#000',
        }
      },
      "series": [
        {
          'type': 'pie',
          'center': ['30%', '50%'],
          'radius': ['40%', '80%'],
          'itemStyle': {
            'borderWidth': 5, //描边线宽
            'borderColor': '#fff',
          },
          'label': {
            'show': true,
          },
          'labelLine': {
            'show': true,
          },
          'data': [
            {
              "name": "接入",
              "value": topTotalData['dischargeCount'],
            },
            {
              "name": "故障",
              "value": topTotalData['alarmCount'],
            },
            {
              "name": "下线",
              "value": topTotalData['standbyCount'],
            },
            {
              "name": "待接入",
              "value": topTotalData['operationCount'],
            },
          ],
        },
      ]
    };
    // 将 Dart 对象转换为 JSON 字符串
    String optionJson = jsonEncode(option);
    // List dataList = [
    //   {
    //     name: "接入",
    //     "value": topTotalData['dischargeCount'],
    //   },
    //   {
    //     name: "故障",
    //     "value": topTotalData['alarmCount'],
    //   },
    //   {
    //     name: "下线",
    //     "value": topTotalData['standbyCount'],
    //   },
    //   {
    //     name: "待接入",
    //     "value": topTotalData['operationCount'],
    //   }
    // ];

    // String name = "接入";
    // var item = dataList.firstWhere((i) => i['name'] == name);
    // var p = item['value'];
    // print(p);

    // 替换占位符为实际的 JavaScript 函数
    optionJson = optionJson.replaceAll('"__FORMATTTER_PLACEHOLDER__"',
        'function(val) {return val.name + "  " + val.value + "  个"; }');

    return optionJson;
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
