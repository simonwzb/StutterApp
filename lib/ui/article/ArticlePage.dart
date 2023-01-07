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

class ArticlePage extends StatefulWidget {
  String id;

  ArticlePage(this.id);

  @override
  State createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  PathProviderPlatform provider = PathProviderPlatform.instance;
  String tempDir = "";
  String htmlData = "";

  getData() async {
    Dio _dio = DioUtil.getInstance()!.dio;
    await _dio.request("/v1/article/id/" + widget.id).then((value) async {
      print(value);
      Map<String, dynamic> res0 =
          new Map<String, dynamic>.from(value.data['data']);
      setState(() {
        res = res0;
      });
      //Response resp = await _dio.get(res0['blogUrl']);
      List<String> arr = res0['text'].split('/');
      var zipPathPre = arr[arr.length - 1];
      var response = await http.get(Uri.parse(res0['text']));
      print(response.toString());
      String? tempDir = await provider.getTemporaryPath();
      File fileZip = File(tempDir! + '/' + zipPathPre);
      await fileZip.writeAsBytes(response.bodyBytes);
      /*await DocumentFileSave.saveFile(response.bodyBytes, zipPathPre, "text/plain");
      String zipPath =
          await FileSaver.instance.saveFile(zipPathPre, response.bodyBytes, '');*/
      String zipPath = fileZip.path;
      print(zipPath);
      var htmlPath = '';
      try {
        final inputStream = InputFileStream(zipPath);
        final archive = ZipDecoder().decodeBuffer(inputStream);
        for (ArchiveFile file in archive.files) {
          print("1");
          if (file.isFile) {
            print("2");
            htmlPath = tempDir! + "/" + '${file.name}';
            File htmlFile = File(htmlPath);
            htmlFile.delete();
            final outputStream = OutputFileStream(htmlPath);
            print("3");
            file.writeContent(outputStream);
            print("4");
            outputStream.close();
            print("5");
            print(file.size.toString());
            File fileFinal = File(tempDir! + "/" + file.name);
            String htmlDataTmp = await fileFinal.readAsString();
            print(htmlDataTmp);
            print(tempDir);
            /*fileFinal.delete();
            File(zipPath).delete();*/
            setState(() {
              htmlData = htmlDataTmp;
            });
          }
        }
      } catch (e) {
        print(e);
      }
      if (context.loaderOverlay.visible) context.loaderOverlay.hide();
    });
  }

  bool navBarMode = false;
  final rnd = Random();
  late List<int> extents;
  int crossAxisCount = 2;
  Map<String, dynamic> res = {
    'tite': '',
    'author': {'name': ''},
    'text': ''
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: MaterialApp(debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: Platform.isAndroid?"FZRBlack":'' 
          ),
            home: LoaderOverlay(
                disableBackButton: false,
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: SpinKitFadingCircle(
                    color: Colors.brown,
                    size: 45.0,
                  ),
                ),
                overlayOpacity: 0.55,
                child: Scaffold(
                    floatingActionButton:
                        new Builder(builder: (BuildContext context) {
                      return new FloatingActionButton(
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 8.5),
                              Icon(Icons.insert_comment_outlined),
                              Text(
                                "评论",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        tooltip: "评论",
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.brown,
                        heroTag: null,
                        elevation: 7.0,
                        highlightElevation: 14.0,
                        onPressed: () {},
                        mini: false,
                        shape: new CircleBorder(),
                        isExtended: false,
                      );
                    }),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.miniEndFloat,
                    body: CustomScrollView(
                        /*primary: false, controller: _controller,*/
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.brown.shade200,
                            flexibleSpace: new FlexibleSpaceBar(
                              background: Image.network(
                                res['imgUrl'],
                                fit: BoxFit.fitWidth,
                              ),
                              title: Text(
                                res['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              centerTitle: true,
                              collapseMode: CollapseMode.pin,
                            ),
                            leading: new IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            expandedHeight: 245,
                            floating: false,
                            snap: false,
                            pinned: false,
                            titleSpacing: 1,
                            title: Row(
                              children: [
                                ExtendedImage.network(
                                  res['author']['profilePicUrl'],
                                  height: 32,
                                  width: 32,
                                  cache: true,
                                  fit: BoxFit.fill,
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                SizedBox(
                                  width: 4.5,
                                ),
                                Text(
                                  res['author']['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate(
                            [
                              ...List.generate(
                                  1,
                                  (index) => Container(
                                        padding: EdgeInsets.fromLTRB(
                                            12, 9.5, 12, 58),
                                        child: HtmlWidget(
                                          htmlData,
                                          isSelectable: true,
                                          renderMode: RenderMode.column,
                                          textStyle: TextStyle(fontSize: 18.5,fontFamily: Platform.isAndroid?"FZRBlack":''),
                                        ),
                                      ))
                            ],
                          ))
                        ])))));
  }
}
