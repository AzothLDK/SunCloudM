import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:suncloudm/toolview/imports.dart';

class OplInspectiontaskPage extends StatefulWidget {
  const OplInspectiontaskPage({super.key});

  @override
  State<OplInspectiontaskPage> createState() => _OplInspectiontaskPageState();
}

class _OplInspectiontaskPageState extends State<OplInspectiontaskPage> {
  List<String> titleList = ['按人员', '按班组', '按电站'];
  List<String> personList = ['人员1', '人员2', '人员3'];
  int _currentDateButtonIndex = 1;
  String? selectedPerson;
  int _selectedIndex = -1; // 初始化未选中任何按钮
  int _currentDateType = 0;
  String startDate = formatDate(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      [yyyy, '-', mm, '-', dd]);
  String endDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List> _events = {
    DateTime.utc(2025, 6, 20): ['加油']
  };

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
            '巡检任务',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),
                  itemCount: titleList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      // height: 40, // 设置高度为 40  ,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 16, // 设置字体大小为 16
                          ),
                          backgroundColor: _selectedIndex == index
                              ? Color(0xFF24C18F)
                              : Colors.white,
                          foregroundColor: _selectedIndex == index
                              ? Colors.white
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // 设置 20 圆角
                          ),
                          minimumSize: const Size(80, 20), // 设置长条形和高度 40
                        ),
                        child: Text(titleList[index]),
                      ),
                    );
                  },
                ),
                // const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        hint: const Text('请选择人员'),
                        items: personList
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPerson = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: MaterialSegmentedControl(
                        children: {
                          0: Text('上月'),
                          1: Text('本月'),
                          2: Text('下月'),
                        },
                        selectionIndex: _currentDateButtonIndex,
                        borderColor: Colors.grey,
                        selectedColor: Colors.green,
                        unselectedColor: Colors.white,
                        selectedTextStyle: TextStyle(color: Colors.white),
                        unselectedTextStyle: TextStyle(color: Colors.grey),
                        // onSegmentChosen: (index) {
                        //   setState(() {
                        //     _currentDateButtonIndex = index;
                        //     // 根据选择设置开始和结束时间
                        //     switch (index) {
                        //       case 0:
                        //         startDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
                        //         endDate = DateTime(DateTime.now().year, DateTime.now().month, 0);
                        //         break;
                        //       case 1:
                        //         startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                        //         endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                        //         break;
                        //       case 2:
                        //         startDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
                        //         endDate = DateTime(DateTime.now().year, DateTime.now().month + 2, 0);
                        //         break;
                        //     }
                        //   });
                        // },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
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
                                        ? DateRangePickerView.month
                                        : _currentDateType == 1
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
                                                ? [yyyy, '-', mm, '-', dd]
                                                : _currentDateType == 1
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
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "$startDate",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black26),
                          ),
                          Text(
                            "-",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black26),
                          ),
                          Text(
                            "$endDate",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black26),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
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
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('任务列表',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DataTable(
                          columnSpacing: 30, // 缩短列间距
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('人员名称'),
                            ),
                            DataColumn(
                              label: Text('巡检类型'),
                            ),
                            DataColumn(
                              label: Text('巡检日期'),
                            ),
                            DataColumn(
                              label: Text('巡检电战'),
                            ),
                          ],
                          rows: const <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('张三')),
                                DataCell(Text('日常巡检')),
                                DataCell(Text('2024-01-01')),
                                DataCell(Text('电站A')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('李四')),
                                DataCell(Text('专项巡检')),
                                DataCell(Text('2024-01-02')),
                                DataCell(Text('电站A')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('王五')),
                                DataCell(Text('定期巡检')),
                                DataCell(Text('2024-01-03')),
                                DataCell(Text('电站A')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('赵六')),
                                DataCell(Text('临时巡检')),
                                DataCell(Text('2024-01-04')),
                                DataCell(Text('电站A')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
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
                            SizedBox(
                              height: 18,
                              child: VerticalDivider(
                                thickness: 3,
                                color: Colors.green,
                              ),
                            ),
                            Text('巡检日历',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text('工单抢修'),
                                SizedBox(width: 10),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text('周期巡检'),
                                SizedBox(width: 10),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text('临时计划'),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        TableCalendar(
                          locale: savedLanguage == 'zh'
                              ? const Locale('zh_CN')
                              : const Locale('en_US'),
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          // rangeStartDay: DateTime(2025, 6, 14),
                          // rangeEndDay: DateTime(2025, 6, 20),
                          // eventLoader: (day) => _events[day] ?? [],
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              if (isSameDay(day, DateTime.utc(2025, 6, 20))) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${day.day}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        '李工',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay =
                                  focusedDay; // update `_focusedDay` here as well
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
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
}
