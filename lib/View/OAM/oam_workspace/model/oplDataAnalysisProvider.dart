import 'package:flutter/foundation.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'package:suncloudm/dao/daoX.dart';

class OplDataAnalysisProvider extends ChangeNotifier {
  // 状态变量
  List teamList = [];
  List groupList = [];

  String selectedTeam = '';
  int selectedTeamId = 0;
  String selectedGroup = '';
  int selectedGroupId = 0;

  String seleteTime = '';

  // 图表数据
  Map workSummaryData = {};
  Map acceptStatisticsData = {};
  List workRankData = [];

  bool isLoading = false;

  OplDataAnalysisProvider() {
    // 初始化时间为当前月份
    seleteTime = date_format
        .formatDate(DateTime.now(), [date_format.yyyy, '-', date_format.mm]);

    // 初始化加载数据
    initData();
  }

  // 初始化数据
  Future<void> initData() async {
    try {
      isLoading = true;
      notifyListeners();

      await getTeamList();
    } catch (e) {
      if (kDebugMode) {
        print('初始化数据失败: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 获取团队列表
  Future<void> getTeamList() async {
    try {
      Map<String, dynamic> params = {};
      var data = await WorkDao.getTeamList(params: params);

      if (data["code"] == 200) {
        teamList = [];
        teamList = data['data'];
        if (teamList.isNotEmpty) {
          selectedTeam = teamList[0]['teamName'];
          selectedTeamId = teamList[0]['id'];
          await getGroupList();
        } else {
          selectedGroup = '';
          groupList = [];
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取团队列表失败: $e');
      }
    }
  }

  // 获取小组列表
  Future<void> getGroupList() async {
    try {
      Map<String, dynamic> params = {};
      params['teamId'] = selectedTeamId;
      var data = await WorkDao.getGroupList(params: params);

      if (data["code"] == 200) {
        groupList = [];
        groupList = data['data'];
        if (groupList.isNotEmpty) {
          selectedGroup = groupList[0]['teamName'];
          selectedGroupId = groupList[0]['id'];
        } else {
          selectedGroup = '';
          selectedGroupId = 0;
        }

        // 重新加载所有数据
        await Future.wait([
          getWorkSummary(),
          getAcceptStatistics(),
          getWorkRank(),
        ]);
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取小组列表失败: $e');
      }
    }
  }

  // 获取工单汇总数据
  Future<void> getWorkSummary() async {
    try {
      Map<String, dynamic> params = {};
      params['updateTime'] = seleteTime;
      params['groupId'] = selectedGroupId;
      params['teamId'] = selectedTeamId;
      var data = await WorkDao.getWorkSummary(params: params);

      if (data["code"] == 200) {
        workSummaryData = data['data'] ?? {};
      } else {
        workSummaryData = {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取工单汇总数据失败: $e');
      }
      workSummaryData = {};
    } finally {
      notifyListeners();
    }
  }

  // 获取接单统计数据
  Future<void> getAcceptStatistics() async {
    try {
      Map<String, dynamic> params = {};
      params['updateTime'] = seleteTime;
      params['groupId'] = selectedGroupId;
      params['teamId'] = selectedTeamId;
      var data = await WorkDao.getAcceptStatistics(params: params);

      if (data["code"] == 200) {
        acceptStatisticsData = data['data'] ?? {};
      } else {
        acceptStatisticsData = {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取接单统计数据失败: $e');
      }
      acceptStatisticsData = {};
    } finally {
      notifyListeners();
    }
  }

  // 获取工单处理排名数据
  Future<void> getWorkRank() async {
    try {
      Map<String, dynamic> params = {};
      params['updateTime'] = seleteTime;
      params['groupId'] = selectedGroupId;
      params['teamId'] = selectedTeamId;
      var data = await WorkDao.getWorkRank(params: params);

      if (data["code"] == 200) {
        workRankData = data['data'] ?? [];
      } else {
        workRankData = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取工单处理排名数据失败: $e');
      }
      workRankData = [];
    }
  }

  // 更新选中的团队
  Future<void> updateSelectedTeam(int teamId, String teamName) async {
    try {
      selectedTeamId = teamId;
      selectedTeam = teamName;
      notifyListeners();

      await getGroupList();
    } catch (e) {
      if (kDebugMode) {
        print('更新选中团队失败: $e');
      }
    }
  }

  // 更新选中的小组
  Future<void> updateSelectedGroup(int groupId, String groupName) async {
    try {
      selectedGroupId = groupId;
      selectedGroup = groupName;
      notifyListeners();

      // 重新加载所有数据
      await Future.wait([
        getWorkSummary(),
        getAcceptStatistics(),
        getWorkRank(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('更新选中小组失败: $e');
      }
    }
  }

  // 更新选择的时间
  Future<void> updateSelectedTime(String time) async {
    try {
      seleteTime = time;
      notifyListeners();

      // 重新加载所有数据
      await Future.wait([
        getWorkSummary(),
        getAcceptStatistics(),
        getWorkRank(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('更新选择时间失败: $e');
      }
    }
  }

  // 刷新所有数据
  Future<void> refreshAllData() async {
    try {
      isLoading = true;
      notifyListeners();

      await Future.wait([
        getWorkSummary(),
        getAcceptStatistics(),
        getWorkRank(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('刷新所有数据失败: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
