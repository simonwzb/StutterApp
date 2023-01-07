import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:stutter_app/ui/login/pages/widgets/sign_in.dart';
import 'package:stutter_app/ui/login/pages/widgets/signUp.dart';
import 'package:stutter_app/ui/login/utils/bubble_indicator_painter.dart';
import 'package:stutter_app/widget/svglib/drawing_widget.dart';
import 'package:stutter_app/widget/svglib/line_animation.dart';
import 'package:stutter_app/widget/svglib/path_order.dart';

import '../../../theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      CustomTheme.loginGradientStart,
                      CustomTheme.loginGradientEnd
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 1.0),
                    stops: <double>[0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(children: [
                                  SizedBox(
                                    height: 44,
                                  ),
                                  Row(
                                    //alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          "assets/img/logo_middle.png",
                                          fit: BoxFit.fill,
                                          height: 55,
                                          //alignment: Alignment.bottomCenter,
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(6.5, 2, 0, 0),
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          "assets/img/logo_name_white.png",
                                          fit: BoxFit.fill,
                                          height: 22.5,
                                          //alignment: Alignment.bottomCenter,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "“互相帮助，战胜口吃!”",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16.5,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "——口吃社群体口袋里的App",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                          height: 155)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (int i) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: SignIn(),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: SignUp(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
            onTap: () => navService.goBack(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 52.0, 0, 0),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: 24,
              ),
            )),
      ]),
    );
  }

  final NavigationService navService = NavigationService();

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignInButtonPress,
                child: Text(
                  '老用户',
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  '新朋友',
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}
