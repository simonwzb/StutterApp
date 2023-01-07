import 'package:flutter/cupertino.dart';

class PhoneUtil {
  /// 校验手机号码 ture:合法 false： 不合法
  static bool isPhone(String input) {
    if (input == null) {
      return false;
    }
    RegExp mobile = new RegExp(r"1[0-9]\d{9}$");
    return mobile.hasMatch(input);
  }

  /// 校验验证码 ture:合法 false： 不合法
  static bool isValidateCaptcha(String input) {
    RegExp mobile = new RegExp(r"\d{6}$");
    return mobile.hasMatch(input);
  }

  /// 校验密码 ture:合法 false： 不合法
  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$");
    return mobile.hasMatch(input);
  }

  /// 是否是折叠屏铺开
  static bool isFoldScreenExpand(BuildContext context) {
    return MediaQuery.of(context).size.width > 0 && MediaQuery.of(context).size.height / MediaQuery.of(context).size.width < 1.35;
  }

/*  /// 是否折叠屏折起
  static bool isFoldCollapse(BuildContext context) {
    return FontSizeUtil.isFold && !isFoldScreenExpand(context);
  }

  /// 是否折叠屏展开
  static bool isFoldExpand(BuildContext context) {
    return FontSizeUtil.isFold && isFoldScreenExpand(context);
  }*/
}
