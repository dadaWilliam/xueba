import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xueba/pages/account/about.dart';

import 'package:xueba/pages/account/account_page.dart';
import 'package:xueba/pages/account/user_page.dart';

import 'package:xueba/pages/home/main_video_page.dart';
import 'package:xueba/pages/search/search_page.dart';
import 'package:xueba/pages/video/video_detail.dart';
import 'package:xueba/utils/colors.dart';

import '../../utils/dimensions.dart';
import '../video/popular_video_detail.dart';
import '../video/search_video_detail.dart';

class SecondHomePage extends StatefulWidget {
  int? bottom_id;
  SecondHomePage({
    Key? key,
    this.bottom_id,
  }) : super(key: key);

  @override
  State<SecondHomePage> createState() => _SecondHomePageState();
}

class _SecondHomePageState extends State<SecondHomePage> {
  int _selectedIndex = 0;

  List pages = [
    const AboutPage(),
    // const AccountPage(),
    const VideoDetail(),
    const SearchVideoDetail(),
    const PopularVideoDetail(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
      if (widget.bottom_id != null) {
        _selectedIndex = widget.bottom_id!;
        widget.bottom_id = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Dimensions.update(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
      // debugPrint(Dimensions.screenHeight.toString());
      // debugPrint(Dimensions.screenWidth.toString());
    });
    if (widget.bottom_id != null) {
      _selectedIndex = widget.bottom_id!;
      widget.bottom_id = null;
    }
    return AnnotatedRegion(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: pages[_selectedIndex],
        // bottomNavigationBar: BottomNavigationBar(
        //     selectedItemColor: AppColors.mainColor,
        //     unselectedItemColor: Colors.amberAccent,
        //     showSelectedLabels: false,
        //     showUnselectedLabels: false,
        //     selectedFontSize: 0.0,
        //     unselectedFontSize: 0.0,
        //     currentIndex: _selectedIndex,
        //     onTap: onTapNav,
        //     items: const [
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.home_rounded), label: "主页"),
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.search_rounded), label: "全部"),
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.person_rounded), label: "我的")
        //     ]),
      ),
    );
  }
}
