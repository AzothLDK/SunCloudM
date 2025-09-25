import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:suncloudm/dao/daoX.dart';

_cellView(String title, String num, String pre) {
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
          ),
          pre != ''
              ? Text(
                  pre,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF8693AB)),
                )
              : Container()
        ],
      ),
    ),
  );
}

class EMEleDLPage extends StatefulWidget {
  final String loopId;
  final String seleteTime;

  const EMEleDLPage(
      {super.key, required this.loopId, required this.seleteTime});

  @override
  State<EMEleDLPage> createState() => _EMEleDLPageState();
}

class _EMEleDLPageState extends State<EMEleDLPage> {
  Map<String, dynamic> viewData = {};
  Map<String, dynamic> chartData = {};

  Future<Map<String, dynamic>> getMeterInfo() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getMeterInfo(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getEleQuantityCure() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getEleQuantityCure(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return chartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFF7F7F9),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: getMeterInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '进电量(kWh)',
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xFF8693AB)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${viewData['totalCharge']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '出电量(kWh)',
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xFF8693AB)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${viewData['totalDischarge']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text('峰平谷电量及占比',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('  进电量',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView(
                                    "尖电量(kWh)",
                                    "${viewData['sharpCharge']}",
                                    "占比:${viewData['sharpChargeProportion']}%"),
                                const SizedBox(width: 15),
                                _cellView(
                                    "峰电量(kWh)",
                                    "${viewData['peakCharge']}",
                                    "占比:${viewData['peakChargeProportion']}%"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView(
                                    "平电量(kWh)",
                                    "${viewData['flatCharge']}",
                                    "占比:${viewData['flatChargeProportion']}%"),
                                const SizedBox(width: 15),
                                _cellView(
                                    "谷电量(kWh)",
                                    "${viewData['valleyCharge']}",
                                    "占比:${viewData['valleyChargeProportion']}%"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView(
                                    "深谷电量(kWh)",
                                    "${viewData['deepValleyCharge']}",
                                    "占比:${viewData['deepValleyChargeProportion']}%"),
                                const SizedBox(width: 15),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('  出电量',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView(
                                    "尖电量(kWh)",
                                    "${viewData['sharpDischarge']}",
                                    "占比:${viewData['sharpDischargeProportion']}%"),
                                const SizedBox(width: 15),
                                _cellView(
                                    "峰电量(kWh)",
                                    "${viewData['peakDischarge']}",
                                    "占比:${viewData['peakDischargeProportion']}%"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView(
                                    "平电量(kWh)",
                                    "${viewData['flatDischarge']}",
                                    "占比:${viewData['flatDischargeProportion']}%"),
                                const SizedBox(width: 15),
                                _cellView(
                                    "谷电量(kWh)",
                                    "${viewData['valleyDischarge']}",
                                    "占比:${viewData['valleyDischargeProportion']}%"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _cellView(
                                    "深谷电量(kWh)",
                                    "${viewData['deepValleyDischarge']}",
                                    "占比:${viewData['deepValleyDischargeProportion']}%"),
                                const SizedBox(width: 15),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('暂无数据!',
                                  style: TextStyle(fontSize: 20)))));
                } else {
                  return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),

          const SizedBox(height: 10),

          ///电网电量趋势
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('电网电量趋势',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getEleQuantityCure(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List xdata = chartData['xlist'];
                        List yaxis = chartData['chargeAmountList'];
                        List yaxis2 = chartData['dischargeAmountList'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": ['进电量', '放电量'],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "kWh",
                              }
                            ],
                            "series": [
                              {
                                'name': '进电量',
                                "data": yaxis,
                                "type": 'bar',
                                "color": '#3D71FD'
                              },
                              {
                                'name': '放电量',
                                "data": yaxis2,
                                "type": 'bar',
                                "color": '#FBAF38'
                              },
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text('暂无数据!',
                                        style: TextStyle(fontSize: 20)))));
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

///功率表
class EMEleGLPage extends StatefulWidget {
  final String loopId;
  final String seleteTime;

  const EMEleGLPage(
      {super.key, required this.loopId, required this.seleteTime});

  @override
  State<EMEleGLPage> createState() => _EMEleGLPageState();
}

class _EMEleGLPageState extends State<EMEleGLPage> {
  Map<String, dynamic> viewData = {};
  Map<String, dynamic> chartData = {};

  Future<Map<String, dynamic>> getMeterInfo() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getMeterInfo(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getEleLoadCure() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getEleLoadCure(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return chartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFF7F7F9),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: getMeterInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('有功功率',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(kW)",
                                "${viewData['maxActivePower']}",
                                "${viewData['maxActivePowerTime']}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(kW)",
                                "${viewData['minActivePower']}",
                                "${viewData['minActivePowerTime']}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "平均值(kW)", "${viewData['flatCharge']}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('暂无数据!',
                                  style: TextStyle(fontSize: 20)))));
                } else {
                  return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),

          const SizedBox(height: 10),

          ///功率趋势
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getEleLoadCure(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List xdata = chartData['xlist'];
                        List yaxis = chartData['loadList'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": ['功率'],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "kW",
                              }
                            ],
                            "series": [
                              {
                                'name': '功率',
                                "data": yaxis,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#20C487'
                              }
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text('暂无数据!',
                                        style: TextStyle(fontSize: 20)))));
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

///无功功率
class EMEleWGGLPage extends StatefulWidget {
  final String loopId;
  final String seleteTime;

