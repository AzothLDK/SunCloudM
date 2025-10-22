import 'dart:async';
import 'package:date_format/date_format.dart' as date_format;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/toolview/appColor.dart';
import 'package:suncloudm/utils/dateTimeEx.dart';
import 'package:tab_container/tab_container.dart';
import 'package:suncloudm/toolview/imports.dart';

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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

_statusView(Map statusInfo, BuildContext context) {
  String title = statusInfo['name'] ?? '';
  bool value = statusInfo['value'];
  return Expanded(
    child: InkWell(
      onTap: () {
        Map datemap = {
          "field": statusInfo['field'],
          "deviceCode": statusInfo['deviceCode']
        };
        var json = jsonEncode(datemap);
        Routes.instance!.navigateTo(context, Routes.cnmonitoringYxpage, json);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 40,
        decoration: BoxDecoration(
            color: value ? const Color(0xFF24C18F) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 12,
                    color: value ? Colors.white : const Color(0xFF8693AB)),
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: value ? Colors.white : const Color(0xFF8693AB),
              size: 15,
            )
          ],
        ),
      ),
    ),
  );
}

class OverViewSegement extends StatefulWidget {
  final Map companyData;
  const OverViewSegement({super.key, required this.companyData});

  @override
  State<OverViewSegement> createState() => _OverViewSegementState();
}

class _OverViewSegementState extends State<OverViewSegement> {
  Map<String, dynamic> lineChartData = {};
  DateTime seleteTime = DateTime.now();
  DateTime seleteTimeX = DateTime.now();
  List<String> formatsX = [date_format.yyyy, '-', date_format.mm];
  int _currentDateType = 0;

