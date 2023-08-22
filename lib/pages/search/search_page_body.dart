import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xueba/widgets/player_func.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/auth_controller.dart';
import '../../controller/classification_controller.dart';
import '../../controller/video_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text.dart';
import '../../widgets/small_text.dart';

import '../../controller/search_controller.dart';

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({Key? key}) : super(key: key);

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

Future<void> _launchUrl(Uri url) async {
  try {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

class _SearchPageBodyState extends State<SearchPageBody> {
  String Token = '';
  String search = '';

  @override
  void initState() {
    super.initState();
    //_getClassification();
    _getToken();
    Get.find<SearchVideoController>().isCleared = true;
    _getVideo();

    //_getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  _updateVideo() {
    var userId = Get.find<AuthController>().getUserId();
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      Get.find<VideoController>().updateVideo();
      // Get.find<IndexShowVideoController>().getIndexShowVideoList();
      // Get.find<VideoController>().isUpdate = true;
      // Get.find<VideoController>().getVideoList();
    }
    //print(_userId);
    setState(() {});
  }

  // 获取数据
  _getData() async {
    await Get.find<SearchVideoController>().getSearchResult();
  }

  _getVideo() async {
    await Get.find<VideoController>().getPopularVideoList();
    setState(() {});
  }

  _getClassification() async {
    await Get.find<ClassificationController>().getClassificationList();
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //setState(() {
    var isSearched = Get.find<SearchVideoController>().isSearched;
    //});
  }

  @override
  void dispose() {
    super.dispose();

    //super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<SearchVideoController>(builder: (searchVideos) {
          return searchVideos.isSearched == true &&
                  searchVideos.isCleared == false
              ? Column(children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            if (searchVideos.allowBack) {
                              Get.back();
                            } else {
                              searchVideos.isCleared = true;
                              _getData();
                            }
                          }),
                          child: const AppIcon(
                            icon: Icons.arrow_back_ios_new_rounded,
                          ),
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BigText(
                              text:
                                  '"${Get.find<SearchVideoController>().search}" ',
                              color: Colors.red,
                              size: Dimensions.font18,
                            ),
                            BigText(
                              text: ' 的搜索结果:',
                              size: Dimensions.font18,
                            ),
                          ],
                        )),
                        GestureDetector(
                          onTap: (() {
                            AwesomeDialog(
                              width: Dimensions.width45 * 10,
                              context: context,
                              dialogType: DialogType.info,
                              title: '分享',
                              desc: '该网页链接 可在浏览器中打开',
                              btnOkText: '分享此搜索结果',
                              btnOkOnPress: () {
                                Share.share(
                                    '${AppConstants.URL}${AppConstants.SEARCH}/?q=${Get.find<SearchVideoController>().search}');
                                // ShareEvent(video_id);
                              },
                              btnCancelText: '在浏览器打开',
                              btnCancelOnPress: () {
                                _launchUrl(Uri.parse(
                                    '${AppConstants.URL}${AppConstants.SEARCH}/?q=${Get.find<SearchVideoController>().search}'));
                              },
                            ).show();
                            //debugPrint(video_id);
                            // Share.share(
                            //     '${'在 学霸空间 官网打开 https://edu.iamdada.xyz/video/detail/$video_id'}/');
                          }),
                          child: const AppIcon(icon: Icons.ios_share_rounded),
                        )
                      ],
                    ),

                    // ElevatedButton(
                    //   style: ButtonStyle(
                    //     padding:
                    //         MaterialStateProperty.all(EdgeInsets.zero),
                    //     // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     backgroundColor:
                    //         MaterialStateProperty.all(Colors.blueAccent),
                    //   ),
                    //   onPressed: () async {
                    //     if (!searchVideos.isLoading) {
                    //       searchVideos.isCleared = true;
                    //       Get.back();
                    //       await _getData();
                    //     } else {
                    //       showCustomSnacker("请勿重复点击!", title: "请注意");
                    //     }
                    //   },
                    //   child: Column(
                    //     children: [
                    //       Center(
                    //         child: BigText(
                    //           text: " 返回上一页 ",
                    //           color: Colors.white,
                    //           size: Dimensions.font15,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),

                  // SizedBox(
                  //   height: Dimensions.height5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     BigText(
                  //       text: '"${Get.find<SearchVideoController>().search}" ',
                  //       color: Colors.red,
                  //       size: Dimensions.font18,
                  //     ),
                  //     BigText(
                  //       text: ' 的搜索结果为:',
                  //       size: Dimensions.font18,
                  //     ),
                  //   ],
                  // ),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchVideos.videoList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: (() {
                                Get.toNamed(RouteHelper.getSearchVideo(index));
                                searchVideos.videoList[index].viewCount++;
                                var list = searchVideos.videoList[index].url!
                                    .split('/');
                                var videoId = list[list.length - 2];
                                Get.find<VideoController>().video_id =
                                    int.parse(videoId);
                                _updateVideo();
                              }),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  // A motion is a widget used to control how the pane animates.
                                  motion:
                                      const DrawerMotion(), //ScrollMotion(),

                                  // All actions are defined in the children parameter.
                                  children: [
                                    // A SlidableAction can have an icon and/or a label.
                                    // SlidableAction(
                                    //   onPressed: null,
                                    //   backgroundColor: Color(0xFFFE4A49),
                                    //   foregroundColor: Colors.white,
                                    //   icon: Icons.delete,
                                    //   label: 'Delete',
                                    // ),
                                    SlidableAction(
                                      onPressed: (value) {
                                        AwesomeDialog(
                                          width: Dimensions.width45 * 10,
                                          context: context,
                                          dialogType: DialogType.info,
                                          title: '分享',
                                          desc: '该网页链接 可在浏览器中打开',
                                          btnOkText: '分享此视频',
                                          btnOkOnPress: () {
                                            Share.share(searchVideos
                                                .videoList[index].url
                                                .toString()
                                                .replaceAll(
                                                    '/video/', '/detail/')
                                                .replaceAll(
                                                    '/api/', '/video/'));
                                          },
                                          btnCancelText: '在浏览器打开',
                                          btnCancelOnPress: () {
                                            _launchUrl(Uri.parse(searchVideos
                                                .videoList[index].url
                                                .toString()
                                                .replaceAll(
                                                    '/video/', '/detail/')
                                                .replaceAll(
                                                    '/api/', '/video/')));
                                          },
                                        ).show();

                                        setState(() {});
                                      },
                                      backgroundColor: const Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.share_rounded,
                                      label: '分享',
                                    ),
                                  ],
                                ),
                                // The end action pane is the one at the right or the bottom side.
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      // An action can be bigger than the others.
                                      // flex: 2,
                                      onPressed: (value) async {
                                        var list = searchVideos
                                            .videoList[index].url
                                            .split('/');
                                        var videoId = list[list.length - 2];
                                        //debugPrint(video_id);
                                        Get.find<VideoController>().video_id =
                                            int.parse(videoId);
                                        var isLiked =
                                            await Get.find<VideoController>()
                                                .isLike();
                                        var snackBar = SnackBar(
                                          backgroundColor: Colors.pinkAccent
                                              .withOpacity(0.95),
                                          content: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: Dimensions.iconSize24,
                                              ),
                                              SizedBox(
                                                width: Dimensions.width5,
                                              ),
                                              BigText(
                                                text: isLiked
                                                    ? '成功移出 我的喜欢 '
                                                    : '成功添加至 我的喜欢 ',
                                                size: Dimensions.font18,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        if (isLiked == false) {
                                          searchVideos.videoList[index].liked!
                                              .add('new one');
                                          setState(() {});
                                          // setState(() {
                                          //   addLike = 1;
                                          // });
                                          // debugPrint(addLike.toString());
                                        } else {
                                          searchVideos.videoList[index].liked!
                                              .removeLast();
                                          setState(() {});
                                        }
                                        await Get.find<VideoController>()
                                            .updateLike();
                                        // debugPrint(is_liked.toString());
                                      },
                                      backgroundColor: Colors
                                          .pinkAccent, //Color(0xFF7BC043),
                                      foregroundColor: Colors.white,
                                      icon: Icons.favorite_rounded,
                                      label: '喜欢',
                                    ),
                                    SlidableAction(
                                      onPressed: (value) async {
                                        var list = searchVideos
                                            .videoList[index].url
                                            .split('/');
                                        var videoId = list[list.length - 2];
                                        //debugPrint(video_id);
                                        Get.find<VideoController>().video_id =
                                            int.parse(videoId);
                                        var isCollected =
                                            await Get.find<VideoController>()
                                                .isCollect();
                                        var snackBar = SnackBar(
                                          backgroundColor: Colors.lightBlue
                                              .withOpacity(0.95),
                                          content: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: Dimensions.iconSize24,
                                              ),
                                              SizedBox(
                                                width: Dimensions.width5,
                                              ),
                                              BigText(
                                                text: isCollected
                                                    ? '成功移出 我的收藏 '
                                                    : '成功添加至 我的收藏 ',
                                                size: Dimensions.font18,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        if (isCollected == false) {
                                          searchVideos
                                              .videoList[index].collected!
                                              .add('new one');
                                          setState(() {});
                                          // setState(() {
                                          //   addLike = 1;
                                          // });
                                          // debugPrint(addLike.toString());
                                        } else {
                                          searchVideos
                                              .videoList[index].collected!
                                              .removeLast();
                                          setState(() {});
                                        }
                                        await Get.find<VideoController>()
                                            .updateCollect();
                                        // debugPrint(is_liked.toString());
                                      },
                                      backgroundColor:
                                          Colors.lightBlue, //Color(0xFF0392CF),
                                      foregroundColor: Colors.white,
                                      icon: Icons.bookmark_add_rounded,
                                      label: '收藏',
                                    ),
                                  ],
                                ),

                                // The child of the Slidable is what the user sees when the
                                // component is not dragged.
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Dimensions.width15,
                                      right: Dimensions.width15,
                                      top: Dimensions.height10),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                          width: Dimensions.iconSize24 * 5,
                                          height: Dimensions.iconSize24 * 5,
                                          imageUrl: searchVideos
                                                  .videoList[index].cover! +
                                              '/?tk=' +
                                              Token,
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius20),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                          placeholder: (context, url) {
                                            return Transform.scale(
                                              scale: 0.5,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: AppColors.mainColor,
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: Dimensions.height20,
                                                  ),
                                                  Icon(
                                                    Icons.error,
                                                    size:
                                                        Dimensions.iconSize24 *
                                                            2,
                                                  ),
                                                  BigText(text: '出错啦')
                                                ],
                                              )),
                                      // Container(
                                      //   //image
                                      //   width: Dimensions.listViewImgSize,
                                      //   height: Dimensions.listViewImgSize,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(
                                      //           Dimensions.radius20),
                                      //       color: Colors.white24,
                                      //       image: DecorationImage(
                                      //           opacity: Theme.of(context)
                                      //                       .brightness ==
                                      //                   Brightness.dark
                                      //               ? 0.9
                                      //               : 1,
                                      //           fit: BoxFit.cover,
                                      //           image: NetworkImage(searchVideos
                                      //                   .videoList[index]
                                      //                   .cover! +
                                      //               '/?tk=' +
                                      //               Token))),
                                      // ),
                                      Expanded(
                                        child: Container(
                                          height:
                                              Dimensions.listViewTextContSize,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                    Dimensions.radius20),
                                                bottomRight: Radius.circular(
                                                    Dimensions.radius20)),
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[800]
                                                    : Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: Dimensions.width10,
                                                right: Dimensions.width10,
                                                top: Dimensions.height5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                BigText(
                                                  text: searchVideos
                                                      .videoList[index].title,
                                                  size: Dimensions.font18,
                                                ),
                                                SizedBox(
                                                  height: Dimensions.height5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SmallText(
                                                      text: searchVideos
                                                          .videoList[index]
                                                          .classification
                                                          .title,
                                                      size: Dimensions.font14,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SmallText(
                                                      text: searchVideos
                                                          .videoList[index]
                                                          .createTime
                                                          .split('T')[0],
                                                      size: Dimensions.font13,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: Dimensions.height10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconAndText(
                                                        icon: Icons
                                                            .remove_red_eye_rounded,
                                                        text: searchVideos
                                                            .videoList[index]
                                                            .viewCount!
                                                            .toString(),
                                                        color: Colors.black,
                                                        iconColor: Colors
                                                            .orangeAccent),
                                                    IconAndText(
                                                        icon: Icons
                                                            .favorite_rounded,
                                                        text: searchVideos
                                                            .videoList[index]
                                                            .liked!
                                                            .toList()
                                                            .length
                                                            .toString(),
                                                        color: Colors.black,
                                                        iconColor:
                                                            Colors.pinkAccent),
                                                    IconAndText(
                                                        icon: Icons
                                                            .bookmark_rounded,
                                                        text: searchVideos
                                                            .videoList[index]
                                                            .collected!
                                                            .toList()
                                                            .length
                                                            .toString(),
                                                        color: Colors.black,
                                                        iconColor:
                                                            Colors.blueAccent)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  )
                ])
              : Column(
                  children: [
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    BigText(text: "暂无搜索结果"),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    SmallText(text: "本地搜索记录:"),
                    SizedBox(
                      height: Dimensions.height5,
                    ),
                    Get.find<SearchVideoController>().pre_search.isEmpty
                        ? GestureDetector(
                            onTap: () {},
                            child: Chip(
                              label: BigText(
                                text: '暂无',
                                size: Dimensions.font13,
                              ),
                              avatar: const Icon(
                                Icons.history_toggle_off_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: Dimensions.width10,
                            alignment: WrapAlignment.center,
                            // 主轴(水平)方向间距
                            children: [
                              for (var i in Get.find<SearchVideoController>()
                                  .pre_search)
                                GestureDetector(
                                  onTap: (() async {
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
                                          const CircularProgressIndicator(
                                              strokeWidth: 5.0,
                                              color: AppColors.mainColor),
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
                                    // showCustomNoticeQuickSnacker(
                                    //     '正在加载中...',
                                    //     title: '通知');
                                    searchVideos.search = '$i';
                                    _getData().then((value) => load.dismiss());
                                  }),
                                  child: Chip(
                                    label: BigText(
                                      text: '$i',
                                      size: Dimensions.font13,
                                    ),
                                    avatar: const Icon(
                                      Icons.history_toggle_off_rounded,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                            ],
                          ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    SmallText(text: "试试关键词, 或点击下方分类:"),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    // SmallText(text: "如 学霸三，分数，求和，第5页，第4题"),
                    GetBuilder<ClassificationController>(
                        builder: (classifications) {
                      return classifications.isLoaded == true
                          ? Column(
                              children: [
                                SizedBox(
                                  width: Dimensions.screenWidth,
                                  // height: Dimensions.screenHeight * 0.55,
                                  child: Wrap(
                                      spacing: Dimensions.width20, // 主轴(水平)方向间距
                                      runSpacing:
                                          Dimensions.height5, // 纵轴（垂直）方向间距
                                      alignment: WrapAlignment.center,
                                      children: classifications
                                          .classificationList
                                          .map((item) {
                                            return GestureDetector(
                                              onTap: (() async {
                                                var load = AwesomeDialog(
                                                  width:
                                                      Dimensions.screenWidth *
                                                          0.5,
                                                  context: context,
                                                  dialogType:
                                                      DialogType.noHeader,
                                                  animType: AnimType.scale,
                                                  dismissOnTouchOutside: false,
                                                  body: Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            Dimensions.height15,
                                                      ),
                                                      const CircularProgressIndicator(
                                                          strokeWidth: 5.0,
                                                          color: AppColors
                                                              .mainColor),
                                                      SizedBox(
                                                        height:
                                                            Dimensions.height30,
                                                      ),
                                                      BigText(
                                                        text: '加载中...',
                                                        size: Dimensions.font15,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            Dimensions.height20,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                load.show();
                                                // showCustomNoticeQuickSnacker(
                                                //     '正在加载中...',
                                                //     title: '通知');
                                                searchVideos.search =
                                                    item.title;
                                                _getData().then(
                                                    (value) => load.dismiss());
                                              }),
                                              child: Chip(
                                                // padding:
                                                //     EdgeInsets.all(Dimensions.width10),
                                                backgroundColor:
                                                    Colors.green[400],
                                                shadowColor: Colors.grey,
                                                label: BigText(
                                                  color: Colors.white,
                                                  text: item.title,
                                                  size: Dimensions.font15,
                                                ),
                                              ),
                                            );
                                          })
                                          .toList()
                                          .cast<Widget>()
                                      //     +
                                      // [
                                      //   Container(
                                      //       margin: EdgeInsets.only(
                                      //           top: Dimensions.height15),
                                      //       child: Column(
                                      //         children: [
                                      //           Center(
                                      //             child: SmallText(
                                      //                 text: " © 学霸空间"),
                                      //           )
                                      //         ],
                                      //       ))
                                      // ],
                                      ),
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                BigText(
                                  text: "热门内容 ",
                                  size: Dimensions.font25,
                                ),
                                Get.find<VideoController>().ispopularOk == true
                                    ? GetBuilder<VideoController>(
                                        builder: (popularVideos) {
                                        return SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: MediaQuery.removePadding(
                                                removeTop: true,
                                                context: context,
                                                child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: popularVideos
                                                        .popularVideoList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: (() {
                                                          Get.toNamed(RouteHelper
                                                              .getPopularVideo(
                                                                  index));
                                                          popularVideos
                                                              .popularVideoList[
                                                                  index]
                                                              .viewCount++;
                                                        }),
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              top: Dimensions
                                                                  .height10,
                                                              left: Dimensions
                                                                  .width15,
                                                              right: Dimensions
                                                                  .width15,
                                                              bottom: Dimensions
                                                                      .height5 /
                                                                  2),
                                                          child: Row(
                                                            children: [
                                                              CachedNetworkImage(
                                                                  width: Dimensions
                                                                          .iconSize24 *
                                                                      5,
                                                                  height: Dimensions
                                                                          .iconSize24 *
                                                                      5,
                                                                  imageUrl: popularVideos
                                                                          .popularVideoList[
                                                                              index]
                                                                          .cover! +
                                                                      '/?tk=' +
                                                                      Token,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                                              image: DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                  placeholder:
                                                                      (context,
                                                                          url) {
                                                                    return Transform
                                                                        .scale(
                                                                      scale:
                                                                          0.5,
                                                                      child:
                                                                          const CircularProgressIndicator(
                                                                        color: AppColors
                                                                            .mainColor,
                                                                      ),
                                                                    );
                                                                  },
                                                                  errorWidget:
                                                                      (context,
                                                                              url,
                                                                              error) =>
                                                                          Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: Dimensions.height20,
                                                                              ),
                                                                              Icon(
                                                                                Icons.error,
                                                                                size: Dimensions.iconSize24 * 2,
                                                                              ),
                                                                              BigText(text: '出错啦')
                                                                            ],
                                                                          )),

                                                              // Container(
                                                              //   //image
                                                              //   width: Dimensions
                                                              //       .listViewImgSize,
                                                              //   height: Dimensions
                                                              //       .listViewImgSize,
                                                              //   decoration: BoxDecoration(
                                                              //       borderRadius:
                                                              //           BorderRadius.circular(Dimensions
                                                              //               .radius20),
                                                              //       color: Colors
                                                              //           .white24,
                                                              //       image: DecorationImage(
                                                              //           opacity: Theme.of(context).brightness == Brightness.dark
                                                              //               ? 0.9
                                                              //               : 1,
                                                              //           fit: BoxFit
                                                              //               .cover,
                                                              //           image: NetworkImage(popularVideos.popularVideoList[index].cover! +
                                                              //               '/?tk=' +
                                                              //               Token))),
                                                              // ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: Dimensions
                                                                      .listViewTextContSize,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(Dimensions
                                                                                .radius20),
                                                                        bottomRight:
                                                                            Radius.circular(Dimensions.radius20)),
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? Colors.grey[
                                                                            800]
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: Dimensions
                                                                            .width10,
                                                                        right: Dimensions
                                                                            .width10,
                                                                        top: Dimensions
                                                                            .height5),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        BigText(
                                                                          text: popularVideos
                                                                              .popularVideoList[index]
                                                                              .title,
                                                                          size:
                                                                              Dimensions.font18,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              Dimensions.height5,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SmallText(
                                                                              text: popularVideos.popularVideoList[index].classification.title,
                                                                              size: Dimensions.font14,
                                                                              color: Colors.grey[500],
                                                                            ),
                                                                            SmallText(
                                                                              text: popularVideos.popularVideoList[index].createTime.split('T')[0],
                                                                              size: Dimensions.font13,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              Dimensions.height10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            IconAndText(
                                                                                icon: Icons.remove_red_eye_rounded,
                                                                                text: popularVideos.popularVideoList[index].viewCount!.toString(),
                                                                                color: Colors.black,
                                                                                iconColor: Colors.orangeAccent),
                                                                            IconAndText(
                                                                                icon: Icons.favorite_rounded,
                                                                                text: popularVideos.popularVideoList[index].liked!.toList().length.toString(),
                                                                                color: Colors.black,
                                                                                iconColor: Colors.pinkAccent),
                                                                            IconAndText(
                                                                                icon: Icons.bookmark_rounded,
                                                                                text: popularVideos.popularVideoList[index].collected!.toList().length.toString(),
                                                                                color: Colors.black,
                                                                                iconColor: Colors.blueAccent)
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })));
                                      })
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: Dimensions.height20,
                                          ),
                                          const CircularProgressIndicator(
                                            color: AppColors.mainColor,
                                          )
                                        ],
                                      ),
                                // SizedBox(height: Dimensions.height45),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: Dimensions.height5,
                                        bottom: Dimensions.height10),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: SmallText(text: " © 学霸空间"),
                                        )
                                      ],
                                    ))
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  SizedBox(
                                    height: Dimensions.height30,
                                  ),
                                  const CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  ),
                                  SizedBox(
                                    height: Dimensions.height30,
                                  ),
                                  SmallText(text: "正在加载分类中 ... "),
                                ]);
                    }),
                  ],
                );
        })
      ],
    );
  }
}