  const EMEleWGGLPage(
      {super.key, required this.loopId, required this.seleteTime});

  @override
  State<EMEleWGGLPage> createState() => _EMEleWGGLPageState();
}

class _EMEleWGGLPageState extends State<EMEleWGGLPage> {
  Map<String, dynamic> viewData = {};
  Map<String, dynamic> chartData = {};

  Future<Map<String, dynamic>> getMeterInfo() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getMeterInfo(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getReactivePowerCure() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getReactivePowerCure(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return chartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFF7F7F9),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: getMeterInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('无功总功率',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(kW)",
                                "${viewData['maxReactivePower']}",
                                "${viewData['maxReactivePowerTime']}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(kW)",
                                "${viewData['minReactivePower']}",
                                "${viewData['minReactivePowerTime']}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(kW)",
                                "${viewData['avgReactivePower']}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('A相无功',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(kW)",
                                "${viewData['maxAReactivePower'] ?? "--"}",
                                "${viewData['maxAReactivePowerTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(kW)",
                                "${viewData['minAReactivePower'] ?? "--"}",
                                "${viewData['minAReactivePowerTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(kW)",
                                "${viewData['avgAReactivePower'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('B相无功',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(kW)",
                                "${viewData['maxBReactivePower'] ?? "--"}",
                                "${viewData['maxBReactivePowerTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(kW)",
                                "${viewData['minBReactivePower'] ?? "--"}",
                                "${viewData['minBReactivePowerTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(kW)",
                                "${viewData['avgBReactivePower'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('C相无功',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(kW)",
                                "${viewData['maxCReactivePower'] ?? "--"}",
                                "${viewData['maxCReactivePowerTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(kW)",
                                "${viewData['minCReactivePower'] ?? "--"}",
                                "${viewData['minCReactivePowerTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(kW)",
                                "${viewData['avgCReactivePower'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('暂无数据!',
                                  style: TextStyle(fontSize: 20)))));
                } else {
                  return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('无功功率曲线',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getReactivePowerCure(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List xdata = chartData['xlist'];
                        List yaxis1 = chartData['reactiveLoadList'];
                        List yaxis2 = chartData['areactiveLoadList'];
                        List yaxis3 = chartData['breactiveLoadList'];
                        List yaxis4 = chartData['creactiveLoadList'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": ['无功功率', 'A相无功', 'B相无功', 'C相无功'],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "kW",
                              }
                            ],
                            "series": [
                              {
                                'name': '无功功率',
                                "data": yaxis1,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#20C487'
                              },
                              {
                                'name': 'A相无功',
                                "data": yaxis2,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#FBAF38'
                              },
                              {
                                'name': 'B相无功',
                                "data": yaxis3,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#EE6666'
                              },
                              {
                                'name': 'C相无功',
                                "data": yaxis4,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#4ECCDF'
                              }
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text('暂无数据!',
                                        style: TextStyle(fontSize: 20)))));
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

///功率因素表
class EMEleGLYSPage extends StatefulWidget {
  final String loopId;
  final String seleteTime;

  const EMEleGLYSPage(
      {super.key, required this.loopId, required this.seleteTime});

  @override
  State<EMEleGLYSPage> createState() => _EMEleGLYSPageState();
}

class _EMEleGLYSPageState extends State<EMEleGLYSPage> {
  Map<String, dynamic> viewData = {};
  Map<String, dynamic> chartData = {};

  Future<Map<String, dynamic>> getMeterInfo() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getMeterInfo(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPowerFactorCure() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getPowerFactorCure(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return chartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFF7F7F9),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: getMeterInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('功率因素',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("最大值", "${viewData['maxPowerFactor']}",
                                "${viewData['maxPowerFactorTime']}"),
                            const SizedBox(width: 15),
                            _cellView("最小值", "${viewData['minPowerFactor']}",
                                "${viewData['minPowerFactorTime']}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "平均值", "${viewData['avgPowerFactor']}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('暂无数据!',
                                  style: TextStyle(fontSize: 20)))));
                } else {
                  return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('功率因素曲线',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getPowerFactorCure(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List xdata = chartData['xlist'];
                        List yaxis = chartData['powerFactorList'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": ['功率因素'],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "kW",
                              }
                            ],
                            "series": [
                              {
                                'name': '功率因素',
                                "data": yaxis,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#20C487'
                              }
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text('暂无数据!',
                                        style: TextStyle(fontSize: 20)))));
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

///电流表
class EMEleIPage extends StatefulWidget {
  final String loopId;
  final String seleteTime;

  const EMEleIPage({super.key, required this.loopId, required this.seleteTime});

  @override
  State<EMEleIPage> createState() => _EMEleIPageState();
}

