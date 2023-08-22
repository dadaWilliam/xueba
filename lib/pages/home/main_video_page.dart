// ignore_for_file: unused_element

import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:xueba/base/show_custom_message.dart';
import 'package:xueba/controller/user_controller.dart';
import 'package:xueba/pages/home/video_page_body.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:xueba/utils/app_constants.dart';
import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/big_text.dart';

import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/index_show_video_controller.dart';
import '../../controller/video_controller.dart';
import 'package:badges/badges.dart' as badges;

import '../../widgets/small_text.dart';

class MainVideoPage extends StatefulWidget {
  const MainVideoPage({Key? key}) : super(key: key);

  @override
  State<MainVideoPage> createState() => _MainVideoPageState();
}

class _MainVideoPageState extends State<MainVideoPage> {
  final PageController _controller = PageController(keepPage: true);
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey title = GlobalKey();
  GlobalKey user = GlobalKey();
  GlobalKey scan = GlobalKey();
  GlobalKey noti = GlobalKey();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  int unread = 0;
  bool ok = false;
  // var user;

  // _loadResource() {
  //   if (Get.find<AuthController>().userLoggedIn()) {
  //     int id = Get.find<AuthController>().getUserId();
  //     user = Get.find<UserController>().getUserInfo(id);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _getNotification(0); // 0 unread
    //_getUser();
    // _loadResource();
    // Get.find<VideoController>().isUpdate = true;
    // Get.find<VideoController>().page = 1;
    // Get.find<VideoController>().getVideoList();
    // Get.find<IndexShowVideoController>().getIndexShowVideoList();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      if (_controller.offset < 500 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 500 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    if (Get.find<AuthController>().userUsed() == false) {
      createTutorial();
      Future.delayed(const Duration(seconds: 1), showTutorial);
    }
  }

  _getNotification(int code) async {
    Get.find<UserController>().isNotificationUpdate = true;
    await Get.find<UserController>().getNotification(code);
    // print(Get.find<UserController>().notificationList.length);
    setState(() {
      unread = Get.find<UserController>().notificationList.length;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  // _getUser() {
  //   var userId = Get.find<AuthController>().getUserId();
  //   bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
  //   if (userLoggedIn) {
  //     Get.find<UserController>().getUserInfo(userId);
  //   }
  //   //print(_userId);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height45, bottom: Dimensions.height5),
              padding: EdgeInsets.only(
                  left: Dimensions.height20, right: Dimensions.height20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          _controller.animateTo(
                            .0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        },
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                    height: Dimensions.height20 * 15,
                                    color: Colors.transparent,
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                            child: Image.asset(
                                          'assets/image/logo.png',
                                          width: Dimensions.width10 * 8,
                                        )),
                                        SizedBox(
                                          height: Dimensions.height20,
                                        ),
                                        Center(
                                          child: BigText(
                                            text: "学霸空间",
                                            color: AppColors.mainColor,
                                            size: Dimensions.font25,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimensions.height20,
                                        ),
                                        Center(
                                          child: BigText(
                                            text:
                                                "Developed by William & Match",
                                            color: AppColors.mainBlackColor,
                                            size: Dimensions.font20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimensions.height10,
                                        ),
                                        Center(
                                          child: BigText(
                                            text:
                                                "版本号: ${AppConstants.APP_VERSION}",
                                            color: AppColors.mainBlackColor,
                                            size: Dimensions.font18,
                                          ),
                                        ),
                                        // BigText(text: '学霸空间'),
                                        // ElevatedButton(
                                        //   child: const Text('关闭'),
                                        //   onPressed: () =>
                                        //       Navigator.pop(context),
                                        // ),
                                      ],
                                    )));
                              });
                        },
                        child: BigText(
                          key: title,
                          text: "学霸空间",
                          color: AppColors.mainColor,
                          size: Dimensions.font30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteHelper.getUserPage()),
                        child: BigText(
                          key: user,
                          text: Get.find<AuthController>().getUserName(),
                          color: Colors.grey,
                          size: Dimensions.font15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteHelper.getNotification()),
                        //Get.offAllNamed(RouteHelper.getSearchPage()),
                        child: Center(
                            key: noti,
                            child: Container(
                                margin:
                                    EdgeInsets.only(right: Dimensions.width10),
                                width: Dimensions.width45,
                                height: Dimensions.height45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius15),
                                  color: AppColors.iconColor2,
                                ),
                                child: unread == 0
                                    ? Icon(
                                        Icons.notifications_none_rounded,
                                        color: Colors.white,
                                        size: Dimensions.iconSize24,
                                      )
                                    : badges.Badge(
                                        badgeContent: unread < 10
                                            ? SmallText(
                                                text: '$unread',
                                                color: Colors.white,
                                              )
                                            : SmallText(
                                                text: '9+',
                                                color: Colors.white,
                                              ),
                                        child: Center(
                                          child: Icon(
                                            Icons.notifications_none_rounded,
                                            color: Colors.white,
                                            size: Dimensions.iconSize24,
                                          ),
                                        )))),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteHelper.getScan()),
                        child: Center(
                          key: scan,
                          child: Container(
                            width: Dimensions.width45,
                            height: Dimensions.height45,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              color: AppColors.mainColor,
                            ),
                            child: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.white,
                              size: Dimensions.iconSize24,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
          Expanded(
            child: EasyRefresh.builder(
              // header: ClassicHeader(
              //   dragText: '下拉刷新',
              //   processingText: '正在刷新中...',
              //   messageText: '最后更新于 %T',
              //   armedText: '释放刷新',
              //   processedText: '刷新成功',
              //   noMoreText: '没有更多了',
              //   failedText: '刷新失败',
              // ),
              header: const PhoenixHeader(skyColor: AppColors.mainColor),
              // footer: ClassicFooter(),
              footer: const TaurusFooter(
                  skyColor: AppColors.mainColor, springRebound: true),
              onRefresh: () async {
                await Get.find<UserController>().getNotice();
                Get.find<IndexShowVideoController>().isUpdate = true;
                await Get.find<IndexShowVideoController>()
                    .getIndexShowVideoList();
                Get.find<VideoController>().isUpdate = true;
                Get.find<VideoController>().page = 1;
                Response response =
                    await Get.find<VideoController>().getVideoList();

                //const Duration(seconds: 10);
                if (response.statusCode == 200) {
                  //showCustomGreenSnacker('刷新成功!', title: '通知');
                  Get.find<VideoController>().page = 2;
                  return IndicatorResult.success;
                } else {
                  showCustomSnacker('刷新失败!', title: '请注意');
                  return IndicatorResult.fail;
                }
              },
              onLoad: () async {
                // Get.find<VideoController>().isLoaded = false;
                Response response =
                    await Get.find<VideoController>().getVideoList();
                // const Duration(seconds: 10);
                if (response.statusCode == 200) {
                  return IndicatorResult.success;
                } else if (response.statusCode == 404) {
                  showCustomGreenSnacker('已全部加载完毕!', title: '请注意');
                  return IndicatorResult.noMore;
                } else {
                  showCustomSnacker('刷新失败!', title: '请注意');
                  return IndicatorResult.fail;
                }
              },
              childBuilder: (context, physics) {
                return SingleChildScrollView(
                  controller: _controller,
                  physics: physics,
                  child: VideoPageBody(
                    ok: ok,
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _controller.animateTo(
                  .0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              }),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.green,
      hideSkip: true,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        setState(() {
          ok = true;
        });
        // print("finish");
      },
      // onClickTarget: (target) {
      //   print('onClickTarget: $target');
      // },
      // onClickTargetWithTapPosition: (target, tapDetails) {
      //   print("target: $target");
      //   print(
      //       "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      // },
      // onClickOverlay: (target) {
      //   print('onClickOverlay: $target');
      // },
      // onSkip: () {
      //   print("skip");
      // },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: title,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   height: Dimensions.height45,
                  // ),
                  Text(
                    "学霸空间",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Dimensions.font25),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: Dimensions.height15),
                      child: Center(
                        child: Text(
                          "单击 查看APP版本\n双击 返回顶部",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: Dimensions.font20),
                        ),
                      )),
                ],
              );
            },
          ),
        ],
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: user,
        color: Colors.teal,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "用户信息",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: Dimensions.font25,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.height10),
                    child: Text(
                      "单击查看",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: Dimensions.height20,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     controller.previous();
                  //   },
                  //   child: const Icon(Icons.chevron_left),
                  // ),
                  // SizedBox(
                  //   height: Dimensions.height45,
                  // ),
                  // Text(
                  //   "点击 任意地方继续",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //     fontSize: Dimensions.font18,
                  //   ),
                  // ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: Dimensions.height5,
        enableOverlayTab: true,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: noti,
        color: Colors.deepOrange,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "通知消息",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: Dimensions.font25,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.height10),
                    child: Text(
                      "单击查看",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: Dimensions.height5,
        enableOverlayTab: true,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: scan,
        color: Colors.lightGreen[800],
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "扫码登录",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: Dimensions.font25,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.height10),
                    child: Text(
                      "单击查看",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: Dimensions.height5,
        enableOverlayTab: true,
      ),
    );

    return targets;
  }
}
