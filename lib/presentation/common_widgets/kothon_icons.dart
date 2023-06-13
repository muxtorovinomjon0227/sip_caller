import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KothonIcons {
  final String assetName = 'assets/images/logo.svg';
  final String mainIcon = 'assets/images/logowtext.svg';

  Widget svg() {
    return SvgPicture.asset(
      assetName,
      semanticsLabel: 'Kothon Logo',
      width: 35,
      height: 35,
    );
  }

  Widget icon() {
    return SvgPicture.asset(
      mainIcon,
      semanticsLabel: 'Kothon Logo with Text',
      width: 120,
      height: 120,
    );
  }
}
