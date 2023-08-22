import 'package:flutter/widgets.dart';
import 'package:xueba/models/classification_model.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../data/repository/classification_repo.dart';

import '../routes/route_helper.dart';
import 'auth_controller.dart';

class ClassificationController extends GetxController {
  final ClassificationRepo classificationRepo;
  ClassificationController({required this.classificationRepo});
  List<dynamic> _classificationList = [];
  List<dynamic> get classificationList => _classificationList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getClassificationList() async {
    _isLoaded = false;

    Response response = await classificationRepo.getClassificationList();

    if (response.statusCode == 200) {
      debugPrint("ok in classification");
      _classificationList = [];
      _classificationList
          .addAll((classification.fromJson(response.body).results)!.toList());
      _isLoaded = true;
      update();
    } else if (response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.offNamed(RouteHelper.getLogIn());
      showCustomSnacker("请重新登录!(error code:1)", title: "出错啦");
    } else {
      showCustomSnacker("请检查网络连接!", title: "出错啦");
      debugPrint("not ok in classification");
      debugPrint(response.statusCode.toString());
    }
  }
}
