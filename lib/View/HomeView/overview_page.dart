import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../dao/daoX.dart';

class OverViewPage extends StatefulWidget {
  final Map pageData;

  const OverViewPage({super.key, required this.pageData});

  @override
  State<OverViewPage> createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  int _currentDateType = 0;
  String startDate = formatDate(DateTime.now(), [yyyy, '-', mm]);
  String endDate = formatDate(DateTime.now(), [yyyy, '-', mm]);
  String? singleId = GlobalStorage.getSingleId();
  Map<String, dynamic> lineChartData = {};

  Future<Map<String, dynamic>> getindexSYLineChart() async {
    Map<String, dynamic> params = {};
    params['beginDate'] = startDate;
    params['endDate'] = endDate;
    if (singleId != null) {
      params["itemId"] = singleId;
    }
    var data = await IndexDao.getindexSYLineChart(params: params);
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

  @override
  Widget build(BuildContext context) {
    Map mic = (widget.pageData['mic']) ?? {};
    Map storage = widget.pageData['storage'] ?? {};
    Map pv = widget.pageData['pv'] ?? {};

    List xdata = [];
    List yaxis = [];
    List yaxis1 = [];
    List yaxis2 = [];

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ///微电网收益
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
                    Text('微电网收益',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("当日/月收益(元/万元)",
                        "${mic['todayIncome'] ?? '--'} /${mic['thisMonthIncome'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("当年/累计收益(万元)",
                        "${mic['thisYearIncome'] ?? '--'} /${mic['totalIncome'] ?? '--'}"),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///储能收益
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
                    Text('储能收益',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("当日/月收益(元/万元)",
                        "${storage['todayIncome'] ?? '--'} /${storage['thisMonthIncome'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("当年/累计收益(万元)",
                        "${storage['thisYearIncome'] ?? '--'} /${storage['totalIncome'] ?? '--'}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("总充电量/总放电量(MWh)",
                        "${storage['allChargeEle'] ?? '--'} /${storage['allDisChargeEle'] ?? '--'}"),
                    const SizedBox(width: 15),
                    // _cellView("当月/当年充放电效率",
                    // "${storage['thisMonthRate'] ?? '--'}% /${storage['thisYearRate'] ?? '--'}%"),
                    Expanded(child: Container())
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///光伏收益
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
                    Text('光伏收益',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("当日/月消纳收益(元/万元)",
                        "${pv['todayAbsorbIncome'] ?? '--'} /${pv['thisMonthAbsorbIncome'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("当年/累计消纳收益(万元)",
                        "${pv['thisYearAbsorbIncome'] ?? '--'} /${pv['totalAbsorbIncome'] ?? '--'}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("当日/月上网收益(元/万元)",
                        "${pv['todayGridIncome'] ?? '--'} /${pv['thisMonthGridIncome'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("当年/累计上网收益(万元)",
                        "${pv['thisYearGridIncome'] ?? '--'} /${pv['totalGridIncome'] ?? '--'}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cellView("总发电量/总消纳量(MWh)",
                        "${pv['totalEle'] ?? '--'} /${pv['totalAbsorb'] ?? '--'}"),
                    const SizedBox(width: 15),
                    _cellView("总上网电量(MWh)", "${pv['totalGrid'] ?? '--'}"),
                  ],
                ),
                const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _cellView("当月/当年消纳率",
                //         "${pv['thisMonthRate'] ?? '--'}% /${pv['thisYearRate'] ?? '--'}%"),
                //     const SizedBox(width: 14),
                //     Expanded(child: Container())
                //   ],
                // )
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///收益概览
          Container(
            padding: const EdgeInsets.all(6.0),
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
                const SizedBox(height: 10),
                Row(
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
                                              DateRangePickerSelectionMode
                                                  .range,
                                          view: _currentDateType == 0
                                              ? DateRangePickerView.year
                                              : DateRangePickerView.decade,
                                          allowViewNavigation: false,
                                          headerStyle:
                                              const DateRangePickerHeaderStyle(
                                                  backgroundColor:
                                                      Colors.transparent),
                                          startRangeSelectionColor:
                                              const Color.fromRGBO(
                                                  36, 193, 143, 1),
                                          endRangeSelectionColor:
                                              const Color.fromRGBO(
                                                  36, 193, 143, 1),
                                          rangeSelectionColor:
                                              const Color.fromRGBO(
                                                  36, 193, 143, 0.3),
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
                                  color: Color.fromRGBO(212, 212, 212, 1),
                                  width: 1),
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
                        unselectedTextStyle: const TextStyle(
                            color: Color.fromRGBO(36, 193, 1435, 1)),
                        borderWidth: 0.7,
                        borderRadius: 32.0,
                        onSegmentTapped: (index) {
                          switch (index) {
                            case 0:
                              {
                                _currentDateType = 0;
                                startDate =
                                    formatDate(DateTime.now(), [yyyy, '-', mm]);
                                endDate =
                                    formatDate(DateTime.now(), [yyyy, '-', mm]);
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
                const SizedBox(height: 10),
                FutureBuilder(
                    future: getindexSYLineChart(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        xdata = lineChartData['xaxis'];
                        yaxis = lineChartData['yaxis'];
                        yaxis1 = lineChartData['yaxis1'];
                        yaxis2 = lineChartData['yaxis2'];
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
                              "data": ['总收益', '光伏收益', '储能收益'],
                              "inactiveColor": '#ccc'
                            },
                            "grid": {
                              "right": 10 // 这里设置右边距为 20 像素，你可以根据需求调整这个值
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": _currentDateType == 0 ? "元" : '万元',
                              }
                            ],
                            "series": [
                              {
                                'name': '总收益',
                                "data": yaxis,
                                "type": 'line',
                                "symbol": 'none',
                                "smooth": true, // 是否让线条圆滑显示
                                "color": '#3D71FD'
                              },
                              {
                                'name': '光伏收益',
                                "data": yaxis1,
                                "type": 'line',
                                "symbol": 'none',
                                "smooth": true, // 是否让线条圆滑显示
                                "color": '#FBAF38'
                              },
                              {
                                'name': '储能收益',
                                "data": yaxis2,
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
        height: 85,
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
