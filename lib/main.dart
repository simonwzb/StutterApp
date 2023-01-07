import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/SplashPage.dart';
import 'package:stutter_app/ui/article/ArticlePage.dart';
import 'package:stutter_app/ui/editor/EditorPage.dart';
import 'package:stutter_app/ui/login/pages/login_page.dart';
import 'package:stutter_app/ui/my/AboutPage.dart';
import 'package:stutter_app/ui/my/FeebackPage.dart';
import 'package:stutter_app/util/color_util.dart';

Future<void> main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized(); //必须要添加这个进行初始化 否则下面会错误
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SpUtil.getInstance();
  DioUtil.CACHE_ENABLE = false;
  DioUtil.getInstance()?.openLog();
  initXUpdate();
  runApp(MyApp());
}

//初始化
void initXUpdate() {}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorState = new GlobalKey();
  static RouteObserver<PageRoute> routeObserver = new RouteObserver();

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Stack(
      children: [
        MaterialApp(debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: Platform.isAndroid? "FZRBlack" :'',
            primaryIconTheme: const IconThemeData(color: Colors.brown),
            brightness: Brightness.light,
            primaryColor: ColorUtil.BlueNornal(),
            backgroundColor: Colors.brown,
            accentColor: ColorUtil.GrayF4(),
          ),
          /*navigatorKey: MyApp.navigatorState,
                  onGenerateRoute: (RouteSettings settings) {
                    RouteFactory func = routerMap[settings.name];
                    if (func == null) {
                      return null;
                    }
                    return func(settings);
                  },*/

          home: WillPopScope(
            onWillPop: () async => false,
            child: SplashPage(),
          ),
          builder: (context, widget) {
            return MediaQuery(
                //设置文字大小不随系统设置改变
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!);
          },
          navigatorKey: NavigationService.navigationKey,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginPage());
              case '/about':
                return MaterialPageRoute(builder: (_) => AboutPage());
              case '/feedback':
                return MaterialPageRoute(builder: (_) => FeedbackPage());
              case '/editorPage':
                return MaterialPageRoute(
                    builder: (_) => EditorPage(settings.arguments as bool));
              /*case '/detail_screen':
                return MaterialPageRoute(builder: (_) => DetailScreen(message: settings.arguments));*/
              default:
                return null;
            }
          },
        )
      ],
    ));
  }
}
