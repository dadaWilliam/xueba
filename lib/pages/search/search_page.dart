import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:xueba/controller/search_controller.dart';
import 'package:xueba/controller/search_controller.dart';
import 'package:get/get.dart';

import '../../base/show_custom_message.dart';
import '../../controller/auth_controller.dart';
import '../../controller/classification_controller.dart';

import '../../controller/search_controller.dart';
import '../../controller/user_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import 'search_page_body.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String search = '';
  final PageController _controller = PageController(keepPage: true);

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
    // Get.find<SearchVideoController>().isCleared = true;
    // Get.find<SearchVideoController>().getSearchResult();

    _getUser();
    _controller.addListener(() {
      if (_controller.offset < 300 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 300 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    //_postSearch();
  }

  _getUser() {
    var userId = Get.find<AuthController>().getUserId();
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      Get.find<UserController>().getUserInfo(userId);
    }
    //print(_userId);
    setState(() {});
  }

  // 数据
  _postSearch() async {
    if (search.isNotEmpty) {
      Get.find<SearchVideoController>().search = search;

      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });
    var SearchController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    void _search() {
      search = SearchController.text.trim();

      if (search.isEmpty) {
        showCustomSnacker("请输入搜索内容", title: "出错啦");
      } else {
        //showCustomNoticeQuickSnacker("正在搜索中...", title: "通知");
        var load = AwesomeDialog(
          width: Dimensions.screenWidth * 0.5,
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          body: Column(
            children: [
              SizedBox(
                height: Dimensions.height15,
              ),
              CircularProgressIndicator(
                  strokeWidth: 5.0, color: AppColors.mainColor),
              SizedBox(
                height: Dimensions.height30,
              ),
              BigText(
                text: '加载中...',
                size: Dimensions.font15,
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
            ],
          ),
        );
        load.show();
        _postSearch();
        Get.find<SearchVideoController>()
            .getSearchResult()
            .then((value) => load.dismiss());
      }
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          GetBuilder<SearchVideoController>(
            builder: (controller) {
              return Column(
                children: [
                  SizedBox(
                    height: Dimensions.screenHeight * 0.06,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                      ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // width: Dimensions.width45 * 4,
                            child: TextField(
                              controller: SearchController,
                              decoration: InputDecoration(
                                  //hint  s
                                  hintText: "输入 关键词 开始搜索吧",
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: AppColors.yellowColor,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius30),
                                      borderSide: const BorderSide(
                                          width: 1.0, color: Colors.white)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius30),
                                      borderSide: const BorderSide(
                                          width: 1.0, color: Colors.white))),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _search(),
                            child: Container(
                                width: Dimensions.width30 * 3,
                                height: Dimensions.height45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius30),
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.mainColor.withOpacity(0.9)
                                        : AppColors.mainColor),
                                child: Center(
                                  child: BigText(
                                    text: "搜索",
                                    size: Dimensions.font18,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                ],
              );
            },
          ),
          Expanded(
              flex: 1,
              child: EasyRefresh.builder(
                header: const PhoenixHeader(skyColor: AppColors.mainColor),
                footer: const TaurusFooter(
                    skyColor: AppColors.mainColor, springRebound: true),
                onRefresh: () async {
                  if (Get.find<SearchVideoController>().search != '') {
                    Get.find<SearchVideoController>().page = 0;
                    Response response = await Get.find<SearchVideoController>()
                        .getSearchResult();
                    if (response.statusCode == 200) {
                      // showCustomGreenSnacker('刷新成功!', title: '通知');
                      return IndicatorResult.success;
                    } else {
                      // showCustomSnacker('刷新失败!', title: '请注意');
                      return IndicatorResult.fail;
                    }
                  } else {
                    Get.find<ClassificationController>()
                        .getClassificationList();
                  }
                },
                onLoad: () async {
                  Response response;
                  if (Get.find<SearchVideoController>().search != '') {
                    response = await Get.find<SearchVideoController>()
                        .getSearchResult();
                    if (response.statusCode == 200) {
                      return IndicatorResult.success;
                    } else if (response.statusCode == 404) {
                      // showCustomGreenSnacker('已全部加载完毕!', title: '请注意');
                      return IndicatorResult.noMore;
                    } else {
                      // showCustomSnacker('刷新失败!', title: '请注意');
                      return IndicatorResult.fail;
                    }
                  } else {
                    Get.find<ClassificationController>()
                        .getClassificationList();
                  }
                },
                childBuilder: (context, physics) {
                  return SingleChildScrollView(
                    controller: _controller,
                    physics: physics,
                    child: const SearchPageBody(),
                  );
                },
              ))
        ],
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _controller.animateTo(
                  .0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              }),
    );
  }
}
