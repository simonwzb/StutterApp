import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_util.dart';

class UiUtils {
  static double getAspect(BuildContext context, int numColumn, double desiredCellHeight, {double space = 0.0}) {
    double cellWidth = ((MediaQuery.of(context).size.width) / numColumn);
    double childAspectRatio = cellWidth / desiredCellHeight;
    return childAspectRatio;
  }
}

resetStatusBar(StatusbarStyle style, {String formPage = "undefind"}) {
  print("LifecycleTestPage - resetStatusBar------$style,formPage=$formPage");

  Color color;
  Brightness dayOrNight;
  switch (style) {
    case StatusbarStyle.WhiteBg:
      color = Colors.white;
      dayOrNight = Brightness.dark;
      break;
    case StatusbarStyle.BlueBg:
      color = ColorUtil.BlueNornal();
      dayOrNight = Brightness.light;
      break;
  }
  // color = Colors.transparent;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: color, statusBarIconBrightness: dayOrNight));
}

enum StatusbarStyle { WhiteBg, BlueBg }
