import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../utils/dimensions.dart';

class PlayerMarquee extends StatelessWidget {
  final String text;
  const PlayerMarquee({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: '正在播放 $text',
      style:
          TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font18),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 20.0,
      velocity: 100.0,
      pauseAfterRound: const Duration(seconds: 1),
      //startPadding: 10.0,
      accelerationDuration: const Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}
