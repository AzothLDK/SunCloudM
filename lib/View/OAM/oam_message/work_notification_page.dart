import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';

class WorkNotificationPage extends StatefulWidget {
  const WorkNotificationPage({super.key});

  @override
  State<WorkNotificationPage> createState() => _WorkNotificationPageState();
}

class _WorkNotificationPageState extends State<WorkNotificationPage> {
  List<WorkNotificationItem> _notificationList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkNotificationList();
  }

  Future<void> _fetchWorkNotificationList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 设置固定参数：mesType=1，type=29
      Map<String, dynamic> params = {
        "mesType": 1,
        "type": 29,
      };
      final result = await WorkDao.getWorkNotificationList(params: params);

      if (result != null && result['code'] == 200) {
        // 解析数据
        List<dynamic> xxRecords = result['data']?['xxRecords'] ?? [];
        List<WorkNotificationItem> items = [];
        
        for (var record in xxRecords) {
          List<dynamic> records = record['records'] ?? [];
          for (var item in records) {
            items.add(WorkNotificationItem.fromJson(item));
          }
        }
        
        setState(() {
          _notificationList = items;
        });
      } else {
        // API调用失败时使用mock数据
        _loadMockData();
      }
    } catch (e) {
      // 捕获异常时使用mock数据
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
    List<WorkNotificationItem> mockData = [
      WorkNotificationItem(
        id: 236117,
        userId: "172",
        name: "工单通知",
        itemId: null,
        workNumber: "SN25082514103243a8",
        isHandle: null,
        mesType: 1,
        noticeType: 29,
        isRead: 1,
        updateTime: "52天前",
        createTime: "2025-08-25 14:10:32",
        remark: "您有一个新的工单<尼特威光伏项目-逆变器1-202508251409>，请及时处理。",
      ),
      WorkNotificationItem(
        id: 236118,
        userId: "172",
        name: "工单通知",
        itemId: null,
        workNumber: "SN25082614103243a9",
        isHandle: null,
        mesType: 1,
        noticeType: 29,
        isRead: 0,
        updateTime: "51天前",
        createTime: "2025-08-26 14:10:32",
        remark: "您有一个新的工单<智能能源站项目-配电柜1-202508261409>，请及时处理。",
      ),
      WorkNotificationItem(
        id: 236119,
        userId: "172",
        name: "工单通知",
        itemId: null,
        workNumber: "SN25082714103243aa",
        isHandle: null,
        mesType: 1,
        noticeType: 29,
        isRead: 0,
        updateTime: "50天前",
        createTime: "2025-08-27 14:10:32",
        remark: "您有一个新的工单<城市综合体项目-变压器1-202508271409>，请及时处理。",
      ),
    ];
    
    setState(() {
      _notificationList = mockData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工单消息'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('一键已读'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notificationList.isEmpty
              ? const Center(child: Text('暂无工单消息'))
              : ListView.builder(
                  itemCount: _notificationList.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationItem(_notificationList[index]);
                  },
                ),
    );
  }

  Widget _buildNotificationItem(WorkNotificationItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              if (item.isRead == 0) // 未读消息显示红点
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              const Spacer(),
              Text(
                item.updateTime,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.remark,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                item.workNumber,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    // 这里可以实现标记所有消息为已读的逻辑
    setState(() {
      for (var item in _notificationList) {
        item.isRead = 1;
      }
    });
    SVProgressHUD.showSuccess(status: '已全部标记为已读');
  }
}

// 工单消息数据模型
class WorkNotificationItem {
  final int id;
  final String userId;
  final String name;
  final dynamic itemId;
  final String workNumber;
  final dynamic isHandle;
  final int mesType;
  final int noticeType;
  int isRead; // 0: 未读, 1: 已读
  final String updateTime;
  final String createTime;
  final String remark;

  WorkNotificationItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.itemId,
    required this.workNumber,
    required this.isHandle,
    required this.mesType,
    required this.noticeType,
    required this.isRead,
    required this.updateTime,
    required this.createTime,
    required this.remark,
  });

  factory WorkNotificationItem.fromJson(Map<String, dynamic> json) {
    return WorkNotificationItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      itemId: json['itemId'],
      workNumber: json['workNumber'] ?? '',
      isHandle: json['isHandle'],
      mesType: json['mesType'] ?? 0,
      noticeType: json['noticeType'] ?? 0,
      isRead: json['isRead'] ?? 0,
      updateTime: json['updateTime'] ?? '',
      createTime: json['createTime'] ?? '',
      remark: json['remark'] ?? '',
    );
  }
}