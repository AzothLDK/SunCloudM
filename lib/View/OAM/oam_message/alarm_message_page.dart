import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';

class AlarmMessagePage extends StatefulWidget {
  const AlarmMessagePage({super.key});

  @override
  State<AlarmMessagePage> createState() => _AlarmMessagePageState();
}

class _AlarmMessagePageState extends State<AlarmMessagePage> {
  List<AlarmItem> _alarmList = [];
  bool _isLoading = true;
  int _currentTabIndex = 0; // 0: 全部, 1: 未处理, 2: 已处理

  @override
  void initState() {
    super.initState();
    _fetchAlarmList();
  }

  Future<void> _fetchAlarmList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // SVProgressHUD.show();
      Map<String, dynamic> params = {
        "pageNum": 1,
        "pageSize": 998,
        "alarmType": _currentTabIndex,
      };
      final result = await LoginDao.getAlarmList(params: params);

      if (result != null && result['code'] == 200) {
        // 数据在 records 字段中
        List<dynamic> records = result['data']?['records'] ?? [];
        setState(() {
          _alarmList = records.map((item) => AlarmItem.fromJson(item)).toList();
        });
      } else {
        // API调用失败时使用mock数据
        // SVProgressHUD.showInfo(status: result?['msg'] ?? '使用本地模拟数据');
        _loadMockData();
      }
    } catch (e) {
      // SVProgressHUD.showInfo(status: '使用本地模拟数据');
      _loadMockData();
    } finally {
      SVProgressHUD.dismiss();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMockData() {
    // 添加模拟数据，以便在API无法访问时展示页面效果
    List<AlarmItem> mockData = [
      AlarmItem(
        id: 6212801,
        deviceCode: "78hg2cvly9z2k9ut9",
        alarmValue: "singleoveruwarning2",
        alarmContent: "簇N单体过压中度告警",
        equipmentType: 3,
        status: 1,
        processTime: "2025-10-14 12:35:00",
        createTime: "2025-10-14 12:30:01",
        alarmType: 2,
        alarmLevel: "中度告警",
        alarmTime: "2025-10-14 12:30:01",
        alarmCode: "1185",
        deviceName: "簇9",
        stationId: 3,
        stationName: "隆盛新厂储能站",
        projectType: 1,
        itemId: 5,
      ),
      AlarmItem(
        id: 6212802,
        deviceCode: "78hg2cvly9z2k9ut9",
        alarmValue: "bancharge",
        alarmContent: "簇N禁充",
        equipmentType: 3,
        status: 1,
        processTime: "2025-10-14 12:35:00",
        createTime: "2025-10-14 12:30:01",
        alarmType: 2,
        alarmLevel: "故障告警",
        alarmTime: "2025-10-14 12:30:01",
        alarmCode: "1235",
        deviceName: "簇9",
        stationId: 3,
        stationName: "隆盛新厂储能站",
        projectType: 1,
        itemId: 5,
      ),
      AlarmItem(
        id: 6212345,
        deviceCode: "20250114lslcbms13",
        alarmValue: "singleoveruwarning2",
        alarmContent: "簇N单体过压中度告警",
        equipmentType: 3,
        status: 2,
        processTime: "2025-10-14 12:54:07",
        createTime: "2025-10-14 12:26:07",
        alarmType: 2,
        alarmLevel: "中度告警",
        alarmTime: "2025-10-14 12:26:07",
        alarmCode: "1185",
        deviceName: "簇3",
        stationId: 337,
        stationName: "隆盛老厂储能站",
        projectType: 1,
        itemId: 499,
      ),
      AlarmItem(
        id: 6212346,
        deviceCode: "20250114lslcbms14",
        alarmValue: "temperaturehigh",
        alarmContent: "电池温度过高告警",
        equipmentType: 3,
        status: 0,
        createTime: "2025-10-14 13:00:00",
        alarmType: 1,
        alarmLevel: "严重告警",
        alarmTime: "2025-10-14 13:00:00",
        alarmCode: "1123",
        deviceName: "簇4",
        stationId: 337,
        stationName: "隆盛老厂储能站",
        projectType: 1,
        itemId: 499,
      ),
    ];

    setState(() {
      _alarmList = mockData;
    });
  }

  List<AlarmItem> get _filteredAlarmList {
    switch (_currentTabIndex) {
      case 1:
        return _alarmList.where((item) => item.status == 0).toList(); // 未处理
      case 2:
        return _alarmList.where((item) => item.status == 1).toList(); // 处理中
      case 3:
        return _alarmList.where((item) => item.status == 2).toList(); // 已处理
      default:
        return _alarmList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            '告警消息',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 实现一键已读逻辑
                _handleMarkAllAsRead();
              },
              child: const Text('一键已读', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        body: Column(
          children: [
            // 状态筛选标签
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTabIndex = 0;
                      });
                    },
                    child: Text(
                      '全部',
                      style: TextStyle(
                        fontWeight: _currentTabIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentTabIndex == 0
                            ? Colors.black
                            : Color(0xFF8693AB),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTabIndex = 1;
                      });
                    },
                    child: Text(
                      '未处理',
                      style: TextStyle(
                        fontWeight: _currentTabIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentTabIndex == 1
                            ? Colors.black
                            : Color(0xFF8693AB),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTabIndex = 2;
                      });
                    },
                    child: Text(
                      '处理中',
                      style: TextStyle(
                        fontWeight: _currentTabIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentTabIndex == 2
                            ? Colors.black
                            : Color(0xFF8693AB),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTabIndex = 3;
                      });
                    },
                    child: Text(
                      '已处理',
                      style: TextStyle(
                        fontWeight: _currentTabIndex == 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _currentTabIndex == 3
                            ? Colors.black
                            : Color(0xFF8693AB),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 列表内容
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredAlarmList.isEmpty
                      ? const Center(child: Text('暂无告警消息'))
                      : ListView.builder(
                          itemCount: _filteredAlarmList.length,
                          itemBuilder: (context, index) {
                            final alarmItem = _filteredAlarmList[index];
                            return _buildAlarmItem(alarmItem);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmItem(AlarmItem item) {
    return InkWell(
      onTap: () {
        // 处理点击事件，例如查看详情
        _handleAlarmItemClick(item);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.alarmContent,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.alarmTime,
                    style:
                        const TextStyle(color: Color(0xFF8692A3), fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getAlarmLevelColor(item.alarmLevel),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.alarmLevel,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusText(item.status),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '设备: ${item.deviceName ?? '未知'}',
                style: const TextStyle(color: Color(0xFF8692A3)),
              ),
              Text(
                '站点: ${item.stationName ?? '未知'}',
                style: const TextStyle(color: Color(0xFF8692A3)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAlarmLevelColor(String level) {
    switch (level) {
      case '轻微告警':
        return Colors.blue;
      case '中度告警':
        return Colors.orange;
      case '严重告警':
        return Colors.red;
      case '故障告警':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.red; // 未处理
      case 1:
        return Colors.orange; // 处理中
      case 2:
        return Colors.green; // 已处理
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return '未处理';
      case 1:
        return '处理中';
      case 2:
        return '已处理';
      default:
        return '未知状态';
    }
  }

  void _handleAlarmItemClick(AlarmItem item) {
    // 实现点击告警项的逻辑
    print('点击了告警项: ${item.alarmContent}');
  }

  void _handleMarkAllAsRead() {
    // 实现一键已读的逻辑
    SVProgressHUD.showInfo(status: '一键已读功能待实现');
  }
}

class AlarmItem {
  final int id;
  final String deviceCode;
  final String? alarmValue;
  final String? alarmId;
  final String alarmContent;
  final int equipmentType;
  final int status;
  final String? action;
  final String? processTime;
  final String createTime;
  final int alarmType;
  final String alarmLevel;
  final dynamic isRules;
  final String? processStartTime;
  final String? alarmInfo;
  final String? alarmTypeValue;
  final String alarmTime;
  final String? alarmConfigId;
  final String alarmCode;
  final String? deviceType;
  final String? statusValue;
  final String? processMode;
  final String? deviceName;
  final String? companyId;
  final int? stationId;
  final String? stationName;
  final int? alarmCount;
  final String? workStatus;
  final String? workNumber;
  final int projectType;
  final int? counts;
  final int itemId;
  final String? pid;

  AlarmItem({
    required this.id,
    required this.deviceCode,
    this.alarmValue,
    this.alarmId,
    required this.alarmContent,
    required this.equipmentType,
    required this.status,
    this.action,
    this.processTime,
    required this.createTime,
    required this.alarmType,
    required this.alarmLevel,
    this.isRules,
    this.processStartTime,
    this.alarmInfo,
    this.alarmTypeValue,
    required this.alarmTime,
    this.alarmConfigId,
    required this.alarmCode,
    this.deviceType,
    this.statusValue,
    this.processMode,
    this.deviceName,
    this.companyId,
    this.stationId,
    this.stationName,
    this.alarmCount,
    this.workStatus,
    this.workNumber,
    required this.projectType,
    this.counts,
    required this.itemId,
    this.pid,
  });

  factory AlarmItem.fromJson(Map<String, dynamic> json) {
    return AlarmItem(
      id: json['id'] ?? 0,
      deviceCode: json['deviceCode'] ?? '',
      alarmValue: json['alarmValue'],
      alarmId: json['alarmId'],
      alarmContent: json['alarmContent'] ?? '',
      equipmentType: json['equipmentType'] ?? 0,
      status: json['status'] ?? 0,
      action: json['action'],
      processTime: json['processTime'],
      createTime: json['createTime'] ?? '',
      alarmType: json['alarmType'] ?? 0,
      alarmLevel: json['alarmLevel'] ?? '',
      isRules: json['isRules'],
      processStartTime: json['processStartTime'],
      alarmInfo: json['alarmInfo'],
      alarmTypeValue: json['alarmTypeValue'],
      alarmTime: json['alarmTime'] ?? '',
      alarmConfigId: json['alarmConfigId'],
      alarmCode: json['alarmCode'] ?? '',
      deviceType: json['deviceType'],
      statusValue: json['statusValue'],
      processMode: json['processMode'],
      deviceName: json['deviceName'],
      companyId: json['companyId'],
      stationId: json['stationId'],
      stationName: json['stationName'],
      alarmCount: json['alarmCount'],
      workStatus: json['workStatus'],
      workNumber: json['workNumber'],
      projectType: json['projectType'] ?? 0,
      counts: json['counts'],
      itemId: json['itemId'] ?? 0,
      pid: json['pid'],
    );
  }
}
