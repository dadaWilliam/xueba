import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xueba/utils/app_constants.dart';
import 'package:xueba/widgets/player_marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'package:xueba/controller/index_show_video_controller.dart';
import 'package:xueba/controller/video_controller.dart';
import 'package:xueba/routes/route_helper.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/app_icon.dart';
import 'package:get/get.dart';

import 'package:marquee/marquee.dart';

import 'package:flowder/flowder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../controller/auth_controller.dart';
import '../../controller/search_controller.dart';
import '../../controller/user_controller.dart';
import '../../widgets/player_func.dart';
import '../../widgets/small_text.dart';
import '/file_models/file_model.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/player_func.dart';
import '../../widgets/icon_and_text.dart';
import 'package:chewie/chewie.dart';

class HistoryVideoDetail extends StatefulWidget {
  final int? pageId;
  final int? id;

  const HistoryVideoDetail({Key? key, this.pageId, this.id}) : super(key: key);

  @override
  State<HistoryVideoDetail> createState() => _HistoryVideoDetailState();
}

class _HistoryVideoDetailState extends State<HistoryVideoDetail> {
  VideoPlayerController? _videoPlayerController;

  ChewieController? _chewieController;
  int? bufferDelay;

  List<FileModel> fileList = [];

  DownloaderUtils? options;
  DownloaderCore? core;
  late final String download_path;

  var is_collected = false;
  var is_liked = false;
  var is_collected_ok = false;
  var is_liked_ok = false;
  var is_played = false;
  var likes = 0;
  var collects = 0;
  var progress = 0.0;

  var video;
  // var ID1 = -1;
  // var ID2 = -1;
  // var videos_index_show;
  // var videos_latest;
  // var videos_search;
  var videos_history;
  late File new_video_file;

  String Token = '';

  @override
  void initState() {
    super.initState();
    is_played == false;
    _getToken();
    _getVideo();
    _getUser();
    //initializePlayer();
    // _updateVideo();

    initPlatformState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => yourFunction(context));
    // _isLike();
    // _isCollect();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(new_video_file);

