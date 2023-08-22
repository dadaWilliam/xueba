import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:xueba/models/sign_in_body.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/classification_controller.dart';
import '../../controller/index_show_video_controller.dart';
import '../../controller/user_controller.dart';
import '../../controller/video_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/safe_verify.dart';

class VerifyPage extends StatefulWidget {
  final String? user;
  final String? pwd;
  const VerifyPage({Key? key, this.user, this.pwd}) : super(key: key);
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool success = false;
  var times = 0;
  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });

    /// 禁用侧滑
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return true;
        } else {
          return true;
        }
      },
      child: Scaffold(
        // appBar: AppBar(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: Dimensions.height45 * 2),
              BigText(text: '安全验证', size: Dimensions.font30),
              const SizedBox(height: 20),
              const Text('为了你的账号安全，本次登录需要进行验证'),
              const Text('请将下方的图标移动到圆形区域内'),
              const SizedBox(height: 20),
              // Text('共3次机会,已失败$times次'),
              const SizedBox(height: 20),
              Expanded(
                child: DemoVerity(lister: (state) async {
                  debugPrint('longer   返回状态>>> $state');
                  // await Get.find<VideoController>().getVideoList();
                  // await Get.find<IndexShowVideoController>()
                  //     .getIndexShowVideoList();
                  // var user_id = await Get.find<AuthController>().getUserId();
                  // await Get.find<UserController>().getUserInfo(user_id);
                  if (state) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.scale,
                      title: '通知',
                      desc: '验证成功!',
                      btnOkText: '我知道了',
                      btnOkOnPress: () async {
                        debugPrint(widget.user);
                        debugPrint(widget.pwd);
                        AwesomeDialog(
                          width: Dimensions.screenWidth * 0.5,
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.scale,
                          dismissOnTouchOutside: false,
                          body: Column(
                            children: [
                              SizedBox(
                                height: Dimensions.height15,
                              ),
                              const CircularProgressIndicator(
                                  strokeWidth: 5.0, color: AppColors.mainColor),
                              SizedBox(
                                height: Dimensions.height30,
                              ),
                              BigText(
                                text: '登录中...',
                                size: Dimensions.font15,
                              ),
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                            ],
                          ),
                        ).show();

                        SignInBody signInBody = SignInBody(
                            username: widget.user!, pwd: widget.pwd!);
                        var authController = Get.find<AuthController>();
                        await authController
                            .login(signInBody)
                            .then((value) async {
                          if (authController.userLoggedIn()) {
                            //showCustomGreenSnacker("登录成功！", title: "通知");
                            var userId = Get.find<AuthController>().getUserId();
                            await Get.find<UserController>()
                                .getUserInfo(userId);
                            await Get.find<UserController>().getNotice();
                            Get.find<VideoController>().isUpdate = true;
                            Get.find<VideoController>().page = 1;
                            await Get.find<VideoController>().getVideoList();

                            await Get.find<IndexShowVideoController>()
                                .getIndexShowVideoList();
                            await Get.find<ClassificationController>()
                                .getClassificationList();

                            await Get.offAllNamed(RouteHelper.getInitial());

                            // Get.offNamed(RouteHelper.getInitial());
                          } else {
                            await Get.offNamed(RouteHelper.getLogIn());
                          }
                        });
                        //
                      },
                    ).show();
                  } else {
                    times++;
                    debugPrint(times.toString());
                    //print(times);
                    if (times >= 3) {
                      times = 1;
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        title: '通知',
                        desc: '验证失败! 请重试!',
                        btnCancelText: '退出',
                        //btnOkText: '重试',
                        //btnOkOnPress: () {},
                        btnCancelOnPress: () {
                          Get.offNamed(RouteHelper.getLogIn());
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        title: '通知',
                        desc: '验证失败! 请重试!\n 剩余 ${3 - times} 次尝试',
                        btnCancelText: '退出',
                        btnOkText: '重试',
                        btnOkOnPress: () {},
                        btnCancelOnPress: () {
                          Get.offNamed(RouteHelper.getLogIn());
                        },
                      ).show();
                      //showCustomNoticeQuickSnacker("未能通过验证，请重试！", title: "很抱歉");
                    }
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
