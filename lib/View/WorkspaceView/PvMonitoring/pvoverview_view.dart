import 'dart:convert';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/utils/dateTimeEx.dart';
import '../../../dao/daoX.dart';
import '../../../toolview/appColor.dart';
import 'package:suncloudm/generated/l10n.dart';

class PvOverView extends StatefulWidget {
  final Map pageData;
  final String itemId;

  const PvOverView(this.itemId, {super.key, required this.pageData});

  @override
  State<PvOverView> createState() => _PvOverViewState();
}

class _PvOverViewState extends State<PvOverView> {
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic> lineChartData = {};
  DateTime seleteTime = DateTime.now();
  DateTime seleteTimeX = DateTime.now();
  List<String> formatsX = [
    date_format.yyyy,
    '-',
    date_format.mm,
    '-',
    date_format.dd
  ];
  int _currentDateType = 0;
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  Map<String, dynamic> barChartData = {};

  Future<Map<String, dynamic>> getPvInverterEp() async {
    Map<String, dynamic> params = {};
    params['time'] = date_format.formatDate(seleteTime,
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    if (isOperator == true && singleId == null) {
      params['stationId'] = widget.itemId;
    }
    if (isOperator == true && singleId != null) {
      params['stationId'] = singleId;
    }
    debugPrint(params.toString());
    var data = await IndexDao.getPvInverterEp(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return lineChartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getPvInverterPower() async {
    Map<String, dynamic> params = {};
    params['time'] = date_format.formatDate(seleteTimeX, formatsX);
    if (isOperator == true && singleId == null) {
      params['stationId'] = widget.itemId;
    }
    if (isOperator == true && singleId != null) {
      params['stationId'] = singleId;
    }
    var data = await IndexDao.getPvInverterPower(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return barChartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    List xdata = [];
    List yaxis = [];

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('${S.current.overview}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.generation_today}(kWh)",
                        "${widget.pageData['daySum'] ?? "--"}"),
                    const SizedBox(width: 15),
                    _cellView("${S.current.flh_today}(h)",
                        "${widget.pageData['fdHour'] ?? "--"}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.generation_this_month}(kWh)",
                        "${widget.pageData['monthSum'] ?? "--"}"),
                    const SizedBox(width: 15),
                    _cellView("${S.current.generation_this_year}(kWh)",
                        "${widget.pageData['yearSum'] ?? "--"}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.total_generation}(kWh)",
                        "${widget.pageData['totalSum']}"),
                    const SizedBox(width: 15),
                    _cellView("${S.current.total_on_grid}(kWh)",
                        "${widget.pageData['totalReverseSum']}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.consumption}(%)",
                        "${widget.pageData['consumptionRate'] ?? "--"}"),
                    const SizedBox(width: 15),
                    _cellView("${S.current.irradiance}(Wm³)",
                        "${widget.pageData['radiationvalue'] ?? "--"}"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///功率趋势
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('${S.current.power_trend}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          seleteTime =
                              seleteTime.subtract(const Duration(days: 1));
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_back_ios_sharp)),
                    Expanded(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              date_format.formatDate(seleteTime, [
                                date_format.yyyy,
                                '-',
                                date_format.mm,
                                '-',
                                date_format.dd
                              ]),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            ))),
                    IconButton(
                        onPressed: () {
                          seleteTime = seleteTime.add(const Duration(days: 1));
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_forward_ios_sharp))
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getPvInverterEp(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        xdata = lineChartData['xdata'];
                        yaxis = lineChartData['ydata'];
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
                              "data": yaxis.map((e) => e['name']).toList(),
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "dataZoom": [
                              {
                                "type": 'slider',
                                "xAxisIndex": 0,
                                "start": 0,
                                "end": 100
                              },
                              {
                                "type": 'inside',
                                "xAxisIndex": 0,
                                "start": 0,
                                "end": 100,
                                'minValueSpan': 10
                              }
                            ],
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
                            "series": yaxis
                                .map(
                                  (e) => {
                                    "name": e['name'],
                                    "data": e['data'],
                                    "type": 'line',
                                    "smooth": true,
                                    "symbol": 'none', // 是否让线条圆滑显示
                                    "color": ColorList()
                                        .lineColorList[yaxis.indexOf(e)]
                                  },
                                )
                                .toList()
                          })),
                        );
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    })
              ],
            ),
          ),

          const SizedBox(height: 10),

          ///电量趋势
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    Text('${S.current.energy_trend}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          switch (_currentDateType) {
                            case 0:
                              {
                                seleteTimeX = seleteTimeX
                                    .subtract(const Duration(days: 1));
                              }
                            case 1:
                              {
                                seleteTimeX = seleteTimeX.previousMonth;
                              }
                            case 2:
                              {
                                seleteTimeX = seleteTimeX.previousYear;
                              }
                          }
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          size: 15,
                        )),
                    Expanded(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              date_format.formatDate(seleteTimeX, formatsX),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black),
                            ))),
                    IconButton(
                        onPressed: () {
                          switch (_currentDateType) {
                            case 0:
                              {
                                seleteTimeX =
                                    seleteTimeX.add(const Duration(days: 1));
                              }
                            case 1:
                              {
                                seleteTimeX = seleteTimeX.nextMonth;
                              }
                            case 2:
                              {
                                seleteTimeX = seleteTimeX.nextYear;
                              }
                          }
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                        )),
                    SizedBox(
                      width: 140,
                      child: MaterialSegmentedControl(
                        verticalOffset: 5,
                        children: {
                          0: Text(S.current.day),
                          1: Text(S.current.month),
                          2: Text(S.current.year)
                        },
                        selectionIndex: _currentDateType,
                        borderColor: const Color.fromRGBO(36, 193, 143, 1),
                        selectedColor: const Color.fromRGBO(36, 193, 143, 1),
                        unselectedColor: Colors.white,
                        selectedTextStyle: const TextStyle(color: Colors.white),
                        unselectedTextStyle: const TextStyle(
                            color: Color.fromRGBO(36, 193, 1435, 1)),
                        borderWidth: 0.7,
                        borderRadius: 32.0,
                        onSegmentTapped: (index) {
                          switch (index) {
                            case 0:
                              {
                                _currentDateType = 0;
                                formatsX = [
                                  date_format.yyyy,
                                  '-',
                                  date_format.mm,
                                  '-',
                                  date_format.dd
                                ];
                              }
                            case 1:
                              {
                                _currentDateType = 1;
                                formatsX = [
                                  date_format.yyyy,
                                  '-',
                                  date_format.mm
                                ];
                              }
                            case 2:
                              {
                                _currentDateType = 2;
                                formatsX = [date_format.yyyy];
                              }
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getPvInverterPower(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        xdata = barChartData['xdata'];
                        yaxis = barChartData['ydata'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "legend": {
                              "textStyle": {"fontSize": 10, "color": '#333'},
                              "itemGap": 2,
                              //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                              "data": yaxis.map((e) => e['name']).toList(),
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
                            "grid": {
                              "top": "27%",
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "series": yaxis
                                .map(
                                  (e) => {
                                    "name": e['name'],
                                    "data": e['data'],
                                    "type": 'bar',
                                    "smooth": true, // 是否让线条圆滑显示
                                    "stack": "总量",
                                    "color": ColorList()
                                        .lineColorList[yaxis.indexOf(e)]
                                  },
                                )
                                .toList()
                          })),
                        );
                      } else {
                        return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()));
                      }
                    })
              ],
            ),
          ),
        ],
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

  // _pointView(Color color, String num) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 8.0,
  //         height: 8.0,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: color,
  //         ),
  //       ),
  //       const SizedBox(width: 5),
  //       Text(
  //         num,
  //         style: const TextStyle(fontSize: 12),
  //       ),
  //     ],
  //   );
  // }
}
