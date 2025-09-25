import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenDimensions {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

class Screen {
  static double get width {
    return ScreenUtil().screenWidth;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  ///
  /// 状态栏高度
  ///
  static double get statusH {
    return ScreenUtil().statusBarHeight;
  }

  static double get totalH {
    return ScreenUtil().statusBarHeight + AppBar().preferredSize.height;
  }
}
