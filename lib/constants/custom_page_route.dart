import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;

  CustomPageRoute({@required this.widget})
      : super(
          transitionDuration: Duration(milliseconds: 450),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            // return ScaleTransition(
            //   scale: animation,
            //   child: child,
            //   alignment: Alignment.center,
            // );
            return FadeTransition(
              opacity: animation,
              child: child,
              alwaysIncludeSemantics: false,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return widget;
          },
        );
}
