import 'package:flutter/material.dart';
import 'package:xueba/widgets/big_text.dart';
import 'package:get/get.dart';

void showCustomSnacker(String message,
    {bool isError = true, String title = "Error"}) {
  Get.snackbar(title, message,
      duration: const Duration(seconds: 2),
      titleText: BigText(
        text: title,
        color: Colors.white,
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent.withOpacity(0.9));
}

void showCustomNoticeSnacker(String message,
    {bool isError = true, String title = "Error"}) {
  Get.snackbar(title, message,
      duration: const Duration(seconds: 2),
      titleText: BigText(
        text: title,
        color: Colors.white,
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blueAccent.withOpacity(0.9));
}

void showCustomNoticeQuickSnacker(String message,
    {bool isError = true, String title = "Error"}) {
  Get.snackbar(title, message,
      duration: const Duration(seconds: 1),
      titleText: BigText(
        text: title,
        color: Colors.white,
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blueAccent.withOpacity(0.9));
}

void showCustomGreenSnacker(String message,
    {bool isError = true, String title = "Error"}) {
  Get.snackbar(title, message,
      duration: const Duration(seconds: 2),
      titleText: BigText(
        text: title,
        color: Colors.white,
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.9));
}
