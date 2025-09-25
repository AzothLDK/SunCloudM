import 'package:date_format/date_format.dart' as date_format;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:suncloudm/toolview/imports.dart';

class CnmonitoringYxpage extends StatefulWidget {
  final Map projectInfo;
  const CnmonitoringYxpage({super.key, required this.projectInfo});

  @override
  State<CnmonitoringYxpage> createState() => _CnmonitoringYxpageState();
}

class _CnmonitoringYxpageState extends State<CnmonitoringYxpage> {
  DateTime? _startTime;
  DateTime? _endTime;
  Map<String, dynamic> viewData = {};

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _endTime = DateTime.now();
  }

  Future<Map<String, dynamic>> getChangeRecord() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = widget.projectInfo['deviceCode'];
    params['measureField'] = widget.projectInfo['field'];
    params['startTime'] = _startTime;
    params['endTime'] = _endTime;
    var data = await CnMonitorDao.getChangeRecord(params: params);
    debugPrint(params.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        return viewData = data['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _selectTime() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: true,
      isShowSeconds: true,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (dateTimeList != null) {
      _startTime = dateTimeList[0];
      _endTime = dateTimeList[1];
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.tsSwitchRecord,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white, // 添加白色背景
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 添加8像素圆角
                    ),
                  ),
                  onPressed: () => _selectTime(),
                  child: Text(
                    date_format.formatDate(_startTime!, [
                      date_format.yyyy,
                      '-',
                      date_format.mm,
                      '-',
                      date_format.dd,
                      ' ',
                      date_format.HH,
                      ':',
                      date_format.nn,
                      ':',
                      date_format.ss
                    ]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white, // 添加白色背景
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 添加8像素圆角
                    ),
                  ),
                  onPressed: () => _selectTime(),
                  child: Text(
                    date_format.formatDate(_endTime!, [
                      date_format.yyyy,
                      '-',
                      date_format.mm,
                      '-',
                      date_format.dd,
                      ' ',
                      date_format.HH,
                      ':',
                      date_format.nn,
                      ':',
                      date_format.ss
                    ]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 10, // 新增Row与上方的间隔
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _startTime =
                          DateTime.now().subtract(const Duration(days: 30));
                      _endTime = DateTime.now();
                    });
                  },
                  child: Text(S.current.pastMonth),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _startTime =
                          DateTime.now().subtract(const Duration(days: 90));
                      _endTime = DateTime.now();
                    });
                  },
                  child: Text(S.current.past3Months),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _startTime =
                          DateTime.now().subtract(const Duration(days: 180));
                      _endTime = DateTime.now();
                    });
                  },
                  child: Text(S.current.past6Months),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          FutureBuilder(
              future: getChangeRecord(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F8F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                      '${S.current.totalSwitchTimes}  ${data['totalChange']}'),
                                ),
                              ),
                            ),
                            // 新增数据列表区域
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  // 标题行
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF8F8F8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              S.current.time,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              S.current.value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 数据列表
                                  Container(
                                    constraints: const BoxConstraints(
                                        maxHeight: 400), // 限制最大高度可滚动
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: data['xlist']?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        List timeList = data['xlist'];
                                        List valueList = data['valueList'];
                                        final time = timeList[index];
                                        final value = valueList[index];
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(
                                                  time.toString(),
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(
                                                  value.toString(),
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  // 无数据提示
                                  if ((data['xlist']?.length ?? 0) == 0)
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Text(S.current.noSwitchRecord),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}
