import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/auth_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String Token = Get.find<AuthController>().getUserToken();
  String homeUrl = '${AppConstants.URL}/myadmin'; // Replace with your own URL.
  double percentage_progress = 0.0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    homeUrl = '$homeUrl/?tk=$Token';
    print(homeUrl);
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
            text: "后台管理",
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
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
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
                            text: '不能返回啦',
                            size: Dimensions.font18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              // You can add more icons here for more functionality
            ],
          ),
        ));
  }
}
