import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suncloudm/toolview/language_resource.dart';
import 'package:suncloudm/toolview/language_switcher.dart';
import 'package:suncloudm/toolview/personal_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../routes/Routes.dart';
import 'package:suncloudm/generated/l10n.dart';

class AdminPersionPage extends StatelessWidget {
  const AdminPersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PersonalInfoScreen();
  }
}

class _PersonalInfoScreen extends StatelessWidget {
  const _PersonalInfoScreen();

  @override
  Widget build(BuildContext context) {
    final personalInfoProvider = Provider.of<PersonalInfoProvider>(context);

    if (personalInfoProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String userTypeText;
    switch (personalInfoProvider.userInfo['userType']) {
      case 0:
        userTypeText = S.current.super_administrator;
        break;
      case 1:
        userTypeText = S.current.single_station_user;
        break;
      case 2:
        userTypeText = S.current.investor;
        break;
      case 3:
        userTypeText = S.current.operation_analyst;
        break;
      case 4:
        userTypeText = S.current.operation_and_maintenance_personnel;
        break;
      case 5:
        userTypeText = S.current.equipment_supplier;
        break;
      default:
        userTypeText = S.current.unknown_type;
    }

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/gradientbg.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Transform.translate(
                offset: const Offset(-10, 0),
                child: Image(
                    height: 50,
                    image: AssetImage(
                        LanguageResource.getImagePath('assets/logintext'))),
              ),
              SizedBox(
                height: 120,
                child: Container(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          // ignore: prefer_interpolation_to_compose_strings
                          'https://api.smartwuxi.com' +
                              (personalInfoProvider.userInfo["logoUrl"] ?? ''),
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  personalInfoProvider.userInfo["title"] ??
                                      "--",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                Text(
                                  userTypeText,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black26),
                                ),
                              ],
                            ),
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
                      Routes.instance!.navigateTo(context, Routes.editpassword);
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
                                Icons.lock,
                                color: Colors.green,
                              ),
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
                    onTap: () {
                      if (personalInfoProvider.nowVersion ==
                          personalInfoProvider.lastVersion) {
                        // 已经是最新版本
                      } else {
                        _openDialog(context, personalInfoProvider);
                      }
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
                            const Icon(
                              Icons.security_update,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              S.current.update_version,
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'ldk'),
                            ),
                            const SizedBox(width: 10),
                            Visibility(
                              visible: personalInfoProvider.nowVersion !=
                                  personalInfoProvider.lastVersion,
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
                              personalInfoProvider.nowVersion,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'ldk',
                                  color: Colors.black26),
                            ),
                          ],
                        )),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // 显示语言选择对话框
                  //     LanguageSwitcher.showLanguageSelectionDialog(context);
                  //   },
                  //   child: Container(
                  //       margin: const EdgeInsets.only(
                  //           top: 5, bottom: 5, left: 15, right: 15),
                  //       padding: const EdgeInsets.symmetric(horizontal: 15),
                  //       height: 65,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(10)),
                  //       child: Row(
                  //         children: <Widget>[
                  //           const Padding(
                  //             padding: EdgeInsets.only(right: 16),
                  //             child: Icon(
                  //               Icons.language,
                  //               color: Colors.green,
                  //             ),
                  //           ),
                  //           Expanded(
                  //               child: Text(
                  //             S.current.language_settings,
                  //             style: const TextStyle(
                  //                 fontSize: 16, fontFamily: 'ldk'),
                  //           )),
                  //           const Icon(Icons.arrow_forward_ios_outlined,
                  //               color: Colors.grey)
                  //         ],
                  //       )),
                  // ),
                ],
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () => personalInfoProvider.logout(context),
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
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDialog(BuildContext context, PersonalInfoProvider provider) {
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
                  style: const TextStyle(
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
                      appUrl = provider.versionData['iosFile'] ?? '';
                    } else if (Platform.isAndroid) {
                      appUrl = provider.versionData['androidFile'] ?? '';
                    }
                    final Uri url = Uri.parse(appUrl);
                    if (appUrl.isNotEmpty && await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
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
                      style: const TextStyle(fontSize: 20, color: Colors.white),
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
}
