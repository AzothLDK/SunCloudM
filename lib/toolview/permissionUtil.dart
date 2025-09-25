import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

/// 权限工具类
class PermissionUtil {
  /// 申请摄像头权限
  static Future<bool> requestCameraPermission() async {
    await [
      Permission.camera,
    ].request();

    if (await Permission.camera.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  /// 申请存储权限
  static Future<bool> requestStoragePermission() async {
    await [
      Permission.photos,
      Permission.storage,
      Permission.photosAddOnly,
      Permission.camera,
    ].request();
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
