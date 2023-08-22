// import 'dart:io';
// import 'package:flutter/gestures.dart';
// import 'package:food_delivery/controller/search_controller.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:food_delivery/controller/video_controller.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:food_delivery/routes/route_helper.dart';
// import 'package:food_delivery/utils/dimensions.dart';
// import 'package:food_delivery/widgets/app_icon.dart';
// import 'package:get/get.dart';

// import 'package:flowder/flowder.dart';
// import '../../base/show_custom_message.dart';
// import '../../controller/auth_controller.dart';
// import '../../controller/user_controller.dart';
// import '../../widgets/small_text.dart';
// import '/file_models/file_model.dart';

// import 'package:percent_indicator/percent_indicator.dart';

// import '../../widgets/big_text.dart';
// import '../../widgets/icon_and_text.dart';

// class SearchVideoDetail extends StatefulWidget {
//   final int? pageId;
//   final int? id;

//   const SearchVideoDetail({Key? key, this.pageId, this.id}) : super(key: key);

//   @override
//   State<SearchVideoDetail> createState() => _SearchVideoDetailState();
// }

// class _SearchVideoDetailState extends State<SearchVideoDetail> {
//   List<FileModel> fileList = [];

//   late DownloaderUtils options;
//   late DownloaderCore core;
//   late final String path;
//   var video;
//   var videos_search;

//   var is_collected = false;
//   var is_liked = false;
//   var likes = 0;
//   var collects = 0;

//   String Token = '';

//   @override
//   void initState() {
//     super.initState();
//     _getToken();
//     _getVideo();
//     _getUser();
//     initPlatformState();
//   }

//   generateFileList() {
//     _getToken();
//     fileList.add(FileModel(
//       fileName: video.title!,
//       url: video.file! + '/?tk=' + Token,
//       progress: 0.0,
//     ));
//   }

//   _getToken() {
//     Token = Get.find<AuthController>().getUserToken();
//     //print(Token);
//     setState(() {});
//   }

//   _getVideo() {
//     videos_search = Get.find<SearchVideoController>().videoList;
//   }

//   _getUser() {
//     var userId = Get.find<AuthController>().getUserId();
//     bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
//     if (userLoggedIn) {
//       Get.find<UserController>().getUserInfo(userId);
//     }
//     //print(_userId);
//     setState(() {});
//   }

//   _updateHistory() {
//     Get.find<VideoController>().updateHistory();
//     setState(() {});
//   }

//   _isLike() async {
//     is_liked = await Get.find<VideoController>().isLike();
//     likes = Get.find<VideoController>().likes;

//     setState(() {});
//   }

//   _isCollect() async {
//     is_collected = await Get.find<VideoController>().isCollect();
//     collects = Get.find<VideoController>().collects;

//     setState(() {});
//   }

//   _updateLike() async {
//     await Get.find<VideoController>().updateLike();
//     likes = Get.find<VideoController>().likes;

//     setState(() {
//       is_liked = !is_liked;
//     });
//   }

//   _updateCollect() async {
//     await Get.find<VideoController>().updateCollect();
//     collects = Get.find<VideoController>().collects;

//     setState(() {
//       is_collected = !is_collected;
//     });
//   }

//   Future<void> initPlatformState() async {
//     _setPath();
//     if (!mounted) return;
//   }

//   void _setPath() async {
//     Directory path = await getApplicationDocumentsDirectory();

//     String localPath = '${path.path}${Platform.pathSeparator}Download';

//     final savedDir = Directory(localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }

//     path = localPath as Directory;
//   }

//   var clicks = 0;
//   generateWidgetList() {
//     List<Widget> widgetList = [];
//     _getToken();

//     fileList.asMap().forEach((index, element) {
//       widgetList.add(Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//             child: BigText(
//               text: fileList[index].fileName!,
//               overFlow: TextOverflow.visible,
//               size: Dimensions.font18,
//             ),
//           ),
//           SizedBox(
//             height: Dimensions.height20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.blue),
//                 ),
//                 onPressed: () async {
//                   print("CLICKS$clicks");

//                   if (clicks == 0) {
//                     clicks++;
//                     showCustomNoticeSnacker("正在加载中...", title: "通知");
//                     _updateHistory();
//                     options = DownloaderUtils(
//                       progressCallback: (current, total) {
//                         final progress = (current / total) * 100;
//                         //print('Downloading: $progress');

//                         setState(() {
//                           fileList[index].progress = (current / total);
//                         });
//                       },
//                       file: File('$path/${fileList[index].fileName}'),
//                       progress: ProgressImplementation(),
//                       onDone: () {
//                         setState(() {
//                           fileList[index].progress = 0.0;
//                         });
//                         print("download ok");
//                         clicks = 0;

//                         Get.toNamed(RouteHelper.getVideoPlayer(
//                             '$path/${fileList[index].fileName}'));

