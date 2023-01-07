import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/experience/ExperiencePage.dart';
import 'package:stutter_app/ui/home/HomePage.dart';
import 'package:stutter_app/ui/my/MyPage.dart';
import 'package:stutter_app/ui/research/ResearchPage.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:stutter_app/widget/updater/src/controller.dart';
import 'package:stutter_app/widget/updater/src/enums.dart';
import 'package:stutter_app/widget/updater/updater.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemUiOverlayStyle style = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          ///这是设置状态栏的图标和字体的颜色
          ///Brightness.light  一般都是显示为白色
          ///Brightness.dark 一般都是显示为黑色
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(style);
    }
    if (Platform.isAndroid) checkUpdate();
  }

  UpdaterController controller = UpdaterController(
    listener: (UpdateStatus status) {
      print('Listener: $status');
    },
    onChecked: (bool isAvailable) {
      print(isAvailable);
    },
    progress: (current, total) {
      print('Progress: $current -- $total');
    },
    onError: (status) {
      print('Error: $status');
    },
  );

  checkUpdate() async {
    bool isAvailable = await Updater(
      context: context,
      url: DioUtil.BASE_URL + "/v1/update/last?author=wzb198911290019",
      titleText: '更新APP',
      confirmText: "更新",
      cancelText: "下次",
      contentText: "",
      // backgroundDownload: false,
      // allowSkip: false,
      // allowSkip: false,
      callBack:
          (versionName, versionCode, contentText, minSupport, downloadUrl) {
        print(
            '$versionName - $versionCode - $contentText - $minSupport - $downloadUrl');
      },
      controller: controller,
    ).check();
    print(isAvailable);
  }

  final List<TitledNavigationBarItem> items = [
    TitledNavigationBarItem(
        title: Text(
          '首页',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: Icon(Icons.home)),
    TitledNavigationBarItem(
        title: Text('痊愈', style: TextStyle(fontWeight: FontWeight.w600)),
        icon: Icon(Icons.vpn_key_outlined)),
    TitledNavigationBarItem(
        title: Text('研学', style: TextStyle(fontWeight: FontWeight.w600)),
        icon: Icon(Icons.apartment_outlined)),
    TitledNavigationBarItem(
        title: Text('我的', style: TextStyle(fontWeight: FontWeight.w600)),
        icon: Icon(Icons.person_outline)),
  ];
  int currentIndex = 0;
  List<Widget> listTabs = [];
  final PageController pageController = PageController();
  final Curve _curve = Curves.ease;
  final Duration _duration = Duration(milliseconds: 300);

  _navigateToPage(value) {
    pageController.animateToPage(value, duration: _duration, curve: _curve);
    setState(() {
      currentIndex = value;
    });
  }

  DateTime? lastPopTime = null;

  @override
  Widget build(BuildContext context) {
    setState(() {
      listTabs = [
        HomePage(context),
        ExperiencePage(context),
        ResearchPage(context),
        MyPage(context)
      ];
    });
    return WillPopScope(
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime!) > Duration(seconds: 3)) {
            lastPopTime = DateTime.now();
            showToast('再按一次退出');
            return false;
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        },
        child: MaterialApp(debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: Platform.isAndroid ? "FZRBlack" : ''),
            home: Scaffold(
                appBar: null,
                body: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  onPageChanged: (page) {
                    setState(() {
                      currentIndex = page;
                    });
                  },
                  children: listTabs,
                ),
                bottomNavigationBar: TitledBottomNavigationBar(
                  height: 60,
                  indicatorHeight: 2,
                  currentIndex: currentIndex,
                  onTap: (index) {
                    _navigateToPage(index);
                  },
                  reverse: false,
                  curve: Curves.linearToEaseOut,
                  items: items,
                  activeColor: Colors.brown,
                  inactiveColor: Colors.brown,
                ))));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