    await Future.wait([
      _videoPlayerController!.initialize(),
    ]);
    _createChewieController();
    if (mounted) {
      setState(() {});
    }
  }

  void _createChewieController() {
    final subtitles = AppConfigs().Subtitles;

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: false,
      looping: false,
      allowedScreenSleep: false,
      allowPlaybackSpeedChanging: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      showControlsOnInitialize: false,
      showOptions: false,
      zoomAndPan: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //       onTap: videoError,
      //       iconData: Icons.question_mark_rounded,
      //       title: '遇见问题',
      //     ),
      //   ];
      // },
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  Future<void> videoError() async {
    await _videoPlayerController!.pause();

    await initializePlayer();
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print(Token);
    if (mounted) {
      setState(() {});
    }
  }

  _getVideo() async {
    // videos_index_show = Get.find<IndexShowVideoController>().indexShowVideoList;
    // videos_latest = Get.find<VideoController>().videoList;
    videos_history = Get.find<UserController>().historyList;

    // videos_history = videos_his.video;
    // print(videos_history);
    await Get.find<VideoController>().getPopularVideoList();
  }

  _getUser() {
    var userId = Get.find<AuthController>().getUserId();
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      Get.find<UserController>().getUserInfo(userId);
    }
    //print(_userId);
    if (mounted) {
      setState(() {});
    }
  }

  _updateVideo() {
    // var _userId = Get.find<AuthController>().getUserId();
    // bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    // if (_userLoggedIn) {
    Get.find<VideoController>().updateVideo();
    //Get.find<IndexShowVideoController>().getIndexShowVideoList();
    // Get.find<VideoController>().isUpdate = true;
    // Get.find<VideoController>().getVideoList();
    // }
    //print(_userId);
    if (mounted) {
      setState(() {});
    }
  }

  _updateHistory() {
    Get.find<VideoController>().updateHistory();
    if (mounted) {
      setState(() {});
    }
  }

  _isLike() async {
    is_liked = await Get.find<VideoController>().isLike();
    likes = Get.find<VideoController>().likes;

    if (mounted) {
      setState(() {
        is_liked_ok = true;
      });
    }
  }

  _isCollect() async {
    is_collected = await Get.find<VideoController>().isCollect();
    collects = Get.find<VideoController>().collects;

    if (mounted) {
      setState(() {
        is_collected_ok = true;
      });
    }
  }

  _updateLike() async {
    Response response = await Get.find<VideoController>().updateLike();
    likes = Get.find<VideoController>().likes;
    if (response.statusCode == 200) {
      if (is_liked == false) {
        videos_history[widget.id].video[0].liked!.add('new one');
      } else {
        videos_history[widget.id].video[0].liked!.removeLast();
      }

      if (mounted) {
        var snackBar = SnackBar(
          backgroundColor: Colors.pinkAccent.withOpacity(0.95),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                text: is_liked ? '成功移出 我的喜欢 ' : '成功添加至 我的喜欢 ',
                size: Dimensions.font18,
                color: Colors.white,
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          is_liked = !is_liked;
        });
      }
    }
  }

  _updateCollect() async {
    Response response = await Get.find<VideoController>().updateCollect();
    collects = Get.find<VideoController>().collects;
    if (response.statusCode == 200) {
      if (is_liked == false) {
        videos_history[widget.id].video[0].collected!.add('new one');
      } else {
        videos_history[widget.id].video[0].collected!.removeLast();
      }
      if (mounted) {
        var snackBar = SnackBar(
          backgroundColor: Colors.lightBlue.withOpacity(0.95),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                text: is_collected ? '成功移出 我的收藏 ' : '成功添加至 我的收藏 ',
                size: Dimensions.font18,
                color: Colors.white,
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          is_collected = !is_collected;
        });
      }
    }
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    Directory path = await getApplicationDocumentsDirectory();

    String localPath = '${path.path}${Platform.pathSeparator}Download';

    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    download_path = localPath;
  }

  var times = 0;
  var video_id;
  var clicks = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });
    Get.find<VideoController>();
    if (widget.id != null) {
      video = videos_history[widget.id!].video[0];
      //print("id" + widget.id.toString());
      //print(" name is " + video.title!);
      times++;
    } else {
      debugPrint("id and pageId == null");
    }
    //_updateVideo();
    if (times == 1) {
      var list = video.url!.split('/');
      video_id = list[list.length - 2];
      //debugPrint(video_id);
      Get.find<VideoController>().video_id = int.parse(video_id);
      //initializePlayer();
      _updateVideo();
      _isCollect();
      _isLike();
    }

    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: MediaQuery.removePadding(
                removeTop: is_played == false ? false : false,
                context: context,
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                      automaticallyImplyLeading: false,
                      title:
                          // is_played ==
                          //         false //||Theme.of(context).platform == TargetPlatform.android

                          //     ?
                          SizedBox(
                        height: Dimensions.height45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (() {
                                _chewieController != null &&
                                        _chewieController!.videoPlayerController
                                            .value.isInitialized &&
                                        progress == 0.0
                                    ? null
                                    : core?.cancel();
                                Get.back();
                              }),
                              child: const AppIcon(
                                icon: Icons.arrow_back_ios_new_rounded,
                                backgroundColor: Colors.white54,
                              ),
                            ),
                            SizedBox(
                                width: Dimensions.screenWidth * 0.6,
                                height: Dimensions.height30,
                                child: Center(
                                    child: is_played
                                        ? PlayerMarquee(text: video.title)
                                        : null)),
                            GestureDetector(
                              onTap: (() {
                                //debugPrint(video_id);
                                print("share");
                                ShareEvent(video_id);
                              }),
                              child:
                                  const AppIcon(icon: Icons.ios_share_rounded),
                            )
                          ],
                        ),
                      ),
                      // : null,
                      bottom: PreferredSize(
                          preferredSize:
                              Size.fromHeight(Dimensions.height30 * 3),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.only(
                                top: Dimensions.height10,
                                bottom: Dimensions.height10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius20),
                                topLeft: Radius.circular(Dimensions.radius20),
                              ),
                            ),
                            child: Center(
                              child: BigText(text: video.title),
                            ),
                          )),
                      pinned: true,
                      backgroundColor:
                          // Theme.of(context).scaffoldBackgroundColor,
                          // AppColors.yellowColor,
                          Colors.black,
                      expandedHeight: is_played == false
                          ? Dimensions.videoImgSize - Dimensions.height5
                          : Theme.of(context).platform == TargetPlatform.android
                              ? Dimensions.videoImgSize + Dimensions.height20
                              : Dimensions.videoImgSize +
                                  Dimensions.height10 * 7,
                      flexibleSpace: SizedBox(
                        height: is_played == false
                            ? Dimensions.videoImgSize + Dimensions.height15
                            : Theme.of(context).platform ==
                                    TargetPlatform.android
                                ? Dimensions.videoImgSize + Dimensions.height10
                                : Dimensions.videoImgSize +
                                    Dimensions.height20 * 3,
                        child: is_played == false
                            ? GestureDetector(
                                onTap: () async {
                                  if (mounted) {
                                    setState(() {
                                      is_played = true;
                                    });
                                  }
                                  _updateHistory();
                                  var startTime = DateTime.now();
                                  var connectivityResult =
                                      await Connectivity().checkConnectivity();
                                  if (connectivityResult ==
                                      ConnectivityResult.mobile) {
                                    // I am connected to a mobile network.
                                    Fluttertoast.showToast(
                                        msg: "正在使用 数据流量 加载中...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else if (connectivityResult ==
                                      ConnectivityResult.wifi) {
                                    // I am connected to a wifi network.
                                    Fluttertoast.showToast(
                                        msg: "正在使用 Wi-Fi 加载中...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  options = DownloaderUtils(
                                    progressCallback: (current, total) {
                                      if (DateTime.now()
                                              .difference(startTime) >=
                                          Duration(seconds: 30)) {
                                        Fluttertoast.showToast(
                                            msg: "请检查下载进度，如必要退出重试",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.deepOrange,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        if (DateTime.now()
                                                .difference(startTime) >=
                                            Duration(seconds: 120)) {
                                          Fluttertoast.showToast(
                                              msg: "下载已取消，请退出重试",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          core?.cancel();
                                          debugPrint("cancelled download");
                                        }
                                      }
                                      progress = (current / total) * 100;
                                      //print('Downloading: $progress');
                                      if (mounted) {
                                        setState(() {
                                          FileModel(
                                            fileName: video.title!,
                                            url: video.file! + '/?tk=' + Token,
                                            progress: 0.0,
                                          ).progress = (current / total);
                                        });
                                      }
                                    },
                                    file:
                                        File('$download_path/${video.title!}'),
                                    progress: ProgressImplementation(),
                                    onDone: () async {
                                      debugPrint("download ok");
                                      File videoFile = File(
                                          '$download_path/${video.title!}');
                                      var oldPath = videoFile.path;
                                      var lastSeparator = download_path
                                          .lastIndexOf(Platform.pathSeparator);
                                      var newFileName = "new.mp4";
                                      var newPath = download_path.substring(
                                              0, lastSeparator + 1) +
                                          newFileName;
                                      new_video_file =
                                          await videoFile.rename(newPath);
                                      await initializePlayer();
                                      progress = 0.0;
                                    },
                                    deleteOnCancel: true,
                                  );
                                  core = await Flowder.download(
                                    video.file! + '/?tk=' + Token,
                                    options!,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          video.cover! + '/?tk=' + Token,
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Icon(
                                    Icons.play_circle_fill_rounded,
                                    size: Dimensions.iconSize24 * 2,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[800]!.withOpacity(0.9)
                                        : Colors.grey[300]!.withOpacity(0.9),
                                  ),
                                ))
                            : _chewieController != null &&
                                    _chewieController!.videoPlayerController
                                        .value.isInitialized
                                ? Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: Theme.of(context).platform ==
                                                    TargetPlatform.android
                                                ? Dimensions.height20 * 2
                                                : Dimensions.height20 * 5),
                                        child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.start,
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.start,
                                            children: [
                                              Chewie(
                                                controller: _chewieController!,
                                              ),
                                            ]),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: Dimensions.height45),
                                      // CircularPercentIndicator(
                                      //   //width: 100.0,
                                      //   lineWidth: 6.0,
                                      //   animationDuration: 5000,
                                      //   percent:
                                      //       progress >= 1 ? 0.98 : progress,
                                      //   backgroundColor: Colors.white,
                                      //   progressColor: AppColors.mainColor,
                                      //   radius: Dimensions.iconSize24,
                                      // ),
                                      const CircularProgressIndicator(
                                        color: AppColors.mainColor,
                                      ),
                                      SizedBox(height: Dimensions.height20),
                                      BigText(
                                        text: '已加载 ${progress.toInt()}%',
                                        size: Dimensions.font18,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                      )),
                  SliverToBoxAdapter(
                      child:
                          // // button left & right

                          Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.height5,
                                  bottom: Dimensions.height5),
                              padding: EdgeInsets.only(
                                  left: Dimensions.width5,
                                  right: Dimensions.width5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Get.find<SearchVideoController>()
                                              .isCleared = true;
                                          await Get.find<
                                                  SearchVideoController>()
                                              .getSearchResult();
                                          Get.find<SearchVideoController>()
                                                  .search =
                                              video.classification.title;
                                          Get.toNamed(
                                              RouteHelper.getSearchPage());
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
                                          Get.find<SearchVideoController>()
                                              .allowBack = true;
                                          await Get.find<
                                                  SearchVideoController>()
                                              .getSearchResult()
                                              .then((value) {
                                            load.dismiss();
                                          });
                                        },
                                        child: Chip(
                                          label: BigText(
                                            text: video.classification.title,
                                            size: Dimensions.font15,
                                            color: Colors.black,
                                          ),
                                          avatar: const Icon(
                                              Icons.article_outlined),
                                        ),
                                      ),
                                      Chip(
                                        label: BigText(
                                          text: video.createTime!.split('T')[0],
                                          size: Dimensions.font15,
                                          color: Colors.black,
                                        ),
                                        avatar: const Icon(
                                            Icons.access_time_rounded),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimensions.height20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconAndText(
                                        icon: Icons.remove_red_eye_rounded,
                                        text: '${video.viewCount!}次观看',
                                        color: Colors.black,
                                        iconColor: Colors.orangeAccent,
                                        size: Dimensions.iconSize16 * 2,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // is_liked
                                          //     ? video.liked.add['add']
                                          //     : video.liked.removeLast;
                                          // print(video.liked);
                                          _updateLike();
                                        },
                                        child: IconAndText(
                                          icon: Icons.favorite_rounded,
                                          text: is_liked_ok
                                              ? '$likes人喜欢'
                                              : ' 加载中',
                                          color: Colors.black,
                                          iconColor: is_liked
                                              ? Colors.pinkAccent
                                              : Colors.grey,
                                          size: Dimensions.iconSize16 * 2,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _updateCollect();
                                          // video.collected!.toList().length = collects;
                                        },
                                        child: IconAndText(
                                          icon: Icons.bookmark_rounded,
                                          text: is_collected_ok
                                              ? '$collects人收藏'
                                              : ' 加载中',
                                          color: Colors.black,
                                          iconColor: is_collected
                                              ? Colors.blueAccent
                                              : Colors.grey,
                                          size: Dimensions.iconSize16 * 2,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: Dimensions.height20,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            BigText(
                                              text: "热门内容 ",
                                              size: Dimensions.font25,
                                            ),
                                          ]),
                                      Get.find<VideoController>().ispopularOk ==
                                              true
                                          ? GetBuilder<VideoController>(
                                              builder: (popularVideos) {
                                              return SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child:
                                                      MediaQuery.removePadding(
                                                          removeTop: true,
                                                          context: context,
                                                          child:
                                                              ListView.builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      popularVideos
                                                                          .popularVideoList
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          (() {
                                                                        Get.toNamed(
                                                                            RouteHelper.getPopularVideo(index));
                                                                        popularVideos
                                                                            .popularVideoList[index]
                                                                            .viewCount++;
                                                                      }),
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                Dimensions.height5,
                                                                            left: Dimensions.width15,
                                                                            right: Dimensions.width15,
                                                                            bottom: Dimensions.height5 / 2),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            CachedNetworkImage(
                                                                                width: Dimensions.iconSize24 * 5,
                                                                                height: Dimensions.iconSize24 * 5,
                                                                                imageUrl: popularVideos.popularVideoList[index].cover! + '/?tk=' + Token,
                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                                                        image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                placeholder: (context, url) {
                                                                                  return Transform.scale(
                                                                                    scale: 0.5,
                                                                                    child: const CircularProgressIndicator(
                                                                                      color: AppColors.mainColor,
                                                                                    ),
                                                                                  );
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
                                                                                    )),

                                                                            // Container(
                                                                            //   //image
                                                                            //   width: Dimensions.listViewImgSize,
                                                                            //   height: Dimensions.listViewImgSize,
                                                                            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radius20), color: Colors.white24, image: DecorationImage(opacity: Theme.of(context).brightness == Brightness.dark ? 0.9 : 1, fit: BoxFit.cover, image: NetworkImage(popularVideos.popularVideoList[index].cover! + '/?tk=' + Token))),
                                                                            // ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                height: Dimensions.listViewTextContSize,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius20), bottomRight: Radius.circular(Dimensions.radius20)),
                                                                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, top: Dimensions.height5),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      BigText(
                                                                                        text: popularVideos.popularVideoList[index].title,
                                                                                        size: Dimensions.font18,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: Dimensions.height5,
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                        height: Dimensions.height10,
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          IconAndText(icon: Icons.remove_red_eye_rounded, text: popularVideos.popularVideoList[index].viewCount!.toString(), color: Colors.black, iconColor: Colors.orangeAccent),
                                                                                          IconAndText(icon: Icons.favorite_rounded, text: popularVideos.popularVideoList[index].liked!.toList().length.toString(), color: Colors.black, iconColor: Colors.pinkAccent),
                                                                                          IconAndText(icon: Icons.bookmark_rounded, text: popularVideos.popularVideoList[index].collected!.toList().length.toString(), color: Colors.black, iconColor: Colors.blueAccent)
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
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 0, bottom: Dimensions.height30),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: SmallText(text: " © 学霸空间"),
                                          )
                                        ],
                                      ))
                                ],
                              )))
                ]))));
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave})
      : super(key: key);

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}
