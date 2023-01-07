import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loadmore/loadmore.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../network/dio_util.dart';
import '../../util/MD5Util.dart';
import '../article/ArticlePage.dart';
import '../login/pages/login_page.dart';

class ExpHealthyPage extends StatefulWidget {
  var parentContext;

  ExpHealthyPage(this.parentContext);

  @override
  State createState() => _ExpHealthyPageState();
}

class _ExpHealthyPageState extends State<ExpHealthyPage>
    with
        AutomaticKeepAliveClientMixin<ExpHealthyPage>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final webViewKey = GlobalKey<_ExpHealthyPageState>();
  final NavigationService navService = NavigationService();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    loadPaged();
  }

  @override
  Widget build(BuildContext context) {
    return  _buildPubu() ;
  }

  static List<String> agestageArrDefault = ['儿童', '成年'];
  static List<String> paiArrDefault = ['心理学派', '矫正派', '其它派'];
  static List<String> degreeArrDefault = ['偶尔', '日常', '严重时说不出话'];

  List<String> healthArr = ['心路秘籍'];
  List<String> agestageArr = agestageArrDefault;
  List<String> paiArr = paiArrDefault;
  List<String> degreeArr = degreeArrDefault;
  List<Map<String, dynamic>> res = [];
  bool isRecomond = true;
  int pageNumber = 0;
  int PAGE_COUNT = 20;
  List<String> extras = [];

  getRecomond() async {
    Dio _dio = DioUtil.getInstance()!.dio;
    await _dio.post(DioUtil.BASE_URL + "/v1/articles/recomond", data: {
      'healthArr': healthArr,
      'agestageArr': agestageArr,
      'paiArr': paiArr,
      'degreeArr': degreeArr,
    }).then((value) {
      extras.clear();
      for (var item in res) {
        extras.add(item['_id']);
      }
      setState(() {
        res = new List<Map<String, dynamic>>.from(value.data['data']);
        extras = extras;
      });
    });
  }

  loadPaged() async {
    pageNumber++;
    Dio _dio = DioUtil.getInstance()!.dio;
    await _dio.post(DioUtil.BASE_URL + "/v1/articles/list", data: {
      'pageNumber': pageNumber.toString(),
      'pageItemCount': PAGE_COUNT.toString(),
      'healthArr': healthArr,
      'agestageArr': agestageArr,
      'paiArr': paiArr,
      'degreeArr': degreeArr,
      'extras': extras
    }).then((value) {
      List<Map<String, dynamic>> tmp =
          new List<Map<String, dynamic>>.from(value.data['data']);
      res.addAll(tmp);
      setState(() {
        res = tmp;
      });
    });
  }

  Widget _buildPubu() {
    return LoadMore(
      //textBuilder: LoadMoreTextBuilder(),
      //isFinish: count >= 60,
      onLoadMore: () async {
        print("onLoadMore");
        await Future.delayed(Duration(seconds: 0, milliseconds: 100));
        await loadPaged();
        return true;
      },
      child: SliverMasonryGrid.count(
        childCount: res.length,
        crossAxisCount: 2,
        //mainAxisSpacing: 1,
        //crossAxisSpacing: 1,
        //shrinkWrap: true,
        itemBuilder: (context, index) {
          return Ink(
              child: InkWell(
                  child: Card(
                    color: Color(0xFFFFF2E2),
                    shadowColor: Colors.black,
                    elevation: 3,
                    borderOnForeground: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(3.5, 3.5, 3.5, 1.5),
                            child: Text(
                              res[index]['title'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(3.5, 0, 3.5, 2.5),
                            child: Text(
                              res[index]['description'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.normal),
                            )),
                        ExtendedImage.network(res[index]['imgUrl'],
                            cache: true,
                            cacheRawData: true,
                            imageCacheName:
                                MD5Util.generateMd5(res[index]['imgUrl']),
                            cacheMaxAge: Duration(days: 15),
                            cacheKey: MD5Util.generateMd5(res[index]['imgUrl']),
                            fit: BoxFit.contain,
                            border: Border(
                                left: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                )),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0)),
                            loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              //_controller.reset();
                              return Center(
                                  child: Container(
                                height: MediaQueryData.fromWindow(
                                            WidgetsBinding.instance!.window)
                                        .size
                                        .width *
                                    2 /
                                    3,
                                child: Center(
                                    child: SpinKitThreeBounce(
                                  size: 12.5,
                                  color: Colors.brown,
                                )),
                              ));
                              break;
                            case LoadState.completed:
                              return /*FadeTransition(
                                  opacity: _controller,*/
                                  ExtendedRawImage(
                                image: state.extendedImageInfo?.image,
                              );
                              break;
                            case LoadState.failed:
                              return Container(
                                height: MediaQueryData.fromWindow(
                                            WidgetsBinding.instance!.window)
                                        .size
                                        .width *
                                    2 /
                                    3,
                              );
                          }
                        }),
                        SizedBox(
                          height: 0,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(widget.parentContext,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return ArticlePage(res[index]['_id']);
                    }));
                  }));
        },
        //itemCount: extents.length,
      ),
    );
  }
}
