import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';

class PersonalPageProvider extends ChangeNotifier {
  // 状态变量
  Map<String, dynamic> versionData = {};
  String nowVersion = 'V1.0.0';
  String lastVersion = 'V1.0.0';
  String? singleId = GlobalStorage.getSingleId();
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  PersonalPageProvider() {
    // 初始化时加载数据
    initData();
  }

  // 初始化数据
  Future<void> initData() async {
    try {
      isLoading = true;
      notifyListeners();

      // 并行获取数据
      await Future.wait([
        getAppVersion(),
        getUserInfo(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('初始化数据失败: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 获取应用版本信息
  Future<void> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      nowVersion = "V${packageInfo.version}";

      var data = await LoginDao.appVersion();
      if (kDebugMode) {
        print(data.toString());
      }
      if (data["code"] == 200 && data['data'] != null) {
        versionData = data['data'];
        lastVersion = versionData['version'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取版本信息失败: $e');
      }
    }
  }

  // 获取用户信息
  Future<void> getUserInfo() async {
    try {
      String? loginInfo = GlobalStorage.getLoginInfo();
      if (loginInfo != null) {
        userInfo = jsonDecode(loginInfo);
      }
    } catch (e) {
      if (kDebugMode) {
        print('获取用户信息失败: $e');
      }
    }
  }

  // 登出操作
  Future<void> logout() async {
    GlobalStorage.clearUserInfo();
    userInfo = null;
    singleId = null;
    notifyListeners();
  }

  // 检查是否有新版本
  bool get hasNewVersion => nowVersion != lastVersion;
}
