import 'package:flutter/widgets.dart';
import 'package:get/get_connect.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../utils/app_constants.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  //late Map<String, String> _mainHeaders;
  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    //token = 'a1d2519c21999c0f8dc275909fae2d62';
    // token = '0b54c171384cfe4fbc5dbd66c7a8dd67';
    // _mainHeaders = {
    //   'Content-type': 'application/json; charset=UTF-8',

    //   // 'Authorization': 'Bearer $token',
    // };
  }
  Future<Response> getData(
    String uri,
    int page,
  ) async {
    try {
      Response response = await get(uri, query: {
        'tk': token,
        'page': page.toString(),
      });
      //print(response.statusCode);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // ignore: non_constant_identifier_names
  Future<Response> update(String uri, int video_id) async {
    try {
      Response response =
          await get(uri, query: {'tk': token, 'video_id': video_id.toString()});
      //print(response.statusCode);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> updateNotification(String uri, int notice_id) async {
    try {
      Response response = await get(uri,
          query: {'tk': token, 'notice_id': notice_id.toString()});
      //print(response.statusCode);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
  // Future<Response> delete_history(String uri,) async {
  //   try {
  //     Response response =
  //         await delete(uri, query: {'tk': token,});
  //     //print(response.statusCode);
  //     return response;
  //   } catch (e) {
  //     return Response(statusCode: 1, statusText: e.toString());
  //   }
  // }
  // Future<Response> getNoticeList(String uri) async {
  //   try {
  //     Response response = await get(uri, query: {
  //       'tk': token,
  //     });
  //     //print(response.statusCode);
  //     return response;
  //   } catch (e) {
  //     return Response(statusCode: 1, statusText: e.toString());
  //   }
  // }

  Future<Response> getSearchData(
    String uri,
    String search,
    int page,
  ) async {
    try {
      Response response = await get(uri, query: {
        'tk': token,
        'search': search,
        'page': page.toString(),
      });
      //print(response.statusCode);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> check(
    String uri,
  ) async {
    try {
      Response response = await get(uri, query: {
        // 'tk': token,
        'version': AppConstants.APP_VERSION.toString(),
      });
      //print(response.statusCode);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // Future<Response> getLikedCollected(
  //   String uri,
  //   int page,
  // ) async {
  //   try {
  //     Response response = await get(uri, query: {
  //       'tk': token,
  //       'page': page.toString(),
  //     });
  //     //print(response.statusCode);
  //     return response;
  //   } catch (e) {
  //     return Response(statusCode: 1, statusText: e.toString());
  //   }
  // }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(
        uri,
        body,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
