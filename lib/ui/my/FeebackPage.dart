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
import 'package:oktoast/oktoast.dart';
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

class FeedbackPage extends StatefulWidget {
  @override
  State createState() => _FeedbackPageState();
}

TextEditingController titleController = TextEditingController();
TextEditingController despController = TextEditingController();

///用来控制  TextField 焦点的获取与关闭
FocusNode focusNodeTitle = new FocusNode();
FocusNode focusNodeDesp = new FocusNode();

class _FeedbackPageState extends State<FeedbackPage> {
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
                      width: MediaQuery.of(context).size.width,
                      height: 115,
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
                      child: Container(
                          padding: EdgeInsets.fromLTRB(7.5, 80, 0, 0),
                          child: Center(
                            child: Text(
                              "您的反馈，\n是我们继续加油的力量来源。\n谢谢您真的支持。"  ,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87),
                            ),
                          )),
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
                  expandedHeight: 115,
                  floating: false,
                  snap: false,
                  pinned: true,
                  titleSpacing: 1,
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(32),
                      child: Row(children: [
                        Spacer(),
                        FractionalTranslation(
                            translation: const Offset(0, 0),
                            child: MaterialButton(
                                height: 30,
                                color: Colors.brown.shade200,
                                highlightColor: Colors.brown,
                                splashColor: CustomTheme.loginGradientEnd,
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.5),
                                  child: Text(
                                    '提交',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onPressed: () async {
                                  if (titleController.text.length == 0 ||
                                      titleController.text.length > 100) {
                                    showToast("请填写联系方式");
                                    return;
                                  }
                                  if (despController.text.length == 0) {
                                    showToast("反馈内容不能为空");
                                    return;
                                  }
                                  if (despController.text.length > 1000) {
                                    showToast("反馈内容不能多余1000字");
                                    return;
                                  }
                                  Map? _data = {
                                    'text': despController.text,
                                    'contact': titleController.text,
                                  };
                                  print(_data.toString());
                                  Dio _dio = DioUtil.getInstance()!.dio;
                                  await _dio
                                      .put(
                                          DioUtil.BASE_URL +
                                              "/v1/feedback/submit",
                                          data: _data)
                                      .then((value) async {
                                    showToast("已成功反馈~");
                                    await Future.delayed(
                                        Duration(milliseconds: 1800));
                                    Navigator.pop(context);
                                  }).onError((error, stackTrace) async {
                                    showToast("已成功反馈~");
                                    await Future.delayed(
                                        Duration(milliseconds: 1800));
                                    Navigator.pop(context);
                                  });
                                })),
                        SizedBox(
                          width: 4,
                        )
                      ]))),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Container(
                          child: TextFormField(
                            controller: despController,
                            maxLines: 20,
                            //enabled: isEnable,
                            focusNode: focusNodeDesp,
                            decoration: const InputDecoration(
                              hintText: "请输入1000个字以内内容",
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                textBaseline: TextBaseline.ideographic,
                              ),
                              labelText: "反馈内容",
                              labelStyle: TextStyle(color: Colors.brown),
                              prefixIcon:
                                  Icon(Icons.title, color: Colors.brown),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.5)),
                                borderSide: BorderSide(
                                  color: Colors.black87,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.5)),
                                borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(4.5, 9.5, 4.5, 0)),
                      Container(
                          child: TextField(
                            maxLines: 1,
                            //enabled: isEnable,
                            controller: titleController,
                            focusNode: focusNodeTitle,
                            decoration: const InputDecoration(
                              hintText: "请输入您的手机号/微信号/qq号",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                textBaseline: TextBaseline.ideographic,
                              ),
                              labelText: "联系方式",
                              labelStyle: TextStyle(color: Colors.brown),
                              prefixIcon: Icon(Icons.phone_outlined,
                                  color: Colors.brown),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.5)),

                                ///用来配置边框的样式
                                borderSide: BorderSide(
                                  ///设置边框的颜色
                                  color: Colors.black87,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.5)),
                                borderSide: BorderSide(
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(4.5, 9.5, 14.5, 0)),
                    ]))
              ]))
            ]))));
  }
}
