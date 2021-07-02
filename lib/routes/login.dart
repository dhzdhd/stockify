import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:stockify/models/login_signup.dart';
import 'package:stockify/widgets/login_button.dart';

import '../widgets/login_field.dart';
import '../backend/auth.dart';

const String mobileLoginSvgPath = 'lib/assets/svg/mobile_login.svg';
const String desktopLoginSvgPath = 'lib/assets/svg/desktop_login.svg';

class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width < 1200
          ? MobileLoginScreen()
          : DesktopLoginScreen(),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: SvgPicture.asset(
              mobileLoginSvgPath,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Column(
            children: [
              Flexible(flex: 2, child: SafeArea(child: WelcomeContainer())),
              Flexible(flex: 4, child: FieldContainer()),
              Flexible(flex: 1, child: SignUpContainer()),
            ],
          ),
        ),
      ],
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.blueAccent),
        child: Column(children: [
          Flexible(
              flex: 7,
              child: Container(
                child: Row(
                  children: [
                    Spacer(flex: 1),
                    Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Spacer(flex: 3),
                            Flexible(flex: 3, child: WelcomeContainer()),
                            Spacer(flex: 5)
                          ],
                        )),
                    Spacer(flex: 1),
                    Flexible(flex: 3, child: DesktopHorizontalContainer()),
                    Spacer(flex: 1),
                  ],
                ),
              )),
          Flexible(
              child: Center(
            child: SignUpContainer(),
          ))
        ]));
  }
}

class DesktopHorizontalContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(),
      child: Column(
        children: [
          Spacer(flex: 4),
          Flexible(flex: 7, child: FieldContainer()),
          Spacer(flex: 5)
        ],
      ),
    );
  }
}

class WelcomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Spacer(flex: 5),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 55, color: Colors.white),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Consumer<LoginSignupModel>(
                      builder: (builder, model, child) {
                    return Text(
                      model.model
                          ? 'Log in to continue!'
                          : 'Sign in to continue!',
                      style: TextStyle(
                          fontSize: 35,
                          color: Color.fromARGB(255, 207, 212, 215)),
                    );
                  }))),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}

class FieldContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupModel>(builder: (builder, model, child) {
      return Container(
          child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(
                flex: 10,
              ),
              LoginField(text: 'Username', hidden: false),
              Spacer(),
              LoginField(text: 'Password', hidden: true),
              Spacer(),
              Visibility(
                  visible: model.model ? false : true,
                  child: LoginField(text: 'Confirm password', hidden: true)),
              Spacer(
                flex: 5,
              ),
              LoginButton(
                  model.model ? 'Login' : 'Sign Up',
                  model.model
                      ? () => Navigator.of(context).pushNamed('/content')
                      : () => Navigator.of(context).pushNamed('/content')),
              Spacer(
                flex: 7,
              )
            ],
          ),
        ),
      ));
    });
  }
}

class SignUpContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
      child: Consumer<LoginSignupModel>(builder: (builder, model, child) {
        return TextButton(
          child: Text(
            model.model
                ? 'Not signed in? Sign up here \u2794'
                : 'Already signed in? Login here \u2794',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => model.model ? model.toSignUp() : model.toLogin(),
        );
      }),
    ));
  }
}