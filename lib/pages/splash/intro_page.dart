/// Example page
import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:xueba/utils/colors.dart';

import '../../controller/auth_controller.dart';
import '../../routes/route_helper.dart';

bool bright = true;

class IntroPage extends StatefulWidget {
  IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
      slides: pages,
      indicatorType: IndicatorType.circle,
      skipText: '',
      nextText: '继续',
      doneText: '开始使用',
      footerBgColor: Colors.teal,
      onDone: () async {
        /// TODO: Go to desire page like login or home
        Get.offAllNamed(RouteHelper.getSplashPage());
        // await Get.find<AuthController>().saveUserUsed();
      },
    );
  }
}

final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    mainCircleBgColor: AppColors.mainColor,
    sideDotsBgColor: AppColors.mainColor,
    title: '欢迎使用 学霸空间 App !',
    imageHeightMultiple: 0.15,
    description: 'Designed by William & Match ',
    imageAsset: 'assets/image/logo.png',
  ),
  // const SingleIntroScreen(
  //   mainCircleBgColor: Colors.blue,
  //   sideDotsBgColor: Colors.blue,
  //   title: '首页 使用方法 !',
  //   imageHeightMultiple: 0.66,
  //   description: '左右滑动，单击、双击',
  //   imageAsset: 'assets/image/1.jpg',
  // ),
  const SingleIntroScreen(
    mainCircleBgColor: AppColors.yellowColor,
    sideDotsBgColor: Colors.yellow,
    title: '学霸空间 需要得到你的同意 !',
    description:
        '学霸空间 App 需要获得系统相关权限 !\n如网络,相机,通知等权限\n\n你需要同意 学霸空间《管理条例》和《隐私政策》',
    imageAsset: 'assets/image/onboard_two.png',
  ),
  const SingleIntroScreen(
    title: '开始学习吧 !',
    mainCircleBgColor: Colors.redAccent,
    sideDotsBgColor: Colors.pinkAccent,
    description: '加油! @学霸空间 \n\nDesigned by William & Match',
    imageAsset: 'assets/image/onboard_three.png',
  ),
];
