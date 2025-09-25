import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formGK = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  late bool _passwordVisible = true;
  late bool _confirmPasswordVisible = true;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/loginBg.png'), fit: BoxFit.fill)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 150,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logintext.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 120),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(
                        top: 20, left: 15, right: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Form(
                      key: _formGK,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: _buildContent(),
                      ),
                    )),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // 返回上一页，通常是登录页面
              },
            ),
          ),
        ],
      ),
    );
  }

  String? _tempPassword; // 新增临时变量

  List<Widget> _buildContent() {
    return <Widget>[
      const Align(
        alignment: Alignment.center,
        child: Text('账号注册',
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF24C18F),
                fontWeight: FontWeight.bold)),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15, bottom: 5, top: 15),
        child: Text('账号', style: TextStyle(fontSize: 16)),
      ),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        decoration: customInputDecoration(Icons.account_circle, '输入账号', false),
        validator: (val) {
          return val?.length == 0 ? "账号不能为空" : null;
        },
        onSaved: (val) {
          _data["username"] = val!;
        },
      ),
      const SizedBox(
        height: 15,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15, bottom: 5),
        child: Text(
          '密码',
          style: TextStyle(fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 15.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: _passwordVisible,
          decoration: customInputDecoration(Icons.lock, '输入密码', true),
          validator: (val) {
            if (val!.length <= 6) {
              return "密码长度必须大于6位";
            }
            return null;
          },
          onChanged: (val) {
            _tempPassword = val; // 实时保存密码到临时变量
          },
          onSaved: (val) {
            _data["password"] = val;
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 15, bottom: 5),
        child: Text(
          '确认密码',
          style: TextStyle(fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 15.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: _confirmPasswordVisible,
          decoration: customInputDecoration(Icons.lock, '再次输入密码', true),
          validator: (val) {
            if (val!.length <= 6) {
              return "密码长度必须大于6位";
            }
            if (val != _tempPassword) {
              return "两次输入的密码不一致";
            }
            return null;
          },
        ),
      ),
      InkWell(
        onTap: _submit,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient:
                  const LinearGradient(colors: [Colors.blue, Colors.lime]),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 5.0, offset: Offset(2, 2))
              ]),
          child: const Text(
            '注册',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    ];
  }

  _submit() {
    FormState? fs = _formGK.currentState;
    if (fs!.validate()) {
      fs.save();
      _register(_data);
    }
  }

  // 注册
  _register(Map<String, dynamic> data) async {
    SVProgressHUD.show();
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    debugPrint(data.toString());
    // 这里需要实现实际的注册接口调用
    // var response = await RegisterDao.register(data);
    // 模拟注册成功
    await Future.delayed(const Duration(seconds: 2));
    SVProgressHUD.dismiss();
    SVProgressHUD.setMinimumDismissTimeInterval(1.0);
    SVProgressHUD.showSuccess(status: '注册成功');
    // 注册成功后返回登录页面
    Navigator.of(context).pop();
  }

  InputDecoration customInputDecoration(
      IconData icon, String str, bool isShowPW) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: const Color.fromRGBO(247, 247, 249, 1),
      hintText: str,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      suffixIcon: isShowPW
          ? IconButton(
              icon: Icon(isShowPW
                  ? _passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off
                  : _confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                  _confirmPasswordVisible = !_confirmPasswordVisible;
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