  Map stationInfoData = {};
  Map<String, dynamic> barChartData = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getCnOverviewHomepage();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      getCnOverviewHomepage();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant OverViewSegement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.companyData != oldWidget.companyData) {
      getCnOverviewHomepage();
    }
  }

  getCnOverviewHomepage() async {
    Map<String, dynamic> params = {};
    params['itemId'] = widget.companyData['id'];
    var data = await CnMonitorDao.cnOverviewHomepage(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        stationInfoData = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  Future<Map<String, dynamic>> getcnEpList() async {
    Map<String, dynamic> params = {};
    params['dateStr'] = date_format.formatDate(seleteTime,
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    params['itemId'] = widget.companyData['id'];
    var data = await CnMonitorDao.getcnEpList(params: params);
    // debugPrint(data.toString());
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

  Future<Map<String, dynamic>> getcnChargeList() async {
    Map<String, dynamic> params = {};
    params['dateStr'] = date_format.formatDate(seleteTimeX, formatsX);
    params['itemId'] = widget.companyData['id'];
    var data = await CnMonitorDao.getcnChargeList(params: params);
    // debugPrint(data.toString());
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
    List yaxis1 = [];
    List yaxis2 = [];
    List yaxis3 = [];
    List yaxis4 = [];
    List yaxis5 = [];

    List xdataE = [];
    List yaxisE1 = [];
    List yaxisE2 = [];
    List yaxisE3 = [];

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
                    Expanded(
                      child: Text(S.current.station_overview,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.power} (kW)",
                        "${stationInfoData['nowEp'] ?? '--'}", ""),
                    const SizedBox(width: 15),
                    _cellView("${S.current.status}",
                        "${stationInfoData['status'] ?? '--'}", ""),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.total_charging} (MWh)",
                        "${stationInfoData['chargeTotal'] ?? '--'}", ""),
                    const SizedBox(width: 15),
                    _cellView("${S.current.total_discharge} (MWh)",
                        "${stationInfoData['dischargeTotal'] ?? '--'}", ""),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.charging_capacity} (kWh)",
                        "${stationInfoData['chargeAvailable'] ?? '--'}", ""),
                    const SizedBox(width: 15),
                    _cellView("${S.current.discharging_capacity} (kWh)",
                        "${stationInfoData['dischargeAvailable'] ?? '--'}", ""),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView(
                        "${S.current.charge_discharge_ratio_this_month} (%)",
                        "${stationInfoData['chargeRatio'] ?? '--'}",
                        ""),
                    const SizedBox(width: 15),
                    _cellView(
                        "SOC(%)", "${stationInfoData['soc'] ?? '--'}", ""),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.commissioning_time}",
                        "${stationInfoData['operationTime'] ?? '--'}", ""),
                    const SizedBox(width: 15),
                    _cellView("${S.current.safe_operation_days} (d)",
                        "${stationInfoData['operationNumber'] ?? '--'}", ""),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("${S.current.rated_power} (MW)",
                        "${stationInfoData['power'] ?? '--'}", ""),
                    const SizedBox(width: 15),
                    _cellView("${S.current.installed_capacity} (MWh)",
                        "${stationInfoData['capacity'] ?? '--'}", ""),
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
                    future: getcnEpList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        xdata = lineChartData['xdata'];
                        yaxis1 = lineChartData['ydata1'];
                        yaxis2 = lineChartData['ydata2'];
                        yaxis3 = lineChartData['ydataGk'];
                        yaxis4 = lineChartData['ydataYesTodayGk'];
                        yaxis5 = lineChartData['ydataCharge'];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "confine": true,
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
                              "data": [S.current.ess, S.current.grid, 'SOC'],
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
                              },
                              {
                                "type": 'value',
                                "name": "%",
                              },
                            ],
                            // "dataZoom": [
                            //   {
                            //     "type": 'slider',
                            //     "xAxisIndex": 0,
                            //     "start": 0,
                            //     "end": 100
                            //   },
                            //   {
                            //     "type": 'inside',
                            //     "xAxisIndex": 0,
                            //     "start": 0,
                            //     "end": 100,
                            //     'minValueSpan': 10
                            //   }
                            // ],
                            "series": [
                              // {
                              //   'name': '昨日',
                              //   "data": yaxis1,
                              //   "type": 'line',
                              //   "color": '#3D71FD'
                              // },
                              {
                                'name': S.current.ess,
                                "data": yaxis2,
                                "type": 'line',
                                "symbol": 'none',
                                "color": '#C666DE'
                              },
                              // {
                              //   'name': '昨日电网',
                              //   "data": yaxis3,
                              //   // "yAxisIndex": '1',
                              //   "smooth": true, // 是否让线条圆滑显示
                              //   "type": "line",
                              //   "color": '#2ED75A'
                              // },
                              {
                                'name': S.current.grid,
                                "data": yaxis3,
                                // "yAxisIndex": '1',
                                "smooth": true, // 是否让线条圆滑显示
                                "type": "line",
                                "symbol": 'none',
                                "color": '#4ECCDF'
                              },
                              {
                                'name': 'SOC',
                                "data": yaxis5,
                                "yAxisIndex": '1',
                                "smooth": true, // 是否让线条圆滑显示
                                "type": "line",
                                "symbol": 'none',
                                "color": '#FB8208'
                              },
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(S.current.no_data,
                                style: const TextStyle(fontSize: 20)));
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
                    Text(S.current.energy_trend,
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
                                seleteTimeX = seleteTimeX.previousMonth;
                              }
                            case 1:
                              {
                                seleteTimeX = seleteTimeX.previousYear;
                              }
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_back_ios_sharp)),
                    Expanded(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              date_format.formatDate(seleteTimeX, formatsX),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            ))),
                    IconButton(
                        onPressed: () {
                          switch (_currentDateType) {
                            case 0:
                              {
                                seleteTimeX = seleteTimeX.nextMonth;
                              }
                            case 1:
                              {
                                seleteTimeX = seleteTimeX.nextYear;
                              }
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_forward_ios_sharp)),
                    SizedBox(
                      width: 120,
                      child: MaterialSegmentedControl(
                        verticalOffset: 5,
                        children: {
                          0: Text(S.current.month),
                          1: Text(S.current.year)
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
                                  date_format.mm
                                ];
                              }
                            case 1:
                              {
                                _currentDateType = 1;
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
                    future: getcnChargeList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        xdataE = barChartData['xList'];
                        yaxisE1 = barChartData['yList'];
                        yaxisE2 = barChartData['yList2'];
                        yaxisE3 = barChartData['yList3'];
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
                              "data": [
                                S.current.charging,
                                S.current.discharging,
                                S.current.charge_discharge_ratio
                              ],
                              //图例的数据数组。
                              "inactiveColor": '#ccc',
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdataE,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": "kWh",
                              },
                              {
                                "type": 'value',
                                "name": "%",
                              },
                            ],
                            "grid": {
                              "top": "27%",
                              "left": "3%",
                              "right": "4%",
                              'bottom': '3%',
                              "containLabel": true
                            },
                            "series": [
                              {
                                'name': S.current.charging,
                                "data": yaxisE1,
                                "type": 'bar',
                                "color": '#3D71FD'
                              },
                              {
                                'name': S.current.discharging,
                                "data": yaxisE2,
                                "type": 'bar',
                                "color": '#FBAF38'
                              },
                              {
                                'name': S.current.charge_discharge_ratio,
                                "data": yaxisE3,
                                "yAxisIndex": '1',
                                "smooth": true, // 是否让线条圆滑显示
                                "type": "line",
                                "symbol": 'none',
                                "color": '#2ED75A'
                              },
                            ]
                          })),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(S.current.no_data,
                                style: const TextStyle(fontSize: 20)));
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
}

