import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/toolview/imports.dart';

class PvHomePage extends StatefulWidget {
  const PvHomePage({super.key});

  @override
  State<PvHomePage> createState() => _PvHomePageState();
}

class _PvHomePageState extends State<PvHomePage> {
  Future<dynamic>? _PvNumFuture;
  Future<dynamic>? _PvPowerChartFuture;
  Future<dynamic>? _PVEnergyChartFuture;
  Future<dynamic>? _PVIncomeChartFuture;
  Future<dynamic>? _PVRankListFuture;
  List projectList = [];

  String poweritemId = '';
  String eleitemId = '';

  int _incomeDateType = 1;

  @override
  void initState() {
    super.initState();
    getstationList();
    // getIncomeInfo();
    _PvNumFuture = getPvTopNum();
    _PvPowerChartFuture = getPvPowerChart();
    _PVEnergyChartFuture = getPVEnergyChart();
    _PVIncomeChartFuture = getPVIncomeChart();
    _PVRankListFuture = getPVRankList();
  }

  Future<Map<String, dynamic>> getPvTopNum() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getPvTopNum(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPvPowerChart() async {
    Map<String, dynamic> params = {};
    params['itemId'] = poweritemId;
    var data = await IndexDao.getPvPowerEnergyChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPVEnergyChart() async {
    Map<String, dynamic> params = {};
    params['itemId'] = eleitemId;
    var data = await IndexDao.getPvPowerEnergyChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPVIncomeChart() async {
    Map<String, dynamic> params = {};
    params['type'] = _incomeDateType;
    var data = await IndexDao.getPvIncomeChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getPVRankList() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getPvRankList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      List record = data['data'];
      record.sort((a, b) => b['hour'].compareTo(a['hour']));
      return record;
    } else {
      throw Exception('Failed to load data');
    }
  }

  getstationList() async {
    Map<String, dynamic> params = {};
    var data = await IndexDao.getPvStationList(params: params);
    if (data["code"] == 200) {
      List dataList = data['data'];
      projectList = [];
      projectList = dataList
          .map((item) => {'id': item['id'], 'itemName': item['itemName']})
          .toList();
      projectList.insert(0, {'id': '', 'itemName': '全部'});
      setState(() {});
    } else {}
  }

  Future<void> _refreshData() async {
    setState(() {
      _PvNumFuture = getPvTopNum();
      _PvPowerChartFuture = getPvPowerChart();
      _PVEnergyChartFuture = getPVEnergyChart();
      _PVIncomeChartFuture = getPVIncomeChart();
      _PVRankListFuture = getPVRankList();
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
                          future: _PvNumFuture,
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
                                    const Row(
                                      children: [
                                        SizedBox(
                                          height: 18,
                                          child: VerticalDivider(
                                            thickness: 3,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text('光伏电站状态概览',
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
                                                    'assets/gfnumIcon.png')),
                                            const SizedBox(width: 10),
                                            const Center(
                                              child: Text(
                                                '光伏电站数(个)',
                                                style: TextStyle(
                                                    color: Color(0xFF8693AB)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Center(
                                              child: Text(
                                                '${topTotalData['gfCount'] ?? "0"}',
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
                                          "color": [
                                            '#25D9BA',
                                            '#FA4068',
                                            '#98AEFD'
                                          ],
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
                                                'formatter': '{b}: {c}个',
                                              },
                                              'data': [
                                                {
                                                  "name": "在线",
                                                  "value": topTotalData[
                                                      'onlineCount'],
                                                },
                                                {
                                                  "name": "故障",
                                                  "value": topTotalData[
                                                      'alarmCount'],
                                                },
                                                {
                                                  "name": "离线",
                                                  "value": topTotalData[
                                                      'standbyCount'],
                                                }
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
                          future: _PvNumFuture,
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
                                    const Row(
                                      children: [
                                        SizedBox(
                                          height: 18,
                                          child: VerticalDivider(
                                            thickness: 3,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text('运营数据',
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
                                        _cellView("总装机容量(MWp)",
                                            "${topTotalData['underTotalCapacity'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("总发电量(MWh)",
                                            "${topTotalData['chargeTotal'] ?? '--'}"),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cellView("今日发电量(kWh)",
                                            "${topTotalData['chargeToday'] ?? '--'}"),
                                        const SizedBox(width: 15),
                                        _cellView("今日收益(元)",
                                            "${topTotalData['incomeToday'] ?? '--'}"),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
                      //功率
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      // borderSide: BorderSide.none,
                                      borderSide: const BorderSide(
                                          color: Color(0xFF8693AB)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF8693AB)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF8693AB)),
                                    ),
                                  ),
                                  hint: const Text(
                                    '全部',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  items: projectList
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item['id'].toString(),
                                            child: Text(
                                              item['itemName'],
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    debugPrint(value);
                                    poweritemId = value!;
                                    setState(() {
                                      _PvPowerChartFuture = getPvPowerChart();
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 20)),
                                  iconStyleData: const IconStyleData(
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: Colors.black45),
                                      iconSize: 24),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16))),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _PvPowerChartFuture,
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
                                    List yaxis = lineChartData['ydataFd'] ?? [];
                                    // List yaxis1 = lineChartData['ydata2'] ?? [];
                                    return SizedBox(
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
                                          "data": ['发电功率', '今日'],
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
                                            'name': '发电功率',
                                            "data": yaxis,
                                            "type": 'line',
                                            "smooth": true, // 是否让线条圆滑显示
                                            "symbol": 'none',
                                            "color": '#0F9CFF',
                                          },
                                          // {
                                          //   'name': '今日',
                                          //   "data": yaxis1,
                                          //   "type": 'line',
                                          //   "smooth": true, // 是否让线条圆滑显示
                                          //   "color": '#61A643',
                                          // },
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
                                                    item['itemName'],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          debugPrint(value);
                                          eleitemId = value!;
                                          setState(() {
                                            _PVEnergyChartFuture =
                                                getPVEnergyChart();
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
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _PVEnergyChartFuture,
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
                                    List yaxis = lineChartData['ydata1'] ?? [];
                                    List yaxis1 = lineChartData['ydata2'] ?? [];
                                    List yaxis2 =
                                        lineChartData['ydataXn'] ?? [];
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
                                              "${lineChartData['lastEp'] ?? '--'}%",
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
                                              "data": ['发电量', '上网电量', '消纳率'],
                                              "inactiveColor": '#ccc'
                                            },
                                            "grid": {
                                              "right": 30,
                                              "left": 40,
                                              "bottom": 30,
                                            },
                                            "xAxis": {
                                              "type": 'category',
                                              "data": xdata,
                                            },
                                            "yAxis": [
                                              {"type": 'value', "name": 'kWh'},
                                              {
                                                "type": 'value',
                                                "name": '%',
                                              }
                                            ],
                                            "series": [
                                              {
                                                'name': '发电量',
                                                "data": yaxis,
                                                "type": 'bar',
                                                "yAxisIndex": 0,
                                                "color": '#61A643'
                                              },
                                              {
                                                'name': '上网电量',
                                                "data": yaxis1,
                                                "type": 'bar',
                                                "yAxisIndex": 0,
                                                "color": '#0F9CFF'
                                              },
                                              {
                                                'name': '消纳率',
                                                "data": yaxis2,
                                                "type": "line",
                                                "yAxisIndex": 1,
                                                "symbol": 'none',
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

                      //收益
                      FutureBuilder(
                          future: _PVIncomeChartFuture,
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
                              List yaxis = lineChartData['ydata'] ?? [];
                              List yaxis1 = lineChartData['ydataXn'] ?? [];
                              List yaxis2 = lineChartData['ydataSw'] ?? [];
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
                                        Text('收益概览',
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '上月收益(万元)',
                                              style: TextStyle(
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "${lineChartData['lastMonth'] ?? '--'}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '本月收益(万元)',
                                              style: TextStyle(
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "${lineChartData['thisMonth'] ?? '--'}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '累计收益(万元)',
                                              style: TextStyle(
                                                  color: Color(0xFF8693AB)),
                                            ),
                                            Text(
                                              "${lineChartData['totalMonth'] ?? '--'}",
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
                                                    _PVIncomeChartFuture =
                                                        getPVIncomeChart();
                                                  });
                                                }
                                              case 2:
                                                {
                                                  _incomeDateType = 2;
                                                  setState(() {
                                                    _PVIncomeChartFuture =
                                                        getPVIncomeChart();
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
                                          "itemHeight": 1,
                                          "textStyle": {
                                            "fontSize": 12,
                                            "color": '#333'
                                          },
                                          "itemGap": 10,
                                          "data": ['总收益', '消纳收益', '上网收益'],
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
                                            "name": _incomeDateType == 1
                                                ? '元'
                                                : '万元',
                                          },
                                        ],
                                        "series": [
                                          {
                                            'name': '总收益',
                                            "data": yaxis,
                                            "type": "line",
                                            "symbol": 'none',
                                            "smooth": true,
                                            "color": '#61A643'
                                          },
                                          {
                                            'name': '消纳收益',
                                            "data": yaxis1,
                                            "type": "line",
                                            "symbol": 'none',
                                            "smooth": true,
                                            "color": '#0F9CFF'
                                          },
                                          {
                                            'name': '上网收益',
                                            "data": yaxis2,
                                            "type": "line",
                                            "symbol": 'none',
                                            "smooth": true,
                                            "color": '#E9B815'
                                          },
                                        ]
                                      })),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                      const SizedBox(height: 10),
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
                                Text('满发小时数排名',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Spacer(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: _PVRankListFuture,
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
                                        SizedBox(
                                          height: 200,
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              itemCount: record.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
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
                                                          _getRankIcon(index),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(record[index]
                                                              ['itemName']),
                                                          const Spacer(),
                                                          Text(
                                                              "${record[index]['hour']}h"),
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
}
