import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../dao/storage.dart';
import '../../dao/daoX.dart';

class PersonalInfoProvider with ChangeNotifier {
  Map _versionData = {};
  String _nowVersion = 'V1.0.0';
  String _lastVersion = 'V1.0.0';
  Map _userInfo = {};
  String? _singleId;
  bool _isLoading = true;

  // Getters
  Map get versionData => _versionData;
  String get nowVersion => _nowVersion;
  String get lastVersion => _lastVersion;
  Map get userInfo => _userInfo;
  String? get singleId => _singleId;
  bool get isLoading => _isLoading;

  PersonalInfoProvider() {
    // 初始化数据
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      _isLoading = true;
      notifyListeners();
      // 加载用户信息
      _loadUserInfo();
      // 加载版本信息
      await _getAppVersion();
    } catch (e) {
      debugPrint('加载个人信息失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> exAppversion() async {
    try {
      await _getAppVersion();
    } catch (e) {
      debugPrint('获取版本信息失败: $e');
    } finally {
      notifyListeners();
    }
  }

  void _loadUserInfo() {
    String? loginInfo = GlobalStorage.getLoginInfo();
    if (loginInfo != null) {
      _userInfo = jsonDecode(loginInfo);
    }
    _singleId = GlobalStorage.getSingleId();
  }

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _nowVersion = "V${packageInfo.version}";

      var data = await LoginDao.appVersion();
      if (data["code"] == 200 && data['data'] != null) {
        _versionData = data['data'];
        _lastVersion = _versionData['version'] ?? _nowVersion;
      }
    } catch (e) {
      debugPrint('获取版本信息失败: $e');
    }
  }

  // 刷新数据
  Future<void> refreshData() async {
    await loadInitialData();
  }

  // 登出操作
  Future<void> logout(BuildContext context) async {
    GlobalStorage.clearUserInfo();
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );
  }
}

// 提供便捷方法获取Provider
PersonalInfoProvider getPersonalInfoProvider(BuildContext context) {
  return Provider.of<PersonalInfoProvider>(context, listen: false);
}
