import 'package:flutter/material.dart';

import 'color_util.dart';

/// 字符串工具类
class StringUtil {
  static const TEST_IMG_URL =
      "http://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2Fmx12%2F0F420115037%2F200F4115037-11.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637130372&t=1756e45ecedab86f1fa6ec9660958432";

  // 过滤字符串的null
  static String filterNull(String s) {
    return s == null ? "" : s;
  }

  /// 将阅读量转换一下单位
  static String getCountWithUnit(int count) {
    if (count < 10000) {
      return count.toString();
    } else {
      double db = count / 10000;
      return db.toStringAsFixed(1) + "w";
    }
  }

  /// 处理名字过长问题
  static String getShorName(String name, {int length = 7}) {
    if (name != null && name.length > length) {
      name = name.substring(0, length);
      name += "...";
    }
    return getPureStr(name);
  }

  /// 处理为null的字符串
  static String getPureStr(String str) {
    return str == null ? "" : str;
  }

  /// 判断字符串是否空
  static bool isEmpty(String s) {
    return s == null || s.length == 0;
  }

  static String getStringWithoutNull(dynamic target, {String defaultStr = ""}) {
    return selectString(target, defaultStr);
  }

  /// 获取在默认的String和获取的String中选择一个，如果target是null 返回默认String
  static String selectString(dynamic target, String defaultStr) {
    if (!(target is String)) {
      return defaultStr;
    }
    if (target == null || target == "") {
      return defaultStr;
    }
    return target;
  }

  /// 获取item的标题
  static List<TextSpan> getTextSpan(String content, String keyword, double fontSize) {
    // 内容空
    if (StringUtil.isEmpty(content)) {
      return [TextSpan(text: '')];
    }
    // 关键字空
    if (StringUtil.isEmpty(keyword)) {
      return [TextSpan(text: content)];
    }

    int keyIndex = content.indexOf(keyword);
    // 兼容关键字匹配不上的情况
    if (keyIndex == -1) {
      return [
        TextSpan(text: content, style: TextStyle(color: ColorUtil.Gray33(), fontSize: fontSize)),
      ];
    }
    String before = content.substring(0, keyIndex);
    String after = content.substring(keyIndex + keyword.length, content.length);
    List<TextSpan> list = [];
    list.add(TextSpan(text: before, style: TextStyle(color: ColorUtil.Gray33(), fontSize: fontSize)));
    list.add(TextSpan(text: keyword, style: TextStyle(color: ColorUtil.BlueNornal(), fontSize: fontSize)));
    list.addAll(getTextSpan(after, keyword, fontSize));
    return list;
  }

  /// int转string
  static String intToString(int num) {
    if (num == null) {
      return "";
    }
    return num.toString();
  }

  /// object转string
  static String objectToString<T>(T t) {
    if (t == null) {
      return "";
    }
    return t.toString();
  }

  /// 数字字符串为 空｜0
  static bool isEmptyOrZero(String num) {
    return isEmpty(num) || num == "0";
  }

  static String fixAutoLines(String content) {
    if (isEmpty(content)) {
      return "";
    }
    return Characters(content).join('\u{200B}');
  }

  /// 是否包含日期分隔符
  static bool isContainDateSeparator(String content) {
    return !isEmpty(content) && content.contains("-");
  }

  /// 字符串长度
  static int getLength(String text) {
    if (isEmpty(text)) {
      return 0;
    }
    return text.length;
  }
}
