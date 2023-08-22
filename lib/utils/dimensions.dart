import 'package:get/get.dart';

class Dimensions {
  static void update(currentHeight, currentWidth) {
    Dimensions.height = currentHeight;
    Dimensions.screenWidth = currentWidth;
    // print(currentHeight);
    // print(currentWidth);
  }

  static double height = Get.context!.height;
  // static double width = Get.context!.width;
  static double screenWidth = Get.context!.width;

  static double get screenHeight =>
      screenWidth > 800 ? 1000 : (screenWidth < 360 ? 600 : height);
  static double get pageView => screenHeight / 3; //2.64
  static double get pageViewContainer => screenHeight / 3.84;
  static double get pageViewTextContainer => screenHeight / 7.03;

  static double get height5 => screenHeight / 168.8;
  static double get height10 => screenHeight / 84.4;
  static double get height15 => screenHeight / 56.27;
  static double get height20 => screenHeight / 42.2;
  static double get height30 => screenHeight / 28.13;
  static double get height45 => screenHeight / 18.76;

  static double get width5 => screenHeight / 168.8;
  static double get width10 => screenHeight / 84.4;
  static double get width15 => screenHeight / 56.27;
  static double get width20 => screenHeight / 42.2;
  static double get width30 => screenHeight / 28.13;
  static double get width45 => screenHeight / 18.76;

  static double get font13 => screenHeight / 64.92;
  static double get font14 => screenHeight / 60.28;
  static double get font15 => screenHeight / 56.27;
  static double get font18 => screenHeight / 46.88;
  static double get font20 => screenHeight / 42.2;
  static double get font25 => screenHeight / 33.76;
  static double get font30 => screenHeight / 28.13;

  static double get radius15 => screenHeight / 56.27;
  static double get radius20 => screenHeight / 42.2;
  static double get radius30 => screenHeight / 28.13;

  static double get iconSize16 => screenHeight / 52.75;
  static double get iconSize24 => screenHeight / 35.17;

  //list view size
  static double get listViewImgSize => screenHeight / 8;
  static double get listViewTextContSize => screenHeight / 8; //3.9

  static double get videoImgSize => screenHeight / 2.41;
}


//   static double get screenHeight =>
//       screenWidth > 800 ? 1000 : (screenWidth < 400 ? 600 : height);
//   static double get pageView => screenHeight / 3; //2.64
//   static double get pageViewContainer => screenHeight / 3.84;
//   static double get pageViewTextContainer => screenHeight / 7.03;

//   static double get height5 => screenHeight / 168.8;
//   static double get height10 => screenHeight / 84.4;
//   static double get height15 => screenHeight / 56.27;
//   static double get height20 => screenHeight / 42.2;
//   static double get height30 => screenHeight / 28.13;
//   static double get height45 => screenHeight / 18.76;

//   static double get width5 => screenHeight / 168.8;
//   static double get width10 => screenHeight / 84.4;
//   static double get width15 => screenHeight / 56.27;
//   static double get width20 => screenHeight / 42.2;
//   static double get width30 => screenHeight / 28.13;
//   static double get width45 => screenHeight / 18.76;

//   static double get font13 => screenHeight / 64.92;
//   static double get font14 => screenHeight / 60.28;
//   static double get font15 => screenHeight / 56.27;
//   static double get font18 => screenHeight / 46.88;
//   static double get font20 => screenHeight / 42.2;
//   static double get font25 => screenHeight / 33.76;
//   static double get font30 => screenHeight / 28.13;

//   static double get radius15 => screenHeight / 56.27;
//   static double get radius20 => screenHeight / 42.2;
//   static double get radius30 => screenHeight / 28.13;

//   static double get iconSize16 => screenHeight / 52.75;
//   static double get iconSize24 => screenHeight / 35.17;

//   //list view size
//   static double get listViewImgSize => screenHeight / 8;
//   static double get listViewTextContSize => screenHeight / 8; //3.9

//   static double get videoImgSize => screenHeight / 2.41;
// // import 'package:flutter/widgets.dart';
// // import 'package:get/get.dart';

// // class Dimensions extends ChangeNotifier {
// //    static void update() {
// //     Dimensions.height = Get.context!.height;
// //     Dimensions.screenWidth = Get.context!.width;
// //   }

// //   static double height = Get.context!.height;
// //   // static double width = Get.context!.width;
// //   static double screenWidth = Get.context!.width;

// //   static double get screenHeight  => 
// //       screenWidth > 800 ? 1000 : (screenWidth < 400 ? 600 : height);
// //   static double get pageView => screenHeight / 3; //2.64
// //   static double pageViewContainer = screenHeight / 3.84;
// //   static double pageViewTextContainer = screenHeight / 7.03;

// //   static double height5 = screenHeight / 168.8;
// //   static double height10 = screenHeight / 84.4;
// //   static double height15 = screenHeight / 56.27;
// //   static double height20 = screenHeight / 42.2;
// //   static double height30 = screenHeight / 28.13;
// //   static double height45 = screenHeight / 18.76;

// //   static double width5 = screenHeight / 168.8;
// //   static double width10 = screenHeight / 84.4;
// //   static double width15 = screenHeight / 56.27;
// //   static double width20 = screenHeight / 42.2;
// //   static double width30 = screenHeight / 28.13;
// //   static double width45 = screenHeight / 18.76;

// //   static double font13 = screenHeight / 64.92;
// //   static double font14 = screenHeight / 60.28;
// //   static double font15 = screenHeight / 56.27;
// //   static double font18 = screenHeight / 46.88;
// //   static double font20 = screenHeight / 42.2;
// //   static double font25 = screenHeight / 33.76;
// //   static double font30 = screenHeight / 28.13;

// //   static double radius15 = screenHeight / 56.27;
// //   static double radius20 = screenHeight / 42.2;
// //   static double radius30 = screenHeight / 28.13;

// //   static double iconSize16 = screenHeight / 52.75;
// //   static double iconSize24 = screenHeight / 35.17;

// //   //list view size
// //   static double listViewImgSize = screenHeight / 8;
// //   static double listViewTextContSize = screenHeight / 8; //3.9

// //   static double videoImgSize = screenHeight / 2.41;
// // }
