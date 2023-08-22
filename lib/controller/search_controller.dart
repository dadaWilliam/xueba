import 'package:flutter/widgets.dart';
import 'package:xueba/models/video_model.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../data/repository/search_repo.dart';
import 'auth_controller.dart';

class SearchVideoController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  List<dynamic> _videoList = [];
  // ignore: non_constant_identifier_names
  List pre_search = [];
  List<dynamic> get videoList => _videoList;

  SearchVideoController({
    required this.searchRepo,
  });

  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearched = false;
  bool isCleared = false;
  bool allowBack = false;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;
  bool get isSearched => _isSearched;
  int page = 0;
  final int _homePage = 1;
  // ignore: non_constant_identifier_names
  String old_search = '';
  String search = '';

  int get homePage => _homePage;

  Future getSearchResult() async {
    _isSearched = false;
    _isLoading = true;
    if (isCleared == true) {
      old_search = '';
      search = '';
      allowBack = false;
      update();
    }
    if (old_search.isNotEmpty && search == old_search) {
      page++;
      if (page == 1) {
        _videoList = [];
      }
      isCleared = false;
    }
    // else if (_hasMore == false) {
    //   _isSearched = false;
    //   isCleared = true;
    //   update();
    //   isCleared = false;
    //   _hasMore = true;
    //   _isLoading = false;
    //   showCustomGreenSnacker("已全部加载完成！", title: "通知");
    // }
    else {
      page = 1;
      _videoList = [];
      _hasMore = true;
      isCleared = false;
    }
    if (search.isNotEmpty) {
      Response response = await searchRepo.getSearchResult(search, page);
      old_search = search;

      pre_search.add(search);
      pre_search = pre_search.toSet().toList();
      if (pre_search.length > 3) pre_search.removeAt(0);

      if (response.statusCode == 200) {
        // ignore: prefer_interpolation_to_compose_strings
        debugPrint(
            // ignore: prefer_interpolation_to_compose_strings
            "ok in search video " + search + ' page = ' + page.toString());
        _videoList.addAll((Video.fromJson(response.body).results)!.toList());
        if (_videoList.isNotEmpty) {
          _isSearched = true;
          update();
          //showCustomGreenSnacker("搜索成功！", title: "通知");
        } else {
          showCustomSnacker("未找到相关信息！", title: "注意");
          _isSearched = false;
          search = '';
        }
        isCleared = false;
        _isLoading = false;
        _hasMore = true;
        //search = '';
        update();

        return response;
      } else if (response.statusCode == 403) {
        _isSearched = false;
        _hasMore = true;
        _isLoading = false;

        debugPrint(response.statusCode.toString());
        Get.find<AuthController>().clearSharedData();
        Get.offNamed(RouteHelper.getLogIn());

        showCustomSnacker("请重新登录!(error code:2)", title: "出错啦");
        return response;
      } else if (response.statusCode == 404) {
        _isSearched = true;
        _hasMore = false;
        _isLoading = false;

        search = '';
        showCustomGreenSnacker("已全部加载完成！", title: "通知");
        debugPrint("not ok in search video");
        debugPrint(response.statusCode.toString());
        return response;
      } else {
        _hasMore = false;
        _isLoading = false;
        isCleared = false;
        showCustomSnacker("请检查网络连接!", title: "出错啦");
        debugPrint(response.statusCode.toString());
        return response;
      }
    }
  }
}
