import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WithePage extends StatefulWidget {
  const WithePage({super.key});

  @override
  State<WithePage> createState() => _WithePageState();
}

class _WithePageState extends State<WithePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {}; // 存储日期对应的事件

  @override
  void initState() {
    super.initState();
    // 初始化事件数据
    _events = {
      DateTime.now(): ['会议', '健身'],
      DateTime.now().add(Duration(days: 1)): ['约会'],
      DateTime.now().add(Duration(days: 3)): ['生日派对', '电影'],
    };
  }

  // 获取选中日期的事件
  List<String> _getEventsForDay(DateTime day) {
    // 忽略时间部分，只比较年月日
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('带数据的日历')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2023),
            lastDay: DateTime(2025),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },

            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            // 标记有事件的日期
            eventLoader: _getEventsForDay,

            // 自定义事件标记样式
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),

          // 显示选中日期的事件
          // SizedBox(
          //   height: 200,
          //   child: ListView(
          //     shrinkWrap: true,
          //     children: _getEventsForDay(_selectedDay ?? _focusedDay)
          //         .map((event) => ListTile(
          //               title: Text(event),
          //             ))
          //         .toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
