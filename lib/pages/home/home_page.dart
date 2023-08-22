import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import 'package:xueba/pages/account/account_page.dart';

import 'package:xueba/pages/home/main_video_page.dart';
import 'package:xueba/pages/search/search_page.dart';

import 'package:xueba/utils/dimensions.dart';
import 'package:get/get.dart';

import 'ad_page.dart';
import 'content_page.dart';
import 'second_home_page.dart';

class HomePage extends StatefulWidget {
  int? bottom_id;
  HomePage({
    Key? key,
    this.bottom_id,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List pages = [
    const MainVideoPage(),
    const SearchPage(),
    const ContentPage(),
    const ADPage(),
    const AccountPage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void onTapNav(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     if (widget.bottom_id != null) {
  //       _selectedIndex = widget.bottom_id!;
  //       widget.bottom_id = null;
  //     }
  //   });
  // }

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
      child: AdaptiveScaffold(
        smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
        mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
        largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
        useDrawer: false,
        // navigationRailWidth: Dimensions.width10 * 8,
        extendedNavigationRailWidth: 150,
        bodyRatio: 0.65,

        selectedIndex: _selectedIndex,
        onSelectedIndexChange: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            selectedIcon: Icon(Icons.home_rounded),
            label: '主页',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: '搜索',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: '资料',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_rounded),
            selectedIcon: Icon(Icons.card_giftcard_rounded),
            label: '福利',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: '我的',
          ),
        ],

        smallBody: (_) => pages[_selectedIndex],
        body: (_) => pages[_selectedIndex],
        largeBody: (_) => pages[_selectedIndex],

        // Define a default secondaryBody.
        smallSecondaryBody: AdaptiveScaffold.emptyBuilder,
        secondaryBody: AdaptiveScaffold.emptyBuilder,
        largeSecondaryBody: (_) => SecondHomePage(),
        // Container(
        //   color: const Color.fromARGB(255, 234, 158, 192),
        // ),
        // // // // Override the default secondaryBody during the smallBreakpoint to be
        // // // // empty. Must use AdaptiveScaffold.emptyBuilder to ensure it is properly
        // // // // overridden.
        // smallSecondaryBody: AdaptiveScaffold.emptyBuilder,

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
