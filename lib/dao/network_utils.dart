import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

import 'dart:developer';
import '../dao/storage.dart';
import '../main.dart';

class NetworkUtils {
  static final BaseOptions options =
      BaseOptions(connectTimeout: const Duration(milliseconds: 5000));
  static final Dio _dio = Dio(options);

  static dynamic post(String url, {Map<String, dynamic>? params}) async {
    _dio.options.contentType = Headers.jsonContentType;
    debugPrint('此处的url--$url');
    String? token = GlobalStorage.getToken();
    debugPrint('此处的token--$token');
    try {
      var response = await _dio.post(url,
          queryParameters: params,
          data: params,
          options: Options(headers: {
            Headers.contentTypeHeader: "application/json",
            // "Accept-Language": "en-US",
            "token": token
          }));
      if (response.statusCode == 200) {
        if (response.data['code'] == 401) {
          SVProgressHUD.dismiss();
          SVProgressHUD.setMinimumDismissTimeInterval(1.0);
          SVProgressHUD.showInfo(status: 'token已过期,请重新登录');
          globalNavigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          return response.data;
        }
      } else {
        SVProgressHUD.dismiss();
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showInfo(status: '网络连接超时!');
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showInfo(status: '网络连接超时!');
      debugPrint(e.toString());
    }
    return null;
  }

  static dynamic postFile(String url, {FormData? formData}) async {
    _dio.options.contentType = Headers.jsonContentType;
    debugPrint('此处的url--$url');
    String? token = GlobalStorage.getToken();
    debugPrint('此处的token--$token');
    try {
      var response = await _dio.post(url,
          data: formData,
          options: Options(headers: {
            Headers.contentTypeHeader: "multipart/form-data",
            "Accept-Language": "en-US",
            "token": token
          }));
      if (response.statusCode == 200) {
        if (response.data['code'] == 401) {
          SVProgressHUD.dismiss();
          SVProgressHUD.setMinimumDismissTimeInterval(1.0);
          SVProgressHUD.showInfo(status: 'token已过期,请重新登录');
          globalNavigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          return response.data;
        }
      } else {
        SVProgressHUD.dismiss();
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showInfo(status: '网络连接超时!');
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showInfo(status: '网络连接超时!');
      debugPrint(e.toString());
    }
    return null;
  }

  static dynamic login(String url, {Map<String, dynamic>? params}) async {
    _dio.options.contentType = Headers.jsonContentType;
    try {
      var response = await _dio.post(url,
          queryParameters: params,
          data: params,
          options: Options(headers: {
            Headers.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        SVProgressHUD.dismiss();
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showInfo(status: '网络连接超时!');
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showInfo(status: '网络连接超时!');
      debugPrint(e.toString());
    }
    return null;
  }

  static get(String url, {Map<String, dynamic>? params}) async {
    try {
      _dio.options.contentType = Headers.jsonContentType;
      debugPrint('此处的url--$url');
      String? token = GlobalStorage.getToken();
      log('此处的token--$token');
      var response = await _dio.get(url,
          queryParameters: params, //拼接拼接拼接拼接拼
          options: Options(headers: {
            Headers.contentTypeHeader: "application/json",
            "token": token
          }));
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        if (response.data['code'] == 401) {
          SVProgressHUD.dismiss();
          SVProgressHUD.setMinimumDismissTimeInterval(1.0);
          SVProgressHUD.showInfo(status: 'token已过期,请重新登录');
          globalNavigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          return response.data;
        }
      } else {
        SVProgressHUD.dismiss();
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        // SVProgressHUD.showInfo(status: '网络连接超时!');
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      // SVProgressHUD.showInfo(status: '网络连接超时!');
      debugPrint('报错的url--$url');
      debugPrint(e.toString());
    }
  }

  static delete(String url, {Map<String, dynamic>? params}) async {
    try {
      _dio.options.contentType = Headers.jsonContentType;
      debugPrint('此处的url--$url');
      String? token = GlobalStorage.getToken();
      debugPrint('此处的token--$token');
      var response = await _dio.delete(url,
          data: params,
          queryParameters: params, //拼接拼接拼接拼接拼接拼接拼接拼接
          options: Options(headers: {
            Headers.contentTypeHeader: "application/json",
            "token": token
          }));
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        if (response.data['code'] == 401) {
          SVProgressHUD.dismiss();
          SVProgressHUD.setMinimumDismissTimeInterval(1.0);
          SVProgressHUD.showInfo(status: 'token已过期,请重新登录');
          globalNavigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          return response.data;
        }
      } else {
        SVProgressHUD.dismiss();
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showInfo(status: '网络连接超时!');
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showInfo(status: '网络连接超时!');
      debugPrint(e.toString());
    }
  }

  static put(String url, {Map<String, dynamic>? params}) async {
    try {
      _dio.options.contentType = Headers.jsonContentType;
      debugPrint('此处的url--$url');
      String? token = GlobalStorage.getToken();
      debugPrint('此处的token--$token');
      var response = await _dio.put(url,
          data: params,
          queryParameters: params, //拼接拼接拼接拼接拼接拼接拼接拼接
          options: Options(headers: {
            Headers.contentTypeHeader: "application/json",
            "token": token
          }));
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        return response.data;
      } else {
        SVProgressHUD.dismiss();
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
        SVProgressHUD.showInfo(status: '网络连接超时!');
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.setMinimumDismissTimeInterval(1.0);
      SVProgressHUD.showInfo(status: '网络连接超时!');
      debugPrint(e.toString());
    }
  }

  //1、通过静态方法 getInstance() 访问实例—————— getInstance() 构造、获取、返回实例
  /*通过工厂方法获取该类的实例，将实例对象按对应的方法返回出去
   *实例不存在时，调用命名构造方法获取一个新的实例 */
  static NetworkUtils getInstance() {
    _instance ??= NetworkUtils._internal();
    return _instance!;
  }

  //2、静态属性——该类的实例
  static NetworkUtils? _instance = NetworkUtils._internal();

  NetworkUtils._internal() {
    //4.2、设置BaseOptions
    BaseOptions baseOptions = BaseOptions(
      //连接超时
      connectTimeout: const Duration(milliseconds: 5000),
      //接收超时
      receiveTimeout: const Duration(milliseconds: 5000),
    );
    //4.3 初始化dio实例
    _dio != Dio(baseOptions);
  }
}
