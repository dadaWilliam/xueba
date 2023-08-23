import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import 'dimensions.dart';

class AppConstants {
  static const APP_NAME = "学霸空间";
  static const DOMAIN_NAME = "xueba";

  static const int APP_VERSION = 1;
  static const String USER_ID = "0";
  static const String URL = "https://xueba.ca";
  static const String DEFAULTAVATAR = '/static/img/img_default_avatar.png';
  static const String CHANGEPROFILE = '/users/profile';
  static const String CHANGEPWD = '/users/change_password';
  static const String FEEDBACK = '/users/feedback';
  static const String VIDEO = '/video/detail';
  static const String SEARCH = '/video/search';
  static const String ARTICLE = '/article';
  static const String FILE = '/file';
  static const String CHECKQRCODE = '/users/check-qrcode';
  static const String AD = "/api/ad";
  static const String DELETEUSER = "/api/user-delete";

  static String Token = '';
}

class AppConfigs {
  var Subtitles = [
    Subtitle(
      index: 0,
      start: Duration.zero,
      end: const Duration(seconds: 10),
      text: TextSpan(
        children: [
          TextSpan(
            text: ' 学霸空间 ',
            style: TextStyle(color: Colors.green, fontSize: Dimensions.font20),
          ),
          TextSpan(
            text: ' 欢迎 ',
            style: TextStyle(color: Colors.blue, fontSize: Dimensions.font20),
          ),
          TextSpan(
            text: ' ${Get.find<UserController>().userInfo.username!} ',
            style: TextStyle(color: Colors.red, fontSize: Dimensions.font20),
          ),
        ],
      ),
    ),
    Subtitle(
      index: 0,
      start: const Duration(seconds: 10),
      end: const Duration(seconds: 20),
      text: TextSpan(
        children: [
          TextSpan(
            text: ' 学霸空间 ',
            style: TextStyle(color: Colors.green, fontSize: Dimensions.font20),
          ),
        ],
      ),
    ),
  ];
}

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(secondary: Colors.red),
    disabledColor: Colors.grey.shade400,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(secondary: Colors.red),
    disabledColor: Colors.grey.shade400,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
