import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xueba/base/show_custom_message.dart';
import 'dart:convert';

import '../controller/auth_controller.dart';
import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../widgets/big_text.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class StepperPage extends StatefulWidget {
  final String dataString;

  StepperPage({Key? key, required this.dataString}) : super(key: key);

  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int _currentStep = 0;
  late String Token;
  String code = '';
  // var load;
  // late String _time;
  // late Timer _timer;
  int _start = 180; // 3 minutes in seconds

  @override
  initState() {
    super.initState();
    _getToken();
    // load.show();
    _fetchTime();
  }

  _fetchTime() async {
    http.Response response = await http.get(Uri.parse(
        '${AppConstants.URL}${AppConstants.CHECKQRCODE}?code=${widget.dataString}&tk=$Token'));

    print(
        '${AppConstants.URL}${AppConstants.CHECKQRCODE}?code=${widget.dataString}&tk=$Token');
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['code'] == 1000) {
        setState(() {
          code = responseBody['verification'].toString();
        });
        // load.dismiss();
        // print('h');
      } else {
        AwesomeDialog(
            dismissOnTouchOutside: false,
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.error,
            title: '出错了',
            desc: '请重试！',
            btnOkText: '我知道了',
            btnOkOnPress: () {
              Get.back();
            }).show();
        // print('b');
      }
      // var jsonResponse = json.decode(response.body);
      // setState(() {
      //   _time = jsonResponse['time'];
      // });
    }
  }

  _getToken() {
    Token = Get.find<AuthController>().getUserToken();
    //print(Token);
  }
  // _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     if (_start == 0) {
  //       setState(() {
  //         timer.cancel();
  //       });
  //     } else {
  //       setState(() {
  //         _start--;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.mainColor,
          title: BigText(
            text: "请验证",
            size: Dimensions.font20,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            TimerFrame(
              inverted: true,
              description: '倒计时',
              timer: TimerBasic(
                inverted: true,
                format: CountDownTimerFormat.minutesSeconds,
              ),
            ),
            Stepper(
              controlsBuilder:
                  (BuildContext context, ControlsDetails controlsDetails) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: controlsDetails.onStepContinue,
                      child: const Text('继续'), // "CONTINUE" in Chinese
                    ),
                    // SizedBox(
                    //     width:
                    //         Dimensions.width20), // Add some space between the buttons
                    // ElevatedButton(
                    //   onPressed: controlsDetails.onStepCancel,
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.red, // Background color
                    //   ),
                    //   child: const Text('取消'), // "CANCEL" in Chinese
                    // ),
                  ],
                );
              },
              currentStep: _currentStep,
              onStepTapped: (int step) => setState(() => _currentStep = step),
              onStepContinue: () {
                if (_currentStep < 1) {
                  setState(() => _currentStep += 1);
                  if (_currentStep == 1) {
                    print('1');
                    // _startTimer();
                  }
                } else {
                  showCustomGreenSnacker(title: '通知', '验证码已经加载完成！');
                }
              },
              onStepCancel: () =>
                  _currentStep > 0 ? setState(() => _currentStep -= 1) : null,
              steps: [
                Step(
                  title: BigText(text: '确认 是否为本人登录?'),
                  content: Column(
                    children: [
                      SizedBox(height: Dimensions.height10),
                      Row(
                        children: [
                          BigText(
                            text:
                                '用户：${Get.find<AuthController>().getUserName()}',
                            size: Dimensions.font18,
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10),
                    ],
                  ),
                  isActive: _currentStep == 0,
                ),
                Step(
                  title: BigText(text: '验证码：'),
                  content: Column(
                    children: [
                      SizedBox(height: Dimensions.height10),
                      Row(
                        children: [
                          BigText(
                            text: code == '' ? '请稍等...' : '$code',
                            size: Dimensions.font20,
                            color: Colors.deepOrange,
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10),
                    ],
                  ),
                  isActive: _currentStep == 1,
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }
}

const Color purple = Colors.green;

class TimerFrame extends StatelessWidget {
  final String description;
  final Widget timer;
  final bool inverted;

  const TimerFrame({
    required this.description,
    required this.timer,
    this.inverted = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        vertical: inverted ? 30 : 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: inverted ? CupertinoColors.white : purple,
        border: Border.all(
          width: 2,
          color: inverted ? purple : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 0,
              color: inverted ? purple : CupertinoColors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          timer,
        ],
      ),
    );
  }
}

class TimerBasic extends StatelessWidget {
  final CountDownTimerFormat format;
  final bool inverted;

  TimerBasic({
    required this.format,
    this.inverted = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      minutesDescription: '分',
      secondsDescription: '秒',
      format: CountDownTimerFormat.minutesSeconds,
      endTime: DateTime.now().add(
        const Duration(
          days: 0,
          hours: 0,
          minutes: 3,
          seconds: 0,
        ),
      ),
      onEnd: () {
        AwesomeDialog(
            dismissOnTouchOutside: false,
            width: Dimensions.width45 * 10,
            context: context,
            dialogType: DialogType.error,
            title: '倒计时结束',
            desc: '请重试！',
            btnOkText: '我知道了',
            btnOkOnPress: () {
              Get.back();
            }).show();
        // print("Timer finished");
      },
      timeTextStyle: TextStyle(
        color: (inverted) ? purple : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      colonsTextStyle: TextStyle(
        color: (inverted) ? purple : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      descriptionTextStyle: TextStyle(
        color: (inverted) ? purple : CupertinoColors.white,
        fontSize: 10,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      spacerWidth: 0,
      daysDescription: "days",
      hoursDescription: "hours",
      // minutesDescription: "minutes",
      // secondsDescription: "seconds",
    );
  }
}
