import 'dart:io';

import 'package:xueba/pages/account/about.dart';
import 'package:xueba/pages/account/collect_page.dart';
import 'package:xueba/pages/account/notification_page.dart';
import 'package:xueba/pages/account/user_page.dart';
import 'package:xueba/pages/auth/admin_page.dart';
import 'package:xueba/pages/auth/sign_in_page.dart';
import 'package:xueba/pages/auth/verify_page.dart';
import 'package:xueba/pages/home/ad_page.dart';

import 'package:xueba/pages/home/home_page.dart';
import 'package:xueba/pages/scan.dart';
import 'package:xueba/pages/scan_detail.dart';
import 'package:xueba/pages/splash/intro_page.dart';
import 'package:xueba/pages/splash/splash_page.dart';
import 'package:xueba/pages/video/collect_video_detail.dart';
import 'package:xueba/pages/video/notification_video_detail.dart';
import 'package:xueba/pages/video/search_video_detail.dart';
import 'package:xueba/pages/video/video_detail.dart';
import 'package:get/route_manager.dart';

import '../pages/account/history_page.dart';
import '../pages/account/like_page.dart';
import '../pages/auth/web_page.dart';

import '../pages/video/history_video_detail.dart';
import '../pages/video/like_video_detail.dart';
import '../pages/video/popular_video_detail.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String introPage = "/intro-page";
  static const String initial = "/";
  static const String indexShowVideo = "/index-show-video";
  static const String latestVideo = "/video";
  static const String searchPage = "/search-page";
  static const String searchVideo = "/search-video";
  static const String historyVideo = "/history-video";
  static const String likeVideo = "/like-video";
  static const String collectVideo = "/collect-video";
  static const String notificationVideo = "/notification-video";
  static const String liked = "/liked";
  static const String collected = "/collected";
  static const String popularVideo = "/popular-video";
  static const String adminPage = "/admin-page";
  static const String adPage = "/ad-page";
  static const String webPage = "/web-page";
  static const String articlePage = "/article-page";
  static const String about = "/about";

  static const String videoPlayer = "/video-player";
  static const String login = "/login";
  static const String history = "/history";
  static const String notification = "/notification";
  static const String verify = "/verify";
  static const String userpage = "/userpage";
  static const String scan = "/scan";
  static const String scanDetail = "/scan-detail";

  static String getSplashPage() => splashPage;
  static String getIntroPage() => introPage;
  static String getInitial() => initial;
  static String getVerify(String user, String pwd) =>
      '$verify?user=$user&pwd=$pwd';
  static String getLogIn() => login;
  static String getUserPage() => userpage;
  static String getSearchPage() => searchPage;
  static String getADPage() => adPage;
  static String getIndexShowVideo(int pageId) =>
      '$indexShowVideo?pageId=$pageId';
  static String getSearchVideo(int id) => '$searchVideo?id=$id';
  static String getPopularVideo(int id) => '$popularVideo?id=$id';
  static String getHistoryVideo(int id) => '$historyVideo?id=$id';
  static String getNotificationVideo(int id) => '$notificationVideo?id=$id';

  static String getLikeVideo(int id) => '$likeVideo?id=$id';
  static String getCollectVideo(int id) => '$collectVideo?id=$id';
  static String getLatestVideo(int id) => '$latestVideo?id=$id';
  static String getVideoPlayer(String filePath) =>
      '$videoPlayer?file_path=$filePath';
  static String getHistory() => history;
  static String getLiked() => liked;
  static String getCollected() => collected;
  static String getNotification() => notification;

  static String getScan() => scan;
  static String getScanDetail(String data) => '$scanDetail?data=$data';
  static String getadminPage() => adminPage;
  static String getwebPage(String url, String name) =>
      '$webPage?url=$url&name=$name';
  static String getArticlePage(String url, String name) =>
      '$articlePage?url=$url&name=$name';
  static String getAboutPage() => about;

  static List<GetPage> routes = [
    GetPage(
        name: splashPage,
        page: () => const SplashScreen(),
        transition: Transition.native),
    GetPage(
        name: introPage,
        page: () => IntroPage(),
        transition: Transition.native),
    GetPage(
        name: verify,
        page: () {
          var user = Get.parameters['user'];
          var pwd = Get.parameters['pwd'];
          // debugPrint(user);
          // debugPrint(pwd);
          return VerifyPage(user: user, pwd: pwd);
        },
        transition: Transition.native),
    GetPage(
        name: initial, page: () => HomePage(), transition: Transition.native),
    GetPage(
        name: login,
        page: () => const SignInPage(),
        transition: Transition.native),
    GetPage(
        name: userpage,
        page: () => const UserPage(),
        transition: Transition.native),
    GetPage(
        name: history,
        page: () => const HistoryPage(),
        transition: Transition.native),
    GetPage(
        name: notification,
        page: () => const NotificationPage(),
        transition: Transition.native),
    GetPage(
        name: adPage,
        page: () => const ADPage(),
        transition: Transition.native),
    GetPage(
        name: liked,
        page: () => const LikePage(),
        transition: Transition.native),
    GetPage(
        name: collected,
        page: () => const CollectPage(),
        transition: Transition.native),
    GetPage(
        name: searchPage,
        page: () => HomePage(
              bottom_id: 1,
            ),
        transition: Transition.noTransition),
    GetPage(
        name: indexShowVideo,
        page: () {
          var pageId = Get.parameters['pageId'];
          return VideoDetail(pageId: int.parse(pageId!));
        },
        transition: Transition.native),
    GetPage(
        name: latestVideo,
        page: () {
          var id = Get.parameters['id'];
          return VideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    GetPage(
        name: searchVideo,
        page: () {
          var id = Get.parameters['id'];
          return SearchVideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    GetPage(
        name: popularVideo,
        page: () {
          var id = Get.parameters['id'];
          return PopularVideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    GetPage(
        name: historyVideo,
        page: () {
          var id = Get.parameters['id'];
          return HistoryVideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    GetPage(
        name: likeVideo,
        page: () {
          var id = Get.parameters['id'];
          return LikeVideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    GetPage(
        name: collectVideo,
        page: () {
          var id = Get.parameters['id'];
          return CollectVideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    GetPage(
        name: notificationVideo,
        page: () {
          var id = Get.parameters['id'];
          return NotificationVideoDetail(id: int.parse(id!));
        },
        transition: Transition.native),
    // GetPage(
    //     name: videoPlayer,
    //     page: () {
    //       var filePath = Get.parameters['file_path'];
    //       return VideoPlayerPage(file_path: filePath);
    //     },
    //     transition: Transition.native),
    GetPage(
        name: scan,
        page: () {
          return ScanQRcode();
        },
        transition: Transition.native),
    GetPage(
        name: scanDetail,
        page: () {
          var data = Get.parameters['data'];

          return StepperPage(
            dataString: data.toString(),
          );
        },
        transition: Transition.native),
    GetPage(
        name: adminPage,
        page: () {
          return AdminPage();
        },
        transition: Transition.native),
    GetPage(
        name: webPage,
        page: () {
          var url = Get.parameters['url'];
          var name = Get.parameters['name'];
          return WebPage(url: url.toString(), name: name.toString());
        },
        transition: Transition.native),
    // GetPage(
    //     name: articlePage,
    //     page: () {
    //       var url = Get.parameters['url'];
    //       var name = Get.parameters['name'];
    //       return ArticlePage(url: url.toString(), name: name.toString());
    //     },
    //     transition: Transition.native),
    GetPage(
        name: about,
        page: () => const AboutPage(),
        transition: Transition.native),
  ];
}
