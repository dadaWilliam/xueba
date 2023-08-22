import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import 'package:xueba/controller/auth_controller.dart';
import 'package:xueba/controller/classification_controller.dart';
import 'package:xueba/controller/user_controller.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:xueba/utils/app_constants.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base/show_custom_message.dart';
import '../../controller/index_show_video_controller.dart';
import '../../controller/video_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final Uri _url = Uri.parse('${AppConstants.URL}/download');
Future<void> _launchUrl() async {
  try {
    await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  var stop = false;

  Future _loadResource() async {
    Response response = await Get.find<AuthController>().check();
    if (response.statusCode == 200) {
      if (response.body["code"] == 200) {
        if (Get.find<AuthController>().userLoggedIn()) {
          Get.find<AuthController>().getUserToken();
          var userId = Get.find<AuthController>().getUserId();
          await Get.find<UserController>().getUserInfo(userId);
          await Get.find<UserController>().getNotice();

          await Get.find<IndexShowVideoController>().getIndexShowVideoList();
          await Get.find<VideoController>().getVideoList();
          await Get.find<ClassificationController>().getClassificationList();
          // print(Get.find<AuthController>().userLoggedIn());
        }
      } else if (response.body["code"] == 403) {
        stop = true;
        AwesomeDialog(
          width: Dimensions.width45 * 10,
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          title: '出错啦',
          desc: '软件内部已被修改！',
        ).show();
      } else if (response.body["code"] == 500) {
        stop = true;
        AwesomeDialog(
          width: Dimensions.width45 * 10,
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          title: '请注意',
          desc: '系统维护中，暂无法使用！',
        ).show();
      } else if (response.body["code"] == 400) {
        if (Get.find<AuthController>().userLoggedIn()) {
          Get.find<AuthController>().getUserToken();
          var userId = Get.find<AuthController>().getUserId();
          await Get.find<UserController>().getUserInfo(userId);
          await Get.find<UserController>().getNotice();

          await Get.find<IndexShowVideoController>().getIndexShowVideoList();
          await Get.find<VideoController>().getVideoList();
          await Get.find<ClassificationController>().getClassificationList();
          // print(Get.find<AuthController>().userLoggedIn());
        }
        if (response.body["force"] == false) {
          stop = true;
          var desc = response.body["desc"].replaceAll('*', '\n');
          // debugPrint(desc);
          AwesomeDialog(
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.infoReverse,
            animType: AnimType.scale,
            dismissOnTouchOutside: false,
            btnOkText: Theme.of(context).platform == TargetPlatform.android
                ? '前往 官网 下载'
                : '前往 APP Store',
            btnCancelText: '稍后下载',
            btnOkOnPress: () async {
              Theme.of(context).platform == TargetPlatform.android
                  ? _launchUrl()
                  : null; // TODO
              if (Get.find<AuthController>().userLoggedIn()) {
                // _loadResource();
                Get.offNamed(RouteHelper.getInitial());
              } else {
                // print(Get.find<AuthController>().userLoggedIn());
                Get.offNamed(RouteHelper.getLogIn());
              }
            },
            btnCancelColor: Colors.blue,
            btnCancelOnPress: () {
              if (Get.find<AuthController>().userLoggedIn()) {
                // _loadResource();
                Get.offNamed(RouteHelper.getInitial());
              } else {
                // print(Get.find<AuthController>().userLoggedIn());
                Get.offNamed(RouteHelper.getLogIn());
              }
            },
            // desc: "$desc\n\n更新于 ${response.body["time"].split('T')[0]}",
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: InkWell(
                  onTap: () => _launchUrl(),
                  child: BigText(
                    text: '新版本发布',
                    size: Dimensions.font18,
                  ),
                )),
                SizedBox(
                  height: Dimensions.height10,
                ),
                BigText(
                    text: "$desc\n\n更新于 ${response.body["time"].split('T')[0]}",
                    size: Dimensions.font15)
              ],
            ),
          ).show();
        } else {
          stop = true;
          var desc = response.body["desc"].replaceAll('*', '\n');
          // debugPrint(desc);

          AwesomeDialog(
            context: context,
            width: Dimensions.width45 * 10,
            dialogType: DialogType.infoReverse,
            animType: AnimType.scale,
            dismissOnTouchOutside: false,
            btnOkText: Theme.of(context).platform == TargetPlatform.android
                ? '前往 官网 下载'
                : '前往 APP Store',
            btnOkColor: Colors.red,
            btnOkOnPress: () {
              Theme.of(context).platform == TargetPlatform.android
                  ? _launchUrl()
                  : null; // TODO
            },
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: BigText(
                    text: '新版本 强制更新',
                    size: Dimensions.font18,
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                BigText(
                    text: "$desc\n\n更新于 ${response.body["time"].split('T')[0]}",
                    size: Dimensions.font15)
              ],
            ),
          ).show();
        }
      } else {
        showCustomSnacker("请稍后再试!", title: "出错啦");
      }
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      showCustomSnacker("请重新登录!", title: "出错啦");
    } else {
      stop = true;
      // showCustomSnacker("请检查网络连接!", title: "出错啦");
      // ignore: use_build_context_synchronously
      AwesomeDialog(
          width: Dimensions.width45 * 10,
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          title: '请注意',
          desc: '请检查网络连接！请关闭APP再次尝试',
          btnOkText: '我知道了',
          btnOkColor: Colors.red,
          btnOkOnPress: () {
            Restart.restartApp();
          }).show();
      debugPrint(response.statusCode.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_loadResource();
    Dimensions.height = Get.context!.height;
    Dimensions.screenWidth = Get.context!.width;

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    _loadResource().then((value) {
      if (stop == true) {
        stop = false;
      } else {
        if (Get.find<AuthController>().userLoggedIn()) {
          // _loadResource();
          Get.offNamed(RouteHelper.getInitial());
        } else {
          // print(Get.find<AuthController>().userLoggedIn());
          Get.offNamed(RouteHelper.getLogIn());
        }
      }
    });
    Timer(const Duration(seconds: 3), () {
      // debugPrint(stop.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose(); // instead of your controller.dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ScaleTransition(
          scale: animation,
          child: Center(
              child: Image.asset(
            'assets/image/logo.png',
            width: Dimensions.width10 * 10,
          )),
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        Center(
          child: BigText(
            text: "学霸空间",
            color: AppColors.mainColor,
            size: Dimensions.font30,
          ),
        ),
      ]),
    );
  }
}
