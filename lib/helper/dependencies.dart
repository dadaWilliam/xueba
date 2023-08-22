import 'package:xueba/controller/auth_controller.dart';
import 'package:xueba/controller/classification_controller.dart';
import 'package:xueba/controller/video_controller.dart';
import 'package:xueba/data/api/api_client.dart';
import 'package:xueba/data/repository/auth_repo.dart';
import 'package:xueba/data/repository/classification_repo.dart';
import 'package:xueba/data/repository/user_repo.dart';
import 'package:xueba/data/repository/video_repo.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/index_show_video_controller.dart';
import '../controller/search_controller.dart';
import '../controller/user_controller.dart';
import '../data/repository/index_show_video_repo.dart';
import '../data/repository/search_repo.dart';
import '../utils/app_constants.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  // api client
  Get.lazyPut(() => sharedPreferences);

  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.URL));

  // repos
  Get.lazyPut(() => AuthRepo(
        apiClient: Get.find(),
        sharedPreferences: Get.find(),
      ));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => VideoRepo(apiClient: Get.find()));
  Get.lazyPut(() => IndexShowVideoRepo(apiClient: Get.find()));
  Get.lazyPut(() => SearchRepo(apiClient: Get.find()));
  Get.lazyPut(() => ClassificationRepo(apiClient: Get.find()));

  // controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => VideoController(videoRepo: Get.find()));
  Get.lazyPut(() => IndexShowVideoController(indexShowVideoRepo: Get.find()));

  Get.lazyPut(() => SearchVideoController(searchRepo: Get.find()));
  Get.lazyPut(() => ClassificationController(classificationRepo: Get.find()));
}
