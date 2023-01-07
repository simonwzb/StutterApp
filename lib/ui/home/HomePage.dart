import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:loadmore/loadmore.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/network/dio_method.dart';
import 'package:stutter_app/network/dio_response.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/article/ArticlePage.dart';
import 'package:stutter_app/util/MD5Util.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:stutter_app/widget/svglib/drawing_widget.dart';
import 'package:stutter_app/widget/svglib/line_animation.dart';
import 'package:stutter_app/widget/svglib/path_order.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class HomePage extends StatefulWidget {
  var parentContext;

  HomePage(this.parentContext);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin<HomePage>,
        SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  late AnimationController _controller;
  double HEADER_HEIGHT = 32 * 4 + 1.5;
  bool isToTop = false;
  List<Map<String, dynamic>> res = [];
  bool isRecomond = true;
  int pageNumber = 0;
  int PAGE_COUNT = 20;
  List<String> extras = [];
  static List<String> healthArrDefault = ['心路秘籍', '治疗成果'];
  static List<String> agestageArrDefault = ['儿童', '成年'];
  static List<String> paiArrDefault = ['心理学派', '矫正派', '其它派'];
  static List<String> degreeArrDefault = ['偶尔', '日常', '严重时说不出话'];

  List<String> healthArr = healthArrDefault;
  List<String> agestageArr = agestageArrDefault;
  List<String> paiArr = paiArrDefault;
  List<String> degreeArr = degreeArrDefault;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 300),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
    getRecomond();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      'pageNumber': pageNumber,
      'pageItemCount': PAGE_COUNT,
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

  bool navBarMode = false;
  final rnd = Random();
  late List<int> extents;
  int crossAxisCount = 2;
  bool isExpand = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: choices.length,
            initialIndex: 0,
            child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(38),
                    child: Container(
                      child: NewGradientAppBar(
                        title: null,
                        titleSpacing: 0.00,
                        centerTitle: true,
                        elevation: 0.0,
                        gradient: LinearGradient(colors: [
                          Colors.brown,
                          Color(0xFFA1887F),
                          Color(0x33D7CCA0)
                        ]),
                        bottom: PreferredSize(
                            preferredSize: Size.fromHeight(32),
                            child: Row(
                                //alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      "assets/img/logo_middle.png",
                                      fit: BoxFit.fill,
                                      height: 30,
                                      //alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6.5, 2, 0, 0),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      "assets/img/logo_name_white.png",
                                      fit: BoxFit.fill,
                                      height: 23.5,
                                      //alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                                  Spacer(),
                                  TabBar(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                    isScrollable: true,
                                    indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                            width: 2.75, color: Colors.white),
                                        insets: EdgeInsets.symmetric(
                                            vertical: 0.0)),
                                    tabs: choices.map((Choice choice) {
                                      return SizedBox(
                                          child: Tab(
                                        height: 32,
                                        text: choice.title,

                                        ///icon: new Icon(choice.icon),
                                      ));
                                    }).toList(),
                                  ),
                                ])),
                      ),
                    )),
                body: buildPuBu())));
  }

  Widget buildPuBu() {
    return CustomScrollView(/*primary: false, controller: _controller,*/
        slivers: [
      SliverAppBar(
        pinned: true,
        floating: true,
        backgroundColor: Colors.brown.shade200,
        expandedHeight: HEADER_HEIGHT,
        collapsedHeight: 0,
        toolbarHeight: 0,
        flexibleSpace: FlexibleSpaceBar(
            title: Text(
              '',
              style: TextStyle(color: Colors.brown),
            ),
            background: Stack(
              children: [
                GradientCard(
                  gradient: Gradients.buildGradient(
                      Alignment.topLeft, Alignment.topRight, const [
                    Colors.white,
                    Color(0xFFEFEBE9),
                  ]),
                  margin: const EdgeInsets.all(0),
                  shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
                  elevation: 8,
                  child: Container(),
                ),
                Stack(
                  children: [Column(children: buildHead()), buildSvg()],
                ),
              ],
            )),
      ),
      LoadMore(
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
          crossAxisCount: crossAxisCount,
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
                                    fontFamily: Platform.isAndroid?"FZRBlack":'',
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
                                    fontFamily: Platform.isAndroid?"FZRBlack":'',
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
                              cacheKey:
                                  MD5Util.generateMd5(res[index]['imgUrl']),
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
                                  width: 50,
                                  child: Center(
                                      child: SpinKitThreeBounce(
                                    size: 12.5,
                                    color: Colors.brown,
                                  )),
                                ));
                                break;

                              ///if you don't want override completed widget
                              ///please return null or state.completedWidget
                              //return null;
                              //return state.completedWidget;
                              case LoadState.completed:
                                _controller.forward();
                                return /*FadeTransition(
                                  opacity: _controller,*/
                                    ExtendedRawImage(
                                  image: state.extendedImageInfo?.image,
                                  //width: ScreenUtil.instance.setWidth(600),
                                  //height: ScreenUtil.instance.setWidth(400),
                                );
                                break;
                              case LoadState.failed:
                                _controller.reset();
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
                      print(res[index]['_id']);
                      Navigator.push(widget.parentContext,
                          new MaterialPageRoute(
                              builder: (BuildContext context) {
                        return ArticlePage(res[index]['_id']);
                      }));
                    }));
          },
          //itemCount: extents.length,
        ),
      )
    ]);
  }

  List<Map<String, dynamic>> shuffle(List<Map<String, dynamic>> items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  List<Widget> buildHead() {
    return [
      Container(
          height: 32,
          child: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 32,
                  child: TabBar(
                    isScrollable: true,
                    labelStyle: TextStyle(fontWeight: FontWeight.w300),
                    indicatorColor: Colors.brown,
                    tabs: [
                      Tab(
                        text: "默认",
                      ),
                      Tab(
                        text: "偶尔",
                      ),
                      Tab(
                        text: "日常",
                      ),
                      Tab(
                        text: "严重时讲不出话",
                      ),
                    ],
                    labelColor: Colors.black,
                    indicator: MaterialIndicator(
                      height: 2.5,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      horizontalPadding: 16,
                      tabPosition: TabPosition.bottom,
                    ),
                    onTap: (index) {
                      if (index == 0) {
                        degreeArr = degreeArrDefault;
                      } else {
                        degreeArr = [degreeArrDefault[index - 1]];
                      }
                      pageNumber = 0;
                      getRecomond();
                    },
                  ),
                ),
              ))),
      Container(
          height: 32,
          child: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 32,
                  child: TabBar(
                    labelStyle: TextStyle(fontWeight: FontWeight.w300),
                    isScrollable: true,
                    indicatorColor: Colors.brown,
                    tabs: [
                      Tab(
                        text: "默认",
                      ),
                      Tab(
                        text: "心理学派",
                      ),
                      Tab(
                        text: "矫正派",
                      ),
                      Tab(
                        text: "其它派",
                      ),
                    ],
                    labelColor: Colors.black,
                    indicator: MaterialIndicator(
                      height: 2.5,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      horizontalPadding: 16,
                      tabPosition: TabPosition.bottom,
                    ),
                    onTap: (index) {
                      if (index == 0) {
                        paiArr = paiArrDefault;
                      } else {
                        paiArr = [paiArrDefault[index - 1]];
                      }
                      pageNumber = 0;
                      getRecomond();
                    },
                  ),
                ),
              ))),
      Container(
          height: 32,
          child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 32,
                  child: TabBar(
                    labelStyle: TextStyle(fontWeight: FontWeight.w300),
                    isScrollable: true,
                    indicatorColor: Colors.brown,
                    tabs: [
                      Tab(
                        text: "默认",
                      ),
                      Tab(
                        text: "心路秘籍",
                      ),
                      Tab(
                        text: "治疗成果",
                      )
                    ],
                    labelColor: Colors.black,
                    indicator: MaterialIndicator(
                      height: 2.5,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      horizontalPadding: 16,
                      tabPosition: TabPosition.bottom,
                    ),
                    onTap: (index) {
                      if (index == 0) {
                        healthArr = healthArrDefault;
                      } else {
                        healthArr = [healthArrDefault[index - 1]];
                      }
                      pageNumber = 0;
                      getRecomond();
                    },
                  ),
                ),
              ))),
      Container(
        height: 32,
        child: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 32,
                child: TabBar(
                  labelStyle: TextStyle(fontWeight: FontWeight.w300),
                  isScrollable: true,
                  indicatorColor: Colors.brown,
                  tabs: [
                    Tab(
                      text: "默认",
                    ),
                    Tab(
                      text: "儿童",
                    ),
                    Tab(
                      text: "成年",
                    ),
                  ],
                  labelColor: Colors.black,
                  indicator: MaterialIndicator(
                    height: 2.5,
                    topLeftRadius: 8,
                    topRightRadius: 8,
                    horizontalPadding: 16,
                    tabPosition: TabPosition.bottom,
                  ),
                  onTap: (index) {
                    if (index == 0) {
                      agestageArr = agestageArrDefault;
                    } else {
                      agestageArr = [agestageArrDefault[index - 1]];
                    }
                    pageNumber = 0;
                    getRecomond();
                  },
                ),
              ),
            )),
      ),
    ];
  }

  bool isSvgRuning = true;

  Widget buildSvg() {
    return Row(
      children: [
        Spacer(),
        Expanded(
            child: Column(
          children: [
            Spacer(),
            FractionalTranslation(
                translation: const Offset(0.92, 0.1),
                child: Container(
                  height: HEADER_HEIGHT * 1.55 / 3,
                  child: Container(
                    child: AnimatedDrawing.svg("assets/${assets[0][0]}.svg",
                        run: true,
                        duration: new Duration(seconds: 18),
                        lineAnimation: LineAnimation.oneByOne,
                        animationCurve: Curves.linear,
                        animationOrder: PathOrders.original,
                        onFinish: () {}),
                    width: HEADER_HEIGHT * 1.55 / 3,
                  ),
                ))
          ],
        ))
      ],
    );
  }

  List<List> assets = [
    [
      'child7',
      LineAnimation.oneByOne,
      Curves.linear,
      5,
      Colors.black,
      false,
      PathOrders.original,
      "https://www.flickr.com/photos/britishlibrary/11290437266",
      "Colors and more!"
    ],
  ];

  List<Curve> curves = [
    Curves.bounceIn,
    Curves.bounceInOut,
    Curves.bounceOut,
    Curves.decelerate,
    Curves.elasticIn,
    Curves.elasticInOut,
    Curves.elasticOut,
    Curves.linear
  ];

  bool isRunning = false; //all drawings are paused in the beginning
  int previousScreen = 0;
  bool cardExpanded = false;
  bool showSwipe = false;
  bool showStartButton = true;
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  //const Choice(title: '关注', icon: Icons.recommend),
  const Choice(title: '推荐', icon: Icons.push_pin_outlined),
];
