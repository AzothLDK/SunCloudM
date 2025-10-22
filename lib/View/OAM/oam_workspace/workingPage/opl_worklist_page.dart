import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/utils/screentool.dart';
import 'package:suncloudm/View/OAM/model/work_entity.dart';
import 'package:suncloudm/generated/l10n.dart';

class OplWorklistPage extends StatefulWidget {
  final String? statusId; // 新增可空的

  const OplWorklistPage({super.key, this.statusId});

  @override
  State<OplWorklistPage> createState() => _OplWorklistPageState();
}

class _OplWorklistPageState extends State<OplWorklistPage> {
  TextEditingController _search = TextEditingController();

  List workList = [];
  Map workInfoMap = {};

  Future<dynamic>? _OplWorklistFuture;
  String statusId = '0';

  int _selectedTimeValue = 3; // 初始选中的值

  int _selectedValue = 0; // 初始选中的值
  String _selectedName = S.current.all; // 初始选中的值
  List status = [
    {'statusId': '0', 'statusName': S.current.all},
    {'statusId': '1', 'statusName': S.current.pending},
    {'statusId': '2', 'statusName': S.current.returned},
    {'statusId': '3', 'statusName': S.current.received},
    {'statusId': '4', 'statusName': S.current.confirming},
    {'statusId': '5', 'statusName': S.current.completed},
    {'statusId': '6', 'statusName': S.current.discarded},
  ];
  Map<String, dynamic> _numData = {};

  @override
  void initState() {
    super.initState();
    if (widget.statusId != null) {
      statusId = widget.statusId!; // 如果外部传入了 statusId，则使用该值
      _selectedValue =
          status.indexWhere((item) => item['statusId'] == statusId);
      _selectedName = status[_selectedValue]['statusName'];
    }
    _OplWorklistFuture = getworkOrderList();
  }

