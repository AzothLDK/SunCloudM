import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChartAlsPage extends StatefulWidget {
  const ChartAlsPage({super.key});

  @override
  State<ChartAlsPage> createState() => _ChartAlsPageState();
}

class _ChartAlsPageState extends State<ChartAlsPage> {
  String startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String endDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  Map chartData = {};

  Future<Map<String, dynamic>> getEpChartAls() async {
    Map<String, dynamic> params = {};
    params['startTime'] = startDate;
    params['endTime'] = endDate;
    debugPrint(params.toString());
    var data = await ChartDao.getEpChartAls(params: params);
    debugPrint(data.toString());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '企业用电曲线',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                              selectionMode: DateRangePickerSelectionMode.range,
                              view: DateRangePickerView.month,
                              allowViewNavigation: false,
                              headerStyle: const DateRangePickerHeaderStyle(
                                  backgroundColor: Colors.transparent),
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
                                if (value is PickerDateRange) {
                                  List<String> formats = [
                                    yyyy,
                                    '-',
                                    mm,
                                    '-',
                                    dd
                                  ];
                                  startDate =
                                      formatDate(value.startDate!, formats);
                                  if (value.endDate == null) {
                                    endDate =
                                        formatDate(value.startDate!, formats);
                                  } else {
                                    endDate =
                                        formatDate(value.endDate!, formats);
                                  }
                                  setState(() {});
                                  // getIncomeChartsData();
                                }
                                Navigator.of(context).pop();
                              },
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                if (args.value is PickerDateRange) {
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
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black26,
                      size: 14,
                    )
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
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
                      Text('企业用电曲线',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                      future: getEpChartAls(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List dwdata = chartData['dwdata'];
                          List gfdata = chartData['gfdata'];
                          List qydata = chartData['qydata'];
                          List xdata = chartData['xdata'];
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
                                "data": ['今日电网功率', '今日光伏发电功率', '企业用电'],
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
                                  "name": '今日电网功率',
                                  "data": dwdata,
                                  "type": 'line',
                                  "smooth": true, // 是否让线条圆滑显示
                                  "symbol": 'none',
                                  "color": '#FBAF38'
                                },
                                {
                                  "name": '今日光伏发电功率',
                                  "data": gfdata,
                                  "type": 'line',
                                  "smooth": true, // 是否让线条圆滑显示
                                  "symbol": 'none',
                                  "color": '#E966D8'
                                },
                                {
                                  "name": '企业用电',
                                  "data": qydata,
                                  "type": 'line',
                                  "smooth": true, // 是否让线条圆滑显示
                                  "symbol": 'none',
                                  "color": '#3D71FD'
                                }
                              ]
                            })),
                          );
                        } else {
                          return const SizedBox(
                              height: 250,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
