import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:kothon_app/presentation/splash/widgets/animated_image.dart';
import 'package:kothon_app/presentation/login/login_screen.dart';
import 'package:kothon_app/presentation/splash/widgets/animated_image_2.dart';
import 'package:transition/transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _splashTimeOut();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: topPadding,
            ),
            AnimatedImage2(),
          ],
        ),
      ),
    );
  }

  _splashTimeOut() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
    );
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     Transition(
    //       child: LoginScreen(),
    //       transitionEffect: TransitionEffect.scale,
    //     ).builder(),
    //     (route) => false);
  }
}
