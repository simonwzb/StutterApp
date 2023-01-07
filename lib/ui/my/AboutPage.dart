import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:stutter_app/util/string_util.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../theme.dart';
import '../../util/MD5Util.dart';
import '../../widget/svglib/drawing_widget.dart';
import '../../widget/svglib/line_animation.dart';
import '../../widget/svglib/path_order.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String keUrl = "http://media.getlijin.com/laowei-wx.jpg";
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: MaterialApp(debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: Platform.isAndroid?"FZRBlack":'' 
          ),
            home: Scaffold(
                body: CustomScrollView(
                    /*primary: false, controller: _controller,*/
                    slivers: [
              SliverAppBar(
                backgroundColor: Colors.white54,
                flexibleSpace: new FlexibleSpaceBar(
                  background: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Expanded(
                          child: Container(
                            child: AnimatedDrawing.svg("assets/egypt1.svg",
                                run: true,
                                duration: new Duration(seconds: 6),
                                lineAnimation: LineAnimation.allAtOnce,
                                animationCurve: Curves.linear,
                                animationOrder: PathOrders.decreasingLength,
                                onFinish: () {}),
                          ),
                        ),
                        Container(
                          child: Text(
                            "战胜这古老的疾病，口吃",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 9.5,
                                fontStyle: FontStyle.normal,
                                color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ),
                  centerTitle: false,
                  collapseMode: CollapseMode.pin,
                ),
                leading: new IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                expandedHeight: 155,
                floating: false,
                snap: false,
                pinned: true,
                titleSpacing: 1,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: <Color>[
                            Colors.brown.shade200,
                            Colors.white70
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: <double>[0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(children: [
                      Row(children: [
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 44,
                            ),
                            Row(
                              //alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "assets/img/logo_middle.png",
                                    fit: BoxFit.fill,
                                    height: 55,
                                    //alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6.5, 2, 0, 0),
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    "assets/img/logo_name_white.png",
                                    fit: BoxFit.fill,
                                    height: 22.5,
                                    //alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 45,
                            ),
                            Container(
                              width: MediaQueryData.fromWindow(
                                      WidgetsBinding.instance!.window)
                                  .size
                                  .width,
                              child: Center(
                                child: Text(
                                  "“互相帮助，战胜口吃!”",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 26.5,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: MediaQueryData.fromWindow(
                                          WidgetsBinding.instance!.window)
                                      .size
                                      .width *
                                  2.3 /
                                  3,
                              child: Text(
                                "口吃社群体口袋里的App",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ))
                      ]),
                      SizedBox(
                        height: 150,
                      ),
                      Row(children: [
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 44,
                            ),
                            Row(
                              //alignment: Alignment.centerLeft,
                              children: [
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 2, 6.5, 0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "联系方式：老魏@熹学科技",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16.5,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black87),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                                    child: ExtendedImage.network(
                                      keUrl,
                                      height: 55,
                                      width: 55,
                                      cache: true,
                                      cacheRawData: true,
                                      imageCacheName:
                                          MD5Util.generateMd5(keUrl),
                                      cacheMaxAge: Duration(days: 15),
                                      cacheKey: MD5Util.generateMd5(keUrl),
                                      border: Border.all(
                                        color: Colors.black87,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(27.5)),
                                    )),
                                SizedBox(
                                  width: 12,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 40,
                              child: ListTile(
                                leading: Icon(Icons.email_outlined),
                                title: Text(
                                  "simon.wei@live.cn",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.blue.shade300),
                                ),
                                textColor: Colors.white,
                              ),
                            ),
                            Container(
                              height: 40,
                              child: ListTile(
                                leading: Icon(Icons.wechat_outlined),
                                title: Text(
                                  "15904379685",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      decoration: TextDecoration.underline,
                                      color: Colors.black87),
                                ),
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ))
                      ])
                    ]))
              ]))
            ]))));
  }
}
