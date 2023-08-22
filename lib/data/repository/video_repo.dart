// ignore_for_file: non_constant_identifier_names

import 'package:xueba/data/api/api_client.dart';
import 'package:get/get_connect.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class VideoRepo extends GetxService {
  final ApiClient apiClient;
  int page;
  VideoRepo({
    required this.apiClient,
    this.page = 0,
  });

  Future<Response> getVideoList(int page) async {
    if (page <= 1) {
      //print("111");
      return await apiClient.getData("/api/video/", 1);
    } else {
      //print(page);
      return await apiClient.getData("/api/video/", page);
    }
  }

  Future<Response> getPopularVideoList() async {
    return await apiClient.getData("/api/video-recommend/", 1);
  }

  Future<Response> updateVideo(int video_id) async {
    return await apiClient.update("/api/video-view/0", video_id);
  }

  Future<Response> updateHistory(int video_id) async {
    return await apiClient.update("/api/video-view/1", video_id);
  }

  Future<Response> updateLike(int video_id) async {
    return await apiClient.update("/api/video-like/1", video_id);
  }

  Future<Response> updateCollect(int video_id) async {
    return await apiClient.update("/api/video-collect/1", video_id);
  }

  Future<Response> updateRead(int code, int notice_id) async {
    return await apiClient.updateNotification(
        "/api/update-notice/$code", notice_id);
  }

  Future<Response> isLike(int video_id) async {
    return await apiClient.update("/api/video-like/0", video_id);
  }

  Future<Response> isCollect(int video_id) async {
    return await apiClient.update("/api/video-collect/0", video_id);
  }
}
