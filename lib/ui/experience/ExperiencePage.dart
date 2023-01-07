import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loadmore/loadmore.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/ui/experience/ExpHealthyPage.dart';
import 'package:stutter_app/ui/experience/ExpIllPage.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import '../../network/dio_util.dart';
import '../../util/MD5Util.dart';
import '../login/pages/login_page.dart';

class ExperiencePage extends StatefulWidget {
  var parentContext;

  ExperiencePage(this.parentContext);

  @override
  State createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
    with
        AutomaticKeepAliveClientMixin<ExperiencePage>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //extents = List<int>.generate(10000, (int index) => rnd.nextInt(5) + 1);
  }

  bool navBarMode = false;
  final rnd = Random();

  //late List<int> extents;
  int crossAxisCount = 2;
  final NavigationService navService = NavigationService();

  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: choices.length, vsync: this);
    return MaterialApp(debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: Platform.isAndroid?"FZRBlack":'' 
          ),
        home: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Container(
          child: NewGradientAppBar(
              title: null,
              titleSpacing: 0.00,
              centerTitle: true,
              gradient: LinearGradient(
                  colors: [Colors.brown, Color(0xFFA1887F), Color(0x33D7CCA0)]),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(75),
                  child: // new Transform(
                      //transform: new Matrix4.translationValues(0, -24.0, 0.0),
                      Align(
                          alignment: Alignment.center,
                          child: TabBar(
                            controller: tabController,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                            isScrollable: false,
                            indicator: MaterialIndicator(
                              height: 2.5,
                              topLeftRadius: 8,
                              topRightRadius: 8,
                              horizontalPadding: 25,
                              color: Colors.white,
                              tabPosition: TabPosition.bottom,
                            ),
                            tabs: choices.map((Choice choice) {
                              return SizedBox(
                                  child: Tab(
                                //height: 96,
                                text: choice.title,
                                icon: Icon(choice.icon),
                              ));
                            }).toList(),
                          )))),
        ),
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return !tabController.indexIsChanging && tabController.index == 0
            ? FloatingActionButton(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 8.5),
                      Icon(Icons.plus_one_sharp),
                      Text(
                        "投稿",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                tooltip: "投稿文章",
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                heroTag: null,
                elevation: 7.0,
                highlightElevation: 14.0,
                onPressed: () {
                  Map? user = SpUtil.getObject("user");
                  if (user != null && user.isNotEmpty) {
                    navService.pushNamed("/editorPage", args: true);
                  } else {
                    showToast("请登录后投稿");
                    Navigator.push(widget.parentContext,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return LoginPage();
                    }));
                  }
                },
                mini: false,
                shape: new CircleBorder(),
                isExtended: false,
              )
            : Container();
      }),
      floatingActionButtonLocation:
          !tabController.indexIsChanging && tabController.index == 0
              ? FloatingActionButtonLocation.endFloat
              : null,
      body: Container(
          child: TabBarView(
              controller: tabController,
              children: choices.map((Choice choice) {
                return CustomScrollView(
                    /*primary: false, controller: _controller,*/
                    slivers: (choice.title == "心路秘籍")
                        ? _buildHealthyWhole()
                        : _buildEillWhole());
              }).toList())),
    ));
  }

  List<Widget> _buildHealthyWhole() {
    return [
      /*SliverFillRemaining(
          hasScrollBody: false,
          child:*/ SliverList(
              delegate: SliverChildListDelegate([
            ...List.generate(
                1,
                (index) => Column(children: [
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 8),
                          Text(
                            "推荐专栏：",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer()
                        ],
                      ),
                      SizedBox(
                        height: 4.5,
                      ),
                      Container(
                          height: 125,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              itemWidgetMember(FakeInfo(
                                  name: 'HuizZ.',
                                  picUrl:
                                      "https://bkimg.cdn.bcebos.com/pic/a50f4bfbfbedab64034fe29db67fb8c379310a55b01f?x-bce-process=image/resize,m_lfit,w_536,limit_1/format,f_jpg",
                                  label: "社员",
                                  isNotOrg: true)),
                              itemWidgetMember(FakeInfo(
                                  name: '马小',
                                  picUrl:
                                  "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_360_360%2F9f%2F6a%2Fe4%2F9f6ae4d8a78f0b14bc4b5834c6f01952.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650972712&t=103fa3d4d0b7a061db755254b3aa088c",
                                  label: "元老",
                                  isNotOrg: true)),
                            ],
                          )),
                      Row(
                        children: [
                          SizedBox(width: 8),
                          Text(
                            "最近发表：",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer()
                        ],
                      ),
                      SizedBox(
                        height: 4.5,
                      ),
                    ]))
          ])) ,
      ExpHealthyPage(widget.parentContext)
    ];
  }

  List<Widget> _buildEillWhole() {
    return [
      SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                SizedBox(width: 8),
                Text(
                  "治疗师/机构/研究者：",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 4.5,
            ),
            Container(
                height: 188,
                child: ListView(
                  // 横向 horizontal 纵向 vertical
                  scrollDirection: Axis.horizontal,
                  children: _buildFakeMembers(),
                )),
            Row(
              children: [
                SizedBox(width: 8),
                Text(
                  "当日直播课：",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 4.5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 115,
                  width: 200,
                  child: ExtendedImage.network(keUrl,
                      height: 115,
                      width: 200,
                      cache: true,
                      cacheRawData: true,
                      imageCacheName: MD5Util.generateMd5(keUrl),
                      cacheMaxAge: Duration(days: 15),
                      cacheKey: MD5Util.generateMd5(keUrl),
                      border: Border.all(
                        color: Colors.brown.shade100,
                        width: 1,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return Center(
                            child: Container(
                          height: 80,
                          width: 50,
                          child: Center(
                              child: SpinKitThreeBounce(
                            size: 8.5,
                            color: Colors.brown,
                          )),
                        ));
                        break;
                      case LoadState.completed:
                        return ExtendedRawImage(
                          fit: BoxFit.cover,
                          image: state.extendedImageInfo?.image,
                          height: 115,
                          width: 200,
                        );
                      case LoadState.failed:
                        return Container(
                          height: 80,
                        );
                    }
                  }),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 1,
            ),
            Row(
              children: [
                SizedBox(
                  width: 9,
                ),
                Text("讲师："),
                Text(
                  "Dr.李媛媛",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
                Container(
                  width: 30,
                  padding: EdgeInsets.fromLTRB(1.5, 0.4, 1.5, 0.4),
                  child: Center(
                    child: Text(
                      "社员",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.5),
                    ),
                    border: Border.all(color: Colors.blueGrey, width: 1),
                  ),
                )
              ],
            ),
            Row(children: [
              SizedBox(
                width: 9,
              ),
              Text("开播时间："),
              Text(
                "18:00",
                style: TextStyle(
                    color: Colors.brown, decoration: TextDecoration.underline),
              ),
              Text("已报名："),
              Text(
                "104人",
                style: TextStyle(
                    color: Colors.brown, decoration: TextDecoration.underline),
              ),
            ]),
            SizedBox(
              height: 14.5,
            ),
            Row(
              children: [
                SizedBox(width: 8),
                Text(
                  "系列视频：",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Container(
                height: 165,
                child: ListView(
                  // 横向 horizontal 纵向 vertical
                  scrollDirection: Axis.horizontal,
                  children: _buildFakeClasses(),
                )),
            //_buildFakeClass(),
            SizedBox(
              height: 6.5,
            ),
            Row(
              children: [
                SizedBox(width: 8),
                Text(
                  "成果文章：",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
          ])),
      /*SliverFillRemaining(
        hasScrollBody: false,
        child: */
      ExpIllPage(widget.parentContext)
    ];
  }

  Widget itemWidgetClass(FakeClass fake) {
    return Container(
      width: 208.5,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Container(
                height: 115,
                width: 200,
                child: ExtendedImage.network(fake.picUrl,
                    height: 115,
                    width: 200,
                    cache: true,
                    cacheRawData: true,
                    imageCacheName: MD5Util.generateMd5(fake.picUrl),
                    cacheMaxAge: Duration(days: 15),
                    cacheKey: MD5Util.generateMd5(fake.picUrl),
                    border: Border.all(
                      color: Colors.brown.shade100,
                      width: 1,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Center(
                          child: Container(
                        height: 80,
                        width: 50,
                        child: Center(
                            child: SpinKitThreeBounce(
                          size: 8.5,
                          color: Colors.brown,
                        )),
                      ));
                      break;
                    case LoadState.completed:
                      return ExtendedRawImage(
                        fit: BoxFit.cover,
                        image: state.extendedImageInfo?.image,
                        height: 115,
                        width: 200,
                      );
                    case LoadState.failed:
                      return Container(
                        height: 80,
                      );
                  }
                }),
              ),
              Spacer()
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            children: [
              SizedBox(
                width: 9,
              ),
              Text("讲师："),
              Text(
                fake.author,
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
              Container(
                width: 30,
                padding: EdgeInsets.fromLTRB(1.5, 0.4, 1.5, 0.4),
                child: Center(
                  child: Text(
                    fake.label,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.5),
                  ),
                  border: Border.all(color: Colors.blueGrey, width: 1),
                ),
              ),
            ],
          ),
          Row(children: [
            SizedBox(
              width: 9,
            ),
            Text("课时："),
            Text(
              fake.count,
              style: TextStyle(
                  color: Colors.brown, decoration: TextDecoration.underline),
            ),
            Text("学费："),
            Text(
              "￥" + fake.price,
              style: TextStyle(
                  color: Colors.brown, decoration: TextDecoration.underline),
            ),
          ]),
        ],
      ),
    );
  }

  String keUrl =
      'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwww.5tu.cn%2Fattachments%2Fimage_files%2Fmonth_2003%2F202003090908572882.jpg&refer=http%3A%2F%2Fwww.5tu.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650979472&t=f473587943d9863d9eab77a90904ca0e';

  List<Widget> _buildFakeMembers() {
    return peopleFake.map((e) => itemWidgetMember(e)).toList();
  }

  List<Widget> _buildFakeClasses() {
    return classesFake.map((e) => itemWidgetClass(e)).toList();
  }

  Widget itemWidgetMember(FakeInfo fakeInfo) {
    //创建 列表 设置边距 高
    return Container(
      width: 85,
      margin: EdgeInsets.only(left: 6.5, top: 6, bottom: 6, right: 2),
      //设置圆角
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: fakeInfo.isNotOrg ? 70 : 120,
          width: fakeInfo.isNotOrg ? 70 : 75,
          child: ExtendedImage.network(fakeInfo.picUrl,
              height: fakeInfo.isNotOrg ? 80 : 100,
              width: 60,
              cache: true,
              cacheRawData: true,
              imageCacheName: MD5Util.generateMd5(fakeInfo.picUrl),
              cacheMaxAge: Duration(days: 15),
              cacheKey: MD5Util.generateMd5(fakeInfo.picUrl),
              border: Border.all(
                color: Colors.brown.shade100,
                width: 1,
              ),
              shape: fakeInfo.isNotOrg ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Center(
                    child: Container(
                  height: 120,
                  width: 75,
                  child: Center(
                      child: SpinKitThreeBounce(
                    size: 8.5,
                    color: Colors.brown,
                  )),
                ));
                break;
              case LoadState.completed:
                return ExtendedRawImage(
                  fit: BoxFit.cover,
                  image: state.extendedImageInfo?.image,
                  height: fakeInfo.isNotOrg ? 75 : 120,
                  width: 75,
                );
              case LoadState.failed:
                return Container(
                  height: 120,
                );
            }
          }),
        ),
        SizedBox(
          height: 5.5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: Row(
                  children: [
                    Spacer(),
                    !fakeInfo.isNotOrg
                        ? Container()
                        : Container(
                            width: 30,
                            padding: EdgeInsets.fromLTRB(1.5, 0.4, 1.5, 0.4),
                            child: Center(
                              child: Text(
                                fakeInfo.label,
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.brown.shade100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.5),
                              ),
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1),
                            ),
                          ),
                    SizedBox(
                      width: !fakeInfo.isNotOrg ? 1 : 0,
                    ),
                    !fakeInfo.isNotOrg
                        ? Container(
                            width: 30,
                            padding: EdgeInsets.fromLTRB(1.5, 0.4, 1.5, 0.4),
                            child: Center(
                              child: Text(
                                "机构",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.blueAccent),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.5),
                              ),
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1),
                            ),
                          )
                        : Container(),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Container(
                width: 55,
                child: Center(
                  child: Text(
                    fakeInfo.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontSize: 11),
                  ),
                ))
          ],
        ),
      ]),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '心路秘籍', icon: Icons.menu_book_outlined),
  const Choice(title: '成果', icon: Icons.emoji_events_outlined),
];