  Future<Map<String, dynamic>> getworkOrderList() async {
    Map<String, dynamic> params = {};
    if (statusId != '' && statusId != '0') {
      params['status'] = statusId;
    }
    params['workName'] = _search.text;
    params['pageNum'] = 1;
    params['pageSize'] = 999;
    if (_selectedTimeValue == 0) {
      params['recentDay'] = 7;
    } else if (_selectedTimeValue == 1) {
      params['recentDay'] = 14;
    } else if (_selectedTimeValue == 2) {
      params['recentDay'] = 30;
    } else {}
    var data = await WorkDao.getworkOrderList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      // Map dataMap = data['data'];
      return workInfoMap = data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _OplWorklistFuture = getworkOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/oambg.png'), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              S.current.work_order_list,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () async {
            //       // 处理按钮点击事件
            //       // print('添加');
            //       // await Routes.instance!
            //       //     .navigateTo(context, Routes.adaddworkPage);
            //       // _getworkOrderList();
            //     },
            //     child: Text(
            //       '添加',
            //       style: TextStyle(color: Colors.white, fontSize: 18),
            //     ),
            //   ),
            // ],
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        onChanged: (str) {
                          print("你输入内容为：" + str);
                          setState(() {
                            _OplWorklistFuture = getworkOrderList();
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search_sharp),
                          hintText: S.current.please_input_work_order_name,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 120,
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
                              // borderSide: BorderSide.none,
                              borderSide:
                                  const BorderSide(color: Color(0xFF8693AB)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Color(0xFF8693AB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Color(0xFF8693AB)),
                            ),
                          ),
                          hint: Text(
                            _selectedName,
                            style: const TextStyle(fontSize: 14),
                          ),
                          items: status
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['statusId'].toString(),
                                    child: Text(
                                      item['statusName'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            debugPrint(value);
                            statusId = value!;
                            setState(() {
                              _OplWorklistFuture = getworkOrderList();
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(left: 0, right: 10)),
                          iconStyleData: const IconStyleData(
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.black45),
                              iconSize: 24),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.only(left: 25))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRadioButton(0, S.current.seven_days),
                    _buildRadioButton(1, S.current.fourteen_days),
                    _buildRadioButton(2, S.current.one_month),
                    _buildRadioButton(3, S.current.all),
                  ],
                ),
                // const SizedBox(height: 10),
                FutureBuilder(
                    future: _OplWorklistFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return SizedBox(
                            height: 80,
                            child: Center(child: Text(S.current.no_data)));
                      } else if (snapshot.hasData) {
                        List workList = [];
                        Map lineChartData = snapshot.data;
                        List dataList = lineChartData['records'];
                        for (var v in dataList) {
                          workList.add(WorkEntity.fromJson(v));
                        }
                        return Expanded(
                          child: CustomScrollView(
                            slivers: [
                              // 头部 SliverToBoxAdapter
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: SingleChildScrollView(
                                    // scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${workInfoMap['dclCount'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFF9C85FF),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(S.current.pending,
                                                style: const TextStyle(
                                                  color: Color(0xFF8693AB),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${workInfoMap['dspCount'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFFFFA94C),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(S.current.confirming,
                                                style: const TextStyle(
                                                  color: Color(0xFF8693AB),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${workInfoMap['yztCount'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFE68686),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(S.current.returned,
                                                style: const TextStyle(
                                                  color: Color(0xFF8693AB),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${workInfoMap['ywcCount'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF58D565),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(S.current.completed,
                                                style: const TextStyle(
                                                  color: Color(0xFF8693AB),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${workInfoMap['clzCount'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFF1ED2A4),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(S.current.received,
                                                style: const TextStyle(
                                                  color: Color(0xFF8693AB),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${workInfoMap['yfqCount'] ?? '--'}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFFD8BCD5),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(S.current.discarded,
                                                style: const TextStyle(
                                                  color: Color(0xFF8693AB),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 列表内容
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => InkWell(
                                      onTap: () => navigate(index),
                                      child: _workcardView(workList[index])),
                                  childCount: workList.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
              ],
            ),
          ),
        ));
  }

  void navigate(int? id) async {
    List workList = [];
    List dataList = workInfoMap['records'];
    for (var v in dataList) {
      workList.add(WorkEntity.fromJson(v));
    }
    WorkEntity model = workList[id!];
    if (isOperator == true) {
      await Routes.instance!
          .navigateTo(context, Routes.oplWorkInfo, model.workNumber!);
      setState(() {
        _OplWorklistFuture = getworkOrderList();
      });
    } else {
      await Routes.instance!
          .navigateTo(context, Routes.opWorkInfo, model.workNumber!);
      setState(() {
        _OplWorklistFuture = getworkOrderList();
      });
    }
  }

  Widget _buildRadioButton(int value, String buttonText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _selectedTimeValue = value;
          setState(() {
            _OplWorklistFuture = getworkOrderList();
          });
        },
        child: Container(
          width: (Screen.getScreenWidth(context) - 90) / 4,
          height: 40,
          decoration: BoxDecoration(
            color: _selectedTimeValue == value
                ? const Color(0xFF3BBAAF)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedTimeValue == value
                      ? Colors.white
                      : const Color(0xFF8692A3),
                ),
              ),
              // Text(
              //   getNum(value),
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: _selectedValue == value
              //         ? Colors.white
              //         : const Color(0xFF000000),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workcardView(WorkEntity model) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        // height: 100,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              children: [
                getworklevel(model.priority),
                const SizedBox(width: 10),
                Text(
                  model.workNumber!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
                getworkStatus(model.status!),
                const SizedBox(width: 10)
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  S.current.work_order_name,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    model.workName!,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  S.current.work_order_source,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    model.workSourceName ?? '--',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  S.current.station_name,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    model.stationName ?? '--',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  S.current.device_name,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${model.deviceName ?? '--'}h',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  S.current.dispatch_time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    model.createTime!,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Visibility(
            //   visible: model.status == 1 ? false : true,
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           const Text(
            //             '处理日期',
            //             style: TextStyle(fontSize: 14, color: Colors.grey),
            //           ),
            //           const SizedBox(width: 10),
            //           Expanded(
            //             child: Text(
            //               '${model.actualEndTime} ~ ${model.actualStartTime}',
            //               style: const TextStyle(fontSize: 14),
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 1,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 10),
            //     ],
            //   ),
            // ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      S.current.handler,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        model.personnelName!,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            getOverTimeStatus(model.isOvertime)
          ],
        ));
  }

  String getNum(int? index) {
    switch (index) {
      case 0:
        return (_numData['count'] ?? "0").toString();
      case 1:
        return (_numData['dclCount'] ?? "0").toString();
      case 2:
        return (_numData['yztCount'] ?? "0").toString();
      case 3:
        return (_numData['clzCount'] ?? "0").toString();
      case 4:
        return (_numData['dspCount'] ?? "0").toString();
      case 5:
        return (_numData['ywcCount'] ?? "0").toString();
      default:
        return (_numData['yfqCount'] ?? "0").toString();
    }
  }

  Widget getworklevel(int? priority) {
    switch (priority) {
      case 1:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 62, 68, 1),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.immediate_priority,
                  style: const TextStyle(color: Colors.white))),
        );
      case 2:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFA7800),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.high_priority,
                  style: const TextStyle(color: Colors.white))),
        );
      case 3:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 161, 68, 1),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.medium_priority,
                  style: const TextStyle(color: Colors.white))),
        );
      default:
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(205, 178, 64, 1),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.low_priority,
                  style: const TextStyle(color: Colors.white))),
        );
    }
  }

  Widget getworkStatus(int? status) {
    switch (status) {
      case 1:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFEF3E9),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.pending,
                  style: const TextStyle(color: Color(0xFFF68A26)))),
        );
      case 2:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.returned,
                  style: const TextStyle(color: Color(0xFFA5A5A5)))),
        );
      case 3:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFE9F2FC),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.processing,
                  style: const TextStyle(color: Color(0xFF237DE6)))),
        );
      case 4:
        return Container(
          width: 80,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFEF0E9),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.confirming,
                  style: const TextStyle(color: Color(0xFFF66B26)))),
        );
      case 5:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFEDFAEB),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.completed,
                  style: const TextStyle(color: Color(0xFF4DCF37)))),
        );
      default:
        return Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
              color: const Color(0xFFFAF5F8),
              borderRadius: BorderRadius.circular(12.5)),
          child: Center(
              child: Text(S.current.discarded,
                  style: const TextStyle(color: Color(0xFFCB9CB9)))),
        );
    }
  }

  Widget getOverTimeStatus(int? isOvertime) {
    switch (isOvertime) {
      case 1:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 25,
            decoration: BoxDecoration(
                color: const Color(0xFFFCE6E6),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.report_gmailerrorred,
                    size: 14,
                    color: Color(0xFFF66B26),
                  ),
                ),
                Text(S.current.work_order_about_to_timeout,
                    style: const TextStyle(
                        color: Color(0xFFF66B26), fontSize: 12)),
              ],
            ),
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 25,
            decoration: BoxDecoration(
                color: const Color(0xFFFCE6E6),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.report_gmailerrorred,
                    size: 14,
                    color: Color(0xFFE00505),
                  ),
                ),
                Text(S.current.work_order_timeout,
                    style: const TextStyle(
                        color: Color(0xFFE00505), fontSize: 12)),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
