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

import '../../controller/video_controller.dart';
import '../../routes/route_helper.dart';
import '../../widgets/icon_and_text.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);

  @override
  State<LikePage> createState() => _LikePageState();
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

class _LikePageState extends State<LikePage> {
  // int _userId = -1;

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

    // _getUser();
    _getToken();
    Get.find<UserController>().isLikedUpdate = true;
    _getLiked();
    Jiffy.setLocale("zh_cn");
    // Jiffy.locale("zh_cn");
  }

  // 获取数据
  // _getUser() {
  //   _userId = Get.find<AuthController>().getUserId();
  //   bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
  //   if (userLoggedIn) {
  //     Get.find<UserController>().getUserInfo(_userId);
  //   }
  //   //print(_userId);
  //   setState(() {});
  // }

  _shareVideo(String shareUrl) {
    Share.share(shareUrl);
    //print("Token");
    // print(Token.isEmpty);
    //setState(() {});
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print(Token);
    setState(() {});
  }

  _getLiked() async {
    await Get.find<UserController>().getLiked();
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
          text: "我的喜欢",
          size: Dimensions.font20,
          color: Colors.white,
        ),
      ),
      body: GetBuilder<UserController>(builder: (user) {
        return SizedBox(
          width: double.maxFinite,
          // margin: EdgeInsets.only(top: Dimensions.height10),
          child: Column(children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     BigText(
            //       text: '视频列表',
            //       size: Dimensions.font18,
            //     ),
            //     // BigText(text: '观看时间', size: Dimensions.font18),
            //   ],
            // ),
            // SizedBox(
            //   height: Dimensions.height10,
            // ),
            Expanded(
              child: EasyRefresh.builder(
                  header: const PhoenixHeader(skyColor: AppColors.mainColor),
                  // footer: ClassicFooter(),
                  footer: const TaurusFooter(
                      skyColor: AppColors.mainColor, springRebound: true),
                  onRefresh: () async {
                    Get.find<UserController>().isLikedUpdate = true;
                    _getLiked();
                  },
                  onLoad: () async {
                    _getLiked();
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  childBuilder: (context, physics) {
                    return SingleChildScrollView(
                        controller: _controller,
                        physics: physics,
                        child: GetBuilder<UserController>(builder: (likes) {
                          return likes.isLikedLoaded
                              ? Column(children: [
                                  likes.likedList.isEmpty
                                      ? Column(
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
                                      :
                                      //  likes.likedList.length == 0?

                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: likes.likedList.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: (() {
                                                  Get.toNamed(
                                                      RouteHelper.getLikeVideo(
                                                          index));
                                                  // Get.toNamed(
                                                  //     RouteHelper.getSearchVideo(
                                                  //         index));
                                                  // likes.likedList[index].viewCount++;
                                                  // var list =
                                                  //     searchVideos.videoList[index].url!.split('/');
                                                  // var videoId = list[list.length - 2];
                                                  // Get.find<VideoController>().video_id =
                                                  //     int.parse(videoId);
                                                  // _updateVideo();
                                                }),
                                                child: Slidable(
                                                  // Specify a key if the Slidable is dismissible.
                                                  key: UniqueKey(),

                                                  // The start action pane is the one at the left or the top side.
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
                                                              _shareVideo(likes
                                                                  .likedList[
                                                                      index]
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
                                                            btnCancelOnPress:
                                                                () {
                                                              _launchUrl(Uri.parse(likes
                                                                  .likedList[
                                                                      index]
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

                                                          setState(() {});
                                                        },
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF21B7CA),
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon:
                                                            Icons.share_rounded,
                                                        label: '分享',
                                                      ),
                                                    ],
                                                  ),

                                                  // The end action pane is the one at the right or the bottom side.
                                                  endActionPane: ActionPane(
                                                    motion:
                                                        const DrawerMotion(),
                                                    dismissible:
                                                        DismissiblePane(
                                                            onDismissed:
                                                                () async {
                                                      var list = likes
                                                          .likedList[index].url
                                                          .split('/');
                                                      var videoId =
                                                          list[list.length - 2];
                                                      //debugPrint(video_id);
                                                      Get.find<VideoController>()
                                                              .video_id =
                                                          int.parse(videoId);
                                                      // var isLiked = await Get.find<
                                                      //         VideoController>()
                                                      //     .isLike();
                                                      var snackBar = SnackBar(
                                                        backgroundColor: Colors
                                                            .pinkAccent
                                                            .withOpacity(0.95),
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
                                                              text:
                                                                  '成功移出 我的喜欢 ',
                                                              size: Dimensions
                                                                  .font18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      );

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);

                                                      await Get.find<
                                                              VideoController>()
                                                          .updateLike();
                                                      setState(() {
                                                        likes.likedList
                                                            .removeAt(index);
                                                      });

                                                      // debugPrint(is_liked.toString());
                                                    }),
                                                    children: [
                                                      SlidableAction(
                                                        // An action can be bigger than the others.
                                                        // flex: 2,
                                                        onPressed:
                                                            (value) async {
                                                          AwesomeDialog(
                                                            width: Dimensions
                                                                    .width45 *
                                                                10,
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .question,
                                                            title: '需要移除喜欢吗',
                                                            desc: '向左 继续滑动 确认',
                                                            btnOkText: '我知道了',
                                                            btnOkOnPress: () {},
                                                          ).show();
                                                        },
                                                        backgroundColor: Colors
                                                            .pinkAccent, //Color(0xFF7BC043),
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon:
                                                            Icons.clear_rounded,
                                                        label: '移除喜欢',
                                                      ),
                                                    ],
                                                  ),

                                                  // The child of the Slidable is what the user sees when the
                                                  // component is not dragged.
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left:
                                                            Dimensions.width15,
                                                        right:
                                                            Dimensions.width15,
                                                        top: Dimensions
                                                            .height10),
                                                    child: Row(
                                                      children: [
                                                        CachedNetworkImage(
                                                            width: Dimensions
                                                                    .iconSize24 *
                                                                5,
                                                            height: Dimensions
                                                                    .iconSize24 *
                                                                5,
                                                            imageUrl: likes
                                                                    .likedList[
                                                                        index]
                                                                    .cover! +
                                                                '/?tk=' +
                                                                Token,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimensions.radius20),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                            placeholder:
                                                                (context, url) {
                                                              return Transform
                                                                  .scale(
                                                                scale: 0.5,
                                                                child:
                                                                    const CircularProgressIndicator(
                                                                  color: AppColors
                                                                      .mainColor,
                                                                ),
                                                              );
                                                            },
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              Dimensions.height20,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .error,
                                                                          size: Dimensions.iconSize24 *
                                                                              2,
                                                                        ),
                                                                        BigText(
                                                                            text:
                                                                                '出错啦')
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
                                                        //       color: Colors.white24,
                                                        //       image: DecorationImage(
                                                        //           opacity: Theme.of(
                                                        //                           context)
                                                        //                       .brightness ==
                                                        //                   Brightness
                                                        //                       .dark
                                                        //               ? 0.9
                                                        //               : 1,
                                                        //           fit: BoxFit.cover,
                                                        //           image: NetworkImage(likes
                                                        //                   .likedList[
                                                        //                       index]
                                                        //                   .cover! +
                                                        //               '/?tk=' +
                                                        //               Token))),
                                                        // ),

                                                        Expanded(
                                                          child: Container(
                                                            height: Dimensions
                                                                .listViewTextContSize,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          Dimensions
                                                                              .radius20),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          Dimensions
                                                                              .radius20)),
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors
                                                                      .grey[800]
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: Dimensions
                                                                      .width10,
                                                                  right: Dimensions
                                                                      .width10,
                                                                  top: Dimensions
                                                                      .height5),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  BigText(
                                                                    text: likes
                                                                        .likedList[
                                                                            index]
                                                                        .title,
                                                                    size: Dimensions
                                                                        .font18,
                                                                  ),
                                                                  SizedBox(
                                                                    height: Dimensions
                                                                        .height5,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SmallText(
                                                                        text: likes
                                                                            .likedList[index]
                                                                            .classification
                                                                            .title,
                                                                        size: Dimensions
                                                                            .font14,
                                                                        color: Colors
                                                                            .grey[500],
                                                                      ),
                                                                      SmallText(
                                                                        text: likes
                                                                            .likedList[index]
                                                                            .createTime
                                                                            .split('T')[0],
                                                                        size: Dimensions
                                                                            .font13,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: Dimensions
                                                                        .height10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      IconAndText(
                                                                          icon: Icons
                                                                              .remove_red_eye_rounded,
                                                                          text: likes
                                                                              .likedList[
                                                                                  index]
                                                                              .viewCount!
                                                                              .toString(),
                                                                          color: Colors
                                                                              .black,
                                                                          iconColor:
                                                                              Colors.orangeAccent),
                                                                      IconAndText(
                                                                          icon: Icons
                                                                              .favorite_rounded,
                                                                          text: likes
                                                                              .likedList[
                                                                                  index]
                                                                              .liked!
                                                                              .toList()
                                                                              .length
                                                                              .toString(),
                                                                          color: Colors
                                                                              .black,
                                                                          iconColor:
                                                                              Colors.pinkAccent),
                                                                      IconAndText(
                                                                          icon: Icons
                                                                              .bookmark_rounded,
                                                                          text: likes
                                                                              .likedList[
                                                                                  index]
                                                                              .collected!
                                                                              .toList()
                                                                              .length
                                                                              .toString(),
                                                                          color: Colors
                                                                              .black,
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
                                          })

                                  //
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
