import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:xueba/models/history.dart';
import 'package:xueba/models/notice.dart';
import 'package:xueba/models/user_info.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../data/repository/user_repo.dart';

import '../models/notification.dart';
import '../models/video_model.dart';
import 'auth_controller.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  late UserInfo _userInfo;
  UserController({
    required this.userRepo,
  });

  List<dynamic> _historyList = [];
  // List<Video_History> _historyDetailList = [];
  List<dynamic> _likedList = [];
  List<dynamic> _collectedList = [];
  List<dynamic> _noticeList = [];
  List<dynamic> _notificationList = [];
  // List<dynamic> _notificationList1 = [];
  String _notice = '';
  String _notice2 = '';

  List<dynamic> get historyList => _historyList;
  // List<dynamic> get historyDetailList => _historyDetailList;

  List<dynamic> get likedList => _likedList;
  List<dynamic> get collectedList => _collectedList;
  List<dynamic> get noiticeList => _noticeList;
  List<dynamic> get notificationList => _notificationList;
  // List<dynamic> get notificationList1 => _notificationList1;
  String get notice => _notice;
  String get notice2 => _notice2;

  int historyPage = 1;
  int likedPage = 1;
  int collectedPage = 1;
  int noticePage = 1;
  int notificationPage = 1;
  // int notificationPage1 = 1;

  bool _isLoading = false;
  bool _isHistoryLoaded = false;
  bool _isLikedLoaded = false;
  bool _isCollectedLoaded = false;
  bool _isNoticeLoaded = false;
  bool _isNotificationLoaded = false;

  bool isNoticeUpdate = false;
  bool isCollectedUpdate = false;
  bool isLikedUpdate = false;
  bool isHistoryUpdate = false;
  bool isNotificationUpdate = false;

  bool get isLoading => _isLoading;
  bool get isHistoryLoaded => _isHistoryLoaded;
  bool get isLikedLoaded => _isLikedLoaded;
  bool get isCollectedLoaded => _isCollectedLoaded;
  bool get isNoticeLoaded => _isNoticeLoaded;
  bool get isNotificationLoaded => _isNotificationLoaded;
  UserInfo get userInfo => _userInfo;

  Future getUserInfo(int id) async {
    _isLoading = true;
    Response response = await userRepo.getUserInfo(id);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      _userInfo = UserInfo.fromJson(response.body);
      await Get.find<AuthController>().saveUserName('${_userInfo.username}');
      // showCustomGreenSnacker("登录成功！", title: "通知");
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      showCustomSnacker("请重新登录! userinfo error", title: "出错啦");
    } else {
      debugPrint(response.statusCode.toString());
    }
  }

  Future getHistory() async {
    if (isHistoryUpdate == true) {
      _historyList = [];
      historyPage = 1;
      isHistoryUpdate = false;
      _isHistoryLoaded = false;
    }

    Response response = await userRepo.getHistory(
        Get.find<AuthController>().getUserId(), historyPage);

    if (response.statusCode == 200) {
      _isHistoryLoaded = true;
      // print(response.body.results);
      _historyList
          .addAll((HistoryList.fromJson(response.body).results)!.toList());

      // print(_historyList.first.video[0].title);
      // _historyDetailList
      //     .addAll((HistoryList.fromJson(response.body).results)!.toList());
      // _historyDetailList
      //     .addAll(HistoryList.fromJson(response.body).results)!.toList());
      // for (var e in _historyList) {
      //   _historyDetailList.assign(e.video);
      //   // print(e.video.title);
      // }
      // print(_historyDetailList.first.title);

      historyPage++;
      update();
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      //showCustomSnacker("请重新登录!", title: "出错啦");
    } else if (response.statusCode == 404) {
      showCustomGreenSnacker("已加载全部内容!", title: "注意");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint(response.statusCode.toString());
    }
  }

  Future getLiked() async {
    if (isLikedUpdate == true) {
      _likedList = [];
      likedPage = 1;
      isLikedUpdate = false;
      _isLikedLoaded = false;
    }

    Response response = await userRepo.getLikedVideo(likedPage);

    if (response.statusCode == 200) {
      _isLikedLoaded = true;
      // print(response.body);
      _likedList.addAll((Video.fromJson(response.body).results)!.toList());

      likedPage++;
      update();
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      //showCustomSnacker("请重新登录!", title: "出错啦");
    } else if (response.statusCode == 404) {
      showCustomGreenSnacker("已加载全部内容!", title: "注意");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint(response.statusCode.toString());
    }
  }

  Future getCollected() async {
    if (isCollectedUpdate == true) {
      _collectedList = [];
      collectedPage = 1;
      isCollectedUpdate = false;
      _isCollectedLoaded = false;
    }

    Response response = await userRepo.getCollectedVideo(collectedPage);

    if (response.statusCode == 200) {
      _isCollectedLoaded = true;

      _collectedList.addAll((Video.fromJson(response.body).results)!.toList());

      collectedPage++;
      update();
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      //showCustomSnacker("请重新登录!", title: "出错啦");
    } else if (response.statusCode == 404) {
      showCustomGreenSnacker("已加载全部内容!", title: "注意");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint(response.statusCode.toString());
    }
  }

  Future getNotification(int code) async {
    if (isNotificationUpdate == true) {
      _notificationList = [];
      // _notificationList1 = [];
      notificationPage = 1;
      // notificationPage1 = 1;
      isNotificationUpdate = false;
      _isNotificationLoaded = false;
    }

    Response response = await userRepo.getNotificationList(
        code, notificationPage); //0 unread 1 read
    // Response response1 =
    //     await userRepo.getNotificationList(1, notificationPage1); //read

    if (response.statusCode == 200) {
      _isNotificationLoaded = true;

      _notificationList
          .addAll((NotificationList.fromJson(response.body).results)!.toList());
      // _notificationList1.addAll(
      //     (NotificationList.fromJson(response1.body).results)!.toList());

      notificationPage++;
      // notificationPage1++;
      update();
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      //showCustomSnacker("请重新登录!", title: "出错啦");
    } else if (response.statusCode == 404) {
      print(response.body.toString());

      showCustomGreenSnacker("已加载全部内容!", title: "注意");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint(response.statusCode.toString());
    }
  }

  // Future getNoticeList() async {
  //   if (isNoticeUpdate == true) {
  //     _noticeList = [];
  //     noticePage = 1;
  //     isNoticeUpdate = false;
  //     _isNoticeLoaded = false;
  //   }

  //   Response response = await userRepo.getNoticeList(
  //       0, Get.find<AuthController>().getUserId(), noticePage);

  //   if (response.statusCode == 200) {
  //     _isNoticeLoaded = true;
  //     _noticeList
  //         .addAll((NoticeList.fromJson(response.body).results)!.toList());

  //     noticePage++;
  //     update();
  //   } else if (response.statusCode == 403) {
  //     Get.find<AuthController>().clearSharedData();
  //     Get.offNamed(RouteHelper.getLogIn());
  //     //showCustomSnacker("请重新登录!", title: "出错啦");
  //   } else if (response.statusCode == 404) {
  //     showCustomGreenSnacker("已加载全部内容!", title: "注意");
  //   } else {
  //     showCustomSnacker("请检查网络连接!", title: "出错啦");
  //     debugPrint(response.statusCode.toString());
  //   }
  // }

  Future getNotice() async {
    Response response = await userRepo.getNotice();

    if (response.statusCode == 200) {
      _notice = response.body['tip'].toString().replaceAll('<br>', '  ');
      _notice2 = _notice;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      //showCustomSnacker("请重新登录!", title: "出错啦");
    } else if (response.statusCode == 404) {
      showCustomGreenSnacker("已加载全部内容!", title: "注意");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint(response.statusCode.toString());
    }
  }
}
