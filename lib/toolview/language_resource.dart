import 'package:suncloudm/dao/storage.dart';

/// 语言资源工具类，用于根据当前语言获取对应的资源路径
class LanguageResource {
  /// 根据当前语言获取图片资源路径
  /// [basePath] 是基础图片路径，不包含语言后缀和扩展名
  /// [extension] 是图片扩展名，默认为 'png'
  static String getImagePath(String basePath, {String extension = 'png'}) {
    String language = GlobalStorage.getLanguage() ?? 'zh_CN';
    // 英文环境下返回带_en后缀的图片
    if (language.toLowerCase() == 'en' || language.toLowerCase() == 'en_us') {
      return '$basePath\_en.$extension';
    }
    // 默认返回中文图片
    return '$basePath.$extension';
  }
}