import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:suncloudm/View/OAM/op_index_page.dart';
import 'package:suncloudm/View/OAM/opl_index_page.dart';
import 'package:suncloudm/dao/config.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/toolview/language_resource.dart';
import 'package:suncloudm/toolview/personal_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dao/daoX.dart';
import '../../dao/storage.dart';
import '../index_page.dart';
import 'package:suncloudm/utils/jpushutils.dart';

final List<Permission> needPermissionList = [
  Permission.notification,
];

class LoginPage extends StatefulWidget {
  final Function(Locale)? onLocaleChange;
  const LoginPage({super.key, this.onLocaleChange});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formGK = GlobalKey<FormState>();

  final Map<String, dynamic> _data = {};

  late bool _passwordVisible = true;

  String _getUsername() {
    String? pw = GlobalStorage.getPassword();
    if (pw == null) {
      return '';
    } else {
      Map dd = jsonDecode(pw);
      return dd['username'].toString();
    }
  }

  String _getPassword() {
    String? pw = GlobalStorage.getPassword();
    if (pw == null) {
      return '';
    } else {
      Map dd = jsonDecode(pw);
      return dd['password'].toString();
    }
  }

  void checkPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await needPermissionList.request();
    statuses.forEach((key, value) {
      print('$key premissionStatus is $value');
    });
  }

  final dio = Dio();

  void getHttp() async {
    final response = await dio.get('https://www.baidu.com');
    print(response);
  }

  @override
  void initState() {
    super.initState();
    getHttp();
    compareVersion();
    checkPermission();
    AppJPush.setBadge(0);
  }

  void compareVersion() async {
    final personalInfoProvider =
        Provider.of<PersonalInfoProvider>(context, listen: false);
    await personalInfoProvider.exAppversion();
    if (personalInfoProvider.nowVersion != personalInfoProvider.lastVersion) {
      // 版本不一致，提示用户更新
      WidgetsBinding.instance.addPostFrameCallback((_) {
        log(personalInfoProvider.lastVersion);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('版本更新'),
            content: const Text('发现新版本，是否更新？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  String appUrl = "";
                  if (Platform.isIOS) {
                    appUrl = personalInfoProvider.versionData['iosFile'] ?? '';
                  } else if (Platform.isAndroid) {
                    appUrl =
                        personalInfoProvider.versionData['androidFile'] ?? '';
                  }
                  final Uri url = Uri.parse(appUrl);
                  if (appUrl.isNotEmpty && await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text('更新'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/loginBg.png'), fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                // color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage(
                        LanguageResource.getImagePath('assets/logintext'))),
              ),
            ),
            const Spacer(),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(
                    top: 20, left: 15, right: 15, bottom: 15),
                // height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formGK,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildConteny(),
                  ),
                )),
            const Spacer(),
            Container(
              // width: 100,
              height: 50,
              decoration: const BoxDecoration(
                // color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/logintext2.png'),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConteny() {
    //登录
    return <Widget>[
      Align(
        alignment: Alignment.center,
        child: Text(S.current.sign_in,
            style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF24C18F),
                fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 5, top: 15),
        child: Text(S.current.username, style: const TextStyle(fontSize: 16)),
      ),
      TextFormField(
        initialValue: _getUsername(),
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        decoration: customInputDecoration(
            Icons.account_circle, S.current.please_input_username, false),
        validator: (val) {
          // ignore: prefer_is_empty
          return val?.length == 0 ? S.current.username_lengtherror : null;
        },
        onSaved: (val) {
          _data["username"] = val!;
        },
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 5),
        child: Text(
          S.current.password,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 15.0),
        child: TextFormField(
          initialValue: _getPassword(),
          maxLines: 1,
          obscureText: _passwordVisible,
          decoration: customInputDecoration(
              Icons.lock, S.current.please_input_password, true),
          validator: (val) {
            return val!.length <= 2 ? S.current.password_lengtherror : null;
          },
          onSaved: (val) {
            _data["password"] = val;
          },
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.only(left: 15, bottom: 15),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       InkWell(
      //           onTap: () {
      //             // getHttp();
      //           },
      //           child: const Text("忘记密码?",
      //               style: TextStyle(fontSize: 15, color: Colors.grey))),
      //       InkWell(
      //           onTap: () {
      //             Navigator.of(context).push(MaterialPageRoute(
      //                 builder: (context) => const RegisterPage()));
      //           },
      //           child: const Text("注册账号",
      //               style: TextStyle(fontSize: 15, color: Colors.grey)))
      //     ],
      //   ),
      // ),
      InkWell(
        onTap: _submit,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [Colors.blue, Colors.lime]),
            // boxShadow: const [
            //   BoxShadow(
            //       color: Colors.grey, blurRadius: 5.0, offset: Offset(2, 2))
            // ]
          ),
          child: Text(
            S.current.login,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      // Row(
      //   children: [
      //     const Text('Language'),
      //     TextButton(
      //       child: const Text('语言选择'),
      //       onPressed: () async {
      //         final result = await showDialog<Locale>(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return SimpleDialog(
      //               title: const Text('选择语言'),
      //               children: <Widget>[
      //                 SimpleDialogOption(
      //                   onPressed: () {
      //                     Navigator.pop(context, const Locale('zh', 'CN'));
      //                   },
      //                   child: const Text('中文'),
      //                 ),
      //                 SimpleDialogOption(
      //                   onPressed: () {
      //                     Navigator.pop(context, const Locale('en', 'US'));
      //                   },
      //                   child: const Text('English'),
      //                 ),
      //               ],
      //             );
      //           },
      //         );

      //         if (result != null) {
      //           setState(() {
      //             widget.onLocaleChange!(result);
      //           });
      //         }
      //       },
      //     ),
      //   ],
      // )
    ];
  }

  _submit() {
    FormState? fs = _formGK.currentState;
    if (fs!.validate()) {
      fs.save();
      Map<String, dynamic> pw = {};
      pw['username'] = _data["username"];
      pw['password'] = _data["password"];
      pw['isVerifyCode'] = false;
      // debugPrint(pw.toString());
      _login(pw);
    }
  }

  //登录
  _login(Map<String, dynamic> pw) async {
    GlobalStorage.clearUserInfo();
    SVProgressHUD.show();
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    debugPrint(pw.toString());
    var data = await LoginDao.login(pw);
    log(data.toString());
    if (data["code"] == 200) {
      Map result = data["data"];
      AppJPush.initialized(result["user"]['id'].toString(), context);
      GlobalStorage.saveToken(result["token"]);
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showSuccess(status: S.current.login_success);
      GlobalStorage.saveLoginInfo(result["user"]);
      GlobalStorage.saveUserPassWord(pw);
      if (result["user"]["userType"] == 1) {
        isOperator = false;
        List itemIds = result["user"]["itemIds"];
        GlobalStorage.saveSingleId(itemIds[0].toString());
        // var data = await LoginDao.getItemInfo();
        // int itemType = data['data'];
        var data = await LoginDao.getAppMenuTree();
        Map datakk = data['data'];
        List menuList = datakk['menuList'];
        String path = menuList[0]['path'];
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => IndexPage(path: path)),
            // ignore: unnecessary_null_comparison
            (route) => route == null);
      }
      if (result["user"]["userType"] == 2 ||
          result["user"]["userType"] == 11111) {
        isOperator = true;
        var data = await LoginDao.getProjectListUrl();
        if (data["code"] == 200) {
          if (data['data'] != null) {
            GlobalStorage.saveCompanyList(data['data']);
          } else {}
        }
        String path = '';
        var data1 = await LoginDao.getAppMenuTree();
        if (data1["code"] == 200) {
          Map pathdata = data1['data'];
          List menuList = pathdata['menuList'];
          path = menuList[0]['path'];
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => IndexPage(path: path)),
            // ignore: unnecessary_null_comparison
            (route) => route == null);
      }
      if (result["user"]["userType"] == 0) {
        // SVProgressHUD.showInfo(status: '敬请期待');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const OplIndexPage()),
            // ignore: unnecessary_null_comparison
            (route) => route == null);
      }
      if (result["user"]["userType"] == 4) {
        // SVProgressHUD.showInfo(status: '敬请期待');
        Map maintenanceRole = result["user"]["maintenanceRole"];
        if (maintenanceRole["id"] == 29 ||
            maintenanceRole["id"] == 31 ||
            maintenanceRole["id"] == 32) {
          isOperator = true;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => const OplIndexPage()),
              // ignore: unnecessary_null_comparison
              (route) => route == null);
        } else {
          isOperator = false;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => const OpIndexPage()),
              // ignore: unnecessary_null_comparison
              (route) => route == null);
        }
      }
    } else {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showError(status: data['msg']);
    }
  }

  InputDecoration customInputDecoration(
      IconData icon, String str, bool isShowPW) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: const Color.fromRGBO(247, 247, 249, 1),
      hintText: str,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      suffixIcon: isShowPW == true
          ? IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )
          : null,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(30),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(30),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(30),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
