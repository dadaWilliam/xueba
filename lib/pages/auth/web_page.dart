import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';

class WebPage extends StatefulWidget {
  final String? url;
  final String? name;
  const WebPage({Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  String homeUrl = ''; // Replace with your own URL.
  double percentage_progress = 0.0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    if (widget.url.toString().startsWith('http')) {
      homeUrl = '${widget.url}';
    } else {
      homeUrl = '${AppConstants.URL}${widget.url}';
    }

    // print(homeUrl); // Replace with your own URL.
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              percentage_progress = 0.1;
            });
          },
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                percentage_progress = progress / 100.0;
              });
            }

            // percentage_progress = progress / 100;
          },
          onPageFinished: (String url) {
            setState(() {
              percentage_progress = 1.0;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(homeUrl))
      // controller.loadRequest(Uri.parse('https://flutter.dev'));
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    // controller.loadRequest(Uri.parse(homeUrl)); // Replace with your own URL.

    // controller.setNavigationDelegate(
    //   NavigationDelegate(
    //     onProgress: (int progress) {
    //       percentage_progress = progress / 100;
    //       setState(() {});
    //     },
    //     onPageStarted: (String url) {},
    //     onPageFinished: (String url) {},
    //     onWebResourceError: (WebResourceError error) {},
    //     // onNavigationRequest: (NavigationRequest request) {
    //     //   if (request.url.startsWith('https://www.youtube.com/')) {
    //     //     return NavigationDecision.prevent;
    //     //   }
    //     //   return NavigationDecision.navigate;
    //     // },
    //   ),
    // );
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0x00303030)
            : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.mainColor,
          title: BigText(
            text: widget.name.toString(),
            size: Dimensions.font20,
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            LinearProgressIndicator(
              color: AppColors.yellowColor,
              value: percentage_progress,
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  controller.loadRequest(Uri.parse(homeUrl));
                },
              ),
              GestureDetector(
                onDoubleTap: () => Get.back(),
                onTap: () async {
                  if (await controller.canGoBack()) {
                    controller.goBack();
                  } else {
                    var snackBar = SnackBar(
                      backgroundColor: Colors.red.withOpacity(0.95),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: Dimensions.iconSize24,
                          ),
                          SizedBox(
                            width: Dimensions.width5,
                          ),
                          BigText(
                            text: '不能返回啦 , 双击两次退出',
                            size: Dimensions.font18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                  child: Icon(
                    Icons.arrow_back,
                    // Adjust the size and color of the icon as needed
                  ),
                ),
              ),

              // IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: () async {
              //     if (await controller.canGoBack()) {
              //       controller.goBack();

              //     } else {
              //       var snackBar = SnackBar(
              //         backgroundColor: Colors.red.withOpacity(0.95),
              //         content: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Icon(
              //               Icons.error_outline_rounded,
              //               color: Colors.white,
              //               size: Dimensions.iconSize24,
              //             ),
              //             SizedBox(
              //               width: Dimensions.width5,
              //             ),
              //             BigText(
              //               text: '不能返回啦',
              //               size: Dimensions.font18,
              //               color: Colors.white,
              //             ),
              //           ],
              //         ),
              //       );

              //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //     }
              //   },
              // ),
              // // You can add more icons here for more functionality
            ],
          ),
        ));
  }
}
