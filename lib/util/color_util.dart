import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorUtil {
  /// 十六进制颜色
  /// hex，十六进制值，例如：0xffffff，
  /// alpha，透明度[0.0, 1.0]
  static Color hexColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8, (hex & 0x0000FF) >> 0, alpha);
  }

  static Color BlueNornal() {
    // return hexStringColor("#2485E7");
    return Color(0xff2485E7);
  }

  static Color BlueNew() {
    return Color(0xff2B82DF);
  }

  static Color LightBlue() {
    return Color(0xffE5F2FF);
  }

  static Color GrayF4() {
    // return hexStringColor("#f4f4f4");
    return Color(0xfff4f4f4);
  }

  static Color GrayF5() {
    // return hexStringColor("#f4f4f4");
    return Color(0xfff5f5f5);
  }

  static Color GrayF6() {
    // return hexStringColor("#f4f4f4");
    return Color(0xfff6f6f6);
  }

  static Color GrayE6() {
    // return hexStringColor("#f4f4f4");
    return Color(0xffe6e6e6);
  }

  static Color Gray42() {
    return Color(0xff424242);
  }

  static Color Gray99() {
    // return hexStringColor("#999999");
    return Color(0xff999999);
  }

  static Color GrayE5() {
    // return hexStringColor("#E5E5E5");
    return Color(0xffE5E5E5);
  }

  static Color Gray66() {
    // return hexStringColor("#E5E5E5");
    return Color(0xff666666);
  }

  static Color GrayEE() {
    // return hexStringColor("#EEEEEE");
    return Color(0xffEEEEEE);
  }

  /// 十六进制颜色
  /// colorString，字符串，例如：'0x000000'  '0xff000000' '#000000' '#000000'，
  /// alpha，透明度[0.0, 1.0]
  static Color hexStringColor(String colorString, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    String colorStr = colorString;
    // colorString未带0xff前缀并且长度为6
    if (!colorStr.startsWith('0xff') && colorStr.length == 6) {
      colorStr = '0xff' + colorStr;
    }
    // colorString为8位，如0x000000
    if (colorStr.startsWith('0x') && colorStr.length == 8) {
      colorStr = colorStr.replaceRange(0, 2, '0xff');
    }
    // colorString为7位，如#000000
    if (colorStr.startsWith('#') && colorStr.length == 7) {
      colorStr = colorStr.replaceRange(0, 1, '0xff');
    }
    // 先分别获取色值的RGB通道
    Color color = Color(int.parse(colorStr));
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    // 通过fromRGBO返回带透明度和RGB值的颜色
    return Color.fromRGBO(red, green, blue, alpha);
  }

  static Color Gray33() {
    // return hexStringColor("#333333");
    return Color(0xff333333);
  }

  static Color Graycc() {
    // return hexStringColor("#333333");
    return Color(0xffcccccc);
  }

  static Color Gray22() {
    // return hexStringColor("#222222");
    return Color(0xff222222);
  }

  static Color Gray7E() {
    // return hexStringColor("#7e7e7e");
    return Color(0xff7e7e7e);
  }

  // static Color[] colors =  Color[];
  // {"#80B4D9", "#51ABFB", "#62B4CC", "#C4C172", "#BB9DDF", "#91c768", "#D4A64E"};

  static List<Color> colors = [
    Color(0XFF80B4D9),
    Color(0XFF51ABFB),
    Color(0XFF62B4CC),
    Color(0XFFC4C172),
    Color(0XFFBB9DDF),
    Color(0XFF91C768),
    Color(0XFFD4A64E)
  ];

  static Color IndexColor(int index) {
    return colors[index % ColorUtil.colors.length];
  }

  static Color randomColor() {
    return colors[Random().nextInt(colors.length)];
  }

  static int randomIndex() {
    return Random().nextInt(colors.length);
  }

  static Color BlueBarColor() {
    return Color(0x2002485E7);
  }

}
