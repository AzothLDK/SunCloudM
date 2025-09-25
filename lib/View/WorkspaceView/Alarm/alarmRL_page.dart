import 'package:date_format/date_format.dart' as date_format;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:suncloudm/toolview/imports.dart';

class AlarmRLPage extends StatefulWidget {
  final int? itemId;

  const AlarmRLPage({super.key, this.itemId});

  @override
  State<AlarmRLPage> createState() => _AlarmRlPageState();
}

class _AlarmRlPageState extends State<AlarmRLPage> {
  late TextEditingController _alarmContentController;
  List dataList = [];
  bool _isFilterOpen = false;

  List<Map<String, dynamic>> projectList = [];
  List selectedProjectIds = [];
  String alarmLevel = '';
  String status = '';
  String startTime = '';
  String endTime = '';
  String alarmContent = '';
  int todayAlarm = 0;
  int allAlarm = 0;

  List<Map<String, dynamic>> deviceTypeList = [];
  List selectedDeviceTypes = [];

  List<Map<String, dynamic>> deviceModelsList = [];
  List selectedDeviceModels = [];

  List<Map<String, dynamic>> devicesList = [];
  List selectedDevices = [];

  List<Map<String, dynamic>> deviceIndicatorsList = [];
  List selectedDeviceIndicators = [];

