import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';

class AppJPush {
  static final JPushFlutterInterface jPush = JPush.newJPush();

  static Future<void> initialized(String id, BuildContext context) async {
    jPush.isNotificationEnabled().then((bool value) {
      print("通知授权是否打开: $value");
      if (!value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("没有通知权限,点击跳转打开通知设置界面"),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            textColor: Colors.blue[400],
            disabledTextColor: Colors.grey[400],
            onPressed: () {
              jPush.openSettingsForNotification();
            },
            label: "打开设置",
          ),
        ));
      }
    }).catchError((onError) {
      print("通知授权是否打开: ${onError.toString()}");
    });

    jPush.setup(
        //填写在极光官网 组册的 该应用的 **ios系统的** appKey
        appKey: 'ddd12015d27afbf08bfcd466',
        channel: 'theChannel',
        production: false,
        debug: true);
    //TODO 设置别名
    jPush.setAlias(id); //随便填的测试使用的

    /// 监听jPush
    jPush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jPush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print(message);
      },
      onOpenNotification: (Map<String, dynamic> message) async {},
    );
  }

  static void setBadge(int badge) {
    jPush.setBadge(badge);
  }
}
