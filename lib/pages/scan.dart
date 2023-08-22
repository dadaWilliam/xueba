import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xueba/utils/app_constants.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_plus/share_plus.dart';

import '../routes/route_helper.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class ScanQRcode extends StatefulWidget {
  ScanQRcode({Key? key}) : super(key: key);

  @override
  State<ScanQRcode> createState() => _ScanQRcodeState();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
}

bool matchesPattern(String url) {
  final pattern = RegExp(r'^http://xueba\.ca/download\?code=[a-zA-Z0-9]+$');
  return pattern.hasMatch(url);
}

String? extractCode(String url) {
  final pattern = RegExp(r'^http://xueba\.ca/download\?code=([a-zA-Z0-9]+)$');
  var match = pattern.firstMatch(url);
  if (match != null && match.groupCount >= 1) {
    return match.group(1);
  }
  return null;
}

class _ScanQRcodeState extends State<ScanQRcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  bool stop = false;
  QRViewController? controller;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.mainColor,
        title: BigText(
          text: "请扫描二维码",
          size: Dimensions.font20,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: (result != null)
          //         ? Text(
          //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         : BigText(
          //             text: '请扫描二维码',
          //           ),
          //   ),
          // )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (stop == false) {
        setState(() {
          result = scanData;
          stop = true;
        });

        var xueba = matchesPattern(result!.code.toString());
        AwesomeDialog(
          dismissOnTouchOutside: false,
          width: Dimensions.width45 * 10,
          context: context,
          dialogType: DialogType.success,
          title: '扫描结果',
          desc: scanData.code,
          btnOkText: xueba ? '前往登录' : '分享结果',
          btnOkOnPress: () async {
            // stop = false;
            if (xueba) {
              // var load = AwesomeDialog(
              //   width: Dimensions.screenWidth * 0.5,
              //   context: context,
              //   dialogType: DialogType.noHeader,
              //   animType: AnimType.scale,
              //   dismissOnTouchOutside: false,
              //   body: Column(
              //     children: [
              //       SizedBox(
              //         height: Dimensions.height15,
              //       ),
              //       const CircularProgressIndicator(
              //           strokeWidth: 5.0, color: AppColors.mainColor),
              //       SizedBox(
              //         height: Dimensions.height30,
              //       ),
              //       BigText(
              //         text: '加载中...',
              //         size: Dimensions.font15,
              //       ),
              //       SizedBox(
              //         height: Dimensions.height20,
              //       ),
              //     ],
              //   ),
              // );
              // load.show();
              await Get.offNamed(RouteHelper.getScanDetail(
                  extractCode(result!.code.toString()).toString()));
              // load.dismiss();
              // stop = false;
            } else {
              Share.share(scanData.code.toString());
            }
            // xueba
            //     ? (Share.share(scanData.code.toString()))
            //     : Share.share(scanData.code.toString());
          },
          btnCancelText: '继续扫描',
          btnCancelOnPress: () {
            stop = false;
          },
        ).show();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
