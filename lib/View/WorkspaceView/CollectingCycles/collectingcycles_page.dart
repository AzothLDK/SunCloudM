import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:suncloudm/dao/config.dart';
import '../../../dao/daoX.dart';
import '../../../dao/storage.dart';

class CollectingcyclesPage extends StatefulWidget {
  const CollectingcyclesPage({super.key});

  @override
  State<CollectingcyclesPage> createState() => _CollectingcyclesPageState();
}

class _CollectingcyclesPageState extends State<CollectingcyclesPage> {
  String seleteDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  Map<String, dynamic> _pageData = {};
  List _listData = [];

  String seleteId = '';
  String seleteName = '请选择站点';
  List companyList = [];
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? singleId = GlobalStorage.getSingleId();

  @override
  void initState() {
    super.initState();
    if (isOperator == true) {
      String? jsonStr = GlobalStorage.getCompanyList();
      companyList = jsonDecode(jsonStr!);
      seleteId = companyList[0]["id"].toString();
      seleteName = companyList[0]["itemName"].toString();
    }
  }

  Future<Map<String, dynamic>> _getcycleList() async {
    Map<String, dynamic> params = {};
    if (seleteId != "") {
      params['stationId'] = seleteId;
    }
    print(params);
    var data = await StrategyDao.getcycleList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return _pageData = data['data'];
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
          '回收周期',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
        // 移除AppBar的阴影
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _getcycleList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_pageData['recycleInfoList'] != null) {
                _listData = _pageData['recycleInfoList'];
              }
              return Column(
                children: [
                  Visibility(
                    visible:
                        (isOperator == true && singleId == null) ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              // Add more decoration..
                            ),
                            hint: Text(
                              seleteName,
                              style: const TextStyle(fontSize: 15),
                            ),
                            items: companyList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item['id'].toString(),
                                      child: Text(
                                        item['itemName'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              return null;
                            },
                            onChanged: (value) {
                              debugPrint(value);
                              seleteId = value!;
                              setState(() {});
                            },
                            onSaved: (value) {},
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(right: 8),
                            ),
                            iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '当前时间  ',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                              Text(_pageData['nowTime'] ?? "--",
                                  style: const TextStyle(fontSize: 12)),
                              const Spacer(),
                              const Text(
                                '预计时间  ',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                              Text(_pageData['forecastTime'] ?? "--",
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomPaint(
                            size: Size(MediaQuery.of(context).size.width, 12),
                            painter: ProgressIndicatorDotPainter(
                                progressColor: const Color(0xFF3BBAAF),
                                dotColor: Colors.white,
                                progressValue:
                                    (_pageData['amountPercent'] == 0 ||
                                            _pageData['amountPercent'] == null)
                                        ? 0
                                        : (_pageData['amountPercent'] / 100)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                '累计收益金额  ',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                              Text(
                                '${_pageData['amount'] ?? "--"}',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF24C18F)),
                              ),
                              const Text(
                                ' 万元',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                              const Spacer(),
                              const Text(
                                '投资金额 ',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                              Text(
                                '${_pageData['investAmount'] ?? "--"}',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF24C18F)),
                              ),
                              const Text(
                                ' 万元',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '提示：预计回收进度到${_pageData['profitTime'] ?? "--"}开始盈利',
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xB3FFA200)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        color: const Color(0xFFF7F7F9),
                        child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, i) {
                              return _cardView(_listData);
                            })),
                  ),
                ],
              );
            } else {
              return const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }

  _cardView(List listData) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   '1231',
          //   style: const TextStyle(color: Color(0xFF24C18F)),
          // ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(fontSize: 12),
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF2F8F9)),
              headingRowHeight: 40,
              columnSpacing: 20,
              dataTextStyle: const TextStyle(fontSize: 12),
              columns: const [
                DataColumn(
                  label: Text('月份'),
                ),
                DataColumn(
                  label: Text('金额(元)'),
                ),
                DataColumn(
                  label: Text('衰减率'),
                ),
                DataColumn(
                  label: Text('峰谷价差(元/kWh)'),
                ),
                DataColumn(
                  label: Text('峰平价差(元/kWh)'),
                ),
                DataColumn(
                  label: Text('运行天数(天)'),
                ),
                DataColumn(
                  label: Text('故障时间(小时)'),
                ),
                DataColumn(
                  label: Text('回收周期(月)'),
                ),
                DataColumn(
                  label: Text('测算回收周期(月)'),
                ),
              ],
              rows: _getPVData(listData),
              // rows: _getPVData(cyList),
            ),
          ),
        ],
      ),
    );
  }
}

_getPVData(List? datelist) {
  if (datelist == null) {
    return [
      const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      )
    ];
  } else {
    return datelist
        .asMap()
        .entries
        .map((e) => DataRow(
              color: (e.key % 2 == 0)
                  ? WidgetStateProperty.all(const Color(0xFFFFFFFF))
                  : WidgetStateProperty.all(const Color(0xFFF2F8F9)),
              cells: [
                DataCell(Text(e.value["month"] ?? "")),
                DataCell(Text((e.value["amount"] ?? "").toString())),
                DataCell(Text("${e.value["attenuationRate"]}%")),
                DataCell(Text((e.value["peakValleyDiffer"] ?? "").toString())),
                DataCell(Text((e.value["peakFlatDiffer"] ?? "").toString())),
                DataCell(Text((e.value["operationDay"] ?? "").toString())),
                DataCell(Text((e.value["faultTime"] ?? "").toString())),
                DataCell(Text((e.value["recoveryCycle"] ?? "").toString())),
                DataCell(Text((e.value["forecastCycle"] ?? "").toString())),
              ],
            ))
        .toList();
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
    const double dotRadius = 6;
    final Offset dotOffset =
        Offset(progressWidth - dotRadius / 2 + 5, size.height / 2);

    // canvas.drawCircle(dotOffset, dotRadius, borderPaint);
    // canvas.drawCircle(dotOffset, dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