  getstationList() async {
    Map<String, dynamic> params = {};
    params['itemType'] = [1, 2, 3];
    var data = await AlarmDao.getAlarmStationList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        projectList = List<Map<String, dynamic>>.from(data['data']);
        setState(() {});
      } else {}
    } else {}
  }

  getDeviceClassify() async {
    Map<String, dynamic> params = {};
    params['stationId'] = selectedProjectIds;
    var data = await AlarmDao.getDeviceClassifyList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        deviceTypeList = List<Map<String, dynamic>>.from(data['data']);
        setState(() {});
      } else {}
    } else {}
  }

  getDeviceModeList() async {
    Map<String, dynamic> params = {};
    params['stationId'] = selectedProjectIds;
    params['deviceType'] = selectedDeviceTypes;
    var data = await AlarmDao.getDeviceModeList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        deviceModelsList = List<Map<String, dynamic>>.from(data['data']);
        setState(() {});
      } else {}
    } else {}
  }

  getDeviceList() async {
    Map<String, dynamic> params = {};
    params['stationId'] = selectedProjectIds;
    params['modeId'] = selectedDeviceModels;
    var data = await AlarmDao.getDeviceList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        devicesList = List<Map<String, dynamic>>.from(data['data']);
        setState(() {});
      } else {}
    } else {}
  }

  getfieldList() async {
    Map<String, dynamic> params = {};
    params['deviceCode'] = selectedDevices;
    var data = await AlarmDao.getfieldList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        deviceIndicatorsList = List<Map<String, dynamic>>.from(data['data']);
        setState(() {});
      } else {}
    } else {}
  }

  getAlarmList() async {
    Map<String, dynamic> params = {};
    params['pageNum'] = 1;
    params['pageSize'] = 999;
    if (selectedProjectIds.isNotEmpty) {
      params['itemIdList'] = selectedProjectIds;
    }
    if (alarmLevel.isNotEmpty) {
      params['alarmLevel'] = alarmLevel;
    }
    if (status.isNotEmpty) {
      params['status'] = status;
    }
    if (startTime.isNotEmpty) {
      params['startTime'] = startTime;
    }
    if (endTime.isNotEmpty) {
      params['endTime'] = endTime;
    }
    if (alarmContent.isNotEmpty) {
      params['alarmContent'] = alarmContent;
    }
    if (selectedDeviceTypes.isNotEmpty) {
      params['deviceTypeList'] = selectedDeviceTypes;
    }
    if (selectedDeviceModels.isNotEmpty) {
      params['modeIdList'] = selectedDeviceModels;
    }
    if (selectedDevices.isNotEmpty) {
      params['deviceCodeList'] = selectedDevices;
    }
    if (selectedDeviceIndicators.isNotEmpty) {
      params['measureFieldList'] = selectedDeviceIndicators;
    }

    print(params);
    var data = await AlarmDao.getAlarmList(params: params);
    if (data["code"] == 200) {
      if (data['data'] != null) {
        dataList = data['data']['records'];
        // 获取今天的日期
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // 筛选出 alarmTime 是今天的数据
        final todayAlarms = dataList.where((item) {
          final alarmTime = DateTime.parse(item['alarmTime']);
          final alarmDate =
              DateTime(alarmTime.year, alarmTime.month, alarmTime.day);
          return alarmDate == today;
        }).toList();

        // 统计个数并赋值给 todayAlarm
        if (mounted) {
          setState(() {
            todayAlarm = todayAlarms.length;
            allAlarm = dataList.length;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      selectedProjectIds = [widget.itemId];
      getDeviceClassify();
    }

    getstationList();
    getAlarmList();
    _alarmContentController = TextEditingController(text: alarmContent);
  }

  @override
  void dispose() {
    _alarmContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.real_time_alarm,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterOpen = true;
              });
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Text(
                '${S.current.today_alarm_count}：$todayAlarm   ${S.current.total_alarm_count}：$allAlarm',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, i) {
                        return alarmCard(dataList[i]);
                      })),
            ],
          ),
          if (_isFilterOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFilterOpen = false;
                });
              },
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          if (_isFilterOpen)
            AnimatedSlide(
              duration: const Duration(milliseconds: 10000),
              offset: const Offset(0.5, 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 2 / 3,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    // 这里可以添加筛选条件的内容
                    Text(S.current.filter_criteria),
                    // 让筛选条件区域可以滚动并占据剩余空间
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // 选择项目（多选）
                            MultiSelectDropdown(
                              idKey: 'id',
                              nameKey: 'stationName',
                              title: S.current.select_project,
                              options: projectList,
                              selectedIds: selectedProjectIds,
                              // selectedItems: selectedProjects,
                              onChanged: (List newIds) {
                                setState(() {
                                  selectedProjectIds = newIds;
                                  print(selectedProjectIds);
                                  deviceTypeList = [];
                                  selectedDeviceTypes = [];
                                  deviceModelsList = [];
                                  selectedDeviceModels = [];
                                  devicesList = [];
                                  selectedDevices = [];
                                  deviceIndicatorsList = [];
                                  selectedDeviceIndicators = [];
                                  if (selectedProjectIds.isNotEmpty) {
                                    getDeviceClassify();
                                  }
                                });
                              },
                            ),
                            // 告警等级
                            ListTile(
                              title: Text(S.current.alarm_level),
                              trailing: DropdownButton<String>(
                                value: alarmLevel.isEmpty ? null : alarmLevel,
                                items: <String>[
                                  S.current.minor_alarm,
                                  S.current.moderate_alarm,
                                  S.current.critical_alarm,
                                  S.current.fault,
                                  S.current.event,
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    alarmLevel = newValue!;
                                  });
                                },
                              ),
                            ),
                            // 告警状态
                            ListTile(
                              title: Text(S.current.alarm_status),
                              trailing: DropdownButton<String>(
                                value: status.isEmpty ? null : status,
                                items: <String>['0', '1'].map((String value) {
                                  String text = value == '0'
                                      ? S.current.unprocessed
                                      : S.current.processed;
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(text),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      status = newValue;
                                    }
                                  });
                                },
                              ),
                            ),
                            // 开始时间
                            ListTile(
                              title: Text(S.current.start_time),
                              trailing: TextButton(
                                onPressed: () async {
                                  _selectTime();
                                },
                                child: Text(startTime.isEmpty
                                    ? S.current.select_date
                                    : startTime),
                              ),
                            ),
                            // 结束时间
                            ListTile(
                              title: Text(S.current.end_time),
                              trailing: TextButton(
                                onPressed: () async {
                                  _selectTime();
                                },
                                child: Text(endTime.isEmpty
                                    ? S.current.select_date
                                    : endTime),
                              ),
                            ),
                            // 告警内容
                            ListTile(
                              title: Text(S.current.alarm_content),
                              subtitle: TextField(
                                controller: _alarmContentController,
                                decoration: InputDecoration(
                                  hintText: S.current.enter_alarm_content,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    alarmContent = newValue;
                                  }
                                },
                              ),
                            ),
                            MultiSelectDropdown(
                              idKey: 'deviceType',
                              nameKey: 'deviceName',
                              title: S.current.device_type,
                              options: deviceTypeList,
                              selectedIds: selectedDeviceTypes,
                              onChanged: (List newIds) {
                                setState(() {
                                  selectedDeviceTypes = newIds;
                                  print(selectedDeviceTypes);
                                  deviceModelsList = [];
                                  selectedDeviceModels = [];
                                  devicesList = [];
                                  selectedDevices = [];
                                  deviceIndicatorsList = [];
                                  selectedDeviceIndicators = [];
                                  if (selectedDeviceTypes.isNotEmpty) {
                                    getDeviceModeList();
                                  }
                                });
                              },
                            ),
                            MultiSelectDropdown(
                              idKey: 'id',
                              nameKey: 'modelName',
                              title: S.current.device_model,
                              options: deviceModelsList,
                              selectedIds: selectedDeviceModels,
                              onChanged: (List newIds) {
                                setState(() {
                                  selectedDeviceModels = newIds;
                                  print(selectedDeviceModels);
                                  devicesList = [];
                                  selectedDevices = [];
                                  deviceIndicatorsList = [];
                                  selectedDeviceIndicators = [];
                                  if (selectedDeviceModels.isNotEmpty) {
                                    getDeviceList();
                                  }
                                });
                              },
                            ),
                            MultiSelectDropdown(
                              idKey: 'deviceCode',
                              nameKey: 'deviceName',
                              title: S.current.device_name,
                              options: devicesList,
                              selectedIds: selectedDevices,
                              onChanged: (List newIds) {
                                setState(() {
                                  selectedDevices = newIds;
                                  print(selectedDevices);
                                  deviceIndicatorsList = [];
                                  selectedDeviceIndicators = [];
                                  if (selectedDevices.isNotEmpty) {
                                    getfieldList();
                                  }
                                });
                              },
                            ),
                            MultiSelectDropdown(
                              idKey: 'id',
                              nameKey: 'measureName',
                              title: S.current.device_metrics,
                              options: deviceIndicatorsList,
                              selectedIds: selectedDeviceIndicators,
                              onChanged: (List newIds) {
                                setState(() {
                                  selectedDeviceIndicators = newIds;
                                  print(selectedDeviceIndicators);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF2F8F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // 重置逻辑
                                setState(() {
                                  selectedProjectIds.clear();
                                  alarmLevel = '';
                                  status = '';
                                  startTime = '';
                                  endTime = '';
                                  alarmContent = '';
                                  _alarmContentController.clear();
                                  selectedDeviceTypes.clear();
                                  selectedDeviceModels.clear();
                                  selectedDevices.clear();
                                  selectedDeviceIndicators.clear();

                                  deviceTypeList.clear();
                                  deviceModelsList.clear();
                                });
                              },
                              child: Text(
                                S.current.reset,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF24C18F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // 这里可以添加确定逻辑
                                getAlarmList();
                                setState(() {
                                  _isFilterOpen = false;
                                });
                              },
                              child: Text(
                                S.current.confirm,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  alarmCard(Map data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: <Widget>[
          const Image(
            width: 40,
            height: 40,
            image: AssetImage('assets/alarmIcon.png'),
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFF2E5),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        '${data['alarmLevel']}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFFFB8209)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${data['alarmContent']}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 6, vertical: 4),
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xFFFEE9E9),
                    //       borderRadius: BorderRadius.circular(15)),
                    //   child: Text(
                    //     '${data['status'] == 0 ? '未处理' : data['status'] == 1 ? '已处理' : '已转工单'}',
                    //     style: const TextStyle(
                    //         fontSize: 12, color: Color(0xFFF62626)),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${data['stationName']}--${data['deviceName']}',
                    style: const TextStyle(
                        color: Color.fromRGBO(123, 125, 138, 1), fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${data['alarmTime']}',
                        style: const TextStyle(
                            color: Color.fromRGBO(123, 125, 138, 1),
                            fontSize: 14)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
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
      startTime = date_format.formatDate(dateTimeList[0], [
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
      ]);
      endTime = date_format.formatDate(dateTimeList[1], [
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
      ]);
      setState(() {});
      return;
    }
  }
}

// 自定义多选下拉组件，处理包含 id 和 name 的数据
class MultiSelectDropdown extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> options;
  final List selectedIds;
  final Function(List) onChanged;
  final String idKey; // 新增 id 字段名变量
  final String nameKey; // 新增 name 字段名变量

  const MultiSelectDropdown({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
    required this.idKey,
    required this.nameKey,
  }) : super(key: key);

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  void _toggleItem(var id) {
    setState(() {
      if (widget.selectedIds.contains(id)) {
        widget.selectedIds.remove(id);
      } else {
        widget.selectedIds.add(id);
      }
      widget.onChanged(widget.selectedIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取选中的 stationName 列表
    List<String> selectedNames = widget.options
        .where((item) => widget.selectedIds.contains(item[widget.idKey]))
        .map((item) => item[widget.nameKey] as String)
        .toList();
    // 将选中的 stationName 以逗号分隔成字符串
    String selectedNamesString = selectedNames.join(', ');

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          if (selectedNamesString.isNotEmpty)
            Text(
              selectedNamesString,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, state) {
              return AlertDialog(
                title: Text(widget.title),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: widget.options.map((Map<String, dynamic> item) {
                      return CheckboxListTile(
                        title: Text(item[widget.nameKey]),
                        value: widget.selectedIds.contains(item[widget.idKey]),
                        onChanged: (bool? checked) {
                          _toggleItem(item[widget.idKey]);
                          state(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(S.current.confirm),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }
}
