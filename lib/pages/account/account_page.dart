import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';

import 'package:xueba/controller/auth_controller.dart';
import 'package:xueba/controller/user_controller.dart';

import 'package:xueba/routes/route_helper.dart';
import 'package:xueba/utils/app_constants.dart';
import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/account_widget.dart';
import 'package:xueba/widgets/app_icon.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _userId = -1;
  String Token = '';

  @override
  void initState() {
    super.initState();

    _getUser();
    // _getHistory();
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
    // setState(() {});
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print("Token");
    // print(Token.isEmpty);
    //setState(() {});
  }

  _getHistory() async {
    Get.find<UserController>().isHistoryUpdate = true;
    await Get.find<UserController>().getHistory();
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0x00303030)
          : Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.mainColor,
          title: Center(
            child: BigText(
              text: "个人中心",
              size: Dimensions.font20,
              color: Colors.white,
            ),
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
                    // SizedBox(
                    //   height: Dimensions.height20,
                    // ),
                    // AppIcon(
                    //   icon: Icons.supervisor_account_rounded,
                    //   backgroundColor: AppColors.mainColor,
                    //   iconColor: Colors.white,
                    //   size: Dimensions.iconSize24 * 5,
                    //   iconSize: Dimensions.iconSize24 * 3,
                    // ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    Get.find<UserController>().userInfo.isSuperuser == true
                        ? GestureDetector(
                            onTap: (() {
                              Get.toNamed(RouteHelper.getadminPage());
                              // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                            }),
                            child: AccountWidgt(
                                appIcon: AppIcon(
                                  icon: Icons.build_rounded,
                                  backgroundColor: Colors.teal,
                                  iconColor: Colors.white,
                                  size: Dimensions.iconSize24 * 2,
                                  iconSize: Dimensions.iconSize24,
                                ),
                                bigText: BigText(
                                  text: '后台管理',
                                  size: Dimensions.font18,
                                )),
                          )
                        : Container(),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getwebPage('', '学霸空间'));
                        // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.web,
                            backgroundColor: Colors.green,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '官方网站',
                            size: Dimensions.font18,
                          )),
                    ),
                    // SizedBox(
                    //   height: Dimensions.height10,
                    // ),
                    // GestureDetector(
                    //   onTap: (() {
                    //     Get.toNamed(RouteHelper.getADPage());
                    //     // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                    //   }),
                    //   child: AccountWidgt(
                    //       appIcon: AppIcon(
                    //         icon: Icons.card_giftcard_rounded,
                    //         backgroundColor: Colors.deepOrangeAccent,
                    //         iconColor: Colors.white,
                    //         size: Dimensions.iconSize24 * 2,
                    //         iconSize: Dimensions.iconSize24,
                    //       ),
                    //       bigText: BigText(
                    //         text: '福利中心',
                    //         size: Dimensions.font18,
                    //       )),
                    // ),
                    // GestureDetector(
                    //   onTap: (() {
                    //     Get.toNamed(RouteHelper.getadminPage());
                    //     // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                    //   }),
                    //   child: AccountWidgt(
                    //       appIcon: AppIcon(
                    //         icon: Icons.build_rounded,
                    //         backgroundColor: Colors.teal,
                    //         iconColor: Colors.white,
                    //         size: Dimensions.iconSize24 * 2,
                    //         iconSize: Dimensions.iconSize24,
                    //       ),
                    //       bigText: BigText(
                    //         text: '后台管理',
                    //         size: Dimensions.font18,
                    //       )),
                    // ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // //notice
                    // GestureDetector(
                    //   onTap: (() {
                    //     Get.toNamed(RouteHelper.getadminPage());
                    //     // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                    //   }),
                    //   child: AccountWidgt(
                    //       appIcon: AppIcon(
                    //         icon: Icons.notification_important_rounded,
                    //         backgroundColor: Colors.lightBlue,
                    //         iconColor: Colors.white,
                    //         size: Dimensions.iconSize24 * 2,
                    //         iconSize: Dimensions.iconSize24,
                    //       ),
                    //       bigText: BigText(
                    //         text: '消息提醒',
                    //         size: Dimensions.font18,
                    //       )),
                    // ),
                    // SizedBox(
                    //   height: Dimensions.height10,
                    // ),
                    // // //like
                    // GestureDetector(
                    //   onTap: (() {
                    //     Get.toNamed(RouteHelper.getLiked());
                    //     // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                    //   }),
                    //   child: AccountWidgt(
                    //       appIcon: AppIcon(
                    //         icon: Icons.favorite_rounded,
                    //         backgroundColor: Colors.pinkAccent,
                    //         iconColor: Colors.white,
                    //         size: Dimensions.iconSize24 * 2,
                    //         iconSize: Dimensions.iconSize24,
                    //       ),
                    //       bigText: BigText(
                    //         text: "我的点赞",
                    //         size: Dimensions.font18,
                    //       )),
                    // ),
                    // SizedBox(
                    //   height: Dimensions.height10,
                    // ),
                    // //collect
                    // GestureDetector(
                    //   onTap: (() {
                    //     showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                    //   }),
                    //   child: AccountWidgt(
                    //       appIcon: AppIcon(
                    //         icon: Icons.bookmark_rounded,
                    //         backgroundColor: Colors.orangeAccent,
                    //         iconColor: Colors.white,
                    //         size: Dimensions.iconSize24 * 2,
                    //         iconSize: Dimensions.iconSize24,
                    //       ),
                    //       bigText: BigText(
                    //         text: '我的收藏',
                    //         size: Dimensions.font18,
                    //       )),
                    // ),
                    // SizedBox(
                    //   height: Dimensions.height10,
                    // ),
                    // //history
                    // GestureDetector(
                    //   onTap: (() {
                    //     Get.toNamed(RouteHelper.getHistory());
                    //     //showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                    //   }),
                    //   child: AccountWidgt(
                    //       appIcon: AppIcon(
                    //         icon: Icons.history_rounded,
                    //         backgroundColor: Colors.brown,
                    //         iconColor: Colors.white,
                    //         size: Dimensions.iconSize24 * 2,
                    //         iconSize: Dimensions.iconSize24,
                    //       ),
                    //       bigText: BigText(
                    //         text: '历史记录',
                    //         size: Dimensions.font18,
                    //       )),
                    // ),
                    // SizedBox(
                    //   height: Dimensions.height10,
                    // ),

                    // user infor
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getUserPage());
                        //showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
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
                            text: '个人信息',
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // user infor
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getScan());
                        //showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.crop_free_rounded,
                            backgroundColor: Colors.lightBlueAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '扫码登录',
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),

                    GestureDetector(
                      onTap: () {
                        if (Get.find<AuthController>().userLoggedIn()) {
                          AwesomeDialog(
                            width: Dimensions.width45 * 10,
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.scale,
                            title: '注意⚠️',
                            desc: '是否退出登录？',
                            btnOkText: '确定',
                            btnCancelText: '取消',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              Get.find<AuthController>().clearSharedData();
                              Get.offAllNamed(RouteHelper.getLogIn());
                            },
                          ).show();
                        }
                      },
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.logout_rounded,
                            backgroundColor: Colors.red,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: "退出登录",
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    GestureDetector(
                      onTap: (() {
                        // showCustomNoticeSnacker("请切换系统模式!", title: "学霸空间");
                        AwesomeDialog(
                          width: Dimensions.width45 * 10,
                          context: context,
                          dialogType: DialogType.infoReverse,
                          animType: AnimType.scale,
                          title: '注意⚠️',
                          desc: '学霸空间 APP 默认跟随系统模式!',
                          btnOkText: '我知道了',
                          // btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.brightness_4_rounded,
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            iconColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text:
                                Theme.of(context).brightness == Brightness.dark
                                    ? "浅色模式"
                                    : "深色模式 ",
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getwebPage(
                            '${AppConstants.FEEDBACK}?tk=$Token', '反馈问题'));
                        //showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.feedback_rounded,
                            backgroundColor: Colors.pink,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '反馈问题',
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getIntroPage());
                        //showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.book_rounded,
                            backgroundColor: Colors.orangeAccent,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '使用介绍',
                            size: Dimensions.font18,
                          )),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),

                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(RouteHelper.getAboutPage());
                        //showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                      }),
                      child: AccountWidgt(
                          appIcon: AppIcon(
                            icon: Icons.info_outline_rounded,
                            backgroundColor: AppColors.signColor,
                            iconColor: Colors.white,
                            size: Dimensions.iconSize24 * 2,
                            iconSize: Dimensions.iconSize24,
                          ),
                          bigText: BigText(
                            text: '关于我们',
                            size: Dimensions.font18,
                          )),
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