class _EMEleIPageState extends State<EMEleIPage> {
  Map<String, dynamic> viewData = {};
  Map<String, dynamic> chartData = {};

  Future<Map<String, dynamic>> getMeterInfo() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getMeterInfo(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getEleCurrentCure() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getEleCurrentCure(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return chartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFF7F7F9),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: getMeterInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('A相电流',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(A)",
                                "${viewData['maxATermCurrent'] ?? "--"}",
                                "${viewData['maxATermCurrentTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(A)",
                                "${viewData['minATermCurrent'] ?? "--"}",
                                "${viewData['minATermCurrentTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(A)",
                                "${viewData['avgATermCurrent'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('B相电流',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(A)",
                                "${viewData['maxBTermCurrent'] ?? "--"}",
                                "${viewData['maxBTermCurrentTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(A)",
                                "${viewData['minBTermCurrent'] ?? "--"}",
                                "${viewData['minBTermCurrentTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(A)",
                                "${viewData['avgBTermCurrent'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('C相电流',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(A)",
                                "${viewData['maxCTermCurrent'] ?? "--"}",
                                "${viewData['maxCTermCurrentTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(A)",
                                "${viewData['minCTermCurrent'] ?? "--"}",
                                "${viewData['minCTermCurrentTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(A)",
                                "${viewData['avgCTermCurrent'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('暂无数据!',
                                  style: TextStyle(fontSize: 20)))));
                } else {
                  return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('电流曲线',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getEleCurrentCure(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List xdata = chartData['xlist'];
                        List yaxis1 = chartData['aelectricCurrent'];
                        List yaxis2 = chartData['belectricCurrent'];
                        List yaxis3 = chartData['celectricCurrent'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": ['A相电流', 'B相电流', 'C相电流'],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "A",
                              }
                            ],
                            "series": [
                              {
                                'name': 'A相电流',
                                "data": yaxis1,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#FBAF38'
                              },
                              {
                                'name': 'B相电流',
                                "data": yaxis2,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#EE6666'
                              },
                              {
                                'name': 'C相电流',
                                "data": yaxis3,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#4ECCDF'
                              }
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text('暂无数据!',
                                        style: TextStyle(fontSize: 20)))));
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    })
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

///电压表
class EMEleVPage extends StatefulWidget {
  final String loopId;
  final String seleteTime;

  const EMEleVPage({super.key, required this.loopId, required this.seleteTime});

  @override
  State<EMEleVPage> createState() => _EMEleVPageState();
}

class _EMEleVPageState extends State<EMEleVPage> {
  Map<String, dynamic> viewData = {};
  Map<String, dynamic> chartData = {};

  Future<Map<String, dynamic>> getMeterInfo() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getMeterInfo(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getVoltageCure() async {
    Map<String, dynamic> params = {};
    params['loopId'] = widget.loopId;
    params['time'] = widget.seleteTime;
    var data = await EleMeterDao.getVoltageCure(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return chartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFF7F7F9),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          FutureBuilder(
              future: getMeterInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('A相电压',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(V)",
                                "${viewData['maxATermVoltage'] ?? "--"}",
                                "${viewData['maxATermVoltageTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(V)",
                                "${viewData['minATermVoltage'] ?? "--"}",
                                "${viewData['minATermVoltageTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(V)",
                                "${viewData['avgATermVoltage'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('B相电压',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(V)",
                                "${viewData['maxBTermVoltage'] ?? "--"}",
                                "${viewData['maxBTermVoltageTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(V)",
                                "${viewData['minBTermVoltage'] ?? "--"}",
                                "${viewData['minBTermVoltageTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(V)",
                                "${viewData['avgBTermVoltage'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('C相电压',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView(
                                "最大值(V)",
                                "${viewData['maxCTermVoltage'] ?? "--"}",
                                "${viewData['maxCTermVoltageTime'] ?? "--"}"),
                            const SizedBox(width: 15),
                            _cellView(
                                "最小值(V)",
                                "${viewData['minCTermVoltage'] ?? "--"}",
                                "${viewData['minCTermVoltageTime'] ?? "--"}"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _cellView("平均值(V)",
                                "${viewData['avgCTermVoltage'] ?? "--"}", ""),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('暂无数据!',
                                  style: TextStyle(fontSize: 20)))));
                } else {
                  return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('电压曲线',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getVoltageCure(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List xdata = chartData['xlist'];
                        List yaxis1 = chartData['avoltageList'];
                        List yaxis2 = chartData['bvoltageList'];
                        List yaxis3 = chartData['cvoltageList'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "grid": {
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": ['A相电压', 'B相电压', 'C相电压'],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "V",
                              }
                            ],
                            "series": [
                              {
                                'name': 'A相电压',
                                "data": yaxis1,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#FBAF38'
                              },
                              {
                                'name': 'B相电压',
                                "data": yaxis2,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#EE6666'
                              },
                              {
                                'name': 'C相电压',
                                "data": yaxis3,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#4ECCDF'
                              }
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: SizedBox(
                                height: 200,
                                child: Center(
                                    child: Text('暂无数据!',
                                        style: TextStyle(fontSize: 20)))));
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    })
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
