import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: AppColors.mainColor,
            title: BigText(
              text: "关于我们",
              size: Dimensions.font20,
              color: Colors.white,
            )),
        body: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: Dimensions.height45 * 3,
                ),
                Center(
                    child: Image.asset(
                  'assets/image/maintenance.png',
                  width: Dimensions.width45 * 10,
                )),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Center(
                  child: BigText(
                    text: "开发者: William & Match",
                    color: AppColors.mainColor,
                    size: Dimensions.font25,
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Center(
                  child: BigText(
                    text: "更多功能正在努力开发中...",
                    color: AppColors.mainBlackColor,
                    size: Dimensions.font18,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
