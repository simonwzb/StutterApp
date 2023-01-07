import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sp_util/sp_util.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/login/widgets/snackbar.dart';
import 'package:stutter_app/widget/svglib/drawing_widget.dart';
import 'package:stutter_app/widget/svglib/line_animation.dart';
import 'package:stutter_app/widget/svglib/path_order.dart';

import '../../../../eventbus/LoginStatusEvent.dart';
import '../../../../theme.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          validator: (value) {
                            if (!validator.phone(value!)) {
                              return '请输入正确的账号';
                            }
                            return null;
                          },
                          focusNode: focusNodeEmail,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: '账号',
                            hintStyle: TextStyle(fontSize: 17.0),
                          ),
                          onFieldSubmitted: (_) {
                            focusNodePassword.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: focusNodePassword,
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          validator: (value) {
                            if (!validator.mediumPassword(value!)) {
                              return '密码格式:英文字母/数字,至少6位';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: '密码(英文字母/数字)',
                            hintStyle: const TextStyle(fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextPassword
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            _toggleSignInButton();
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      '登录',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () => press(),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            child: TextButton(
              onPressed: () {},
              child: GestureDetector(
                child: Text(
                  '忘记密码?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                ),
                onTap: () {},
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: AnimatedDrawing.svg("assets/egypt1.svg",
                  run: true,
                  duration: new Duration(seconds: 10),
                  lineAnimation: LineAnimation.allAtOnce,
                  animationCurve: Curves.linear,
                  animationOrder: PathOrders.decreasingLength,
                  onFinish: () {}),
            ),
          ),
          Container(
            child: Text(
              "战胜这古老的疾病，口吃",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 10.5,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            child: Center(
              child: Text(
                " ", //Copyright © 2017 - 2022 熹学科技. All Rights Reserved.
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 9.5,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 14.5,
          )
        ],
      ),
    );
  }

  final NavigationService navService = NavigationService();
  EventBus eventBus = EventBus();

  Future<void> press() async {
    if (loginEmailController.text.length < 4 ||
        loginEmailController.text.length > 12) {
      showToast("账号至少4位，最多12位");
      return;
    }
    if (loginPasswordController.text.length < 6 ||
        loginPasswordController.text.length > 16) {
      showToast("密码至少6位，最多16位");
      return;
    }
    Dio _dio = DioUtil.getInstance()!.dio;
    await _dio.post(DioUtil.BASE_URL + "/v1/login/basic", data: {
      'email': loginEmailController.text,
      'password': loginPasswordController.text,
      /*'refreshToken':'123',*/
      /*'profilePicUrl':
          'http://media.getlijin.com/avatar_default_stutter_study_org.png'*/
    }).then((value) async {
      /*print("value.data['data']['tokens']['accessToken']:::" +
          value.data['data']['tokens']['accessToken']);
      print("user12:::" + value.data['data']['user'].toString());
      print("user22:::" +
          Map<String, dynamic>.from(value.data['data']['user']).toString());*/
      //new List<Map<String, dynamic>>.from(value.data['data']);
      await  SpUtil.putString(
          'accessToken', value.data['data']['tokens']['accessToken']);
      await  SpUtil.putString(
          'refreshToken', value.data['data']['tokens']['refreshToken']);
      await  SpUtil.putObject(
          "user", Map<String, dynamic>.from(value.data['data']['user']));
      /* Map? user = SpUtil.getObject("user");
      print("\n\n\n\n\nuser:" + user.toString());
      print("accessToken:" + SpUtil.getString('accessToken')!);*/
      DioUtil.getInstance()?.refreshHeaders();
      eventBus.fire(LoginStatusEvent(true));
      navService.goBack();
    }, onError: (e) {
      showToast("登录失败");
    });
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}

class _toggleSignInButton {}
