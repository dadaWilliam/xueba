import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xueba/controller/classification_controller.dart';
import 'package:xueba/controller/user_controller.dart';
import 'package:xueba/controller/video_controller.dart';

import 'package:xueba/routes/route_helper.dart';

import 'package:get/get.dart';

import 'controller/auth_controller.dart';
import 'controller/index_show_video_controller.dart';

import 'helper/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();

  // if (Platform.isAndroid) {
  //   //设置Android头部的导航栏透明
  //   SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent, //全局设置透明
  //     //statusBarIconBrightness: Brightness.dark,
  //     //light:黑色图标 dark：白色图标
  //     //在此处设置statusBarIconBrightness为全局设置
  //   );
  //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
  //runApp(const ChewieDemo());

  runApp(const MyApp());
  // Dimensions.update();
}

// void setupTimezone() async {
//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation(
//       'Asia/Shanghai')); // Beijing is in the Asia/Shanghai time zone
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return GetBuilder<UserController>(builder: (_) {
        return GetBuilder<VideoController>(builder: (_) {
          return GetBuilder<IndexShowVideoController>(builder: (_) {
            return GetBuilder<ClassificationController>(builder: (_) {
              // debugPrint(Dimensions.screenHeight.toString());
              // debugPrint(Dimensions.screenWidth.toString());
              // Dimensions.update();

              return GetMaterialApp(
                // builder: (context, child) => ResponsiveWrapper.builder(child,
                //     maxWidth: 800,
                //     minWidth: 480,
                //     defaultScale: false,
                //     breakpoints: [
                //       ResponsiveBreakpoint.resize(480, name: MOBILE),
                //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
                //       ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                //       ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                //     ],
                //     background: Container(color: Color(0xFFF5F5F5))),

                title: '学霸空间',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.transparent,
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark),
                  ),
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  textTheme: const TextTheme(
                    titleMedium: TextStyle(color: Colors.white),
                  ),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.transparent,
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.light),
                  ),
                ),

                // home:
                //     WelcomePage(), //MainVideoPage(), //VideoPlayerPage(),//VideoPlayerScreen(),
                initialRoute: Get.find<AuthController>().userUsed()
                    ? RouteHelper.getSplashPage()
                    : RouteHelper.getIntroPage(),
                getPages: RouteHelper.routes,
              );
            });
          });
        });
      });
    });
  }
}

// Future<void> scheduleDailyNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails('channel_id', 'channel_name',
//           importance: Importance.max, priority: Priority.high, showWhen: false);
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   final dailyTime = tz.TZDateTime(tz.local, DateTime.now().year,
//       DateTime.now().month, DateTime.now().day, 13, 57); // 6 PM

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'title',
//       'body',
//       dailyTime.isBefore(DateTime.now())
//           ? dailyTime.add(Duration(days: 1))
//           : dailyTime,
//       platformChannelSpecifics,
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);
// }

// Future<void> scheduleNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails('channel_id', 'channel_name',
//           importance: Importance.max, priority: Priority.high, showWhen: false);
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'title',
//       'body',
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);
// }
