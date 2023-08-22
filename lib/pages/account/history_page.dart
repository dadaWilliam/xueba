import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xueba/controller/auth_controller.dart';
import 'package:xueba/controller/user_controller.dart';
import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';

import 'package:xueba/widgets/big_text.dart';
import 'package:xueba/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../routes/route_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
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

Future<bool> deleteVideoHistory(String delete) async {
  final url = Uri.parse(delete);

  final response = await http.delete(url);
  // print(url);
  // print(url);

  if (response.statusCode == 204) {
    // print('Delete successful');
    return true;
  } else {
    // print(response.statusCode);
    // print('Failed to delete the item: ${response.body}');
    return false;
  }
}

class _HistoryPageState extends State<HistoryPage> {
  int _userId = -1;

  var Token;
  final PageController _controller = PageController(keepPage: true);

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
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

    _getUser();
    _getToken();
    Get.find<UserController>().isHistoryUpdate = true;
    _getHistory();
    Jiffy.setLocale("zh_cn");
    // Jiffy.locale("zh_cn");
  }

  // 获取数据
  _getUser() {
    _userId = Get.find<AuthController>().getUserId();
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      Get.find<UserController>().getUserInfo(_userId);
    }
    //print(_userId);
    setState(() {});
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print(Token);
    setState(() {});
  }

  _getHistory() async {
    await Get.find<UserController>().getHistory();
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
    return Scaffold(
      // backgroundColor: Theme.of(context).brightness == Brightness.dark
      //     ? Color(0x303030)
      //     : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.mainColor,
        title: BigText(
          text: "历史记录",
          size: Dimensions.font20,
          color: Colors.white,
        ),
      ),
      body: GetBuilder<UserController>(builder: (user) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: Dimensions.height10),
          child: Column(children: [
            // AppIcon(
            //   icon: Icons.supervisor_account_rounded,
            //   backgroundColor: AppColors.mainColor,
            //   iconColor: Colors.white,
            //   size: Dimensions.iconSize24 * 5,
            //   iconSize: Dimensions.iconSize24 * 3,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BigText(
                  text: '视频',
                  size: Dimensions.font18,
                ),
                BigText(text: '观看时间', size: Dimensions.font18),
              ],
            ),
            SizedBox(
              height: Dimensions.height10,
            ),

            Expanded(
              child: EasyRefresh.builder(
                  // header: ClassicHeader(
                  //   dragText: '下拉刷新',
                  //   processingText: '正在刷新中...',
                  //   messageText: '最后更新于 %T',
                  //   armedText: '释放刷新',
                  //   processedText: '刷新成功',
                  //   noMoreText: '没有更多了',
                  //   failedText: '刷新失败',
                  // ),

                  header: const PhoenixHeader(skyColor: AppColors.mainColor),
                  // footer: ClassicFooter(),
                  footer: const TaurusFooter(
                      skyColor: AppColors.mainColor, springRebound: true),
                  onRefresh: () async {
                    Get.find<UserController>().isHistoryUpdate = true;
                    _getHistory();
                    // Get.find<IndexShowVideoController>().isUpdate = true;
                    // await Get.find<IndexShowVideoController>()
                    //     .getIndexShowVideoList();
                    // Get.find<VideoController>().isUpdate = true;
                    // Get.find<VideoController>().page = 1;
                    // Response response =
                    //     await Get.find<VideoController>().getVideoList();
                    // //const Duration(seconds: 10);
                    // if (response.statusCode == 200) {
                    //   //showCustomGreenSnacker('刷新成功!', title: '通知');
                    //   Get.find<VideoController>().page = 2;
                    //   return IndicatorResult.success;
                    // } else {
                    //   showCustomSnacker('刷新失败!', title: '请注意');
                    //   return IndicatorResult.fail;
                    // }
                  },
                  onLoad: () async {
                    _getHistory();
                    await Future.delayed(const Duration(seconds: 1));

                    // Get.find<VideoController>().isLoaded = false;
                    // Response response =
                    //     await Get.find<VideoController>().getVideoList();
                    // // const Duration(seconds: 10);
                    // if (response.statusCode == 200) {
                    //   return IndicatorResult.success;
                    // } else if (response.statusCode == 404) {
                    //   showCustomGreenSnacker('已全部加载完毕!', title: '请注意');
                    //   return IndicatorResult.noMore;
                    // } else {
                    //   showCustomSnacker('刷新失败!', title: '请注意');
                    //   return IndicatorResult.fail;
                    // }
                  },
                  childBuilder: (context, physics) {
                    return SingleChildScrollView(
                        controller: _controller,
                        physics: physics,
                        child: GetBuilder<UserController>(builder: (histories) {
                          return histories.isHistoryLoaded
                              ? Column(children: [
                                  histories.historyList.length > 0
                                      ? ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              histories.historyList.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: (() {
                                                Get.toNamed(
                                                    RouteHelper.getHistoryVideo(
                                                        index));
                                                // histories.historyList[index].viewCount++;
                                                // var list =
                                                //     histories.historyList[index].url!.split('/');
                                                // var video_id = list[list.length - 2];
                                                // Get.find<VideoController>().video_id =
                                                //     int.parse(video_id);
                                                // //_updateVideo();
                                              }),
                                              child: Slidable(
                                                // Specify a key if the Slidable is dismissible.
                                                // key:  const ValueKey(0),
                                                key: UniqueKey(),
                                                // The start action pane is the one at the left or the top side.
                                                startActionPane: ActionPane(
                                                  // A motion is a widget used to control how the pane animates.
                                                  motion:
                                                      const DrawerMotion(), //ScrollMotion(),
                                                  // dismissible: DismissiblePane(
                                                  //     onDismissed: () {}),
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
                                                        // _shareVideo(latestVideos
                                                        //     .videoList[index].url
                                                        //     .toString()
                                                        //     .replaceAll('/api/', '/'));
                                                        // setState(() {});
                                                        AwesomeDialog(
                                                          width: Dimensions
                                                                  .width45 *
                                                              10,
                                                          context: context,
                                                          dialogType:
                                                              DialogType.info,
                                                          title: '分享',
                                                          desc:
                                                              '该网页链接 可在浏览器中打开',
                                                          btnOkText: '分享此视频',
                                                          btnOkOnPress: () {
                                                            Share.share(histories
                                                                .historyList[
                                                                    index]
                                                                .video[0]
                                                                .url
                                                                .toString()
                                                                .replaceAll(
                                                                    '/video/',
                                                                    '/detail/')
                                                                .replaceAll(
                                                                    '/api/',
                                                                    '/video/'));
                                                          },
                                                          btnCancelText:
                                                              '在浏览器打开',
                                                          btnCancelOnPress: () {
                                                            _launchUrl(Uri.parse(histories
                                                                .historyList[
                                                                    index]
                                                                .video[0]
                                                                .url
                                                                .toString()
                                                                .replaceAll(
                                                                    '/video/',
                                                                    '/detail/')
                                                                .replaceAll(
                                                                    '/api/',
                                                                    '/video/')));
                                                          },
                                                        ).show();
                                                      },
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF21B7CA),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.share_rounded,
                                                      label: '分享',
                                                    ),
                                                  ],
                                                ),

                                                // The end action pane is the one at the right or the bottom side.
                                                endActionPane: ActionPane(
                                                  motion: const DrawerMotion(),
                                                  dismissible: DismissiblePane(
                                                      onDismissed: () async {
                                                    // _dialogBuilder(context);
                                                    var ok = deleteVideoHistory(
                                                      '${histories.historyList[index].url}?tk=$Token'
                                                          .replaceAll(
                                                              'http', 'https'),
                                                    );
                                                    if (await ok) {
                                                      setState(() {
                                                        histories.historyList
                                                            .removeAt(index);
                                                      });

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        content: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                              size: Dimensions
                                                                  .iconSize24,
                                                            ),
                                                            SizedBox(
                                                              width: Dimensions
                                                                  .width5,
                                                            ),
                                                            BigText(
                                                              text: '删除成功',
                                                              size: Dimensions
                                                                  .font18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor: Colors
                                                            .deepOrangeAccent,
                                                        content: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .error_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: Dimensions
                                                                  .iconSize24,
                                                            ),
                                                            SizedBox(
                                                              width: Dimensions
                                                                  .width5,
                                                            ),
                                                            BigText(
                                                              text: '删除失败',
                                                              size: Dimensions
                                                                  .font18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                    }
                                                  }),
                                                  children: [
                                                    // SlidableAction(
                                                    //   onPressed: null,
                                                    //   backgroundColor:
                                                    //       Color(0xFFFE4A49),
                                                    //   foregroundColor: Colors.white,
                                                    //   icon: Icons.delete,
                                                    //   label: 'Delete',
                                                    // ),
                                                    SlidableAction(
                                                      // An action can be bigger than the others.
                                                      // flex: 2,

                                                      onPressed: (value) {
                                                        AwesomeDialog(
                                                          width: Dimensions
                                                                  .width45 *
                                                              10,
                                                          context: context,
                                                          dialogType: DialogType
                                                              .question,
                                                          title: '需要删除吗',
                                                          desc: '向左 继续滑动 确认删除',
                                                          btnOkText: '我知道了',
                                                          btnOkOnPress: () {},
                                                        ).show();
                                                        // setState(() {
                                                        //   histories.historyList
                                                        //       .removeAt(index);
                                                        // });
                                                      },
                                                      backgroundColor: Colors
                                                          .red, //Color(0xFF7BC043),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.delete,
                                                      label: '删除',
                                                    ),
                                                    // SlidableAction(
                                                    //   onPressed: (value) {},
                                                    //   backgroundColor: Colors
                                                    //       .lightBlue, //Color(0xFF0392CF),
                                                    //   foregroundColor: Colors.white,
                                                    //   icon: Icons
                                                    //       .bookmark_add_rounded,
                                                    //   label: '收藏',
                                                    // ),
                                                  ],
                                                ),

                                                // The child of the Slidable is what the user sees when the
                                                // component is not dragged.
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: Dimensions.height10,
                                                      left: Dimensions.width15,
                                                      right: Dimensions.width15,
                                                      bottom:
                                                          Dimensions.height10),
                                                  child:
                                                      histories
                                                                  .historyList[
                                                                      index]
                                                                  .video !=
                                                              null
                                                          ? Row(
                                                              children: [
                                                                CachedNetworkImage(
                                                                    width: Dimensions
                                                                            .iconSize24 *
                                                                        5,
                                                                    height:
                                                                        Dimensions.iconSize24 *
                                                                            5,
                                                                    imageUrl: histories
                                                                            .historyList[
                                                                                index]
                                                                            .video[
                                                                                0]
                                                                            .cover! +
                                                                        '/?tk=' +
                                                                        Token,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                              decoration: BoxDecoration(
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
                                                                          color:
                                                                              AppColors.mainColor,
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorWidget: (context,
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
                                                                //           BorderRadius.circular(
                                                                //               Dimensions
                                                                //                   .radius20),
                                                                //       color: Colors
                                                                //           .white24,
                                                                //       image: DecorationImage(
                                                                //           opacity: Theme.of(context).brightness == Brightness.dark
                                                                //               ? 0.9
                                                                //               : 1,
                                                                //           fit: BoxFit
                                                                //               .cover,
                                                                //           image: NetworkImage(histories
                                                                //                   .historyList[index]
                                                                //                   .video[0]
                                                                //                   .cover! +
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
                                                                          topRight: Radius.circular(Dimensions
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
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          BigText(
                                                                            text:
                                                                                histories.historyList[index].video[0].title.toString(),
                                                                            size:
                                                                                Dimensions.font18,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.height5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.history_toggle_off_rounded,
                                                                                size: Dimensions.iconSize16 * 1.3,
                                                                                color: Colors.cyan,
                                                                              ),
                                                                              SizedBox(
                                                                                width: Dimensions.width5,
                                                                              ),
                                                                              BigText(
                                                                                text:
                                                                                    // histories
                                                                                    //     .historyList[index]
                                                                                    //     .viewedOn
                                                                                    //     .split('.')[0]
                                                                                    //     .replaceAll('T', ' '),

                                                                                    Jiffy.parse(histories.historyList[index].viewedOn).fromNow(),
                                                                                size: Dimensions.font18,
                                                                                color: Colors.cyan,
                                                                              )
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
                                                                              SmallText(
                                                                                text: histories.historyList[index].video[0].classification.title,
                                                                                size: Dimensions.font14,
                                                                                color: Colors.grey[500],
                                                                              ),
                                                                              SmallText(
                                                                                text: histories.historyList[index].video[0].createTime.split('T')[0],
                                                                                size: Dimensions.font13,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.height10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          : Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height: Dimensions
                                                                        .listViewTextContSize,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            Dimensions.radius20),
                                                                      ),
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
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          BigText(
                                                                            text:
                                                                                "你似乎来到了没有知识存在的荒原...",
                                                                            size:
                                                                                Dimensions.font18,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.height5,
                                                                          ),
                                                                          BigText(
                                                                            text:
                                                                                "此视频不见啦  向左滑动删除 ",
                                                                            size:
                                                                                Dimensions.font15,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                ),
                                              ),
                                            );
                                          })
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                              height: Dimensions.height45 * 3,
                                            ),
                                            Center(
                                                child: Image.asset(
                                              'assets/image/empty_box.png',
                                              width: Dimensions.width10 * 12,
                                            )),
                                            SizedBox(
                                              height: Dimensions.height20,
                                            ),
                                            Center(
                                              child: BigText(
                                                text: "这里空空的~",
                                                color: AppColors.mainColor,
                                                size: Dimensions.font30,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Dimensions.height45 * 5,
                                            ),
                                          ],
                                        )
                                ])
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: Dimensions.screenHeight * 0.3,
                                    ),
                                    Container(
                                      height: Dimensions.height45,
                                      width: Dimensions.width45,
                                      margin: EdgeInsets.all(Dimensions.width5),
                                      child: const CircularProgressIndicator(
                                        color: AppColors.mainColor,
                                        strokeWidth: 5.0,
                                      ),
                                    )
                                  ],
                                );
                        }));
                  }),
            )
          ]),
        );
      }),
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

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Basic dialog title'),
        content: const Text('A dialog is a type of modal window that\n'
            'appears in front of app content to\n'
            'provide critical information, or prompt\n'
            'for a decision to be made.'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Disable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Enable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