//                         // OpenFile.open('$path/${fileList[index].fileName}')
//                         //     .then((value) {
//                         //   // delete the file.
//                         //   File f = File('$path/${fileList[index].fileName}');
//                         //   f.delete();
//                         // });
//                       },
//                       deleteOnCancel: true,
//                     );
//                     core = await Flowder.download(
//                       fileList[index].url!,
//                       options,
//                     );
//                   } else if (clicks >= 2) {
//                     showCustomSnacker("无法加载？退出此页面后重试！", title: '注意');
//                   } else {
//                     clicks++;
//                   }
//                 },
//                 child: Column(
//                   children: [
//                     if (fileList[index].progress == 0.0)
//                       const Icon(
//                         Icons.play_arrow_rounded,
//                       ),
//                     if (fileList[index].progress != 0.0)
//                       CircularPercentIndicator(
//                         //width: 100.0,
//                         //lineHeight: 14.0,
//                         percent: fileList[index].progress!,
//                         backgroundColor: Colors.blue,
//                         progressColor: Colors.white,
//                         radius: 12,
//                       ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: Dimensions.width15,
//               ),
//               BigText(
//                 text: "点击播放",
//                 size: Dimensions.font18,
//               )
//             ],
//           ),
//         ],
//       ));
//     });

//     return widgetList;
//   }

//   var times = 0;

//   @override
//   Widget build(BuildContext context) {
//     Get.find<VideoController>();
//     if (widget.id != null) {
//       video = videos_search[widget.id!];
//       //print("id" + widget.id.toString());
//       //print(" name is " + video.title!);
//       times++;
//     } else {
//       print("id and pageId == null");
//     }
//     if (times == 1) {
//       generateFileList();
//     }
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//               left: 0,
//               right: 0,
//               child: Container(
//                 width: double.maxFinite,
//                 height: Dimensions.videoImgSize,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         opacity: Theme.of(context).brightness == Brightness.dark
//                             ? 0.9
//                             : 1,
//                         fit: BoxFit.cover,
//                         image: NetworkImage(video.cover! + '/?tk=' + Token))),
//               )),
//           // button left & right
//           Positioned(
//               left: Dimensions.width20,
//               right: Dimensions.width20,
//               top: Dimensions.height45,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: (() {
//                       Get.back();
//                     }),
//                     child:
//                         const AppIcon(icon: Icons.arrow_back_ios_new_rounded),
//                   ),
//                   GestureDetector(
//                     onTap: (() {
//                       var list = video.url!.split('/');
//                       var videoId = list[list.length - 2];

//                       Share.share(
//                           '${'在 学霸空间 官网打开 https://edu.iamdada.xyz/video/detail/' + videoId}/');
//                     }),
//                     child: const AppIcon(icon: Icons.ios_share_rounded),
//                   )
//                 ],
//               )),
//           Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               top: Dimensions.videoImgSize - Dimensions.height20,
//               child: Container(
//                 padding: EdgeInsets.only(
//                     left: Dimensions.width20,
//                     right: Dimensions.width20,
//                     top: Dimensions.width20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(Dimensions.radius20),
//                     topLeft: Radius.circular(Dimensions.radius20),
//                   ),
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? Colors.grey[800]
//                       : Colors.white,
//                 ),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ...generateWidgetList(),
//                       SizedBox(
//                         height: Dimensions.height5,
//                       ),
//                       RichText(
//                           text: TextSpan(
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = (() => showCustomSnacker(
//                                     "使用右上角 分享 按钮在浏览器中观看！",
//                                     title: "注意")),
//                               text: "播放出错？",
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: Dimensions.font15,
//                               ))),
//                       Container(
//                         margin: EdgeInsets.only(
//                             top: Dimensions.height5,
//                             bottom: Dimensions.height5),
//                         padding: EdgeInsets.only(
//                             left: Dimensions.width5, right: Dimensions.width5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               height: Dimensions.height15,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 SmallText(
//                                   text: video.classification!.title!,
//                                   size: Dimensions.font18,
//                                   color: Colors.grey[500],
//                                 ),
//                                 SmallText(
//                                   text: video.createTime!.split('T')[0],
//                                   size: Dimensions.font18,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: Dimensions.height20,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 IconAndText(
//                                   icon: Icons.remove_red_eye_rounded,
//                                   text: '${video.viewCount!}次观看',
//                                   color: Colors.black,
//                                   iconColor: Colors.orangeAccent,
//                                   size: Dimensions.iconSize16 * 2,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     // is_liked
//                                     //     ? video.liked.add['add']
//                                     //     : video.liked.removeLast;
//                                     // print(video.liked);
//                                     _updateLike();
//                                   },
//                                   child: IconAndText(
//                                     icon: Icons.favorite_rounded,
//                                     text: '$likes人喜欢',
//                                     color: Colors.black,
//                                     iconColor: is_liked
//                                         ? Colors.pinkAccent
//                                         : Colors.grey,
//                                     size: Dimensions.iconSize16 * 2,
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     _updateCollect();
//                                     // video.collected!.toList().length = collects;
//                                   },
//                                   child: IconAndText(
//                                     icon: Icons.bookmark_rounded,
//                                     text: '$collects人收藏',
//                                     color: Colors.black,
//                                     iconColor: is_collected
//                                         ? Colors.blueAccent
//                                         : Colors.grey,
//                                     size: Dimensions.iconSize16 * 2,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ]),
//               ))
//         ],
//       ),
//     );
//   }
// }
