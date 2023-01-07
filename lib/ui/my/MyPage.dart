import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/login/pages/login_page.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../../eventbus/LoginStatusEvent.dart';

class MyPage extends StatefulWidget {
  var parentContext;

  MyPage(this.parentContext);

  @override
  State createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>
    with AutomaticKeepAliveClientMixin<MyPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    eventBus.on<LoginStatusEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      print(event.isInOrOut);
      getSections();
    });
    getSections();
  }

  EventBus eventBus = EventBus();

  getSections() {
    var sections = List<ExampleSection>.empty(growable: true);
    var section = ExampleSection()
      ..header = "通知中心"
      ..items = ["文章被评论", "被关注", "系统通知"]
      ..expanded = false;
    sections.add(section);
    var section1 = ExampleSection()
      ..header = "个人中心"
      ..items = ["个人资料", "我的发布"]
      ..expanded = false;
    sections.add(section1);
    var section2 = ExampleSection()
      ..header = "设置"
      ..items = ["意见反馈", "关于"]
      ..expanded = false;
    sections.add(section2);
    Map? user = SpUtil.getObject("user");
    print("user:" + user.toString());
    print("accessToken:" + SpUtil.getString('accessToken')!);
    print((user?.isEmpty).toString());
    var section3 = ExampleSection()
      ..header = "账号"
      ..items = [(user == null || user.isEmpty) ? "登录" : "登出"]
      ..expanded = false;
    sections.add(section3);
    setState(() {
      sectionList = sections;
    });
  }

  List<ExampleSection> sectionList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(75),
                child: Container(
                  child: NewGradientAppBar(
                    title: Text("用户中心"),
                    titleSpacing: 0.00,
                    centerTitle: true,
                    gradient: LinearGradient(colors: [
                      Colors.brown,
                      Color(0xFFA1887F),
                      Color(0x33D7CCA0)
                    ]),
                  ),
                )),
            body: Scaffold(
                body: ExpandableListView(
              builder: SliverExpandableChildDelegate<String, ExampleSection>(
                sectionList: sectionList,
                itemBuilder: (context, sectionIndex, itemIndex, index) {
                  String item = sectionList[sectionIndex].items[itemIndex];
                  return GestureDetector(
                      onTap: () {
                        if (sectionIndex == sectionList.length - 1 &&
                            itemIndex == 0) {
                          Map? user = SpUtil.getObject("user");
                          if (user?.length == 0 || user == null) {
                            Navigator.push(widget.parentContext,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return LoginPage();
                            }));
                          } else {
                            CoolAlert.show(
                                context: context,
                                title: "提示",
                                text: '您确认将退出登录吗？',
                                type: CoolAlertType.info,
                                barrierDismissible: true,
                                confirmBtnText: '立即登出',
                                cancelBtnText: '取消',
                                onConfirmBtnTap: () {
                                  signOut();
                                });
                          }
                        } else if (sectionIndex == sectionList.length - 2) {
                          if (itemIndex == 0)
                            navService.pushNamed('/feedback');
                          else if (itemIndex == 1)
                            navService.pushNamed('/about');
                        } else {
                          showToast("此模块尚未在此版本解锁");
                        }
                      },
                      child: ListTile(
                        /*leading: CircleAvatar(
                      child: Text(""),
                    ),*/
                        title: Text(item),
                      ));
                },
                sectionBuilder: (context, containerInfo) => _SectionWidget(
                  section: sectionList[containerInfo.sectionIndex],
                  containerInfo: containerInfo,
                  onStateChanged: () {
                    //notify ExpandableListView that expand state has changed.
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
            ))));
  }

  final NavigationService navService = NavigationService();

  Future<void> signOut() async {
    Dio _dio = DioUtil.getInstance()!.dio;
    print(_dio.options.headers.toString());
    await _dio.post(DioUtil.BASE_URL + "/v1/logout/basic", data: {}).then(
        (value) {
      print(value);
      SpUtil.putString('accessToken', '');
      SpUtil.putString('refreshToken', '');
      SpUtil.putObject("user", {});
      DioUtil.getInstance()?.refreshHeaders();
      eventBus.fire(LoginStatusEvent(false));
      getSections();
      Navigator.of(context, rootNavigator: true).pop();
      //new List<Map<String, dynamic>>.from(value.data['data']);
    }, onError: (e) {
      print(e.toString());
      showToast("登出失败，请反馈给我们\n" + e.toString());
      SpUtil.putString('accessToken', '');
      SpUtil.putString('refreshToken', '');
      SpUtil.putObject("user", {});
      DioUtil.getInstance()?.refreshHeaders();
      eventBus.fire(LoginStatusEvent(false));
      getSections();
      Navigator.of(context, rootNavigator: true).pop();
    });
  }
}

class _SectionWidget extends StatefulWidget {
  final ExampleSection section;
  final ExpandableSectionContainerInfo containerInfo;
  final VoidCallback onStateChanged;

  _SectionWidget(
      {required this.section,
      required this.containerInfo,
      required this.onStateChanged})
      : assert(onStateChanged != null);

  @override
  __SectionWidgetState createState() => __SectionWidgetState();
}

class __SectionWidgetState extends State<_SectionWidget>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
  late AnimationController _controller;

  late Animation _iconTurns;

  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    _iconTurns =
        _controller.drive(_halfTween.chain(CurveTween(curve: Curves.easeIn)));
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));

    if (widget.section.isSectionExpanded()) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.containerInfo
      ..header = _buildHeader(context)
      ..content = _buildContent(context);
    return ExpandableSectionContainer(
      info: widget.containerInfo,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.brown.shade200,
      child: ListTile(
        title: Text(
          widget.section.header,
          style: TextStyle(color: Colors.white),
        ),
        trailing: RotationTransition(
          turns: _iconTurns as Animation<double>,
          child: const Icon(
            Icons.expand_more,
            color: Colors.white70,
          ),
        ),
        onTap: _onTap,
      ),
    );
  }

  void _onTap() {
    widget.section.setSectionExpanded(!widget.section.isSectionExpanded());
    if (widget.section.isSectionExpanded()) {
      widget.onStateChanged();
      _controller.forward();
    } else {
      _controller.reverse().then((_) {
        widget.onStateChanged();
      });
    }
  }

  Widget _buildContent(BuildContext context) {
    return SizeTransition(
      sizeFactor: _heightFactor,
      child: SliverExpandableChildDelegate.buildDefaultContent(
          context, widget.containerInfo),
    );
  }
}

class ExampleSection implements ExpandableListSection<String> {
  //store expand state.
  late bool expanded;

  //return item model list.
  late List<String> items;

  //example header, optional
  late String header;

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
