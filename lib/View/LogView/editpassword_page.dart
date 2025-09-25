// ignore_for_file: deprecated_member_use, prefer_is_empty, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:suncloudm/dao/daoX.dart';
import 'package:suncloudm/dao/storage.dart';
import 'package:suncloudm/generated/l10n.dart';

class EditPWPage extends StatefulWidget {
  const EditPWPage({super.key});

  @override
  State<EditPWPage> createState() => _EditPWPageState();
}

// 首先在 _EditPWPageState 类中添加三个布尔变量用于控制密码可见性
class _EditPWPageState extends State<EditPWPage> {
  final GlobalKey<FormState> _formPW = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  String fisrtPw = '';

  // 添加密码可见性控制变量
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          S.current.change_password,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22 // 增大标题字体大小
              ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // 添加阴影效果
        shadowColor: Colors.grey.withOpacity(0.2),
      ),
      body: Container(
        decoration: const BoxDecoration(
          // 添加背景渐变
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Form(
          key: _formPW,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 添加动画效果
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: '',
                  obscureText: !_isOldPasswordVisible, // 修改为取反变量
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.lock_clock, color: Colors.grey),
                    hintText: S.current.please_input_old_password,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    // 添加背景颜色
                    filled: true,
                    fillColor: Colors.white,
                    // 添加聚焦效果
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF24C18F), width: 2),
                    ),
                    // 添加显示/隐藏密码按钮
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (val) {
                    // ignore: prefer_is_empty
                    return val?.length == 0
                        ? S.current.old_password_cannot_be_empty
                        : null;
                  },
                  onSaved: (val) {
                    _data["oldPassWord"] = val!;
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: '',
                  obscureText: !_isNewPasswordVisible, // 修改为取反变量
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    hintText: S.current.please_input_new_password,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF24C18F), width: 2),
                    ),
                    // 添加显示/隐藏密码按钮
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (val) {
                    fisrtPw = val!;
                    return val.length == 0
                        ? S.current.new_password_cannot_be_empty
                        : null;
                  },
                  onSaved: (val) {
                    // _data["username"] = val!;
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: '',
                  obscureText: !_isConfirmPasswordVisible, // 修改为取反变量
                  maxLines: 1,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    hintText: S.current.please_input_confirm_password,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Color(0xFF24C18F), width: 2),
                    ),
                    // 添加显示/隐藏密码按钮
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (val) {
                    if (fisrtPw == val) {
                      return val?.length == 0
                          ? S.current.new_password_cannot_be_empty
                          : null;
                    } else {
                      return S.current.password_mismatch;
                    }
                  },
                  onSaved: (val) {
                    _data["newPassWord"] = val!;
                  },
                ),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () {
                  _submit();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xFF24C18F),
                    // 添加阴影效果
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF24C18F).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    S.current.confirm,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() async {
    FormState? fs = _formPW.currentState;
    if (fs!.validate()) {
      //通过后
      fs.save();
      Map<String, dynamic> pw = {};
      pw['password'] = _data["newPassWord"];
      pw['oldPassword'] = _data["oldPassWord"];
      var data = await LoginDao.changePassword(params: pw);
      debugPrint(_data.toString());
      if (data['code'] == 200) {
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showSuccess(status: '修改成功');
        GlobalStorage.clearUserInfo();
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/login",
          (route) => false,
        );
      } else {
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showError(status: data['msg']);
      }
    }
  }
}
