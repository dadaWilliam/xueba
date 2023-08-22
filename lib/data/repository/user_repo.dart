import 'package:xueba/data/api/api_client.dart';
import 'package:get/get.dart';

class UserRepo {
  final ApiClient apiClient;

  UserRepo({
    required this.apiClient,
  });

  getUserInfo(int id) async {
    return await apiClient.getData("/api/user/$id", 1);
  }

  Future<Response> getHistory(int userId, int page) async {
    return await apiClient.getSearchData(
        "/api/video-history/", userId.toString(), page);
  }

  Future<Response> getLikedVideo(int page) async {
    return await apiClient.getData("/api/liked-video/", page);
  }

  Future<Response> getCollectedVideo(int page) async {
    return await apiClient.getData("/api/collected-video/", page);
  }

  Future<Response> getNotificationList(int code, int page) async {
    return await apiClient.getData("/api/notification/$code", page);
  }

  Future<Response> getNotice() async {
    return await apiClient.getData("/api/notice/", 1);
  }

  // Future<Response> getEachHistory(int id) async {
  //   return await apiClient.getEachVideoData(
  //     "/api/video/$id/",
  //   );
  // }
}
