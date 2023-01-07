import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WikiPage extends StatefulWidget {
  var parentContext;

  WikiPage(this.parentContext);

  @override
  State createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage>
    with AutomaticKeepAliveClientMixin<WikiPage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final webViewKey = GlobalKey<WebViewContainerState>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        WebViewContainer(key: webViewKey),
        Container(
          height: 43.5,
          child: Center(
              child: Row(
                  //alignment: Alignment.centerLeft,
                  children: [
                SizedBox(
                  width: 43.5,
                ),
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                            width: 12,
                            height: 43.5,
                            child: Icon(
                              Icons.refresh_outlined,
                              size: 10,
                              color: Colors.black26,
                            )),
                        Spacer(),
                        Text("互相帮助，战胜口吃",
                            style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic)),
                        Container(
                          padding: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/img/logo_middle.png",
                            fit: BoxFit.fill,
                            height: 25,
                            //alignment: Alignment.bottomCenter,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    color: Colors.white,
                  ),
                  onTap: () {
                    webViewKey.currentState?.reloadWebView();
                  },
                ))
              ])),
        ),
      ],
    ));
  }
}

class WebViewContainer extends StatefulWidget {
  WebViewContainer({required Key key}) : super(key: key);

  @override
  WebViewContainerState createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  String bdUrl =
      "https://baike.baidu.com/item/%E5%8F%A3%E5%90%83/1678438?fr=aladdin";
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bdUrl,
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      //JS执行模式 是否允许JS执行
      javascriptMode: JavascriptMode.unrestricted,
      zoomEnabled: false,
      backgroundColor: Color(0x33D7CCA0),
      gestureNavigationEnabled: true,
      gestureRecognizers: [
        Factory(() => VerticalDragGestureRecognizer()),
        // 指定WebView只处理垂直手势。
      ].toSet(),
    );
  }

  void reloadWebView() {
    setState(() {
      bdUrl:
      bdUrl;
    });
    _webViewController.loadUrl(bdUrl);
  }
}
