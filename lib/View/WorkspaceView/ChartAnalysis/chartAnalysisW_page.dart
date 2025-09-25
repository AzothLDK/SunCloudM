import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../dao/daoX.dart';

class ChartanalysiswPage extends StatefulWidget {
  const ChartanalysiswPage({super.key});

  @override
  State<ChartanalysiswPage> createState() => _ChartanalysiswPageState();
}

class _ChartanalysiswPageState extends State<ChartanalysiswPage> {
  String startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String endDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  List inverterList = [];
  String seleteName = '';
  List deviceCode = [];
  Map chartData = {};

  Future<void> getInverterList() async {
    var data = await ChartDao.getInverterList();
    debugPrint('数据');
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        inverterList = data['data'];
        deviceCode.add(inverterList[0]['deviceCode']);
        seleteName = inverterList[0]['deviceName'];
        setState(() {});
      } else {}
    }
  }

  Future<Map<String, dynamic>> getDWChartAls() async {
    if (deviceCode.isEmpty) {
      await getInverterList();
    }
    Map<String, dynamic> params = {};
    params['startTime'] = startDate;
    params['endTime'] = endDate;
    params['deviceCode'] = deviceCode;
    debugPrint(params.toString());
    var data = await ChartDao.getDWChartAls(params: params);
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
          '电网功率因数曲线',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [],
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                hint: const Text(
                  '请选择逆变器',
                  style: TextStyle(fontSize: 15),
                ),
                items: inverterList
                    .map((item) => DropdownMenuItem<String>(
                          value: item['deviceCode'],
                          child: Text(
                            item['deviceName'],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  return null;

                  // if (value == null) {
                  //   return '请选择逆变器';
                  // }
                  // return null;
                },
                onChanged: (value) {
                  debugPrint(value);
                  deviceCode = [];
                  deviceCode.add(value);
                  setState(() {});
                },
                onSaved: (value) {
                  // seleteName = value.toString();
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