class FakeInfo {
  const FakeInfo(
      {required this.name,
      required this.picUrl,
      required this.label,
      required this.isNotOrg});

  final String name;
  final String picUrl;
  final String label;
  final bool isNotOrg;
}

class FakeClass {
  const FakeClass(
      {required this.author,
      required this.picUrl,
      required this.count,
      required this.label,
      required this.price});

  final String author;
  final String picUrl;
  final String count;
  final String label;
  final String price;
}

const List<FakeClass> classesFake = const <FakeClass>[
  const FakeClass(
      author: "QW兄",
      picUrl: "http://media.getlijin.com/picccc789.png",
      label: "元老",
      count: "32",
      price: "299"),
  const FakeClass(
      author: "张天禄",
      picUrl: "http://media.getlijin.com/picccc456.png",
      label: "社员",
      count: "9.5",
      price: "99"),
  const FakeClass(
      author: "老魏心理咨询室",
      picUrl: "http://media.getlijin.com/picccc123.png",
      label: "元老",
      count: "88",
      price: "1299"),
];

const List<FakeInfo> peopleFake = const <FakeInfo>[
  const FakeInfo(
      name: '张天禄',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn2.cmsfile.pg0.cn%2Fgroup1%2FM00%2FD2%2F80%2FCgqg11j-rIGAIOw7AATxFNdBUX0454.png&refer=http%3A%2F%2Fn2.cmsfile.pg0.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650973129&t=fee70edf32dbbabad0aec8569404b2c2",
      label: "社员",
      isNotOrg: true),
  const FakeInfo(
      name: '老魏',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fci.xiaohongshu.com%2Fb3207120-0ec2-a35c-159b-b56eb5d35285%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fci.xiaohongshu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650972592&t=4a7dee8bae1cfdf5e1635e45b9e487eb",
      label: "元老",
      isNotOrg: true),
  const FakeInfo(
      name: 'Dr.李媛媛',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190507%2F0f7b39efe63f4a00b65fd4a2af671188.jpeg&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650973168&t=8e3683f32e48228a980ceceaa187a0ea",
      label: "社员",
      isNotOrg: true),
  const FakeInfo(
      name: '阿木训练营',
      picUrl:
          "http://t14.baidu.com/it/u=1825930128,810022999&fm=224&app=112&f=JPEG?w=500&h=500&s=2191539685C7D9F9128895ED0300F061",
      label: "社员",
      isNotOrg: false),
  const FakeInfo(
      name: 'No7抗体弃口吃',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180513%2F5e8faec6ff854b4fb38e3906b7f65027.gif&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650972949&t=593289ced778ccd18e6817c67fda54ae",
      label: "社员",
      isNotOrg: true),
  const FakeInfo(
      name: '凯旋语言训练中心',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fp1.meituan.net%2Fshaitu%2Fab2532488b63a7f8791d7ff696e4e06b127960.jpg&refer=http%3A%2F%2Fp1.meituan.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650973678&t=3ddb7bd451a1fad265be7fe8b5024f09",
      label: "元老",
      isNotOrg: false),
  const FakeInfo(
      name: '治愈系李老师',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20180707%2Fae66fd0714ea47848f8b710793f2081c.jpeg&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650973080&t=070704c02071959a982d377deda68106",
      label: "社员",
      isNotOrg: true),
  const FakeInfo(
      name: '马小口吃矫正中心',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.shejiben.com%2Fcase%2F2019%2F06%2F27%2F20190627142008-0afc80e5-2s.jpeg&refer=http%3A%2F%2Fpic1.shejiben.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650973458&t=cc65b750aa5d7d4924700a7884155a14",
      label: "社员",
      isNotOrg: false),
  const FakeInfo(
      name: '马小',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_360_360%2F9f%2F6a%2Fe4%2F9f6ae4d8a78f0b14bc4b5834c6f01952.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650972712&t=103fa3d4d0b7a061db755254b3aa088c",
      label: "元老",
      isNotOrg: true),
  const FakeInfo(
      name: 'QW兄',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201504%2F17%2F20150417H4458_f2eJS.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650972795&t=0dd06c271ab5ca0efb8121e5973afd5c",
      label: "社员",
      isNotOrg: true),
  const FakeInfo(
      name: '天蓝口吃咨询',
      picUrl:
          "https://img0.baidu.com/it/u=256971815,3224651557&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=661",
      label: "元老",
      isNotOrg: false),
  const FakeInfo(
      name: '老魏心理咨询室',
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.51miz.com%2Fpreview%2Fmuban%2F00%2F00%2F28%2F55%2FM-285590-D9FC842A.jpg-0.jpg&refer=http%3A%2F%2Fimg.51miz.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650973358&t=88437ebd192d40c9a942b5b8e911b388",
      label: "元老",
      isNotOrg: false),
];
