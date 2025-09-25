import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dao/storage.dart';

class LanguageProvider with ChangeNotifier {
  // 初始化时获取系统语言，如果是中文就用中文，否则用英文
  Locale _currentLocale =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'zh'
          ? const Locale('zh', 'CN')
          : const Locale('en', 'US');

  LanguageProvider() {
    // 初始化时先加载保存的语言，如果没有保存的语言则使用系统语言
    loadSavedLanguage();
  }

  Locale get currentLocale => _currentLocale;

  // 从存储中加载保存的语言
  void loadSavedLanguage() {
    String? savedLanguage = GlobalStorage.getLanguage();
    if (savedLanguage != null) {
      if (savedLanguage == 'en') {
        _currentLocale = const Locale('en', 'US');
      } else {
        _currentLocale = const Locale('zh', 'CN');
      }
    } else {
      // 如果没有保存的语言，使用系统语言
      _currentLocale =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'zh'
              ? const Locale('zh', 'CN')
              : const Locale('en', 'US');
      GlobalStorage.saveLanguage(_currentLocale.languageCode);
    }
    notifyListeners();
  }

  // 切换语言
  void changeLanguage(Locale newLocale) {
    GlobalStorage.saveLanguage(newLocale.languageCode);
    _currentLocale = newLocale;
    notifyListeners();
  }

  // 获取当前语言代码
  String get currentLanguageCode => _currentLocale.languageCode;

  // 检查是否是英文
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // 检查是否是中文
  bool get isChinese => _currentLocale.languageCode == 'zh';
}

// 提供一个便捷的方法来获取语言Provider
LanguageProvider getLanguageProvider(BuildContext context) {
  return Provider.of<LanguageProvider>(context, listen: false);
}
