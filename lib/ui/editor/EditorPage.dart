import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:stutter_app/base/base_state.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/login/pages/login_page.dart';
import 'package:stutter_app/util/MD5Util.dart';
import 'package:stutter_app/util/StaggeredGridUtil.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart' as Qiniu;

import '../../theme.dart';

class EditorPage extends StatefulWidget {
  /*var parentContext;
  EditorPage(this.parentContext);*/
  bool healthyOrNot = true;

  EditorPage(this.healthyOrNot);

  @override
  State createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>
    with AutomaticKeepAliveClientMixin<EditorPage> {
  @override
  bool get wantKeepAlive => true;
  String host = "http://media.getlijin.com/";
  TextEditingController titleController = TextEditingController();
  TextEditingController despController = TextEditingController();

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNodeTitle = new FocusNode();
  FocusNode focusNodeDesp = new FocusNode();
  final _scrollController = ScrollController();
  String filePath = "";

  @override
  void initState() {
    super.initState();

    ///添加获取焦点与失去焦点的兼听
    /*focusNode.addListener(() {
      ///当前兼听的 TextFeild 是否获取了输入焦点
      bool hasFocus = focusNode.hasFocus;

      ///当前 focusNode 是否添加了兼听
      bool hasListeners = focusNode.hasListeners;
      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });*/

    /// WidgetsBinding 它能监听到第一帧绘制完成，第一帧绘制完成标志着已经Build完成
    /*WidgetsBinding.instance!.addPostFrameCallback((_) {
      ///获取输入框焦点
      FocusScope.of(context).requestFocus(focusNode);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: MaterialApp(debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: Platform.isAndroid?"FZRBlack":''),
            home: LoaderOverlay(
                disableBackButton: false,
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: SpinKitPouringHourGlass(
                    color: Colors.brown,
                    size: 45.0,
                  ),
                ),
                overlayOpacity: 0.55,
                child: Scaffold(
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(32),
                        child: Container(
                          child: NewGradientAppBar(
                            title: Text("文章撰写"),
                            titleSpacing: 0.00,
                            centerTitle: true,
                            leading: new IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            bottom: PreferredSize(
                                preferredSize: Size.fromHeight(32),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    FractionalTranslation(
                                      translation: const Offset(0, -0.3),
                                      child: MaterialButton(
                                        height: 30,
                                        color: Colors.brown.shade200,
                                        highlightColor: Colors.brown,
                                        splashColor:
                                            CustomTheme.loginGradientEnd,
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.5),
                                          child: Text(
                                            '投稿',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (titleController.text.length ==
                                                  0 ||
                                              titleController.text.length >
                                                  20) {
                                            showToast("标题长度不符合要求，请修正候再提交");
                                            return;
                                          }
                                          if (despController.text.length == 0 ||
                                              despController.text.length >
                                                  100) {
                                            showToast("一句话摘要长度不符合要求，请修正候再提交");
                                            return;
                                          }
                                          if (filePath.isEmpty) {
                                            showToast("请选择一篇.docx文档作为正文后再提交");
                                            return;
                                          }
                                          if (_imageFile == null ||
                                              _imageFile!.path.isEmpty) {
                                            showToast("请选择一张封面图后再提交");
                                            return;
                                          }
                                          var _message =
                                              '您确认将投稿此文章吗？\nPS：投稿后，若您认为需要修改，请反馈给我们。';
                                          CoolAlert.show(
                                              title: "提示",
                                              context: context,
                                              text: _message,
                                              type: CoolAlertType.success,
                                              barrierDismissible: true,
                                              confirmBtnText: '立即投稿',
                                              cancelBtnText: '取消',
                                              onConfirmBtnTap: () async {
                                                showToast("服务器处理中，请稍候...",
                                                    duration:
                                                        Duration(seconds: 3));
                                                context.loaderOverlay.show();
                                                //1. 获取七牛token
                                                Dio _dio =
                                                    DioUtil.getInstance()!.dio;
                                                await _dio
                                                    .get(DioUtil.BASE_URL +
                                                        "/v1/qiniu/token")
                                                    .then(
                                                  (value) async {
                                                    String token =
                                                        value.data['token'];
                                                    print(SpUtil.getObject(
                                                        'user'));
                                                    String key = SpUtil
                                                                .getObject(
                                                                    'user')![
                                                            '_id'] +
                                                        '-' +
                                                        MD5Util.generateMd5(DateUtil
                                                                .getDateTimeByMs(
                                                                    DateUtil
                                                                        .getNowDateMs())
                                                            .toIso8601String()) +
                                                        '-' +
                                                        File(filePath)
                                                            .path
                                                            .split("/")
                                                            .last;
                                                    // 2. 使用Qiniu-storage的putFile对象进行文件上传
                                                    await Qiniu.Storage()
                                                        .putFile(File(filePath),
                                                            token,
                                                            options: PutOptions(
                                                                key: key))
                                                        .catchError((e) => showToast(
                                                            "上传Word文件失败，请反馈\n" +
                                                                e.toString()))
                                                        .then((respHtml) async {
                                                      String blogUrl =
                                                          host + respHtml.key!;
                                                      await Qiniu.Storage()
                                                          .putFile(
                                                              File(_imageFile!
                                                                  .path),
                                                              token)
                                                          .catchError((e) => {
                                                                showToast(
                                                                    "上传封面失败，请反馈\n" +
                                                                        e.toString())
                                                              })
                                                          .then(
                                                              (respCover) async {
                                                        String coverUrl = host +
                                                            respCover.key!;
                                                        Map? user =
                                                            SpUtil.getObject(
                                                                'user');
                                                        String userStr =
                                                            jsonEncode(user);
                                                        Map? _data = {
                                                          'title':
                                                              titleController
                                                                  .text,
                                                          'description':
                                                              despController
                                                                  .text,
                                                          'text': blogUrl,
                                                          'author': user,
                                                          'blogUrl': blogUrl,
                                                          'imgUrl': coverUrl,
                                                          'health': (widget
                                                                  .healthyOrNot)
                                                              ? "心路秘籍"
                                                              : "治疗成果",
                                                          'agestage': agestage,
                                                          'pai': pai,
                                                          'degree': degree,
                                                          'createdBy': user,
                                                          'updatedBy': user,
                                                        };
                                                        print(user.toString());
                                                        print(userStr);
                                                        print(_data.toString());
                                                        Dio _dio = DioUtil
                                                                .getInstance()!
                                                            .dio;
                                                        await _dio
                                                            .put(
                                                                DioUtil.BASE_URL +
                                                                    "/v1/write/article",
                                                                data: _data)
                                                            .then(
                                                                (value) async {
                                                          showToast("已成功投稿~");
                                                          await Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      1800));
                                                          context.loaderOverlay
                                                              .hide();
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      });
                                                    });
                                                  },
                                                );
                                              });
                                        },
                                      ),
                                    )
                                  ],
                                )),
                            gradient: LinearGradient(colors: [
                              Colors.brown,
                              Color(0xFFA1887F),
                              Color(0x33D7CCA0)
                            ]),
                          ),
                        )),
                    body: Scaffold(
                        body: Scrollbar(
                            showTrackOnHover: true,
                            controller: _scrollController,
                            // <---- Here, the controller
                            isAlwaysShown: false,
                            thickness: 13.5,
                            child: CustomScrollView(slivers: [
                              SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: TextField(
                                              maxLines: 1,
                                              //enabled: isEnable,
                                              controller: titleController,
                                              focusNode: focusNodeTitle,
                                              decoration: const InputDecoration(
                                                hintText: "请输入20个字以内的标题",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  textBaseline:
                                                      TextBaseline.ideographic,
                                                ),
                                                labelText: "文章标题",
                                                labelStyle: TextStyle(
                                                    color: Colors.brown),
                                                prefixIcon: Icon(Icons.title,
                                                    color: Colors.brown),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.5)),

                                                  ///用来配置边框的样式
                                                  borderSide: BorderSide(
                                                    ///设置边框的颜色
                                                    color: Colors.black87,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.5)),
                                                  borderSide: BorderSide(
                                                    color: Colors.brown,

                                                    ///设置边框的粗细
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                4.5, 9.5, 14.5, 0)),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              4.5, 22.5, 14.5, 20),
                                          child: Center(
                                            child: MaterialButton(
                                              textTheme: ButtonTextTheme.normal,
                                              highlightElevation: 4,
                                              textColor: Colors.white,
                                              color: Colors.brown.shade300,
                                              shape: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              child: Text("选择文章[.docx格式]"),
                                              onPressed: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                            type:
                                                                FileType.custom,
                                                            allowedExtensions: [
                                                      'docx'
                                                    ]);
                                                if (result != null) {
                                                  showToast("已选择：" +
                                                      result
                                                          .files.single.path!);
                                                  setState(() {
                                                    filePath = result
                                                        .files.single.path!;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 75,
                                          child: Center(
                                            child: Text(
                                              (filePath == '' ? "未" : "已") +
                                                  "选文章\n" +
                                                  filePath,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown),
                                            ),
                                          ),
                                        ),
                                        /*])),
                          SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [*/
                                        Container(
                                            child: TextField(
                                              controller: despController,
                                              maxLines: 1,
                                              //enabled: isEnable,
                                              focusNode: focusNodeDesp,
                                              decoration: const InputDecoration(
                                                hintText: "请输入100个字以内的一句话",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  textBaseline:
                                                      TextBaseline.ideographic,
                                                ),
                                                labelText: "一句话摘要",
                                                labelStyle: TextStyle(
                                                    color: Colors.brown),
                                                prefixIcon: Icon(Icons.title,
                                                    color: Colors.brown),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.5)),
                                                  borderSide: BorderSide(
                                                    color: Colors.black87,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.5)),
                                                  borderSide: BorderSide(
                                                    color: Colors.brown,
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                4.5, 9.5, 14.5, 0)),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              4.5, 2.5, 14.5, 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.5),
                                              border: Border.all(
                                                  color: Colors.black87,
                                                  width: 1)),
                                          child: Column(children: buildHead()),
                                        ),
                                        Container(
                                            height: MediaQueryData.fromWindow(
                                                        WidgetsBinding
                                                            .instance!.window)
                                                    .size
                                                    .width *
                                                0.8,
                                            margin: EdgeInsets.fromLTRB(
                                                4.5, 2.5, 14.5, 0),
                                            decoration: BoxDecoration(
                                                //color: Colors.brown.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(5.5),
                                                border: Border.all(
                                                    color: Colors.black87,
                                                    width: 1)),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: _imageFile != null
                                                      ? Image.file(
                                                          File(
                                                              _imageFile!.path),
                                                          fit: BoxFit.contain)
                                                      : Container(),
                                                ),
                                                Container(
                                                  child: Center(
                                                    child: MaterialButton(
                                                      textTheme: ButtonTextTheme
                                                          .normal,
                                                      highlightElevation: 4,
                                                      textColor: Colors.white,
                                                      color:
                                                          Colors.brown.shade300,
                                                      shape: Border.all(
                                                          color: Colors.grey,
                                                          width: 1,
                                                          style: BorderStyle
                                                              .solid),
                                                      child: Text("选择封面"),
                                                      onPressed: () {
                                                        _onImageButtonPressed(
                                                            ImageSource.gallery,
                                                            context: context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ])),
                              /*SliverFillRemaining(
                              hasScrollBody: false,
                              child: SingleChildScrollView(
                                //hasScrollBody: true,
                                child: Container(
                                  height: MediaQueryData.fromWindow(
                                          WidgetsBinding.instance!.window)
                                      .size
                                      .height,
                                  padding:
                                      EdgeInsets.fromLTRB(4.5, 2.5, 14.5, 0),
                                  child: LocalFileViewer(
                                    filePath: filePath,
                                  ),
                                ),
                              )),*/
                            ])))))));
  }

  static List<String> agestageArrDefault = ['儿童', '成年'];
  static List<String> paiArrDefault = ['心理学派', '矫正派', '其它派'];
  static List<String> degreeArrDefault = ['偶尔', '日常', '严重时说不出话'];
  String agestage = '成年';
  String pai = '其它派';
  String degree = '日常';

  List<Widget> buildHead() {
    return [
      Container(
          padding: EdgeInsets.fromLTRB(4.5, 2.5, 4.5, 3),
          child: Text(
            "请选择具体分类：",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
          )),
      Container(
          height: 32,
          child: DefaultTabController(
              length: 3,
              initialIndex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 32,
                  child: TabBar(
                    isScrollable: false,
                    indicatorColor: Colors.brown,
                    tabs: [
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
                      degree = degreeArrDefault[index];
                    },
                  ),
                ),
              ))),
      Container(
          height: 32,
          child: DefaultTabController(
              length: 3,
              initialIndex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 32,
                  child: TabBar(
                    isScrollable: false,
                    indicatorColor: Colors.brown,
                    tabs: [
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
                      pai = paiArrDefault[index];
                    },
                  ),
                ),
              ))),
      Container(
        height: 32,
        child: DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 32,
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: Colors.brown,
                  tabs: [
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
                    agestage = agestageArrDefault[index];
                  },
                ),
              ),
            )),
      ),
    ];
  }

  XFile? _imageFile;

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    /*await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {*/
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        /*maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,*/
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      showToast("遇到错误，请反馈给我们\n" + e.toString());
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
