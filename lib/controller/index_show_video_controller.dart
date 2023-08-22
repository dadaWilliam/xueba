import 'package:flutter/widgets.dart';
import 'package:xueba/data/repository/index_show_video_repo.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../models/video_model.dart';
import '../routes/route_helper.dart';
import 'auth_controller.dart';

class IndexShowVideoController extends GetxController {
  final IndexShowVideoRepo indexShowVideoRepo;
  IndexShowVideoController({required this.indexShowVideoRepo});
  List<dynamic> _indexShowVideoList = [];
  List<dynamic> get indexShowVideoList => _indexShowVideoList;

  bool isUpdate = false;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getIndexShowVideoList() async {
    // await Get.find<AuthController>().getUserToken();
    // var user_id = await Get.find<AuthController>().getUserId();
    // await Get.find<UserController>().getUserInfo(user_id);
    Response response = await indexShowVideoRepo.getIndexShowVideoList();
    if (response.statusCode == 200) {
      debugPrint("ok in index show");
      _indexShowVideoList = [];
      _indexShowVideoList
          .addAll((Video.fromJson(response.body).results)!.toList());
      //print(_indexShowVideoList);
      _isLoaded = true;
      if (isUpdate == true) {
        isUpdate = false;
      } else {
        update();
      }
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      showCustomSnacker("请重新登录!index video error", title: "出错啦");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in index show");
      debugPrint(response.statusCode.toString());
    }
  }
}
