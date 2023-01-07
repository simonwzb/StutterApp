// ignore: file_names
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/ui/MainPage.dart';
import 'package:stutter_app/util/color_util.dart';
import 'package:stutter_app/widget/svglib/drawing_widget.dart';
import 'package:stutter_app/widget/svglib/line_animation.dart';
import 'package:stutter_app/widget/svglib/path_order.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  late Timer timerMain;

  int count = 3;
  bool hasJump = false;

  int startTime = new DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    if (Platform.isAndroid) {
      SystemUiOverlayStyle style = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          ///这是设置状态栏的图标和字体的颜色
          ///Brightness.light  一般都是显示为白色
          ///Brightness.dark 一般都是显示为黑色
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(style);
    }
    super.initState();
    const period = const Duration(seconds: 1);
    const timeout = const Duration(milliseconds: 500);
    Timer(timeout, () {
      Timer.periodic(period, (timer) {
        timerMain = timer;
        if (mounted) {
          setState(() {
            count = count - 1;
          });
        }
        if (count == 0) {
          jump();
          //_hasLoagin();
        }
      });
    });
  }

  /*_hasLoagin() async {
    bool hasLogin = await UserUtil.hasLogin();
    if(hasLogin){
      // 已登陆
      jump();
    }else{
      if (timerMain != null) {
        timerMain.cancel();
        //timerMain = null;
      }
      Navigator.pop(context);
      Navigator.pushNamed(context, "loginPage",arguments: {'splashToLogin':true,'firstLogin':true});
    }
  }*/

  void jump() {
    if (hasJump) {
      return;
    }
    hasJump = true;
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return MainPage();
    }));
  }

  @override
  void dispose() {
    if (timerMain != null) {
      timerMain.cancel();
      //timerMain = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: null,
        //resizeToAvoidBottomInset: false,
        body: Container(
            child: new Stack(
          children: [
            Container(
              width: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                  .size
                  .width,
              height: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                      .size
                      .height +
                  MediaQueryData.fromWindow(window).padding.top,
              //alignment: Alignment.center,
              child: Image.asset(
                "assets/img/bg_launding_page.png",
                fit: BoxFit.fill,
                height:
                    MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                            .size
                            .height +
                        MediaQueryData.fromWindow(window).padding.top,
                //alignment: Alignment.bottomCenter,
              ),
            ),
            Container(
              height: 23.5,
              child: Row(
                children: [
                  Expanded(child: new SizedBox()),
                  Container(
                      width: 61,
                      height: 23.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(color: ColorUtil.Gray99(), width: 1)),
                      child: new GestureDetector(
                        onTap: () {
                          // _hasLoagin();
                          jump();
                        },
                        child: new Stack(
                          children: [
                            Center(
                                child: Container(
                              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Row(
                                children: [
                                  SizedBox(width: 2),
                                  Text("跳过",
                                      style: TextStyle(
                                          color: ColorUtil.Gray99(),
                                          fontSize: 12)),
                                  SizedBox(width: 2),
                                  Text(count.toString() + "S",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 12)),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ))
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 26 * 2.15, 13.5, 0),
              width: double.infinity,
            ),
            Column(
              children: [
                SizedBox(height: 48),
                FractionalTranslation(
                    translation: const Offset(0, 0.0),
                    child: Container(
                      child: Container(
                        /*width:MediaQueryData.fromWindow(
                                    WidgetsBinding.instance!.window)
                                .size
                                .width *
                            3.
                            4*/
                        height: MediaQueryData.fromWindow(
                                    WidgetsBinding.instance!.window)
                                .size
                                .width /
                            6,
                        child: AnimatedDrawing.svg(
                          "assets/child6.svg",
                          run: isSvgRunning,
                          duration: new Duration(milliseconds: 2500),
                          lineAnimation: LineAnimation.oneByOne,
                          animationCurve: Curves.linear,
                          animationOrder: PathOrders.leftToRight,
                          onFinish: () {
                            setState(() {
                              isSvgRunning = false;
                            });
                          },
                        ),
                      ),
                    )),
                Spacer()
              ],
            )
          ],
        )),
      ),
    );
  }

  bool isSvgRunning = true;
}
