import 'package:flutter/material.dart';
import 'language_provider.dart';

/// 语言切换工具类，提供便捷的语言切换方法
class LanguageSwitcher {
  /// 显示语言选择对话框
  static Future<void> showLanguageSelectionDialog(BuildContext context) async {
    final result = await showDialog<Locale>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('选择语言 / Select Language'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, const Locale('zh', 'CN'));
              },
              child: const Text('中文'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, const Locale('en', 'US'));
              },
              child: const Text('English'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      // 切换语言
      final languageProvider = getLanguageProvider(context);
      languageProvider.changeLanguage(result);
    }
  }

  /// 创建语言切换按钮
  static Widget buildLanguageSwitchButton(BuildContext context) {
    return TextButton(
      child: Text(
        getLanguageProvider(context).isEnglish ? '中文' : 'English',
      ),
      onPressed: () {
        showLanguageSelectionDialog(context);
      },
    );
  }
}