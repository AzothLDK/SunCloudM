import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:suncloudm/generated/l10n.dart';

class OplWorkschedulePage extends StatefulWidget {
  const OplWorkschedulePage({super.key});

  @override
  State<OplWorkschedulePage> createState() => _OplWorkschedulePageState();
}

class _OplWorkschedulePageState extends State<OplWorkschedulePage> {
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String? savedLanguage = GlobalStorage.getLanguage();

  late final ValueNotifier<List> _selectedEvents;

  Map<DateTime, List> eventMap = {};

  String? selectedPerson;

  List<Map<String, dynamic>> workScheduleList = [];

  int _currentDateButtonIndex = 1;

  Future<dynamic>? _workScheduleFuture;

  String seleteTime = date_format
      .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List workTypeList = [];
  List memberList = [];
  List<String> memberNameList = [];
  String _seleteMemberName = S.current.please_select;
  int? _seleteMemberId; // 班组人员id

  Future<Map<DateTime, List>> getWorkSchedule() async {
    Map<String, dynamic> params = {};
    params['startTime'] = seleteTime;
    params['endTime'] = seleteTime;
    params['userId'] = _seleteMemberId;
    var data = await WorkDao.getWorkSchedule(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      return eventMap = _convertToEventMap(data['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  _getWorkTypeList() async {
    Map<String, dynamic> params = {};
    var data = await WorkDao.getWorkTypeList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      workTypeList = [];
      workTypeList = data['data'];
      setState(() {});
    } else {}
  }

  _getGroupMemberList() async {
    Map<String, dynamic> params = {};
    params['roleName'] = S.current.group_member;
    var data = await WorkDao.getGroupMemberList(params: params);
    debugPrint(data.toString());
    if (data["code"] == 200) {
      memberList = [];
      memberNameList = [];
      memberList = data['data'];
      for (var v in memberList) {
        memberNameList.add(v['lastName']);
      }
      // 检查列表是否为空，防止RangeError
      if (memberNameList.isNotEmpty && memberList.isNotEmpty) {
        _seleteMemberName = memberNameList[0];
        _seleteMemberId = memberList[0]['userId'];
        setState(() {
          _workScheduleFuture = getWorkSchedule();
        });
      } else {
        // 列表为空时设置默认值
        _seleteMemberName = S.current.please_select;
        _seleteMemberId = null;
        setState(() {});
      }
    } else {
      // API调用失败时也设置默认值
      _seleteMemberName = S.current.please_select;
      _seleteMemberId = null;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getWorkTypeList();
    if (isOperator == true) {
      _getGroupMemberList();
    } else {
      _seleteMemberId = userInfo['userId'];
    }
    _workScheduleFuture = getWorkSchedule();
  }

  Map<DateTime, List> _convertToEventMap(List scheduleList) {
    final Map<DateTime, List<Map<String, dynamic>>> eventMap = {};

    for (var schedule in scheduleList) {
      final DateTime date = DateTime.parse(schedule['updateDay']);

      if (eventMap.containsKey(date)) {
        eventMap[date]!.addAll(schedule['data']);
      } else {
        eventMap[date] = List.from(schedule['data']);
      }
    }
    return eventMap;
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
          title: Text(
            S.current.shift_plan,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
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
                Visibility(
                  visible: isOperator == true,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: BorderSide.none,
                        borderSide: const BorderSide(color: Color(0xFF8693AB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF8693AB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF8693AB)),
                      ),
                    ),
                    hint: Text(_seleteMemberName),
                    items: memberList
                        .map((item) => DropdownMenuItem<String>(
                              value: item['userId'].toString(),
                              child: Text(item['lastName']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _seleteMemberId = int.parse(value!);
                        _seleteMemberName = memberList.firstWhere((element) =>
                            element['userId'] == int.parse(value))['lastName'];
                        _workScheduleFuture = getWorkSchedule();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            DateTime? d = await showMonthYearPicker(
                              context: context,
                              initialMonthYearPickerMode:
                                  MonthYearPickerMode.month,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                              locale: savedLanguage == 'zh'
                                  ? const Locale('zh')
                                  : const Locale('en'),
                            );
                            if (d != null) {
                              seleteTime = date_format.formatDate(
                                  d, [date_format.yyyy, '-', date_format.mm]);
                              setState(() {});
                            }
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
                                seleteTime,
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
                    SizedBox(
                      width: 180,
                      child: MaterialSegmentedControl(
                        children: {
                          0: Text(S.current.last_month),
                          1: Text(S.current.this_month),
                          2: Text(S.current.next_month),
                        },
                        selectionIndex: _currentDateButtonIndex,
                        borderColor: Colors.grey,
                        selectedColor: Colors.green,
                        unselectedColor: Colors.white,
                        selectedTextStyle: const TextStyle(color: Colors.white),
                        unselectedTextStyle:
                            const TextStyle(color: Colors.grey),
                        onSegmentTapped: (index) {
                          setState(() {
                            _currentDateButtonIndex = index;
                            // 根据选择设置开始和结束时间
                            switch (index) {
                              case 0:
                                seleteTime = date_format.formatDate(
                                    DateTime(DateTime.now().year,
                                        DateTime.now().month - 1, 1),
                                    [date_format.yyyy, '-', date_format.mm]);
                                _workScheduleFuture = getWorkSchedule();

                                break;
                              case 1:
                                seleteTime = date_format.formatDate(
                                    DateTime(DateTime.now().year,
                                        DateTime.now().month, 1),
                                    [date_format.yyyy, '-', date_format.mm]);
                                _workScheduleFuture = getWorkSchedule();
                                break;
                              case 2:
                                seleteTime = date_format.formatDate(
                                    DateTime(DateTime.now().year,
                                        DateTime.now().month + 1, 1),
                                    [date_format.yyyy, '-', date_format.mm]);
                                _workScheduleFuture = getWorkSchedule();
                                break;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    // height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // 设置圆角半径为 8
                    ),
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
                            Text(S.current.personal_shift_plan,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: workTypeList.map((item) {
                              return Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(item['colour']
                                          .replaceAll('#', '0xFF'))),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(item['typeName']),
                                  const SizedBox(width: 10),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            FutureBuilder(
                                future: _workScheduleFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return SizedBox(
                                        height: 80,
                                        child: Center(
                                            child: Text(S.current.no_data)));
                                    ;
                                  } else if (snapshot.hasData) {
                                    // Map<DateTime, List> events;
                                    // List workScheduleList = snapshot.data;
                                    // events = _convertToEventMap(workScheduleList);

                                    final kEvents =
                                        LinkedHashMap<DateTime, List>(
                                      equals: isSameDay,
                                      hashCode: getHashCode,
                                    )..addAll(eventMap);

                                    // _selectedEvents = ValueNotifier(
                                    //     kEvents(_selectedDay));

                                    return Column(
                                      children: [
                                        TableCalendar(
                                          locale: savedLanguage == 'zh'
                                              ? 'zh_CN'
                                              : 'en_US',
                                          headerVisible: false,
                                          firstDay: DateTime.utc(2020, 10, 16),
                                          lastDay: DateTime.utc(2030, 3, 14),
                                          focusedDay: _focusedDay,
                                          selectedDayPredicate: (day) =>
                                              isSameDay(_selectedDay, day),
                                          onDaySelected:
                                              (selectedDay, focusedDay) {
                                            setState(() {
                                              _selectedDay = selectedDay;
                                              _focusedDay =
                                                  focusedDay; // update `_focusedDay` here as well
                                            });
                                          },
                                          eventLoader: (day) {
                                            return kEvents[day] ?? [];
                                          },
                                          calendarBuilders: CalendarBuilders(
                                            markerBuilder:
                                                (context, date, events) {
                                              if (events.isNotEmpty) {
                                                return Positioned(
                                                  right: 1,
                                                  bottom: 1,
                                                  child: _buildEventsMarker(
                                                      date, events),
                                                );
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        // 显示选中日期的事件
                                        // if (_selectedDay != null) ...[
                                        //   const SizedBox(height: 8),
                                        //   const Text(
                                        //     '选中日期的事件:',
                                        //     style: TextStyle(
                                        //         fontSize: 16,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        //   ...(events[_selectedDay] ?? [])
                                        //       .map((event) {
                                        //     return Padding(
                                        //       padding: const EdgeInsets.symmetric(
                                        //           horizontal: 12, vertical: 4),
                                        //       child: Text('- $event'),
                                        //     );
                                        //   }),
                                        // ],
                                        _buildEventList(_selectedDay),
                                      ],
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColor(events),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  getColor(List events) {
    if (events.isEmpty) {
      return Colors.black;
    }
    final typeNames = events.map((event) => event['typeName']).toSet();
    if (typeNames.length == 1) {
      final event = events[0];
      return Color(int.parse(event['typeColour'].replaceAll('#', '0xFF')));
    }
    return Colors.black;
  }

  Widget _buildEventList(DateTime date) {
    final kEvents = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventMap);
    final events = kEvents[date] ?? [];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          // height: 40,
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(event['itemName'] ?? ''),
            subtitle: Text(event['typeName'] ?? ''),
            leading: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Color(
                    int.parse(event['typeColour'].replaceAll('#', '0xFF'))),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
