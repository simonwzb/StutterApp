import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sp_util/sp_util.dart';
import 'package:stutter_app/network/dio_util.dart';
import 'package:stutter_app/ui/login/widgets/snackbar.dart';

import '../../../../eventbus/LoginStatusEvent.dart';
import '../../../../theme.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 23.0),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          /*Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[*/
          Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 300.0,
                height: 310.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      child: TextField(
                        focusNode: focusNodeName,
                        controller: signupNameController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        autocorrect: false,
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.black,
                          ),
                          hintText: '昵称',
                          hintStyle: TextStyle(fontSize: 16.0),
                        ),
                        onSubmitted: (_) {
                          focusNodeEmail.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      width: 250.0,
                      height: 1.0,
                      color: Colors.grey[400],
                    ),
                    Container(
                      width: 300.0,
                      //height: 190.0,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextFormField(
                              focusNode: focusNodeEmail,
                              controller: signupEmailController,
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
                                top: 10.0,
                                bottom: 10.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextFormField(
                              focusNode: focusNodePassword,
                              controller: signupPasswordController,
                              obscureText: _obscureTextPassword,
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
                                  onTap: _toggleSignup,
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
                                focusNodeConfirmPassword.requestFocus();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                              focusNode: focusNodeConfirmPassword,
                              controller: signupConfirmPasswordController,
                              obscureText: _obscureTextConfirmPassword,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: const Icon(
                                  FontAwesomeIcons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: '确认密码',
                                hintStyle: const TextStyle(fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignupConfirm,
                                  child: Icon(
                                    _obscureTextConfirmPassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onSubmitted: (_) {
                                _toggleSignUpButton();
                              },
                              textInputAction: TextInputAction.go,
                            ),
                          ),
                          Container(
                            //margin: const EdgeInsets.only(top: 340.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
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
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 42.0),
                                child: Text(
                                  '注册',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ),
                              onPressed: () => press(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ])));
  }

  _toggleSignUpButton() {}
  final NavigationService navService = NavigationService();
  EventBus eventBus = EventBus();

  Future<void> press() async {
    if (signupEmailController.text.length < 4 ||
        signupEmailController.text.length > 12) {
      showToast("账号至少4位，最多12位");
      return;
    }
    if (signupPasswordController.text.length < 6 ||
        signupPasswordController.text.length > 16) {
      showToast("密码至少6位，最多16位");
      return;
    }
    if (signupPasswordController.text != signupConfirmPasswordController.text) {
      showToast("两次密码长度不同");
      return;
    }
    if (signupNameController.text.length <= 4 ||
        signupNameController.text.length > 20) {
      showToast("昵称长度至少4位，最多20位");
      return;
    }
    Dio _dio = DioUtil.getInstance()!.dio;
    await _dio.post(DioUtil.BASE_URL + "/v1/signup/basic", data: {
      'name': signupNameController.text,
      'email': signupEmailController.text,
      'password': signupPasswordController.text,
      /*'refreshToken':'123',*/
      'profilePicUrl':
          'http://media.getlijin.com/avatar_default_stutter_study_org.png',
      //'signiture':''
    }).then((value) async {
      print(value);
      //new List<Map<String, dynamic>>.from(value.data['data']);
      await SpUtil.putString(
          'accessToken', value.data['data']['tokens']['accessToken']);
      await SpUtil.putString(
          'refreshToken', value.data['data']['tokens']['refreshToken']);
      await SpUtil.putObject(
          "user", Map<String, dynamic>.from(value.data['data']['user']));
      DioUtil.getInstance()?.refreshHeaders();
      eventBus.fire(LoginStatusEvent(true));
      navService.goBack();
    }, onError: (e) {
      showToast("失败，请反馈给我们\n" + e.toString());
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