class PCSSegement extends StatefulWidget {
  final Map companyData;
  final Map deviceData;
  const PCSSegement(
      {super.key, required this.companyData, required this.deviceData});

  @override
  State<PCSSegement> createState() => _PCSSegementState();
}

class _PCSSegementState extends State<PCSSegement> {
  List deviceList = [];
  Map seleteDevice = {};

  List runInfoList = [];
  List runStatusList = [];
  bool _isExpanded = true; // 新增状态管理
  bool _isExpandedX = true; // 新增状态管理
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    tabDataSelectList();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      getRunInfo();
      getRunStatus();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  tabDataSelectList() async {
    Map<String, dynamic> params = {};
    params['itemId'] = widget.companyData['id'];
    params['name'] = widget.deviceData['name'];
    params['tagSign'] = widget.deviceData['tagSign'];
    print(params.toString());
    var data = await CnMonitorDao.tabDataSelectList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        deviceList = data['data'];
        if (deviceList.isNotEmpty) {
          seleteDevice = deviceList[0];
          getRunInfo();
          getRunStatus();
        }
      } else {}
    } else {}
  }

  getRunInfo() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = seleteDevice['deviceCode'];
    params['tagSign'] = widget.deviceData['tagSign'];
    var data = await CnMonitorDao.getTabUpData(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        runInfoList = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  getRunStatus() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = seleteDevice['deviceCode'];
    params['tagSign'] = widget.deviceData['tagSign'];
    var data = await CnMonitorDao.getTabDownData(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        runStatusList = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  getCellsView() {
    if (runInfoList.isNotEmpty) {
      List<Widget> cellViews = [];
      int showNum;
      if (_isExpanded == true) {
        if (runInfoList.length > 8) {
          showNum = 8;
        } else {
          showNum = runInfoList.length;
        }
      } else {
        showNum = runInfoList.length;
      }
      for (int i = 0; i < showNum; i += 2) {
        Widget firstCell = _cellView(
            (runInfoList[i]['name'] ?? '--') + (runInfoList[i]['unit'] ?? ''),
            (runInfoList[i]['label'] ?? '--').toString(),
            '');
        Widget? secondCell;
        if (i + 1 < showNum) {
          secondCell = _cellView(
              (runInfoList[i + 1]['name'] ?? '--') +
                  (runInfoList[i + 1]['unit'] ?? ''),
              (runInfoList[i + 1]['label'] ?? '--').toString(),
              '');
        }
        cellViews.add(
          Column(
            children: [
              Row(
                children: [
                  firstCell,
                  if (secondCell != null) ...[
                    const SizedBox(width: 10),
                    secondCell
                  ]
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }
      return Column(
        children: cellViews,
      );
    } else {
      return Center(child: Container());
    }
  }

  getStatusCellsView() {
    if (runStatusList.isNotEmpty) {
      List<Widget> cellViews = [];
      int showNum;
      if (_isExpandedX == true) {
        if (runStatusList.length > 8) {
          showNum = 8;
        } else {
          showNum = runStatusList.length;
        }
      } else {
        showNum = runStatusList.length;
      }
      for (int i = 0; i < showNum; i += 2) {
        Widget firstCell = _statusView(runStatusList[i], context);
        Widget? secondCell;
        if (i + 1 < showNum) {
          secondCell = _statusView(runStatusList[i + 1], context);
        }
        cellViews.add(
          Column(
            children: [
              Row(
                children: [
                  firstCell,
                  if (secondCell != null) ...[
                    const SizedBox(width: 10),
                    secondCell
                  ]
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }
      return Column(
        children: cellViews,
      );
    } else {
      return Center(child: Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: Text(
                        seleteDevice['deviceName'] ?? "--",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      items: deviceList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['deviceCode'].toString(),
                                child: Text(
                                  item['deviceName'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        return null;
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        for (var item in deviceList) {
                          if (item['deviceCode'].toString() == value) {
                            seleteDevice = item;
                          }
                        }
                        getRunInfo();
                        getRunStatus();
                      },
                      onSaved: (value) {},
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16))),
                ),
              ),
              const SizedBox(height: 10),
              Container(
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
                        Text(S.current.running_data,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        IconButton(
                          icon: Icon(_isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    getCellsView()
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
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
                        Text(S.current.running_status,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        IconButton(
                          icon: Icon(_isExpandedX
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _isExpandedX = !_isExpandedX;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    getStatusCellsView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BMSSegement extends StatefulWidget {
  final Map companyData;
  final Map deviceData;
  const BMSSegement(
      {super.key, required this.companyData, required this.deviceData});

  @override
  State<BMSSegement> createState() => _BMSSegementState();
}

class _BMSSegementState extends State<BMSSegement>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabContainer(
      controller: _tabController,
      // color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      tabBorderRadius: BorderRadius.circular(10),
      childPadding: const EdgeInsets.all(0.0),
      selectedTextStyle: const TextStyle(
        color: Color(0xFF24C18F),
        fontSize: 16.0,
      ),
      unselectedTextStyle: const TextStyle(
        color: Colors.blueGrey,
        fontSize: 14.0,
      ),
      tabs: [
        Text(S.current.cluster_monitoring),
        Text(S.current.cell_monitoring),
      ],
      children: [
        SingleChildScrollView(
            child: BMSCPage(
                companyData: widget.companyData,
                deviceData: widget.deviceData)),
        SingleChildScrollView(
            child: BMSDXPage(
                companyData: widget.companyData,
                deviceData: widget.deviceData)),
      ],
    );
  }
}

class BMSCPage extends StatefulWidget {
  final Map companyData;
  final Map deviceData;
  const BMSCPage(
      {super.key, required this.companyData, required this.deviceData});

  @override
  State<BMSCPage> createState() => _BMSCPageState();
}

class _BMSCPageState extends State<BMSCPage> {
  List dList = [];
  Map seleteD = {};

  List cList = [];
  Map seleteC = {};

  List runInfoList = [];
  List runStatusList = [];
  bool _isExpanded = true; // 新增状态管理
  bool _isExpandedX = true; // 新增状态管理
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    tabDataSelectList();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      getRunInfo();
      getRunStatus();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  tabDataSelectList() async {
    Map<String, dynamic> params = {};
    params['itemId'] = widget.companyData['id'];
    params['name'] = widget.deviceData['name'];
    params['tagSign'] = widget.deviceData['tagSign'];
    var data = await CnMonitorDao.tabDataSelectList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        dList = data['data'];
        if (dList.isNotEmpty) {
          seleteD = dList[0];
          cList = seleteD['childList'];
          seleteC = cList[0];
          getRunInfo();
          getRunStatus();
        }
      } else {}
    } else {}
  }

  getRunInfo() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = seleteC['deviceCode'];
    params['tagSign'] = widget.deviceData['tagSign'];
    print(params.toString());
    var data = await CnMonitorDao.getTabUpData(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        runInfoList = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  getRunStatus() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = seleteC['deviceCode'];
    params['tagSign'] = widget.deviceData['tagSign'];
    print(params.toString());
    var data = await CnMonitorDao.getTabDownData(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        runStatusList = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  getCellsView() {
    if (runInfoList.isNotEmpty) {
      List<Widget> cellViews = [];
      int showNum;
      if (_isExpanded == true) {
        if (runInfoList.length > 8) {
          showNum = 8;
        } else {
          showNum = runInfoList.length;
        }
      } else {
        showNum = runInfoList.length;
      }
      for (int i = 0; i < showNum; i += 2) {
        Widget firstCell = _cellView(
            runInfoList[i]['name'] +
                (runInfoList[i]['unit'] != null ? runInfoList[i]['unit'] : ''),
            (runInfoList[i]['label'] ?? '--').toString(),
            '');
        Widget? secondCell;
        if (i + 1 < showNum) {
          secondCell = _cellView(
              runInfoList[i + 1]['name'] +
                  (runInfoList[i + 1]['unit'] != null
                      ? runInfoList[i + 1]['unit']
                      : ''),
              (runInfoList[i + 1]['label'] ?? '--').toString(),
              '');
        }
        cellViews.add(
          Column(
            children: [
              Row(
                children: [
                  firstCell,
                  if (secondCell != null) ...[
                    const SizedBox(width: 10),
                    secondCell
                  ]
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }
      return Column(
        children: cellViews,
      );
    } else {
      return Center(child: Container());
    }
  }

  getStatusCellsView() {
    if (runStatusList.isNotEmpty) {
      List<Widget> cellViews = [];
      int showNum;
      if (_isExpandedX == true) {
        if (runStatusList.length > 8) {
          showNum = 8;
        } else {
          showNum = runStatusList.length;
        }
      } else {
        showNum = runStatusList.length;
      }
      for (int i = 0; i < showNum; i += 2) {
        Widget firstCell = _statusView(runStatusList[i], context);
        Widget? secondCell;
        if (i + 1 < showNum) {
          secondCell = _statusView(runStatusList[i + 1], context);
        }
        cellViews.add(
          Column(
            children: [
              Row(
                children: [
                  firstCell,
                  if (secondCell != null) ...[
                    const SizedBox(width: 10),
                    secondCell
                  ]
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }
      return Column(
        children: cellViews,
      );
    } else {
      return Center(child: Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 40,
                child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: Text(
                      seleteD['deviceName'] ?? "--",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    items: dList
                        .map((item) => DropdownMenuItem<String>(
                              value: item['deviceCode'].toString(),
                              child: Text(
                                item['deviceName'],
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      return null;
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      for (var item in dList) {
                        if (item['deviceCode'].toString() == value) {
                          seleteD = item;
                          cList = seleteD['childList'];
                          seleteC = cList[0];
                        }
                        getRunInfo();
                        getRunStatus();
                      }
                    },
                    onSaved: (value) {},
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16))),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 40,
                child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: seleteC['deviceCode'],
                    hint: Text(
                      seleteC['deviceName'] ?? "--",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    items: cList
                        .map((item) => DropdownMenuItem<String>(
                              value: item['deviceCode'].toString(),
                              child: Text(
                                item['deviceName'],
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      return null;
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      for (var item in cList) {
                        if (item['deviceCode'].toString() == value) {
                          seleteC = item;
                        }
                      }
                      getRunInfo();
                      getRunStatus();
                    },
                    onSaved: (value) {},
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16))),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
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
                Text(S.current.running_data,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  icon:
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            getCellsView(),
          ],
        ),
      ),
      const SizedBox(height: 10),
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
                Text(S.current.running_status,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  icon: Icon(
                      _isExpandedX ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpandedX = !_isExpandedX;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            getStatusCellsView(),
          ],
        ),
      ),
    ]);
  }
}

class BMSDXPage extends StatefulWidget {
  final Map companyData;
  final Map deviceData;
  const BMSDXPage(
      {super.key, required this.companyData, required this.deviceData});

  @override
  State<BMSDXPage> createState() => _BMSDXPageState();
}

class _BMSDXPageState extends State<BMSDXPage> {
  List dList = [];
  Map seleteD = {};

  List cList = [];
  Map seleteC = {};

  List dxList = [];
  Map seleteDx = {};

  Map<String, dynamic> lineChartDataV = {};

  Map<String, dynamic> lineChartDataW = {};
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {});
    });
    tabDataSelectList();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  tabDataSelectList() async {
    Map<String, dynamic> params = {};
    params['itemId'] = widget.companyData['id'];
    params['name'] = widget.deviceData['name'];
    params['tagSign'] = widget.deviceData['tagSign'];
    var data = await CnMonitorDao.tabDataSelectList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        dList = data['data'];
        if (dList.isNotEmpty) {
          seleteD = dList[0];
          cList = seleteD['childList'];
          seleteC = cList[0];
          dxList = seleteC['childList'];
          seleteDx = dxList[0];
          setState(() {});
        }
      } else {}
    } else {}
  }

  Future<Map<String, dynamic>> getDXVdata() async {
    Map<String, dynamic> params = {};
    params['bmuId'] = seleteDx['deviceId'];
    params['type'] = 1;
    var data = await CnMonitorDao.getDXdata(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return lineChartDataV = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getDXWdata() async {
    Map<String, dynamic> params = {};
    params['bmuId'] = seleteDx['deviceId'];
    params['type'] = 2;
    var data = await CnMonitorDao.getDXdata(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return lineChartDataW = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    List xvlist = [];
    List yvlist = [];

    List xwlist = [];
    List ywlist = [];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: Text(
                        seleteD['deviceName'] ?? "--",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      items: dList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['deviceCode'].toString(),
                                child: Text(
                                  item['deviceName'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        return null;
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        for (var item in dList) {
                          if (item['deviceCode'].toString() == value) {
                            seleteD = item;
                            cList = seleteD['childList'];
                            seleteC = cList[0];
                            dxList = seleteC['childList'];
                            seleteDx = dxList[0];
                          }
                          setState(() {});
                        }
                      },
                      onSaved: (value) {},
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16))),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: seleteC['deviceCode'],
                      hint: Text(
                        seleteC['deviceName'] ?? "--",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      items: cList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['deviceCode'].toString(),
                                child: Text(
                                  item['deviceName'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        return null;
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        for (var item in cList) {
                          if (item['deviceCode'].toString() == value) {
                            seleteC = item;
                            dxList = seleteC['childList'];
                            seleteDx = dxList[0];
                          }
                        }
                        setState(() {});
                      },
                      onSaved: (value) {},
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16))),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  height: 40,
                  child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: seleteDx['deviceId'],
                      hint: Text(
                        seleteDx['deviceName'] ?? "--",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      items: dxList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['deviceId'].toString(),
                                child: Text(
                                  item['deviceName'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        return null;
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        for (var item in cList) {
                          if (item['deviceId'].toString() == value) {
                            seleteDx = item;
                          }
                        }
                        setState(() {});
                      },
                      onSaved: (value) {},
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16))),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //单体电压
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
                  Text('单体电压',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                  future: getDXVdata(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      xvlist = lineChartDataV['xlist'];
                      yvlist = lineChartDataV['ylist'];
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
                          "confine": true,
                          "legend": {
                            "type": 'scroll',
                            "textStyle": {"fontSize": 10, "color": '#333'},
                            "itemGap": 2,
                            //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                            "data": yvlist.map((e) => e['value']).toList(),
                            //图例的数据数组。
                            "inactiveColor": '#ccc',
                          },
                          "xAxis": {
                            "type": 'category',
                            "data": xvlist,
                          },
                          "yAxis": [
                            {
                              "type": 'value',
                              "name": "V",
                            }
                          ],
                          "series": yvlist
                              .map(
                                (e) => {
                                  "name": e['value'],
                                  "data": e['valueList'],
                                  "type": 'line',
                                  "smooth": true, // 是否让线条圆滑显示
                                  "symbol": 'none',
                                  "color": ColorList()
                                      .lineColorList[yvlist.indexOf(e)]
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
        //单体电压
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
                  Text('单体温度',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                  future: getDXWdata(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      xwlist = lineChartDataW['xlist'];
                      ywlist = lineChartDataW['ylist'];
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
                          "confine": true,
                          "legend": {
                            "type": 'scroll',
                            "textStyle": {"fontSize": 10, "color": '#333'},
                            "itemGap": 2,
                            //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                            "data": ywlist.map((e) => e['value']).toList(),
                            //图例的数据数组。
                            "inactiveColor": '#ccc',
                          },
                          "xAxis": {
                            "type": 'category',
                            "data": xwlist,
                          },
                          "yAxis": [
                            {
                              "type": 'value',
                              "name": "℃",
                            }
                          ],
                          "series": ywlist
                              .map(
                                (e) => {
                                  "name": e['value'],
                                  "data": e['valueList'],
                                  "type": 'line',
                                  "smooth": true, // 是否让线条圆滑显示
                                  "symbol": 'none',
                                  "color": ColorList()
                                      .lineColorList[ywlist.indexOf(e)]
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
    );
  }
}
