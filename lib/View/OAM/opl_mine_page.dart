import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:suncloudm/View/LogView/login_page.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/routes/Routes.dart';
import 'package:suncloudm/toolview/language_switcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OplMinePage extends StatefulWidget {
  const OplMinePage({super.key});

  @override
  State<OplMinePage> createState() => _OplMinePageState();
}

class _OplMinePageState extends State<OplMinePage> {
  Map versionData = {};
  Map userInfo = jsonDecode(GlobalStorage.getLoginInfo()!);
  String nowVersion = 'V1.0.0';
  String lastVersion = 'V1.0.0';

  String _locationText = '正在获取位置...';
  String _addressText = '正在解析地址...';

  @override
  void initState() {
    super.initState();
    // _getLocation();
    _getAppVersion();
  }

  Future<void> _getLocation() async {
    // 请求位置权限
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _locationText = '纬度: ${position.latitude}, 经度: ${position.longitude}';
        });
        // 将坐标转换为中文地址
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String address =
              '${placemark.country} ${placemark.administrativeArea} ${placemark.locality} ${placemark.street}';
          setState(() {
            _addressText = address;
          });
        }
      } catch (e) {
        setState(() {
          _locationText = '获取位置失败: $e';
          _addressText = '解析地址失败';
        });
      }
    } else {
      setState(() {
        _locationText = '未授予位置权限';
        _addressText = '未授予位置权限';
      });
    }
  }

//获取版本
  _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    nowVersion = packageInfo.version;
    nowVersion = "V$nowVersion";

    var data = await LoginDao.appVersion();
    debugPrint(data.toString());
    if (data["code"] == 200) {
      if (data['data'] != null) {
        versionData = data['data'];
        lastVersion = versionData['version'];
      }
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/oambg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            '个人中心',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // 移除AppBar的阴影
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 120,
              child: Container(
                padding: EdgeInsets.only(left: 15, bottom: 15),
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 80,
                      width: 80,
                      child:
                          Image(image: AssetImage('assets/homePersonIcon.png')),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userInfo['lastName'],
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Routes.instance!.navigateTo(context, Routes.oplteam);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: <Widget>[
                          // const Padding(
                          //   padding: EdgeInsets.only(right: 16),
                          //   child: Image(image: AssetImage('assets/opmt.png')),
                          // ),
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.group_outlined),
                          ),
                          Expanded(
                              child: Text(
                            S.current.OM_team,
                            style: TextStyle(fontSize: 16, fontFamily: 'ldk'),
                          )),
                          const Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.grey)
                        ],
                      )),
                ),
                InkWell(
                  onTap: () {
                    Routes.instance!
                        .navigateTo(context, Routes.oplWorkschedule);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: <Widget>[
                          // const Padding(
                          //   padding: EdgeInsets.only(right: 16),
                          //   child: Image(
                          //       image: AssetImage('assets/knowledgebase.png')),
                          // ),
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.person_outline_outlined),
                          ),
                          Expanded(
                              child: Text(
                            S.current.my_shift,
                            style: TextStyle(fontSize: 16, fontFamily: 'ldk'),
                          )),
                          const Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.grey)
                        ],
                      )),
                ),
                InkWell(
                  onTap: () {
                    Routes.instance!.navigateTo(context, Routes.editpassword);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: <Widget>[
                          // const Padding(
                          //   padding: EdgeInsets.only(right: 16),
                          //   child: Image(
                          //       image: AssetImage('assets/editpassword.png')),
                          // ),
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.lock_outline),
                          ),
                          Expanded(
                              child: Text(
                            S.current.change_password,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'ldk'),
                          )),
                          const Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.grey)
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    if (nowVersion == lastVersion) {
                      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
                      SVProgressHUD.showInfo(
                          status: S.current.already_latest_version);
                    } else {
                      _openDialog(context);
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.verified_outlined,
                            // color: Colors.green,
                          ),

                          SizedBox(width: 16),
                          // const Padding(
                          //   padding: EdgeInsets.only(right: 16),
                          //   child:Image(image: AssetImage('assets/editpassword.png')),
                          // ),
                          Text(
                            S.current.update_version,
                            style: TextStyle(fontSize: 16, fontFamily: 'ldk'),
                          ),
                          const SizedBox(width: 10),
                          Visibility(
                            visible: (nowVersion == lastVersion) ? false : true,
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                S.current.new_version_available,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            nowVersion,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'ldk',
                                color: Colors.black26),
                          ),
                        ],
                      )),
                ),
                InkWell(
                  onTap: () {
                    // 显示语言选择对话框
                    LanguageSwitcher.showLanguageSelectionDialog(context);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.language,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            S.current.language_settings,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'ldk'),
                          )),
                          const Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.grey)
                        ],
                      )),
                ),
              ],
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: _logout,
              child: Container(
                margin: const EdgeInsets.all(15),
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  S.current.logout,
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            width: 300,
            height: 350,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/appversionBg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  S.current.premium_features,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF3BBAAF),
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String appUrl = "";
                    if (Platform.isIOS) {
                      appUrl = versionData['iosFile'];
                    } else if (Platform.isAndroid) {
                      appUrl = versionData['androidFile'];
                    }
                    final Uri url = Uri.parse(appUrl);
                    if (!await launchUrl(url,
                        mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3BBAAF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      S.current.immediate_update,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //登录
  _logout() {
    GlobalStorage.clearUserInfo();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const LoginPage()),
        (route) => route == null);
  }
}
