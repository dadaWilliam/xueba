import 'package:xueba/data/api/api_client.dart';
import 'package:get/get_connect.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class IndexShowVideoRepo extends GetxService {
  final ApiClient apiClient;

  IndexShowVideoRepo({required this.apiClient});

  Future<Response> getIndexShowVideoList() async {
    return await apiClient.getData("/api/video-index-show", 1);
  }
}
