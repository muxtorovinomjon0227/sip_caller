import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedImage2 extends StatefulWidget {
  @override
  _AnimatedImage2State createState() => _AnimatedImage2State();
}

class _AnimatedImage2State extends State<AnimatedImage2> {
  final Widget svg = SvgPicture.asset(
    'assets/images/logowtext.svg',
    semanticsLabel: 'Kothon Logo',
    height: 200,
    // width: 100,
  );

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: Center(
        child: svg,
      ),
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Padding(
            padding: EdgeInsets.only(bottom: value * 20),
            child: child,
          ),
        );
      },
    );
  }
}
