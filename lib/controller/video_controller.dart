import 'package:flutter/widgets.dart';
import 'package:xueba/data/api/api_client.dart';
import 'package:xueba/data/repository/video_repo.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../models/video_model.dart';
import '../routes/route_helper.dart';
import 'auth_controller.dart';

class VideoController extends GetxController {
  final VideoRepo videoRepo;
  VideoController({required this.videoRepo});
  List<dynamic> _videoList = [];
  final List<dynamic> _popularVideoList = [];

  List<dynamic> get videoList => _videoList;
  List<dynamic> get popularVideoList => _popularVideoList;

  int page = 1;
  // ignore: non_constant_identifier_names
  int video_id = -1;

  int likes = 0;
  int collects = 0;

  bool isLoaded = false;
  bool ispopularOk = false;

  bool isUpdate = false;

  Future<Response> getVideoList() async {
    // if (isLoaded == true) {
    //   isLoaded = true;
    //   update();
    //   // update([
    //   //   'latest_list',
    //   // ]);
    // }

    // await Get.find<AuthController>().getUserToken();
    // var user_id = await Get.find<AuthController>().getUserId();
    // await Get.find<UserController>().getUserInfo(user_id);
    if (isUpdate == true) {
      //_videoList = [];
      // isLoaded = false;
      // update();
      if (page > 1) {
        _videoList = [];
        for (var i = 1; i <= page - 1; i++) {
          Response response = await videoRepo.getVideoList(i);
          _videoList.addAll((Video.fromJson(response.body).results)!.toList());
        }
      }
    }
    Response response = await videoRepo.getVideoList(page);
    if (response.statusCode == 200) {
      // ignore: prefer_interpolation_to_compose_strings
      debugPrint("ok in video " + page.toString());
      if (isUpdate == true) {
        _videoList.assignAll((Video.fromJson(response.body).results)!.toList());
      } else {
        _videoList.addAll((Video.fromJson(response.body).results)!.toList());
      }

      isLoaded = true;
      update();
      if (isUpdate == true) {
        isUpdate = false;
      } else {
        page++;
      }

      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      // showCustomSnacker("请重新登录!(error code:4)", title: "出错啦");
      return response;
    } else if (response.statusCode == 404) {
      showCustomGreenSnacker("已加载全部内容!", title: "注意");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in video");
      debugPrint(response.statusCode.toString());
      return response;
    }
  }

  Future<Response> updateVideo() async {
    //_isLoaded = false;
    // await Get.find<AuthController>().getUserToken();
    // var user_id = await Get.find<AuthController>().getUserId();
    // await Get.find<UserController>().getUserInfo(user_id);
    //print(video_id);
    Response response = await videoRepo.updateVideo(video_id);
    if (response.statusCode == 200) {
      debugPrint("ok in increase $video_id");
      update();
      // print(response.body.toString());
      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      showCustomSnacker("请重新登录!", title: "出错啦");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in video");
      debugPrint(response.statusCode.toString());
      debugPrint('Failed to the item: ${response.body}');
      return response;
    }
  }

  Future<Response> updateHistory() async {
    //_isLoaded = false;
    // await Get.find<AuthController>().getUserToken();
    // var user_id = await Get.find<AuthController>().getUserId();
    // await Get.find<UserController>().getUserInfo(user_id);
    //print(video_id);
    Response response = await videoRepo.updateHistory(video_id);
    if (response.statusCode == 200) {
      debugPrint("ok in history $video_id");
      update();
      // print(response.body.toString());
      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      showCustomSnacker("请重新登录!", title: "出错啦");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in history");
      debugPrint(response.statusCode.toString());
      return response;
    }
  }

  Future<Response> updateCollect() async {
    Response response = await videoRepo.updateCollect(video_id);
    if (response.statusCode == 200) {
      debugPrint("ok in update collect $video_id");
      collects = response.body["collects"] ?? 0;
      update();
      // print(response.body.toString());
      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      showCustomSnacker("请重新登录!", title: "出错啦");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in update collect");
      debugPrint(response.statusCode.toString());
      return response;
    }
  }

  Future<Response> updateLike() async {
    Response response = await videoRepo.updateLike(video_id);
    if (response.statusCode == 200) {
      debugPrint("ok in update like $video_id");
      likes = response.body["likes"];
      update();
      // print(response.body.toString());
      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      showCustomSnacker("请重新登录!", title: "出错啦");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in update like");
      debugPrint(response.statusCode.toString());
      return response;
    }
  }

  Future<Response> updateNotification(int code, int notice_id) async {
    Response response = await videoRepo.updateRead(code, notice_id);
    if (response.statusCode == 200) {
      if (response.body["code"] == 2000) {
        debugPrint("ok in update like $notice_id");
      }
      update();
      print(response.body.toString());
      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      showCustomSnacker("请重新登录!", title: "出错啦");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in update like");
      debugPrint(response.statusCode.toString());
      return response;
    }
  }

  Future<bool> isCollect() async {
    Response response = await videoRepo.isCollect(video_id);
    if (response.statusCode == 200) {
      debugPrint(response.body["code"].toString());
      if (response.body["code"] == 2002) {
        Get.find<AuthController>().clearSharedData();
        Get.offNamed(RouteHelper.getLogIn());
        return false;
      } else {
        debugPrint("ok in isCollect $video_id");
        collects = response.body["collects"] ?? 0;
        update();
        debugPrint(response.body.toString());
        if (response.body["user_collected"] == 1) {
          return false;
        }
        if (response.body["user_collected"] == 0) {
          return true;
        }
        return false;
      }
    } else if (response.statusCode == 403) {
      showCustomSnacker("请重新登录!", title: "出错啦");
      return false;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in isCollect");
      debugPrint(response.statusCode.toString());
      return false;
    }
  }

  Future<bool> isLike() async {
    Response response = await videoRepo.isLike(video_id);
    if (response.statusCode == 200) {
      debugPrint(response.body["code"].toString());
      if (response.body["code"] == 2002) {
        Get.find<AuthController>().clearSharedData();
        Get.offNamed(RouteHelper.getLogIn());
        return false;
      } else {
        debugPrint(response.body.toString());
        debugPrint("ok in isLike $video_id");
        likes = response.body["likes"];
        if (response.body["user_liked"] == 1) {
          return false;
        }
        if (response.body["user_liked"] == 0) {
          return true;
        }
        return false;
        // update();
      }
    } else if (response.statusCode == 403) {
      showCustomSnacker("请重新登录!", title: "出错啦");
      return false;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in isLike");
      debugPrint(response.statusCode.toString());
      return false;
    }
  }

  Future<Response> getPopularVideoList() async {
    // _popularVideoList = [];

    Response response = await videoRepo.getPopularVideoList();
    _popularVideoList
        .assignAll((Video.fromJson(response.body).results)!.toList());

    if (response.statusCode == 200) {
      // ignore: prefer_interpolation_to_compose_strings
      ispopularOk = true;
      debugPrint("ok in popular video ");

      update();

      return response;
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());

      // showCustomSnacker("请重新登录!(error code:4)", title: "出错啦");
      return response;
    } else if (response.statusCode == 404) {
      showCustomGreenSnacker("已加载全部内容!", title: "注意");
      return response;
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in popular video");
      debugPrint(response.statusCode.toString());
      return response;
    }
  }
}
