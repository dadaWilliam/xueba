import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:xueba/base/show_custom_message.dart';
import 'package:xueba/controller/auth_controller.dart';
import 'package:xueba/controller/user_controller.dart';
import 'package:xueba/utils/app_constants.dart';

import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/account_widget.dart';
import 'package:xueba/widgets/app_icon.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _userId = -1;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  // InAppWebViewSettings settings = InAppWebViewSettings(
  //     useShouldOverrideUrlLoading: true,
  //     mediaPlaybackRequiresUserGesture: false,
  //     allowsInlineMediaPlayback: true,
  //     iframeAllow: "camera; microphone",
  //     iframeAllowFullscreen: true);
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  String Token = '';
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _getUser();
    _getToken();
  }

  // 获取数据
  _getUser() {
    _userId = Get.find<AuthController>().getUserId();
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      Get.find<UserController>().getUserInfo(_userId);
    }
    //print(_userId);
    //setState(() {});
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print("Token");
    // print(Token.isEmpty);
    //setState(() {});
  }

  @override
  void dispose() {
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
      // backgroundColor: Theme.of(context).brightness == Brightness.dark
      //     ? Color(0x303030)
      //     : Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.mainColor,
          title: BigText(
            text: "个人信息",
            size: Dimensions.font20,
            color: Colors.white,
          )),
      body: GetBuilder<UserController>(builder: (user) {
        return SizedBox(
          width: double.maxFinite,
          // margin: EdgeInsets.only(top: Dimensions.height20),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.height20,
                    ),

                    // AppIcon(
                    //     icon: Icons.supervisor_account_rounded,
                    //     backgroundColor: AppColors.mainColor,
                    //     iconColor: Colors.white,
                    //     size: Dimensions.iconSize24 * 5,
                    //     iconSize: Dimensions.iconSize24 * 3,
                    //   )
                    // :
                    GestureDetector(
                      onTap: (() {
                        showCustomSnacker("点击修改按钮 进行修改!", title: "学霸空间");
                      }),
                      child: CachedNetworkImage(
                          width: Dimensions.iconSize24 * 5,
                          height: Dimensions.iconSize24 * 5,
                          imageUrl: user.userInfo.avatar == null
                              ? AppConstants.URL + AppConstants.DEFAULTAVATAR
                              : '${user.userInfo.avatar}/?tk=$Token',
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    // colorFilter: ColorFilter.mode(
                                    //     Colors.red, BlendMode.colorBurn)
                                  ),
                                ),
                              ),
                          placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              ),
                          errorWidget: (context, url, error) => Column(
                                children: [
                                  SizedBox(
                                    height: Dimensions.height20,
                                  ),
                                  Icon(
                                    Icons.error,
                                    size: Dimensions.iconSize24 * 2,
                                  ),
                                  BigText(text: '出错啦')
                                ],
                              )),
                    ),

                    // Container(
                    //     //image

                    //     decoration: BoxDecoration(
                    //         borderRadius:
                    //             BorderRadius.circular(Dimensions.radius20),
                    //         image: DecorationImage(
                    //             opacity: Theme.of(context).brightness ==
                    //                     Brightness.dark
                    //                 ? 0.9
                    //                 : 1,
                    //             fit: BoxFit.cover,
                    //             image: CachedNetworkImage(
                    //                  imageUrl: user.userInfo.avatar.toString(),))),
                    //   ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),

                    // username
                    GestureDetector(
                      onTap: (() {
                        showCustomSnacker("点击修改按钮 进行修改!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.person_rounded,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: user.userInfo.username!,
                            size: Dimensions.font18,
                          )),
                    ),

                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // tele mobile
                    GestureDetector(
                      onTap: (() {
                        showCustomSnacker("点击修改按钮 进行修改!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.phone_android_rounded,
                            backgroundColor: Colors.redAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: user.userInfo.mobile == null ||
                                    user.userInfo.mobile.toString().isEmpty
                                ? "暂无"
                                : user.userInfo.mobile.toString(),
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // email
                    GestureDetector(
                      onTap: (() {
                        showCustomSnacker("点击修改按钮 进行修改!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.email_rounded,
                            backgroundColor: AppColors.yellowColor,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: user.userInfo.email == null ||
                                    user.userInfo.email.toString().isEmpty
                                ? "暂无"
                                : user.userInfo.email.toString(),
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // expire
                    GestureDetector(
                      onTap: (() {
                        showCustomSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.access_time_rounded,
                            backgroundColor: Colors.blueAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: (user.userInfo.expire == null) ||
                                    user.userInfo.expire.toString().isEmpty
                                ? "永久有效"
                                : "有效至: ${user.userInfo.expire.toString().split('T')[0]}",
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // vip
                    GestureDetector(
                      onTap: (() {
                        showCustomSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.celebration_rounded,
                            backgroundColor: Colors.pinkAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text:
                                (user.userInfo.vip == true) ? "VIP 用户" : "普通用户",
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // change
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getwebPage(
                            '${AppConstants.CHANGEPROFILE}/${Get.find<AuthController>().getUserId()}',
                            '修改个人信息'));
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.border_color_rounded,
                            backgroundColor: Colors.deepPurpleAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '修改个人信息',
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // pwd
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getwebPage(
                            AppConstants.CHANGEPWD, '修改密码'));
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.pin_rounded,
                            backgroundColor: Colors.lightBlueAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '修改密码',
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // pwd
                    Platform.isIOS
                        ? GestureDetector(
                            onTap: (() {
                              AwesomeDialog(
                                width: Dimensions.width45 * 10,
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.scale,
                                title: '注意⚠️',
                                desc: '删除账户操作不可逆，是否确定删除',
                                btnOkText: '确定',
                                btnCancelText: '取消',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  await http.get(Uri.parse(
                                      '${AppConstants.URL}${AppConstants.DELETEUSER}/?tk=$Token'));
                                  Get.find<AuthController>().clearSharedData();
                                  Get.offAllNamed(RouteHelper.getLogIn());
                                },
                              ).show();
                              // Get.toNamed(RouteHelper.getwebPage(
                              //     AppConstants.CHANGEPWD, '修改密码'));
                            }),
                            child: AccountWidgt(
                                appIcon: AppIcon(
                                  icon: Icons.person_off_rounded,
                                  backgroundColor: Colors.lightGreen,
                                  iconColor: Colors.white,
                                  size: Dimensions.iconSize24 * 2,
                                  iconSize: Dimensions.iconSize24,
                                ),
                                bigText: BigText(
                                  text: '删除账户',
                                  size: Dimensions.font18,
                                )),
                          )
                        : Container(),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      }),
    );
  }
}
