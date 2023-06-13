import 'package:flutter/material.dart';

class KothonModule {
  final int id;
  final String itemName;
  final Widget iconWidget;
  final Function onTap;

  KothonModule({
    @required this.id,
    @required this.itemName,
    @required this.iconWidget,
    @required this.onTap,
  });
}
