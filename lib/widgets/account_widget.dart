import 'package:flutter/material.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/big_text.dart';

import 'app_icon.dart';

class AccountWidgt extends StatelessWidget {
  AppIcon appIcon;
  BigText bigText;
  AccountWidgt({Key? key, required this.appIcon, required this.bigText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0x00303030)
          : Colors.white,
      padding: EdgeInsets.only(
          left: Dimensions.width20,
          top: Dimensions.height10,
          bottom: Dimensions.height10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          appIcon,
          SizedBox(
            width: Dimensions.width20,
          ),
          bigText,
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          Container(
            margin: EdgeInsets.only(right: Dimensions.width10),
            child: const Icon(Icons.arrow_right_rounded),
          )
        ],
      ),
      // decoration: BoxDecoration(color: Colors.white, boxShadow: [
      //   BoxShadow(
      //     blurRadius: 1,
      //     offset: Offset(0, 2),
      //     color: Colors.grey.withOpacity(0.2),
      //   ),
      // ]),
    );
  }
}
