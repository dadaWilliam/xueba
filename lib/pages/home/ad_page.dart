import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xueba/utils/app_constants.dart';

import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/account_widget.dart';
import 'package:xueba/widgets/app_icon.dart';
import 'package:xueba/widgets/big_text.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ADPage extends StatefulWidget {
  const ADPage({Key? key}) : super(key: key);

  @override
  State<ADPage> createState() => _ADPageState();
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

class _ADPageState extends State<ADPage> {
  bool is_Tmall = false;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConstants.URL}${AppConstants.AD}/3'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            is_Tmall = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            is_Tmall = false;
          });
        }
      }
    } catch (e) {
      // setState(() {
      //   _status = 'Error: $e';
      // });
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
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0x00303030)
          : Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.mainColor,
          title: Center(
            child: BigText(
              text: "福利中心",
              size: Dimensions.font20,
              color: Colors.white,
            ),
          )),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.height20,
                ),
                GestureDetector(
                  onTap: (() {
                    var meituan1 =
                        Uri.parse('${AppConstants.URL}${AppConstants.AD}/1');
                    // Uri(
                    //     scheme: 'https',
                    //     host: 'union-click6.meituan.com',
                    //     path: 'page/',
                    //     queryParameters: {
                    //       'click':
                    //           'p=ueIRVj9jpPcUJog9X-Ub7tsWBIvwMoxQfRf_ow7PRhGq_lxreTvA3b4XFqc0UbIZj8LXH5kXwQVqDGDKvIfpjWewQtFD_npcZAkjG0SNGDEFcKXgb9rqW7iwE8xJ6wq-cX56CBPZhznJzcgyVtup5O39n2JSIyPavFDmj-eYWnBm1938QJfNeC4mi5HE2qh7sgS5viC2Qhlahpkl3dmRPr0OREtjMrvf5Ak16Kp-0G2zC3i4Z_NohpKv_S9rEz4Y2vKI8Skc2WBYn6fEFnxskM8Vs9fGFuFTm21QD1xNmP5olByR33pcvTZBI1WejqDmbYTLJgpyJxwTnWF8-aOQyw&send_by=8757669751&invite_code=zdmcvbs45winv&zdm_ss=iOS_8757669751_&from=other'
                    //     });
                    // print(meituan);
                    launchUrl(meituan1, mode: LaunchMode.externalApplication);
                    // Get.toNamed(RouteHelper.getwebPage(
                    //     'https://union-click6.meituan.com/page/click?p=ueIRVj9jpPcUJog9X-Ub7tsWBIvwMoxQfRf_ow7PRhGq_lxreTvA3b4XFqc0UbIZj8LXH5kXwQVqDGDKvIfpjWewQtFD_npcZAkjG0SNGDEFcKXgb9rqW7iwE8xJ6wq-cX56CBPZhznJzcgyVtup5O39n2JSIyPavFDmj-eYWnBm1938QJfNeC4mi5HE2qh7sgS5viC2Qhlahpkl3dmRPr0OREtjMrvf5Ak16Kp-0G2zC3i4Z_NohpKv_S9rEz4Y2vKI8Skc2WBYn6fEFnxskM8Vs9fGFuFTm21QD1xNmP5olByR33pcvTZBI1WejqDmbYTLJgpyJxwTnWF8-aOQyw&send_by=8757669751&invite_code=zdmcvbs45winv&zdm_ss=iOS_8757669751_&from=other',
                    //     '美团'));
                    // showCustomNoticeSnacker("如错误，请联系管理员!", title: "学霸空间");
                  }),
                  child: AccountWidgt(
                      appIcon: AppIcon(
                        icon: Icons.restaurant,
                        backgroundColor: const Color.fromRGBO(251, 192, 45, 1),
                        // const Color.fromRGBO(248, 211, 71, 1.0),
                        iconColor: Colors.white,
                        size: Dimensions.iconSize24 * 2,
                        iconSize: Dimensions.iconSize24,
                      ),
                      bigText: BigText(
                        text: '美团到店 单单必减 (最低 0.5 元)',
                        size: Dimensions.font18,
                      )),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                GestureDetector(
                  onTap: (() {
                    var meituan2 =
                        Uri.parse('${AppConstants.URL}${AppConstants.AD}/2');

                    launchUrl(meituan2, mode: LaunchMode.externalApplication);
                  }),
                  child: AccountWidgt(
                      appIcon: AppIcon(
                        icon: Icons.fastfood_rounded,
                        backgroundColor: Colors.orange,
                        iconColor: Colors.white,
                        size: Dimensions.iconSize24 * 2,
                        iconSize: Dimensions.iconSize24,
                      ),
                      bigText: BigText(
                        text: '美团外卖 领大额红包',
                        size: Dimensions.font18,
                      )),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                is_Tmall
                    ? GestureDetector(
                        onTap: (() {
                          var Tmall = Uri.parse(
                              '${AppConstants.URL}${AppConstants.AD}/3');

                          launchUrl(Tmall,
                              mode: LaunchMode.externalApplication);
                        }),
                        child: AccountWidgt(
                            appIcon: AppIcon(
                              icon: Icons.local_mall_rounded,
                              backgroundColor:
                                  Colors.redAccent, //const Color(0xFF1976D2),
                              iconColor: Colors.white,
                              size: Dimensions.iconSize24 * 2,
                              iconSize: Dimensions.iconSize24,
                            ),
                            bigText: BigText(
                              text: '🌟限时福利 淘宝天猫 抽千元红包',
                              size: Dimensions.font18,
                            )),
                      )
                    : Container(
                        child: LinearProgressIndicator(),
                      ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
