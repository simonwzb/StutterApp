import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/ui/research/WikiPage.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../../util/MD5Util.dart';

class ResearchPage extends StatefulWidget {
  var parentContext;

  ResearchPage(this.parentContext);

  @override
  State createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage>
    with AutomaticKeepAliveClientMixin<ResearchPage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    /*if (Platform.isAndroid) {
      SystemUiOverlayStyle style = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          ///这是设置状态栏的图标和字体的颜色
          ///Brightness.light  一般都是显示为白色
          ///Brightness.dark 一般都是显示为黑色
          statusBarIconBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(style);
    }*/
    extents = List<int>.generate(10000, (int index) => rnd.nextInt(5) + 1);
  }

  bool navBarMode = false;
  final rnd = Random();
  late List<int> extents;
  int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: Platform.isAndroid?"FZRBlack":'' 
          ),
        home: DefaultTabController(
            length: choices.length,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(75),
                  child: Container(
                    child: NewGradientAppBar(
                      title: null,
                      titleSpacing: 0.00,
                      centerTitle: true,
                      gradient: LinearGradient(colors: [
                        Colors.brown,
                        Color(0xFFA1887F),
                        Color(0x33D7CCA0)
                      ]),
                      bottom: PreferredSize(
                          preferredSize: Size.fromHeight(75),
                          child: // new Transform(
                              //transform: new Matrix4.translationValues(0, -24.0, 0.0),
                              Align(
                                  alignment: Alignment.center,
                                  child: TabBar(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
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
                                  ))),
                    ),
                  )),
              body: Container(
                  child: TabBarView(
                      children: choices.map((Choice choice) {
                if (choice.title == "科普") {
                  return WikiPage(context);
                } else if (choice.title == "话题") {
                  return ListView.builder(
                      itemCount: fakeTopics.length,
                      // scrollDirection: Axis.horizontal,//设置为水平布局
                      itemBuilder: (BuildContext context, int index) {
                        return _buildFakeClass(index);
                      });
                } else {
                  return ListView.builder(
                    // scrollDirection: Axis.horizontal,//设置为水平布局
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.fromLTRB(8, 10.4, 8, 0.4),
                          child: Row(
                            children: [
                              ExtendedImage.network(fakeOrgs[index].picUrl,
                                  height: 115,
                                  width: 115,
                                  cache: true,
                                  cacheRawData: true,
                                  imageCacheName: MD5Util.generateMd5(
                                      fakeOrgs[index].picUrl),
                                  cacheMaxAge: Duration(days: 15),
                                  cacheKey: MD5Util.generateMd5(
                                      fakeOrgs[index].picUrl),
                                  border: Border.all(
                                    color: Colors.brown.shade100,
                                    width: 1,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
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
                                      width: 115,
                                    );
                                  case LoadState.failed:
                                    return Container(
                                      height: 80,
                                    );
                                }
                              }),
                              SizedBox(
                                width: 8.5,
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 3),
                                    Text(
                                      fakeOrgs[index].name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "城市：" + fakeOrgs[index].city,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "平台认证：" + fakeOrgs[index].label,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "资质：" + fakeOrgs[index].auth,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "用户评分：" + fakeOrgs[index].score,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ));
                    },
                    itemCount: fakeOrgs.length,
                  );
                }
              }).toList())),
            )));
  }

  Widget _buildFakeClass(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(1.5, 12.4, 1.5, 0.4),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Container(
                height: 95,
                width:
                    MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                            .size
                            .width -
                        8 * 2,
                child: ExtendedImage.network(fakeTopics[index].picUrl,
                    height: 95,
                    width: MediaQueryData.fromWindow(
                                WidgetsBinding.instance!.window)
                            .size
                            .width -
                        8 * 2,
                    cache: true,
                    cacheRawData: true,
                    imageCacheName:
                        MD5Util.generateMd5(fakeTopics[index].picUrl),
                    cacheMaxAge: Duration(days: 15),
                    cacheKey: MD5Util.generateMd5(fakeTopics[index].picUrl),
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
                        height: 95,
                        width: MediaQueryData.fromWindow(
                                    WidgetsBinding.instance!.window)
                                .size
                                .width -
                            8 * 2,
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
                width: 14,
              ),
              Text(
                fakeTopics[index].name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              SizedBox(
                width: 1,
              ),
              Container(
                width: 30,
                padding: EdgeInsets.fromLTRB(1.5, 0.4, 1.5, 0.4),
                child: Center(
                  child: Text(
                    fakeTopics[index].type,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.brown.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.5),
                  ),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
              )
            ],
          ),
          Row(children: [
            SizedBox(
              width: 14,
            ),
            Text(
              fakeTopics[index].count + "条讨论  [closed]",
              style: TextStyle(
                  color: Colors.brown, decoration: TextDecoration.underline),
            ),
          ]),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '科普', icon: Icons.spa_outlined),
  const Choice(title: '话题', icon: Icons.text_rotation_angleup),
  const Choice(title: '矫正机构', icon: Icons.house_outlined),
  //const Choice(title: '直播课', icon: Icons.missed_video_call_outlined),
];
const List<FakeOrg> fakeOrgs = const <FakeOrg>[
  const FakeOrg(
      name: "朗朗口吃矫正中心",
      picUrl: "http://www.langlangkouchi.com/langlang/images/newsR_Pic1.jpg",
      label: "公众号",
      city: "南京"),
  const FakeOrg(
      name: "康语儿童语言训练中心",
      picUrl: "http://image.soxsok.com/image/20201103/20201103145134_2645.jpg",
      label: "尚未认证",
      city: "上海"),
  const FakeOrg(
      name: "杨清语语言矫正培训",
      picUrl:
          "https://midpf-material.cdn.bcebos.com/edc0e28fcc161ff34a1a7c7f8fd60eff.jpeg",
      label: "尚未认证",
      city: "北京"),
  const FakeOrg(
      name: "北京声扬语言矫正中心",
      picUrl:
          "https://img.bosszhipin.com/beijin/mcs/chatphoto/20190415/7e3138c4c845d1bdc1762794062439011c021fa877caa2226ecb2fc908685c50.png?x-oss-process=image/resize,w_120,limit_0",
      label: "尚未认证",
      city: "北京"),
  const FakeOrg(
      name: "声语语言矫正",
      picUrl: "http://img.360sok.com/uploads/img1/4650/logo.jpg",
      label: "尚未认证",
      city: "深圳"),
  //const Choice(title: '直播课', icon: Icons.missed_video_call_outlined),
];

