import 'dart:async';

import 'dart:ui' as ui;
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:xueba/controller/auth_controller.dart';
import 'package:xueba/controller/video_controller.dart';
import 'package:xueba/controller/index_show_video_controller.dart';
import 'package:xueba/models/video_model.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:xueba/widgets/icon_and_text.dart';
import 'package:xueba/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/user_controller.dart';

class VideoPageBody extends StatefulWidget {
  bool ok;
  VideoPageBody({
    Key? key,
    required this.ok,
  }) : super(key: key);

  @override
  State<VideoPageBody> createState() => _VideoPageBodyState();
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

class _VideoPageBodyState extends State<VideoPageBody> {
  PageController pageController =
      PageController(viewportFraction: 0.9, keepPage: true);
  late TutorialCoachMark tutorialCoachMark;
  OverlayEntry? _overlayEntry;
  final GlobalKey detail = GlobalKey();

  //定时器自动轮播
  late Timer _timer;
  var _currPageValue = 0.0;
  var maxPage = 0;
  var length = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;
  bool hasMore = true; //判断有没有数据

  // ignore: non_constant_identifier_names
  String Token = '';
  String latest = '';
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _getToken();
    // _getNotice();

    //_getData();
    //监听滚动事件，打印滚动位置
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });

    // if (widget.ok == true && Get.find<AuthController>().userUsed() == true) {
    //   createTutorial();
    //   Future.delayed(const Duration(seconds: 1), showTutorial);
    // }
  }

  @override
  void didUpdateWidget(VideoPageBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the 'ok' value changed from false to true

    if (oldWidget.ok == false &&
        widget.ok == true &&
        Get.find<AuthController>().userUsed() == false) {
      createTutorial();
      Future.delayed(const Duration(seconds: 0), showTutorial);
    }
  }

  double _getSize() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Lottie.asset('assets/image/animation.json',
            width: Dimensions.height45 * 10, height: Dimensions.height45 * 10),
      ),
    );

    Navigator.of(context).overlay?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  // _getNotice() async {
  //   await Get.find<UserController>().getNotice();
  // }

  // //获取数据
  // _getData() async {
  //   if (hasMore) {
  //     Response response = await Get.find<VideoController>().getVideoList();
  //     setState(() {});
  //     //判断是否是最后一页
  //     if (response.statusCode != 200) {
  //       if (response.statusCode == 403) {
  //         showCustomSnacker("网络错误！", title: '出错啦');
  //         setState(() {
  //           this.hasMore = true;
  //         });
  //       } else {
  //         setState(() {
  //           this.hasMore = false;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         this.hasMore = true;
  //         print(response.statusCode);
  //       });
  //     }
  //   }
  // }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print("Token");
    // print(Token.isEmpty);
    //setState(() {});
  }

  _shareVideo(String shareUrl) {
    Share.share(shareUrl);
    //print("Token");
    // print(Token.isEmpty);
    //setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    //super.initState();

    pageController.dispose();
    _timer.cancel();
  }

  void startTimer() {
    //间隔两秒时间
    _timer = Timer.periodic(const Duration(milliseconds: 3000), (value) {
      //print("定时器");
      //触发轮播切换
      if (_currPageValue.floor() + 1 >= maxPage && pageController.hasClients) {
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 600), curve: Curves.linear);
      } else if (pageController.hasClients) {
        pageController.animateToPage(_currPageValue.floor() + 1,
            duration: Duration(milliseconds: maxPage * 100),
            curve: Curves.linear);
      }

      // //刷新
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });
    return Stack(children: [
      Column(
        children: [
          //slider
          GetBuilder<IndexShowVideoController>(builder: (indexShowVideos) {
            return indexShowVideos.isLoaded
                ? SizedBox(
                    height: Dimensions.pageView,
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: indexShowVideos.indexShowVideoList.isEmpty
                            ? 0
                            : indexShowVideos.indexShowVideoList.length,
                        itemBuilder: (context, position) {
                          maxPage = indexShowVideos.indexShowVideoList.length;

                          return _buildPageItem(
                            position,
                            indexShowVideos.indexShowVideoList[position],
                          );
                        }),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: Dimensions.pageView / 2,
                      ),
                      const CircularProgressIndicator(
                        color: AppColors.mainColor,
                      )
                    ],
                  );
          }),
          //dots
          GetBuilder<IndexShowVideoController>(builder: (IndexShowVideos) {
            return DotsIndicator(
              dotsCount: IndexShowVideos.indexShowVideoList.isEmpty
                  ? 1
                  : IndexShowVideos.indexShowVideoList.length,
              position: _currPageValue.round(),
              decorator: DotsDecorator(
                activeColor: AppColors.mainColor,
                size: const ui.Size.square(9.0),
                activeSize: const ui.Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            );
          }),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.campaign_rounded,
                      color: Colors.deepOrangeAccent,
                      size: Dimensions.iconSize24,
                    ),
                    //BigText(text: "公告 ", size: Dimensions.font25),
                    SizedBox(
                      width: Dimensions.width5,
                    ),

                    Expanded(
                      // margin: EdgeInsets.only(
                      //     left: Dimensions.width5, right: Dimensions.width5),
                      // width: Dimensions.width45 * 7,

                      child: Container(
                          height: Dimensions.height30,
                          child: Marquee(
                            text: Get.find<UserController>().notice,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.font18),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 20.0,
                            velocity: 100.0,
                            pauseAfterRound: const Duration(seconds: 3),
                            //startPadding: 10.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration:
                                const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          )),
                    ),
                    SizedBox(
                      width: Dimensions.width5,
                    ),
                  ])),
          //text 最新发布
          SizedBox(
            height: Dimensions.height5,
          ),

          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // margin: EdgeInsets.only(left: Dimensions.width20),
              children: [
                SizedBox(
                  width: Dimensions.width30,
                ),
                GestureDetector(
                  onDoubleTap: () {
                    _showOverlay(context);
                    // _showOverlay(context);
                    Future.delayed(const Duration(seconds: 8), _removeOverlay);
                  },
                  child: BigText(
                    text: "最新发布 ",
                    size: Dimensions.font25,
                  ),
                ),

                // margin: EdgeInsets.only(
                //   bottom: 3,
                //   left: Dimensions.width5,
                //   right: Dimensions.width10,
                // ),

                Expanded(
                    child: latest.isEmpty
                        ? Container(
                            // margin: EdgeInsets.symmetric(vertical: 20),
                            margin: EdgeInsets.only(
                                // left: Dimensions.width10,
                                right: Dimensions.width10),
                            height: Dimensions.height15,
                            width: Dimensions.width15,
                            child: const ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.mainColor,
                                ),
                                backgroundColor: Color(0xffD6D6D6),
                              ),
                            ),
                          )
                        // Container(
                        //     margin: EdgeInsets.only(left: Dimensions.width20),
                        //     height: Dimensions.height15,
                        //     width: Dimensions.width15,
                        //     child: const LinearProgressIndicator(
                        //       color: AppColors.mainColor,
                        //       // strokeWidth: 2.0,
                        //     ),
                        //   )
                        : SmallText(
                            text: "最近更新于 " + latest,
                            color: Colors.grey[600],
                          )
                    // SizedBox(
                    //   width: Dimensions.width10,
                    // ),
                    ),
                SizedBox(
                  width: Dimensions.width10,
                ),
              ]),

          // list of latest videos
          GetBuilder<VideoController>(builder: (latestVideos) {
            if (latestVideos.videoList.isNotEmpty) {
              latest = latestVideos.videoList[0].createTime.split('T')[0];
            }

            return latestVideos.isLoaded
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                            key: detail,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: latestVideos.videoList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (() {
                                  Get.toNamed(
                                      RouteHelper.getLatestVideo(index));
                                  latestVideos.videoList[index].viewCount++;
                                }),
                                child: Slidable(
                                  // Specify a key if the Slidable is dismissible.
                                  // key: const ValueKey(1),

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
                                            width: Dimensions.width45 * 10,
                                            context: context,
                                            dialogType: DialogType.info,
                                            title: '分享',
                                            desc: '该网页链接 可在浏览器中打开',
                                            btnOkText: '分享此视频',
                                            btnOkOnPress: () {
                                              _shareVideo(latestVideos
                                                  .videoList[index].url
                                                  .toString()
                                                  .replaceAll(
                                                      '/video/', '/detail/')
                                                  .replaceAll(
                                                      '/api/', '/video/'));
                                            },
                                            btnCancelText: '在浏览器打开',
                                            btnCancelOnPress: () {
                                              _launchUrl(Uri.parse(latestVideos
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
                                        backgroundColor:
                                            const Color(0xFF21B7CA),
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
                                          var list = latestVideos
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
                                            latestVideos.videoList[index].liked!
                                                .add('new one');
                                            setState(() {});
                                            // setState(() {
                                            //   addLike = 1;
                                            // });
                                            // debugPrint(addLike.toString());
                                          } else {
                                            latestVideos.videoList[index].liked!
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
                                          var list = latestVideos
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
                                            latestVideos
                                                .videoList[index].collected!
                                                .add('new one');
                                            setState(() {});
                                            // setState(() {
                                            //   addLike = 1;
                                            // });
                                            // debugPrint(addLike.toString());
                                          } else {
                                            latestVideos
                                                .videoList[index].collected!
                                                .removeLast();
                                            setState(() {});
                                          }
                                          await Get.find<VideoController>()
                                              .updateCollect();
                                          // debugPrint(is_liked.toString());
                                        },
                                        backgroundColor: Colors
                                            .lightBlue, //Color(0xFF0392CF),
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
                                        top: Dimensions.height10,
                                        left: Dimensions.width15,
                                        right: Dimensions.width15,
                                        bottom: Dimensions.height5 / 2),
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                            width: Dimensions.iconSize24 * 5,
                                            height: Dimensions.iconSize24 * 5,
                                            imageUrl: latestVideos
                                                    .videoList[index].cover! +
                                                '/?tk=' +
                                                Token,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                Dimensions
                                                                    .radius20),
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
                                            errorWidget:
                                                (context, url, error) => Column(
                                                      children: [
                                                        SizedBox(
                                                          height: Dimensions
                                                              .height20,
                                                        ),
                                                        Icon(
                                                          Icons.error,
                                                          size: Dimensions
                                                                  .iconSize24 *
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
                                        //       color: index.isEven
                                        //           ? AppColors.mainColor
                                        //           : AppColors.yellowColor,
                                        //       image: DecorationImage(
                                        //           opacity: Theme.of(context)
                                        //                       .brightness ==
                                        //                   Brightness.dark
                                        //               ? 0.9
                                        //               : 1,
                                        //           fit: BoxFit.cover,
                                        //           image: NetworkImage(
                                        //             latestVideos.videoList[index]
                                        //                     .cover! +
                                        //                 '/?tk=' +
                                        //                 Token,
                                        //           ))),
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
                                              color: Theme.of(context)
                                                          .brightness ==
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
                                                    text: latestVideos
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
                                                        text: latestVideos
                                                            .videoList[index]
                                                            .classification
                                                            .title,
                                                        size: Dimensions.font14,
                                                        color: Colors.grey[500],
                                                      ),
                                                      SmallText(
                                                        text: latestVideos
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
                                                          text: latestVideos
                                                              .videoList[index]
                                                              .viewCount!
                                                              .toString(),
                                                          color: Colors.black,
                                                          iconColor: Colors
                                                              .orangeAccent),
                                                      IconAndText(
                                                          icon: Icons
                                                              .favorite_rounded,
                                                          text: latestVideos
                                                              .videoList[index]
                                                              .liked!
                                                              .toList()
                                                              .length
                                                              .toString(),
                                                          color: Colors.black,
                                                          iconColor: Colors
                                                              .pinkAccent),
                                                      IconAndText(
                                                          icon: Icons
                                                              .bookmark_rounded,
                                                          text: latestVideos
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
                                ),
                              );
                            })))
                : Column(
                    children: [
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      const CircularProgressIndicator(
                        color: AppColors.mainColor,
                      )
                    ],
                  );
          })

          // image-text
        ],
      )
    ]);
  }

  Widget _buildPageItem(
    int index,
    Results video,
  ) {
    //print(authController.getUserToken());
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getIndexShowVideo(index));
                video.viewCount = video.viewCount! + 1;
              },
              child: Container(
                height: Dimensions.pageViewContainer,
                margin: EdgeInsets.only(
                    left: Dimensions.width10, right: Dimensions.width10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: index.isEven
                      ? const Color(0xFF69c5df)
                      : const Color(0xFF9294cc),
                ),
                child: CachedNetworkImage(
                  // width: Dimensions.iconSize24 * 5,
                  // height: Dimensions.iconSize24 * 5,
                  imageUrl: '${video.cover!}/?tk=$Token',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) {
                    return ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimensions.radius30)),
                        child: const LinearProgressIndicator(
                          color: AppColors.mainColor,
                        ));
                  },
                  errorWidget: (context, url, error) => Column(
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
                  ),
                ),
              )
              // Container(
              //   height: Dimensions.pageViewContainer,
              //   margin: EdgeInsets.only(
              //       left: Dimensions.width10, right: Dimensions.width10),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(Dimensions.radius30),
              //       color: index.isEven
              //           ? const Color(0xFF69c5df)
              //           : const Color(0xFF9294cc),
              //       image: DecorationImage(
              //           opacity: Theme.of(context).brightness == Brightness.dark
              //               ? 0.9
              //               : 1,
              //           fit: BoxFit.cover,
              //           image: NetworkImage('${video.cover!}/?tk=$Token'))),

              // ),
              ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              //width: 300,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.height15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0x00303030)
                          : const Color(0xFFe8e8e8),
                      offset: const Offset(0, 5),
                      blurRadius: 5.0,
                    )
                  ]),
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height20, bottom: Dimensions.height5),
                padding: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BigText(
                      text: video.title!,
                      size: Dimensions.font18,
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          text: video.classification!.title!,
                          size: Dimensions.font15,
                          color: Colors.grey[500],
                        ),
                        SmallText(
                          text: video.createTime!.split('T')[0],
                          size: Dimensions.font15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconAndText(
                            icon: Icons.remove_red_eye_rounded,
                            text: video.viewCount!.toString(),
                            color: Colors.black,
                            iconColor: Colors.orangeAccent),
                        IconAndText(
                            icon: Icons.favorite_rounded,
                            text: video.liked!.toList().length.toString(),
                            color: Colors.black,
                            iconColor: Colors.pinkAccent),
                        IconAndText(
                            icon: Icons.bookmark_rounded,
                            text: video.collected!.toList().length.toString(),
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
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.green,
      hideSkip: true,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () async {
        _showOverlay(context);
        Future.delayed(const Duration(seconds: 8), _removeOverlay);
        await Get.find<AuthController>().saveUserUsed();
        // print("finish");
      },
      // onClickTarget: (target) {
      //   print('onClickTarget: $target');
      // },
      // onClickTargetWithTapPosition: (target, tapDetails) {
      //   print("target: $target");
      //   print(
      //       "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      // },
      // onClickOverlay: (target) {
      //   print('onClickOverlay: $target');
      // },
      // onSkip: () {
      //   print("skip");
      // },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: detail,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   height: Dimensions.height45,
                  // ),
                  Text(
                    "视频列表",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Dimensions.font25),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: Dimensions.height15),
                      child: Center(
                        child: Text(
                          "左划 点赞收藏\n右划 分享视频",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: Dimensions.font20),
                        ),
                      )),
                ],
              );
            },
          ),
        ],
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
      ),
    );
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 1",
    //     keyTarget: user,
    //     color: Colors.teal,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         builder: (context, controller) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "用户信息",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   fontSize: Dimensions.font25,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: Dimensions.height10),
    //                 child: Text(
    //                   "单击查看",
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: Dimensions.font20,
    //                   ),
    //                 ),
    //               ),
    //               // SizedBox(
    //               //   height: Dimensions.height20,
    //               // ),
    //               // ElevatedButton(
    //               //   onPressed: () {
    //               //     controller.previous();
    //               //   },
    //               //   child: const Icon(Icons.chevron_left),
    //               // ),
    //               // SizedBox(
    //               //   height: Dimensions.height45,
    //               // ),
    //               // Text(
    //               //   "点击 任意地方继续",
    //               //   style: TextStyle(
    //               //     fontWeight: FontWeight.bold,
    //               //     color: Colors.white,
    //               //     fontSize: Dimensions.font18,
    //               //   ),
    //               // ),
    //             ],
    //           );
    //         },
    //       )
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //     radius: Dimensions.height5,
    //     enableOverlayTab: true,
    //   ),
    // );
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 2",
    //     keyTarget: noti,
    //     color: Colors.deepOrange,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         builder: (context, controller) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "通知消息",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   fontSize: Dimensions.font25,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: Dimensions.height10),
    //                 child: Text(
    //                   "单击查看",
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: Dimensions.font20,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //       )
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //     radius: Dimensions.height5,
    //     enableOverlayTab: true,
    //   ),
    // );
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 3",
    //     keyTarget: scan,
    //     color: Colors.lightGreen[800],
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         builder: (context, controller) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "扫码登录",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   fontSize: Dimensions.font25,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: Dimensions.height10),
    //                 child: Text(
    //                   "单击查看",
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: Dimensions.font20,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //       )
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //     radius: Dimensions.height5,
    //     enableOverlayTab: true,
    //   ),
    // );

    return targets;
  }
}
