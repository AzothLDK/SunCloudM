import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'package:suncloudm/toolview/imports.dart';

class OplDataAnalysis extends StatefulWidget {
  const OplDataAnalysis({super.key});

  @override
  State<OplDataAnalysis> createState() => _OplDataAnalysisState();
}

class _OplDataAnalysisState extends State<OplDataAnalysis> {
  List teamList = [];
  List groupList = [];

  String selectedTeam = '';
  int selectedTeamId = 0;
  String selectedGroup = '';
  int selectedGroupId = 0;

  String seleteTime = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);

  Future<dynamic>? _workSummaryFuture;
  Future<dynamic>? _acceptStatisticsFuture;
  Future<dynamic>? _workRankFuture;

  getTeamList() async {
    Map<String, dynamic> params = {};
    var data = await WorkDao.getTeamList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      teamList = [];
      teamList = data['data'];
      selectedTeam = teamList[0]['teamName'];
      selectedTeamId = teamList[0]['id'];
      if (selectedTeamId != 0) {
        getGroupList();
      } else {
        selectedGroup = '';
        groupList = [];
        setState(() {});
      }
    } else {}
  }

  getGroupList() async {
    Map<String, dynamic> params = {};
    params['teamId'] = selectedTeamId;
    var data = await WorkDao.getGroupList(params: params);
    if (data["code"] == 200) {
      groupList = [];
      groupList = data['data'];
      if (groupList.isNotEmpty) {
        selectedGroup = groupList[0]['teamName'];
        selectedGroupId = groupList[0]['id'];
      }
      setState(() {
        _workSummaryFuture = getWorkSummary();
        _acceptStatisticsFuture = getAcceptStatistics();
        _workRankFuture = getWorkRank();
      });
    } else {}
  }

  Future<Map> getWorkSummary() async {
    Map<String, dynamic> params = {};
    params['updateTime'] = seleteTime;
    params['groupId'] = selectedGroupId;
    params['teamId'] = selectedTeamId;
    var data = await WorkDao.getWorkSummary(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map> getAcceptStatistics() async {
    Map<String, dynamic> params = {};
    params['updateTime'] = seleteTime;
    params['groupId'] = selectedGroupId;
    params['teamId'] = selectedTeamId;
    var data = await WorkDao.getAcceptStatistics(params: params);
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getWorkRank() async {
    Map<String, dynamic> params = {};
    params['updateTime'] = seleteTime;
    params['groupId'] = selectedGroupId;
    params['teamId'] = selectedTeamId;
    var data = await WorkDao.getWorkRank(params: params);
    debugPrint('getWorkRank');
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  initState() {
    super.initState();
    getTeamList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/oambg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: const Text(
            '数据分析',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                createSeleteCard(),
                createChartCard(),
                // createWorkChartsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createSeleteCard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                // width: 140,
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
                    selectedTeam,
                    style: const TextStyle(fontSize: 15),
                  ),
                  items: teamList
                      .map((item) => DropdownMenuItem<String>(
                            value: item['id'].toString(),
                            child: Text(
                              item['teamName'],
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    selectedTeamId = int.parse(value!);
                    getGroupList();
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                // width: 140,
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
                    selectedGroup,
                    style: const TextStyle(fontSize: 15),
                  ),
                  // 确保 value 在 items 列表中存在
                  value: groupList.isNotEmpty
                      ? groupList
                              .firstWhere(
                                  (item) => item['id'] == selectedGroupId,
                                  orElse: () => {})
                              .isNotEmpty
                          ? selectedGroupId.toString()
                          : null
                      : null,
                  items: groupList.isNotEmpty
                      ? groupList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['id'].toString(),
                                child: Text(
                                  item['teamName'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ))
                          .toList()
                      : [],
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    selectedGroupId = int.parse(value!);
                    setState(() {
                      _workSummaryFuture = getWorkSummary();
                      _acceptStatisticsFuture = getAcceptStatistics();
                      _workRankFuture = getWorkRank();
                    });
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
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
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
                seleteTime = date_format
                    .formatDate(d, [date_format.yyyy, '-', date_format.mm]);
                setState(() {
                  _workSummaryFuture = getWorkSummary();
                  _acceptStatisticsFuture = getAcceptStatistics();
                  _workRankFuture = getWorkRank();
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
                  seleteTime,
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
      ],
    );
  }

  createChartCard() {
    return Column(
      children: [
        const SizedBox(height: 10),
        FutureBuilder(
            future: _workSummaryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return SizedBox(
                    height: 80, child: Center(child: Text(S.current.no_data)));
                ;
              } else if (snapshot.hasData) {
                Map lineChartData = snapshot.data;
                List xdata = lineChartData['time'];
                List yaxis = lineChartData['unprocessedCount'] ?? [];
                List yaxis1 = lineChartData['completedCount'] ?? [];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                          const Text('工单汇总',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          // SizedBox(
                          //   width: 140,
                          //   height: 40,
                          //   child: DropdownButtonFormField2<String>(
                          //     isExpanded: true,
                          //     decoration: InputDecoration(
                          //       filled: true,
                          //       fillColor: Colors.white,
                          //       contentPadding:
                          //           const EdgeInsets.symmetric(vertical: 10),
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(20),
                          //         borderSide: BorderSide.none,
                          //       ),
                          //     ),
                          //     hint: const Text(
                          //       '告警工单',
                          //       style: TextStyle(fontSize: 15),
                          //     ),
                          //     items: ['告警工单', '巡检工单', '外部工单']
                          //         .map((item) => DropdownMenuItem<String>(
                          //               value: item,
                          //               child: Text(
                          //                 item,
                          //                 style: const TextStyle(
                          //                   fontSize: 15,
                          //                 ),
                          //               ),
                          //             ))
                          //         .toList(),
                          //     validator: (value) {
                          //       if (value == null) {
                          //         return null;
                          //       }
                          //       return null;
                          //     },
                          //     onChanged: (value) {
                          //       // worktypeStr = value == '告警工单'
                          //       //     ? '1'
                          //       //     : value == '巡检工单'
                          //       //         ? '2'
                          //       //         : '3';
                          //       // _getPageDataList();
                          //     },
                          //     onSaved: (value) {
                          //       // selectedCustomer = value.toString();
                          //     },
                          //     buttonStyleData: const ButtonStyleData(
                          //       padding: EdgeInsets.only(right: 8),
                          //     ),
                          //     iconStyleData: const IconStyleData(
                          //       icon: Icon(
                          //         Icons.arrow_drop_down,
                          //         color: Colors.black45,
                          //       ),
                          //       iconSize: 24,
                          //     ),
                          //     dropdownStyleData: DropdownStyleData(
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(15),
                          //       ),
                          //     ),
                          //     menuItemStyleData: const MenuItemStyleData(
                          //       padding: EdgeInsets.symmetric(horizontal: 16),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "legend": {
                              // "itemWidth": 10,
                              // "itemHeight": 10,
                              "textStyle": {"fontSize": 11, "color": '#333'},
                              "itemGap": 5,
                              "data": [
                                S.current.unprocessed,
                                S.current.completed,
                              ],
                              "inactiveColor": '#ccc'
                            },
                            "grid": {
                              "right": 10,
                              "left": 10,
                              "bottom": 10,
                              // "top": 60,
                              "containLabel": true
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": '个',
                              }
                            ],
                            // "color": ColorList().lineColorList,
                            "series": [
                              {
                                'name': S.current.unprocessed,
                                "data": yaxis,
                                "type": 'bar',
                                "symbol": 'none',
                                "color": '#0F9CFF',
                              },
                              {
                                'name': S.current.completed,
                                "data": yaxis1,
                                "type": 'bar',
                                "symbol": 'none', // 是否让线条圆滑显示
                                "color": '#C666DE',
                              },
                            ]
                          }))),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }
              return Container();
            }),
        SizedBox(height: 10),
        FutureBuilder(
            future: _acceptStatisticsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return SizedBox(
                    height: 80, child: Center(child: Text(S.current.no_data)));
                ;
              } else if (snapshot.hasData) {
                Map lineChartData = snapshot.data;
                List xdata = lineChartData['userName'];
                List yaxis = lineChartData['acceptCount'] ?? [];
                List yaxis1 = lineChartData['collaborationCount'] ?? [];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                          const Text('接单统计',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const Spacer()
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Echarts(
                              option: jsonEncode({
                            "zlevel": 11,
                            "tooltip": {"trigger": 'axis'},
                            "legend": {
                              // "itemWidth": 10,
                              // "itemHeight": 10,
                              "textStyle": {"fontSize": 11, "color": '#333'},
                              "itemGap": 5,
                              "data": [
                                S.current.accept,
                                S.current.collaboration,
                              ],
                              "inactiveColor": '#ccc'
                            },
                            "grid": {
                              "right": 10,
                              "left": 10,
                              "bottom": 10,
                              // "top": 60,
                              "containLabel": true
                            },
                            "xAxis": {
                              "type": 'category',
                              "data": xdata,
                            },
                            "yAxis": [
                              {
                                "type": 'value',
                                "name": '个',
                              }
                            ],
                            // "color": ColorList().lineColorList,
                            "series": [
                              {
                                'name': S.current.accept,
                                "data": yaxis,
                                "type": 'bar',
                                "stack": 'a',
                                "color": '#91CC75',
                              },
                              {
                                'name': S.current.collaboration,
                                "data": yaxis1,
                                "type": 'bar',
                                "stack": 'a',
                                "color": '#5AB5F4',
                              },
                            ]
                          }))),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }
              return Container();
            }),
        const SizedBox(height: 10),
        FutureBuilder(
            future: _workRankFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return SizedBox(
                    height: 80, child: Center(child: Text(S.current.no_data)));
                ;
              } else if (snapshot.hasData) {
                List rankList = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('运维人员工单处理数排名',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rankList.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 5,
                          color: Colors.transparent,
                        ),
                        itemBuilder: (context, index) {
                          Map datamap = rankList[index];
                          return Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                rankImage(index),
                                const SizedBox(width: 10),
                                Text(datamap['userName'] ?? '',
                                    style: const TextStyle()),
                                const SizedBox(width: 10),
                                Text(datamap['teamName'] ?? '',
                                    style: const TextStyle()),
                                const SizedBox(width: 10),
                                Spacer(),
                                Text(datamap['returnCount'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF3BBAAF))),
                                const SizedBox(width: 15),
                              ],
                            ),
                          ); // zero height: not visible
                        },
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
      ],
    );
  }

  Widget rankImage(int index) {
    switch (index) {
      case 0:
        return const Image(image: AssetImage('assets/rank1.png'));
      case 1:
        return const Image(image: AssetImage('assets/rank2.png'));
      case 2:
        return const Image(image: AssetImage('assets/rank3.png'));
      default:
        return Stack(
          alignment: Alignment.center,
          children: [
            const Image(image: AssetImage('assets/rank4.png')),
            Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        );
    }
  }

  Widget rankTeam(List teamNameList) {
    return Expanded(
      child: ListView.separated(
          separatorBuilder: (_, __) => const VerticalDivider(
                width: 5,
                color: Colors.transparent,
              ),
          itemCount: teamNameList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const Color(0xFFE9F2FC),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                teamNameList[i],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )),
            );
          }),
    );
  }
}
