import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/toolview/imports.dart';

class ProfitanalysisCn extends StatefulWidget {
  final Map? companyinfo;
  const ProfitanalysisCn({super.key, this.companyinfo});

  @override
  State<ProfitanalysisCn> createState() => _ProfitanalysisCnState();
}

class _ProfitanalysisCnState extends State<ProfitanalysisCn> {
  Map infoincomeData = {};
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);

  // Future<Map<String, dynamic>> getincomeRadarData() async {
  //   Map<String, dynamic> params = {};
  //   params['stationId'] = widget.companyinfo['id'];
  //   print('参数$params');
  //   var data = await ReportDao.getSingleIncomeUrl(params: params);
  //   if (data["code"] == 200) {
  //     if (data['data'] != null) {
  //       return infoincomeData = data['data'];
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
  @override
  void initState() {
    super.initState();
    getincomeinfoData();
  }

  @override
  void didUpdateWidget(covariant ProfitanalysisCn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.companyinfo != oldWidget.companyinfo) {
      getincomeinfoData();
    }
  }

  String? singleId = GlobalStorage.getSingleId();

  getincomeinfoData() async {
    Map<String, dynamic> params = {};
    if (widget.companyinfo?['id'] != null) {
      params['stationId'] = widget.companyinfo?['id'];
    }
    if (singleId != null) {
      params["stationId"] = singleId;
    }
    var data = await ReportDao.getSingleIncome(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        infoincomeData = data['data'];
        setState(() {});
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  Text(S.current.operational_data,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cellView(
                      "${S.current.total_investment}(${S.current.tenk_RMB})",
                      "${infoincomeData['investmentTotal']}"),
                  const SizedBox(width: 15),
                  _cellView("${S.current.payback_period}(${S.current.month})",
                      "${infoincomeData['forecastCycle']}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cellView(
                      "${S.current.revenue_this_month}(${S.current.tenk_RMB})",
                      "${infoincomeData['incomeCnMonth']}"),
                  const SizedBox(width: 15),
                  _cellView("${S.current.total_revenue}(${S.current.tenk_RMB})",
                      "${infoincomeData['incomeCnTotal']}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cellView("${S.current.charging_this_month}(MWh)",
                      "${infoincomeData['chargeMonth']}"),
                  const SizedBox(width: 15),
                  _cellView("${S.current.discharge_this_month}(MWh)",
                      "${infoincomeData['disChargeMonth']}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cellView("${S.current.fault_time}(h)",
                      "${infoincomeData['alarmHourMonth'] ?? "--"}"),
                  const SizedBox(width: 14),
                  _cellView("${S.current.operation_time}(h)",
                      "${infoincomeData['builtTime'] ?? "--"}"),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        CNIncomeChart(companyId: widget.companyinfo?['id']?.toString()),
        const SizedBox(height: 10),
        RadarChartView(companyId: widget.companyinfo?['id'].toString())
      ],
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
            const SizedBox(height: 6),
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

class CNIncomeChart extends StatefulWidget {
  final String? companyId;
  const CNIncomeChart({super.key, this.companyId});

  @override
  State<CNIncomeChart> createState() => _CNIncomeChartState();
}

class _CNIncomeChartState extends State<CNIncomeChart> {
  String seletetime = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  int _currentDateType = 0;

  Map chartData = {};
  List xList = [];
  List disChargeMonth = [];
  List incomeCnMonth = [];
  List chargeEfficiency = [];
  List chargeMonth = [];

  String? singleId = GlobalStorage.getSingleId();

  Future<Map> getSingleIncomeCurve() async {
    Map<String, dynamic> params = {};
    params['time'] = seletetime;
    if (widget.companyId != null) {
      params['stationId'] = widget.companyId;
    }
    if (singleId != null) {
      params["stationId"] = singleId;
    }
    var data = await ReportDao.getSingleIncomeCurve(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        chartData = data['data'];
        return chartData;
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
              Text(S.current.revenue_analysis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      if (_currentDateType == 0) {
                        DateTime? d = await showMonthYearPicker(
                          context: context,
                          initialMonthYearPickerMode: MonthYearPickerMode.month,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          locale: savedLanguage == 'zh'
                              ? const Locale('zh')
                              : const Locale('en'),
                        );
                        if (d != null) {
                          seletetime = date_format.formatDate(
                              d, [date_format.yyyy, '-', date_format.mm]);
                          setState(() {});
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
                                    firstDate: DateTime(2000, 5),
                                    lastDate: DateTime(2050, 5),
                                    selectedDate: DateTime.now(),
                                    onChanged: (DateTime value) {
                                      seletetime = date_format.formatDate(
                                          value, [date_format.yyyy]);
                                      setState(() {});
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
                          color: Color.fromRGBO(212, 212, 212, 1), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          seletetime,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black26),
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
                width: 110,
                child: MaterialSegmentedControl(
                  verticalOffset: 5,
                  children: {0: Text(S.current.month), 1: Text(S.current.year)},
                  selectionIndex: _currentDateType,
                  borderColor: const Color.fromRGBO(36, 193, 143, 1),
                  selectedColor: const Color.fromRGBO(36, 193, 143, 1),
                  unselectedColor: Colors.white,
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  unselectedTextStyle:
                      const TextStyle(color: Color.fromRGBO(36, 193, 1435, 1)),
                  borderWidth: 0.7,
                  borderRadius: 32.0,
                  onSegmentTapped: (index) {
                    switch (index) {
                      case 0:
                        {
                          _currentDateType = 0;
                          seletetime = date_format.formatDate(DateTime.now(),
                              [date_format.yyyy, '-', date_format.mm]);
                          setState(() {});
                        }
                      case 1:
                        {
                          _currentDateType = 1;
                          seletetime = date_format
                              .formatDate(DateTime.now(), [date_format.yyyy]);
                          setState(() {});
                        }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder(
              future: getSingleIncomeCurve(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  xList = chartData['xList'] ?? [];
                  disChargeMonth = chartData['disChargeMonth'] ?? [];
                  incomeCnMonth = chartData['incomeCnMonth'] ?? [];
                  chargeEfficiency = chartData['chargeEfficiency'] ?? [];
                  chargeMonth = chartData['chargeMonth'] ?? [];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Echarts(
                        option: jsonEncode({
                      "zlevel": 11,
                      "grid": {"left": 40, 'right': 30}, // 调整右侧间距以容纳新 Y 轴
                      "tooltip": {"trigger": 'axis'},
                      "confine": true,
                      "legend": {
                        "textStyle": {
                          //图例的公用文本样式。
                          "fontSize": 12,
                          "color": '#333'
                        },
                        "itemGap": 10,
                        //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
                        "data": [
                          S.current.revenue,
                          S.current.charging,
                          S.current.discharging,
                          S.current.charging_efficiency
                        ],
                        //图例的数据数组。
                        "inactiveColor": '#ccc',
                      },
                      "xAxis": {
                        "type": 'category',
                        "data": xList,
                        "axisLabel": {
                          "rotate": 0 // 将标签旋转45度
                        }
                      },
                      "yAxis": [
                        {
                          "type": 'value',
                          "name": "kWh",
                          "position": "left",
                          "axisLine": {"show": true},
                          "splitLine": {"show": true}
                        },
                        {
                          // "data": [0, 20, 40, 60, 80, 100],
                          "type": 'value',
                          "name": _currentDateType == 0
                              ? S.current.yuan
                              : S.current.tenk_RMB,
                          "position": "right",
                          "offset": -30,
                          "axisLabel": {"formatter": '{value}'},
                          "axisLine": {"show": true},
                          "splitLine": {"show": true}
                        },
                        {
                          "data": [0, 20, 40, 60, 80, 100],
                          "type": 'value',
                          "name": "%",
                          "position": "right",
                          "offset": 0,
                          // "axisLabel": {"formatter": '{value}'},
                          "axisLine": {"show": true},
                          "splitLine": {"show": true}
                        }
                      ],
                      "series": [
                        {
                          'name': S.current.revenue,
                          "data": incomeCnMonth,
                          "type": 'line',
                          "smooth": true, // 是否让线条圆滑显示
                          "color": '#FF69B4',
                          "symbol": 'none',
                          "yAxisIndex": 1
                        },
                        {
                          'name': S.current.charging,
                          "data": chargeMonth,
                          "type": 'bar',
                          "color": '#3D71FD',
                          "symbol": 'none',
                          "yAxisIndex": 0
                        },
                        {
                          'name': S.current.discharging,
                          "data": disChargeMonth,
                          "type": 'bar',
                          "color": '#FBAF38',
                          "symbol": 'none',
                          "yAxisIndex": 0
                        },
                        {
                          'name': S.current.charging_efficiency,
                          "data": chargeEfficiency,
                          "smooth": true, // 是否让线条圆滑显示
                          "type": "line",
                          "color": '#2ED75A',
                          "symbol": 'none',
                          "yAxisIndex": 2
                        },
                      ]
                    })),
                  );
                } else {
                  return const SizedBox(
                      height: 280,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
        ],
      ),
    );
  }
}

class RadarChartView extends StatefulWidget {
  final String? companyId;
  const RadarChartView({super.key, this.companyId});

  @override
  State<RadarChartView> createState() => _RadarChartViewState();
}

class _RadarChartViewState extends State<RadarChartView> {
  String radarendDate = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  List radarData = [];

  String? singleId = GlobalStorage.getSingleId();

  Future<List> getOperationRun() async {
    Map<String, dynamic> params = {};
    params['month'] = radarendDate;

    if (widget.companyId != null) {
      params['stationId'] = widget.companyId;
    }
    if (singleId != null) {
      params["stationId"] = singleId;
    }
    var data = await ReportDao.getOperationRun(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return radarData = data['data'];
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
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
              Text(S.current.month_on_month_analysis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ElevatedButton(
              onPressed: () async {
                DateTime? d = await showMonthYearPicker(
                  context: context,
                  initialMonthYearPickerMode: MonthYearPickerMode.month,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                  locale: savedLanguage == 'zh'
                      ? const Locale('zh')
                      : const Locale('en'),
                );
                if (d != null) {
                  radarendDate = date_format
                      .formatDate(d, [date_format.yyyy, '-', date_format.mm]);
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 40),
                shape: const StadiumBorder(),
                side: const BorderSide(
                    color: Color.fromRGBO(212, 212, 212, 1), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    radarendDate,
                    style: const TextStyle(fontSize: 16, color: Colors.black26),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black26,
                    size: 14,
                  )
                ],
              )),
          const SizedBox(height: 6),
          FutureBuilder(
              future: getOperationRun(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        // width: MediaQuery.of(context).size.width - 40,
                        height: 280,
                        child: echarDadarView(radarData),
                      ),
                      getTableView(radarData)
                    ],
                  );
                } else {
                  return const SizedBox(
                      height: 280,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
        ],
      ),
    );
  }

  echarDadarView(List radarData) {
    Map dy = radarData[0];
    List dyList = [
      dy["income"] ?? 0,
      dy["chargeEnergy"] ?? 0,
      dy["disChargeEnergy"] ?? 0,
      dy["trading"] ?? 0,
      dy["alarmTime"] ?? 0,
      dy["peakDifference"] ?? 0,
      dy["batteryRate"] ?? 0,
      dy["chargeEfficiency"] ?? 0
    ];
    Map sy = radarData[1];
    List syList = [
      sy["income"] ?? 0,
      sy["chargeEnergy"] ?? 0,
      sy["disChargeEnergy"] ?? 0,
      sy["trading"] ?? 0,
      sy["alarmTime"] ?? 0,
      sy["peakDifference"] ?? 0,
      sy["batteryRate"] ?? 0,
      sy["chargeEfficiency"] ?? 0
    ];

    Map qn = radarData[1];
    List qnList = [
      qn["income"] ?? 0,
      qn["chargeEnergy"] ?? 0,
      qn["disChargeEnergy"] ?? 0,
      qn["trading"] ?? 0,
      qn["alarmTime"] ?? 0,
      qn["peakDifference"] ?? 0,
      qn["batteryRate"] ?? 0,
      qn["chargeEfficiency"] ?? 0
    ];
    return Echarts(
        option: jsonEncode({
      "color": ['#FBAF38', '#3D71FD', '#E966D8'],
      "tooltip": {},
      "confine": true,
      "legend": {
        "textStyle": {
          //图例的公用文本样式。
          "fontSize": 12,
          "color": '#333'
        },
        "itemGap": 10,
        //图例每项之间的间隔。横向布局时为水平间隔，纵向布局时为纵向间隔。
        "data": [
          S.current.this_month,
          S.current.last_month,
          S.current.same_period_last_year
        ],
        //图例的数据数组。
        "inactiveColor": '#ccc',
      },
      "radar": {
        "center": ['50%', '50%'], // 外圆的位置
        "radius": '50%',
        "name": {
          "textStyle": {
            "color": '#333',
            "fontSize": 10,
            "fontWeight": 400,
            "fontFamily": 'PingFangSC-Regular,PingFang SC',
            "fontStyle": 'normal',
          }
        },
        "indicator": [
          {"name": S.current.revenue, "nameGap": 10},
          {"name": S.current.charging, "nameGap": 10},
          {"name": S.current.discharging, "nameGap": 10},
          {"name": S.current.spot_trading, "nameGap": 10},
          {"name": S.current.fault_time, "nameGap": 10},
          {"name": S.current.peak_valley_price_difference, "nameGap": 10},
          {"name": S.current.battery_decay_rate, "nameGap": 10},
          {"name": S.current.charge_discharge_efficiency, "nameGap": 10},
        ],
      },
      "series": [
        {
          "type": 'radar',
          "symbolSize": 1,
          "data": [
            {
              "value": dyList,
              "name": S.current.this_month,
              "areaStyle": {
                "normal": {"color": 'rgba(251, 175, 56, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            },
            {
              "value": syList,
              "name": S.current.last_month,
              "areaStyle": {
                "normal": {"color": 'rgba(61, 113, 253, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            },
            {
              "value": qnList,
              "name": S.current.same_period_last_year,
              "areaStyle": {
                "normal": {"color": 'rgba(233, 102, 216, 0.3)'}
              },
              "lineStyle": {"width": 0.5},
            }
          ]
        }
      ]
    }));
  }

  getTableView(List radarData) {
    Map dy = radarData[0];
    Map sy = radarData[1];
    Map qn = radarData[2];
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 120,
              height: 40,
              color: const Color(0xFFF2F8F9),
            ),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text(
                    '${S.current.revenue}(${S.current.tenk_RMB})',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8693AB),
                      fontSize: 12,
                    ),
                  ),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.charging}(MWh)',
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.discharging}(MWh)',
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.spot_trading}(MWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.fault_time}(h)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text(
                      '${S.current.peak_valley_price_difference}(${S.current.tenk_RMB}${S.current.tenk_RMB}/kWh)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.battery_decay_rate}(%)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                )),
            Container(
                width: 120,
                height: 40,
                color: const Color(0xFFF2F8F9),
                child: Center(
                  child: Text('${S.current.charge_discharge_efficiency}(%)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8693AB), fontSize: 12)),
                ))
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${S.current.this_month}',
                        style: TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["income"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["chargeEnergy"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["disChargeEnergy"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["trading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["alarmTime"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["peakDifference"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["batteryRate"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${dy["chargeEfficiency"] ?? 0}'),
                  ))
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${S.current.last_month}',
                        style: TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["income"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["chargeEnergy"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      '${sy["disChargeEnergy"] ?? 0}',
                    ),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["trading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["alarmTime"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["peakDifference"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["batteryRate"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${sy["chargeEfficiency"] ?? 0}'),
                  ))
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  height: 40,
                  color: const Color(0xFFF2F8F9),
                  child: Center(
                    child: Text('${S.current.same_period_last_year}',
                        style: TextStyle(color: Color(0xFF8693AB))),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["income"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["chargeEnergy"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["disChargeEnergy"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["trading"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["alarmTime"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["peakDifference"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["batteryRate"] ?? 0}'),
                  )),
              SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('${qn["chargeEfficiency"] ?? 0}'),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
