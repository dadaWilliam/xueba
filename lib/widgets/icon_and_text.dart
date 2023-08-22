import 'package:flutter/material.dart';
import 'package:xueba/utils/dimensions.dart';
import 'package:xueba/widgets/small_text.dart';

class IconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  double size;

  IconAndText(
      {Key? key,
      required this.icon,
      required this.text,
      required this.color,
      required this.iconColor,
      this.size = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: Dimensions.width5,
        ),
        Icon(
          icon,
          color: Theme.of(context).brightness == Brightness.dark
              ? iconColor.withOpacity(0.9)
              : iconColor.withOpacity(1),
          size: size == 0 ? Dimensions.iconSize16 : size,
        ),
        SizedBox(
          width: Dimensions.width5,
        ),
        SmallText(
          text: text,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white54
              : color,
        ),
        SizedBox(
          width: Dimensions.width5,
        ),
      ],
    );
  }
}
