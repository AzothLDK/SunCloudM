import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../dao/daoX.dart';
import '../../../dao/storage.dart';

class PhotovoltaicViewPage extends StatefulWidget {
  final Map pageData;

  const PhotovoltaicViewPage({super.key, required this.pageData});

  @override
  State<PhotovoltaicViewPage> createState() => _PhotovoltaicViewPageState();
}

class _PhotovoltaicViewPageState extends State<PhotovoltaicViewPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> selTabs = <Tab>[
    const Tab(text: '电量'),
    const Tab(text: '收益'),
  ];
  TabController? selController;

  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);

  int _currentDateType = 0;
  String startDate = formatDate(DateTime.now(), [yyyy, '-', mm]);
  String endDate = formatDate(DateTime.now(), [yyyy, '-', mm]);
  String? singleId = GlobalStorage.getSingleId();
  Map<String, dynamic> eleChartData = {};
  Map<String, dynamic> rewardChartData = {};

  Future<Map<String, dynamic>> getindexPVLineChart() async {
    Map<String, dynamic> params = {};
    params['beginDate'] = startDate;
    params['endDate'] = endDate;
    params['resourceType'] = 1;
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getindexPVLineChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return eleChartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getindexPVLineChart2() async {
    Map<String, dynamic> params = {};
    params['beginDate'] = startDate;
    params['endDate'] = endDate;
    params['resourceType'] = 2;
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getindexPVLineChart(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return rewardChartData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    selController = TabController(
      length: selTabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map pv = widget.pageData['pv'] ?? {};
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ///运营数据
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
                    Text('运营数据',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isOperator == true ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cellView("投运时间", '${pv['builtTime'] ?? '--'}'),
                      const SizedBox(width: 15),
                      _cellView("运行天数(天)", '${pv['builtDays'] ?? '--'}'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("当日/月收益(元/万元)",
                        "${pv['todayIncome'] ?? '--'} /${pv['thisMonthIncome'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("当年/累计收益(万元)",
                        "${pv['thisYearIncome'] ?? '--'} /${pv['totalIncome'] ?? '--'}"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///电量数据
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
                    Text('电量数据',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("今日发电量(kWh)", "${pv['todayEle'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("今日上网电量(kWh)", "${pv['todayGrid'] ?? '--'}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("累计总发电量(MWh)", "${pv['totalEle'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("累计总上网电量(MWh)", "${pv['totalGrid'] ?? '--'}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("累计消纳率", "${pv['totalRate'] ?? '--'}%"),
                    const SizedBox(width: 15),
                    _cellView("当月绿电率", "${pv['thisMonthRate'] ?? '--'}%"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("当月/累计碳减排(t)",
                        "${pv['thisMonthCarbon'] ?? '--'} /${pv['totalCarbon'] ?? '--'}"),
                    const SizedBox(width: 15),
                    Expanded(child: Container())
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///收益概览
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
                    Text('数据分析',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Material(
                          color: Colors.white,
                          child: Theme(
                            data: ThemeData(
                                splashColor: Colors.transparent,
                                // 点击时的水波纹颜色设置为透明
                                highlightColor: Colors.transparent,
                                // 点击时的背景高亮颜色设置为透明
                                tabBarTheme: const TabBarThemeData(
                                    dividerColor: Colors.transparent)),
                            child: TabBar(
                              tabs: selTabs,
                              unselectedLabelColor:
                                  const Color.fromRGBO(104, 104, 104, 1),
                              labelColor: const Color.fromRGBO(36, 112, 249, 1),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor:
                                  const Color.fromRGBO(36, 112, 249, 1),
                              labelStyle: const TextStyle(fontSize: 17),
                              controller: selController,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 380,
                          child: TabBarView(
                            controller: selController,
                            children: [
                              _dlView(),
                              _syView(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _dlView() {
    List xdata = [];
    List yaxis = [];
    List yaxis1 = [];
    List yaxis2 = [];

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  width: 300,
                                  height: 400,
                                  child: SfDateRangePicker(
                                    confirmText: '确定',
                                    cancelText: '取消',
                                    backgroundColor: Colors.transparent,
                                    showActionButtons: true,
                                    // initialSelectedRange: PickerDateRange(
                                    //     DateTime(2020), DateTime(2050)),
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    view: _currentDateType == 0
                                        ? DateRangePickerView.year
                                        : DateRangePickerView.decade,
                                    allowViewNavigation: false,
                                    headerStyle:
                                        const DateRangePickerHeaderStyle(
                                            backgroundColor:
                                                Colors.transparent),
                                    startRangeSelectionColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    endRangeSelectionColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    rangeSelectionColor:
                                        const Color.fromRGBO(36, 193, 143, 0.3),
                                    onCancel: () {
                                      Navigator.of(context).pop();
                                    },
                                    onSubmit: (Object? value) {
                                      print(value);
                                      if (value is PickerDateRange) {
                                        List<String> formats =
                                            _currentDateType == 0
                                                ? [yyyy, '-', mm]
                                                : [yyyy];
                                        startDate = formatDate(
                                            value.startDate!, formats);
                                        if (value.endDate == null) {
                                          endDate = formatDate(
                                              value.startDate!, formats);
                                        } else {
                                          endDate = formatDate(
                                              value.endDate!, formats);
                                        }
                                        setState(() {});
                                        // getIncomeChartsData();
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      if (args.value is PickerDateRange) {
                                        // startDate = formatDate(args.value.startDate, [yyyy]);
                                        // endDate = formatDate(args.value.endDate, [yyyy]);
                                        // print(args.value.startDate);
                                        // seleteDate=formatDate(args.value.startDate, [yyyy])+formatDate(args.value.endDate, [yyyy]);
                                        setState(() {});
                                      }
                                    },
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
                            color: Color.fromRGBO(212, 212, 212, 1), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$startDate  -  $endDate",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black26),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black26,
                            size: 14,
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(
                width: 110,
                child: MaterialSegmentedControl(
                  verticalOffset: 5,
                  children: const {0: Text('月'), 1: Text('年')},
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
                          startDate =
                              formatDate(DateTime.now(), [yyyy, '-', mm]);
                          endDate = formatDate(DateTime.now(), [yyyy, '-', mm]);
                          setState(() {});
                          // getIncomeChartsData();
                        }
                      case 1:
                        {
                          _currentDateType = 1;
                          startDate = formatDate(DateTime.now(), [yyyy]);
                          endDate = formatDate(DateTime.now(), [yyyy]);
                          setState(() {});
                          // getIncomeChartsData();
                        }
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
            future: getindexPVLineChart(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                xdata = eleChartData['xaxis'];
                yaxis = eleChartData['yaxis'];
                yaxis1 = eleChartData['yaxis1'];
                yaxis2 = eleChartData['yaxis2'];
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Echarts(
                      option: jsonEncode({
                    "zlevel": 11,
                    "tooltip": {"trigger": 'axis'},
                    "legend": {
                      "textStyle": {"fontSize": 12, "color": '#333'},
                      "itemGap": 10,
                      "data": ['发电量', '上网电量', '消纳率'],
                      "inactiveColor": '#ccc'
                    },
                    "xAxis": {
                      "type": 'category',
                      "data": xdata,
                    },
                    "yAxis": [
                      {
                        "type": 'value',
                        "name": "kWh",
                      },
                      {
                        "data": [0, 20, 40, 60, 80, 100],
                        "type": 'value',
                        "name": "%",
                      },
                    ],
                    "series": [
                      {
                        'name': '发电量',
                        "data": yaxis,
                        "type": 'bar',
                        "color": '#3D71FD'
                      },
                      {
                        'name': '上网电量',
                        "data": yaxis1,
                        "type": 'bar',
                        "color": '#FBAF38'
                      },
                      {
                        'name': '消纳率',
                        "data": yaxis2,
                        "yAxisIndex": '1',
                        "smooth": true, // 是否让线条圆滑显示
                        "type": "line",
                        "symbol": 'none',
                        "color": '#2ED75A'
                      },
                    ]
                  })),
                );
              } else {
                return const SizedBox(
                    height: 250,
                    child: Center(child: CircularProgressIndicator()));
              }
            })
      ],
    );
  }

  _syView() {
    List xdata = [];
    List yaxis = [];
    List yaxis1 = [];
    List yaxis2 = [];

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  width: 300,
                                  height: 400,
                                  child: SfDateRangePicker(
                                    confirmText: '确定',
                                    cancelText: '取消',
                                    backgroundColor: Colors.transparent,
                                    showActionButtons: true,
                                    // initialSelectedRange: PickerDateRange(
                                    //     DateTime(2020), DateTime(2050)),
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    view: _currentDateType == 0
                                        ? DateRangePickerView.year
                                        : DateRangePickerView.decade,
                                    allowViewNavigation: false,
                                    headerStyle:
                                        const DateRangePickerHeaderStyle(
                                            backgroundColor:
                                                Colors.transparent),
                                    startRangeSelectionColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    endRangeSelectionColor:
                                        const Color.fromRGBO(36, 193, 143, 1),
                                    rangeSelectionColor:
                                        const Color.fromRGBO(36, 193, 143, 0.3),
                                    onCancel: () {
                                      Navigator.of(context).pop();
                                    },
                                    onSubmit: (Object? value) {
                                      print(value);
                                      if (value is PickerDateRange) {
                                        List<String> formats =
                                            _currentDateType == 0
                                                ? [yyyy, '-', mm]
                                                : [yyyy];
                                        startDate = formatDate(
                                            value.startDate!, formats);
                                        if (value.endDate == null) {
                                          endDate = formatDate(
                                              value.startDate!, formats);
                                        } else {
                                          endDate = formatDate(
                                              value.endDate!, formats);
                                        }
                                        setState(() {});
                                        // getIncomeChartsData();
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      if (args.value is PickerDateRange) {
                                        // startDate = formatDate(args.value.startDate, [yyyy]);
                                        // endDate = formatDate(args.value.endDate, [yyyy]);
                                        // print(args.value.startDate);
                                        // seleteDate=formatDate(args.value.startDate, [yyyy])+formatDate(args.value.endDate, [yyyy]);
                                        setState(() {});
                                      }
                                    },
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
                            color: Color.fromRGBO(212, 212, 212, 1), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$startDate  -  $endDate",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black26),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black26,
                            size: 14,
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(
                width: 110,
                child: MaterialSegmentedControl(
                  verticalOffset: 5,
                  children: const {0: Text('月'), 1: Text('年')},
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
                          startDate =
                              formatDate(DateTime.now(), [yyyy, '-', mm]);
                          endDate = formatDate(DateTime.now(), [yyyy, '-', mm]);
                          setState(() {});
                          // getIncomeChartsData();
                        }
                      case 1:
                        {
                          _currentDateType = 1;
                          startDate = formatDate(DateTime.now(), [yyyy]);
                          endDate = formatDate(DateTime.now(), [yyyy]);
                          setState(() {});
                          // getIncomeChartsData();
                        }
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder(
            future: getindexPVLineChart2(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                xdata = rewardChartData['xaxis'];
                yaxis = rewardChartData['yaxis'];
                yaxis1 = rewardChartData['yaxis1'];
                yaxis2 = rewardChartData['yaxis2'];
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Echarts(
                      option: jsonEncode({
                    "zlevel": 11,
                    "tooltip": {"trigger": 'axis'},
                    "legend": {
                      "textStyle": {"fontSize": 12, "color": '#333'},
                      "itemGap": 10,
                      "data": ['消纳收益', '上网收益', '总收益'],
                      "inactiveColor": '#ccc'
                    },
                    "xAxis": {
                      "type": 'category',
                      "data": xdata,
                    },
                    "yAxis": [
                      {
                        "type": 'value',
                        "name": _currentDateType == 0 ? "元" : '万元',
                      },
                    ],
                    "series": [
                      {
                        'name': '消纳收益',
                        "data": yaxis,
                        "type": 'bar',
                        "color": '#3D71FD'
                      },
                      {
                        'name': '上网收益',
                        "data": yaxis1,
                        "type": 'bar',
                        "color": '#FBAF38'
                      },
                      {
                        'name': '总收益',
                        "data": yaxis2,
                        // "yAxisIndex": '1',
                        "smooth": true, // 是否让线条圆滑显示
                        "type": "line",
                        "symbol": 'none',
                        "color": '#2ED75A'
                      },
                    ]
                  })),
                );
              } else {
                return const SizedBox(
                    height: 250,
                    child: Center(child: CircularProgressIndicator()));
              }
            })
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
            Text(
              num,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  _pointView(Color color, String num) {
    return Row(
      children: [
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          num,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
