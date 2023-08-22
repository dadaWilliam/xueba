import 'package:flutter/material.dart';
import 'package:xueba/data/repository/auth_repo.dart';
import 'package:xueba/models/sign_in_body.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({
    required this.authRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future login(SignInBody signInBody) async {
    _isLoading = true;

    Response response = await authRepo.login(signInBody);
    _isLoading = false;
    //print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body["code"] == 1000) {
        await authRepo.saveUserToken(response.body["token"]);
        await authRepo.saveUserID(response.body["user"]);
        // showCustomGreenSnacker("登录成功！", title: "通知");
        update();
        debugPrint(response.body["token"]);
      } else if (response.body["code"] == 1001) {
        // AwesomeDialog(
        //   context: context,
        //   dialogType: DialogType.error,
        //   animType: AnimType.scale,
        //   title: '出错啦',
        //   desc: '密码长度有误，请检查后重试!',
        //   btnOkText: '我知道了',
        //   btnOkOnPress: () {},
        // ).show();
        showCustomSnacker("密码或用户名错误!", title: "出错啦");
      } else if (response.body["code"] == 1002) {
        showCustomSnacker("用户过期啦! 请联系管理员！", title: "出错啦");
      } else {
        showCustomSnacker("请稍后再试!", title: "出错啦");
      }
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      showCustomSnacker("请重新登录!", title: "出错啦");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint(response.statusCode.toString());
    }
  }

  Future check() async {
    Response response = await authRepo.check();
    return response;
  }

  Future saveUserUsed() async {
    await authRepo.saveUserUsed();
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool userUsed() {
    return authRepo.userUsed();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  int getUserId() {
    return authRepo.getUserId();
  }

  String getUserName() {
    return authRepo.getUserName();
  }

  Future saveUserName(String name) async {
    return await authRepo.saveUserName(name);
  }
}