const List<FakeTopic> fakeTopics = const <FakeTopic>[
  const FakeTopic(
      name: "#成人可以改掉口吃吗？一辈子的坑？",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg1.doubanio.com%2Fview%2Fthing_review%2Fl%2Fpublic%2Fp1745829.jpg&refer=http%3A%2F%2Fimg1.doubanio.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650998677&t=535fee378543dd2e2db985c9be3b8a36",
      type: "官方",
      count: "198"),
  const FakeTopic(
      name: "#儿童口吃怎么办？是遗传导致吗？",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic2.zhimg.com%2Fv2-111977d48abd2cdd12646f9dd63112f4_1440w.jpg%3Fsource%3D172ae18b&refer=http%3A%2F%2Fpic2.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650999494&t=72796750ffd46dec087798d508ee6576",
      type: "官方",
      count: "8091"),
  const FakeTopic(
      name: "#对象是轻微口吃可以接受吗？？",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic3.zhimg.com%2Fv2-2f25cc6626f3888825ea2bf2710e39d8_b.jpg&refer=http%3A%2F%2Fpic3.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650998855&t=7a30351028ba0976103e30ac579ab8b2",
      type: "小组",
      count: "433"),
  const FakeTopic(
      name: "#关于口吃的十大谣言",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.puchedu.cn%2Fuploads%2F1%2F26%2F3263763277%2F551780554.jpg&refer=http%3A%2F%2Fimg.puchedu.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650998900&t=07962b966eb8e388c35903324e3aacba",
      type: "小组",
      count: "867"),
  const FakeTopic(
      name: "#口吃是生理疾病还是心理疾病？",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ftxt25-2.book118.com%2F2017%2F0503%2Fbook48680%2F48679616.jpg&refer=http%3A%2F%2Ftxt25-2.book118.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650999004&t=50011d0b53d13727ac02e9c45e0bb730",
      type: "官方",
      count: "4365"),
  const FakeTopic(
      name: "#口吃应该接受它还是改变它？",
      picUrl:
          "https://pics1.baidu.com/feed/279759ee3d6d55fba28ae07169c2314f21a4dd7a.jpeg?token=0cf90cef2ae99eb0dadeb993511c6a73&s=17B37C854A544DCEDB09B87103000071",
      type: "官方",
      count: "633"),
  const FakeTopic(
      name: "#口吃的心理治疗",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.zhimg.com%2Fv2-d3eea3ee2b28f63d6a5da166ec29787d_1440w.jpg%3Fsource%3D172ae18b&refer=http%3A%2F%2Fpic1.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650999150&t=ae8ab89283c63f78b0436062b4a00a0a",
      type: "小组",
      count: "898"),
  const FakeTopic(
      name: "#突发性口吃的原因",
      picUrl:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcontent.henandaily.cn%2Fuploadfile%2F2018%2F0331%2F1522483131238088.jpg&refer=http%3A%2F%2Fcontent.henandaily.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650998790&t=1c68d0cb09bf7ca0ed4af44f737474c0",
      type: "小组",
      count: "1087"),
];

class FakeOrg {
  const FakeOrg(
      {required this.name,
      required this.picUrl,
      required this.label,
      required this.city});

  final String name;
  final String picUrl;
  final String label;
  final String city;
  final String score = "暂无评分";
  final String auth = "具备营业相关证书";
}

class FakeTopic {
  const FakeTopic(
      {required this.name,
      required this.picUrl,
      required this.type,
      required this.count});

  final String name;
  final String picUrl;
  final String type;
  final String count;
  final String open = "否";
}
