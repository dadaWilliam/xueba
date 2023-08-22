import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:xueba/controller/auth_controller.dart';

import 'package:xueba/utils/colors.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import '../../routes/route_helper.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var check = false;
  var passwordVisible = true; //设置初始状态
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late double screenWidth;
  late double screenHeight;
  var temporary = -1.0;
  var times = 0;

  getCheckBoxBorderColor() {
    if (check) {
      return const Color(0xFF3C78FF);
    } else {
      return const Color(0xFFD1D1D1);
    }
  }

  @override
  void initState() {
    // updatePage();
    super.initState();
    // screenWidth = Get.context!.width;
    // screenHeight = Get.context!.height;

    // Dimensions.update(
    //     MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    // setState(() {});

    // setState(() {
    //   Dimensions.update();
    //   debugPrint(Dimensions.screenHeight.toString());
    //   debugPrint(Dimensions.screenWidth.toString());
    // });
  }

  @override
  void dispose() {
    super.dispose();

    usernameController.dispose();
    passwordController.dispose();
  }

  // void updatePage() {
  //   setState(() {
  //     screenWidth = Get.context!.width;
  //     screenHeight = Get.context!.height;
  //     Dimensions.update();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Dimensions.update(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    // Dimensions.update();
    // updatePage();
    // setState(() {});

    void _loginIn() {
      if (check == false) {
        AwesomeDialog(
          context: context,
          width: Dimensions.width45 * 10,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: '出错啦',
          desc: '请阅读并同意《管理条例》和《隐私政策》！',
          btnOkText: '我知道了',
          // btnCancelText: '取消',
          // btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else {
        Get.find<AuthController>();
        String username = usernameController.text.trim();
        String password = passwordController.text.trim();

        if (username.isEmpty) {
          AwesomeDialog(
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: '出错啦',
            desc: '请输入账号!',
            btnOkText: '我知道了',
            btnOkOnPress: () {},
          ).show();
          //showCustomSnacker("请输入账号!", title: "出错啦");
        } else if (password.isEmpty) {
          AwesomeDialog(
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: '出错啦',
            desc: '请输入密码!',
            btnOkText: '我知道了',
            btnOkOnPress: () {},
          ).show();
          //showCustomSnacker("请输入密码!", title: "出错啦");
        } else if (password.length < 6) {
          AwesomeDialog(
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: '出错啦',
            desc: '密码长度有误，请检查后重试!',
            btnOkText: '我知道了',
            btnOkOnPress: () {},
          ).show();
          //showCustomSnacker("密码长度有误，请检查后重试!", title: "出错啦");
        } else {
          AwesomeDialog(
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.scale,
            title: '通知',
            desc: '为确保您的账户安全，此次登陆需要验证！',
            btnOkText: '确认',
            btnCancelText: '取消',
            btnOkOnPress: () {
              // debugPrint(username);
              Get.offNamed(RouteHelper.getVerify(
                  username.toString(), password.toString()));
            },
            btnCancelOnPress: () {},
          ).show();

          //showCustomNoticeQuickSnacker("正在登录中...", title: "通知");
          //SignInBody signInBody = SignInBody(username: username, pwd: password);
          // authController.login(signInBody).then((value) async {
          //   if (authController.userLoggedIn()) {
          //     showCustomNoticeQuickSnacker("请进行验证！", title: "通知");
          //     Get.offNamed(RouteHelper.getVerify());
          //     // await Get.find<VideoController>().getVideoList();
          //     // await Get.find<IndexShowVideoController>().getIndexShowVideoList();
          //     // var user_id = await Get.find<AuthController>().getUserId();
          //     // await Get.find<UserController>().getUserInfo(user_id);
          //     // Get.offNamed(RouteHelper.getInitial());
          //   }
          // }
          // );
        }
      }
    }

    // updatePage();

    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        body: GetBuilder<AuthController>(
          builder: (controller) {
            // print('tem' + temporary.toString());
            // print(MediaQuery.of(context).size.width);
            if (temporary != Get.context!.width && temporary != -1.0) {
              // print("here " + temporary.toString());
              // print("current  " + MediaQuery.of(context).size.width.toString());
              times++;
              debugPrint('change $times');
              temporary = MediaQuery.of(context).size.width;
              Future.delayed(Duration.zero, () {
                //your code goes here
                setState(() {});
              });

              // print("change " + temporary.toString());
            } else if (temporary == -1.0) {
              temporary = MediaQuery.of(context).size.width;
              // print("initial " + temporary.toString());
            }

            return !controller.isLoading
                ? Column(children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Dimensions.height45 * 2,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Dimensions.height45),
                              height: Dimensions.width45 * 2,
                              child: Center(
                                child: Image.asset(
                                  'assets/image/logo.png',
                                  width: Dimensions.width10 * 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            BigText(
                              text: "学霸空间",
                              size: Dimensions.font25,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(
                              height: Dimensions.height30,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.width20,
                                  right: Dimensions.width20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 7,
                                        offset: const Offset(1, 1),
                                        color: Colors.grey.withOpacity(0.2))
                                  ]),
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                    //hint
                                    hintText: "请输入账号",
                                    prefixIcon: const Icon(
                                      Icons.person_rounded,
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
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.width20,
                                  right: Dimensions.width20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 7,
                                        offset: const Offset(1, 1),
                                        color: Colors.grey.withOpacity(0.2))
                                  ]),
                              child: TextField(
                                controller: passwordController,
                                obscureText: passwordVisible,
                                obscuringCharacter: '•',
                                decoration: InputDecoration(
                                    //hint
                                    hintText: "请输入密码",
                                    prefixIcon: const Icon(
                                      Icons.password_rounded,
                                      color: AppColors.yellowColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      color: Colors.grey[400],
                                      onPressed: () {
                                        // updatePage();
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
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
                            Container(
                                margin: EdgeInsets.only(
                                    top: Dimensions.height20,
                                    bottom: Dimensions.height20,
                                    left: Dimensions.width20 * 1.5,
                                    right: Dimensions.width20 * 1.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RoundCheckBox(
                                        size: Dimensions.height20,
                                        checkedWidget: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: Dimensions.height15,
                                        ),
                                        checkedColor: const Color(0xFF3C78FF),
                                        uncheckedColor: const Color(0x003C78FF),
                                        border: Border.all(
                                            color: getCheckBoxBorderColor(),
                                            width: 1),
                                        isChecked: check,
                                        onTap: (selected) {
                                          check = selected!;
                                          setState(() {});
                                        }),
                                    //  GestureDetector(child: ,)
                                    SizedBox(
                                      width: Dimensions.width5,
                                    ),
                                    BigText(
                                      text: "已阅读并同意",
                                      size: Dimensions.font15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        AwesomeDialog(
                                          width: Dimensions.width45 * 10,
                                          context: context,
                                          dialogType: DialogType.noHeader,
                                          animType: AnimType.scale,
                                          body: Container(
                                            margin: EdgeInsets.only(
                                              top: Dimensions.height5,
                                              bottom: Dimensions.height5,
                                              left: Dimensions.width5,
                                              right: Dimensions.width5,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "学霸空间《管理条例》和《隐私政策》",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize:
                                                        Dimensions.font15 * 1.1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimensions.height10,
                                                ),
                                                Text(
                                                  '学霸空间 可能会收集和使用与您有关的信息，包括（但不限于）以下各类信息：\n(a)身份资料（如姓名、用户名、手机号码、email）；\n(b)档案信息（如性别、居住国、语言以及您希望公开的用户信息）；\n(c)电子身份资料（例如IP地址、cookie）；\n在未经您明确许可的情况下，学霸空间不会向第三方出售、出租、交易或以其它方式转让任何个人和/或流量资料或通讯内容。\n请注意，您在用户档案中自愿公开的信息，或您在讨论区透露的信息，或您通过发表评论透露的信息都将成为公开信息，其他人都可以查看。\n为遵守法律要求、行使我们的法律权利或抗辩法律诉求、保护学霸空间以及用户的利益、打击欺诈行为、执行我们的政策或保护任何人的权利、财产或安全，学霸空间可能会透露个人信息。\n\n最终解释权归学霸空间所有',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: Dimensions.font13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          btnCancelText: '不同意',
                                          btnOkText: '同意',
                                          btnOkOnPress: () {
                                            setState(() {
                                              check = true;
                                            });
                                          },
                                          btnCancelOnPress: () {
                                            setState(() {
                                              check = false;
                                            });
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "《管理条例》和《隐私政策》",
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: Dimensions.font15 * 1.05,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            GestureDetector(
                              onTap: () => _loginIn(),
                              child: Container(
                                  width: Dimensions.width45 * 6,
                                  height: Dimensions.height30 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius30),
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.mainColor.withOpacity(0.9)
                                          : AppColors.mainColor),
                                  child: Center(
                                    child: BigText(
                                      text: "登录",
                                      size: Dimensions.font20,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            RichText(
                                text: TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() => AwesomeDialog(
                                                width: Dimensions.width45 * 10,
                                                context: context,
                                                dialogType: DialogType.question,
                                                animType: AnimType.scale,
                                                title: '无法登陆?',
                                                desc: '请联系管理员！',
                                                btnOkText: '我知道了',
                                                // btnCancelText: '取消',
                                                // btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  // Get.find<AuthController>()
                                                  //     .clearSharedData();
                                                  // Get.offNamed(
                                                  //     RouteHelper.getLogIn());
                                                },
                                              ).show()
                                          // showCustomNoticeSnacker(
                                          //     "重复遇见问题? 请联系管理员！",
                                          //     title: "注意")
                                          ),
                                    text: "登录失败 ？",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: Dimensions.font15,
                                    ))),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            RichText(
                                text: TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() => AwesomeDialog(
                                                width: Dimensions.width45 * 10,
                                                context: context,
                                                dialogType: DialogType.question,
                                                animType: AnimType.scale,
                                                title: '没有账号?',
                                                desc: '请联系管理员分发账号！',
                                                btnOkText: '我知道了',
                                                // btnCancelText: '取消',
                                                // btnCancelOnPress: () {},
                                                btnOkOnPress: () {},
                                              ).show()

                                          // showCustomNoticeSnacker(
                                          //     "请联系管理员分发账号！",
                                          //     title: "注意")
                                          ),
                                    text: "没有账号 ？",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: Dimensions.font15,
                                    )))
                          ],
                        ),
                      ),
                    )
                  ])
                : const CircularProgressIndicator(
                    color: AppColors.mainColor,
                  );
          },
        ));
  }
}
