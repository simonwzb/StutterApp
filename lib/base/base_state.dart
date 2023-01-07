import 'package:flutter/material.dart';
import 'package:stutter_app/main.dart';
import 'package:stutter_app/util/ui_util.dart';


/// 基类状态
abstract class BaseState<T extends StatefulWidget> extends State<T> with RouteAware {
  @override
  void initState() {
    super.initState();
    //resetStatusBar(getStatusBarStyle(), formPage: "Base State");
  }

  @override
  void didChangeDependencies() {
    //MyApp.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    print("BaseState didPush==");
    //resetStatusBar(getStatusBarStyle(), formPage: "Base State");
    onPush();
  }

  @override
  void didPushNext() {
    print("BaseState didPushNext==");
    super.didPushNext();
    onPushNext();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print("BaseState didPopNext==");
    //resetStatusBar(getStatusBarStyle(), formPage: "Base State");
    onPopNext();
  }

  /*StatusbarStyle getStatusBarStyle() {
    return StatusbarStyle.BlueBg;
  }*/

  void onPush() {}

  void onPopNext() {}

  void onPushNext() {}
}

abstract class BaseWhiteState<T extends StatefulWidget> extends BaseState<T> {
  /*@override
  StatusbarStyle getStatusBarStyle() {
    return StatusbarStyle.WhiteBg;
  }*/
}

abstract class BaseStatelessWidget extends StatelessWidget {}
