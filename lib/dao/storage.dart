import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class GlobalStorage {
  GlobalStorage._internal();
  factory GlobalStorage() => _instance;
  static final GlobalStorage _instance = GlobalStorage._internal();
  static late final SharedPreferences _sp;

  static Future<GlobalStorage> getInstance() async {
    _sp = await SharedPreferences.getInstance();
    return _instance;
  }

  static String? getLoginInfo() {
    var modelJson = _sp.getString("userInfo");
    return modelJson;
  }

  static Future<void> saveLoginInfo(Map<dynamic, dynamic> userInfo) async {
    String saveTemp = convert.jsonEncode(userInfo);
    _sp.setString("userInfo", saveTemp);
  }

  static Future<void> saveUserPassWord(Map<String, dynamic> userInfo) async {
    String saveTemp = convert.jsonEncode(userInfo);
    _sp.setString("password", saveTemp);
  }

  static String? getPassword() {
    var modelJson = _sp.getString("password");
    return modelJson;
  }

  static String? getToken() {
    var modelJson = _sp.getString("token");
    return modelJson;
  }

  static Future<void> saveToken(String token) async {
    _sp.setString("token", token);
  }

  static String? getSingleId() {
    var modelJson = _sp.getString("single");
    return modelJson;
  }

  static Future<void> saveSingleId(String? id) async {
    _sp.setString("single", id!);
  }

  static String? getCompanyList() {
    var modelJson = _sp.getString("companyList");
    return modelJson;
  }

  static Future<void> saveCompanyList(List companyList) async {
    String saveTemp = convert.jsonEncode(companyList);
    _sp.setString("companyList", saveTemp);
  }

  static String? getLanguage() {
    var language = _sp.getString("language");
    return language;
  }

  static Future<void> saveLanguage(String language) async {
    _sp.setString("language", language);
  }

  static Future<void> clearUserInfo() async {
    // 不使用_sp.clear()，而是逐个删除不需要的键
    await _sp.remove('userInfo');
    await _sp.remove('password');
    await _sp.remove('token');
    await _sp.remove('single');
    await _sp.remove('companyList');
    // 保留language键，不删除
  }

  static Future<void> deleteKeyValue(String key) async {
    _sp.remove(key);
  }
}
