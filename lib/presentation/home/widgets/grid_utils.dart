import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/kothon_colors.dart';

// class VerticalItem extends StatelessWidget {
//   const VerticalItem({
//     required this.title,
//     required this.itemClick,
//     Key? key,
//   }) : super(key: key);

//   final String title;
//   final Function itemClick;

//   @override
//   Widget build(BuildContext context) => Container(
//         height: 96,
//         child: Card(
//           child: Text(
//             '$title a long title',
//             style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
//           ),
//         ),
//       );
// }

class HorizontalItem extends StatelessWidget {
  const HorizontalItem({
    @required this.title,
    @required this.onClick,
    Key key,
  }) : super(key: key);

  final String title;
  final GestureTapCallback onClick;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onClick,
        child: Container(
          width: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Material(
              color: KothonColors.barBodyColor,
              child: Center(
                child: gridIcon(title),
              ),
            ),
          ),
        ),
      );
}

/// Wrap Ui item with animation & padding
Widget Function(
  BuildContext context,
  int index,
  Animation<double> animation,
) animationItemBuilder(
  Widget Function(int index) child, {
  EdgeInsets padding = EdgeInsets.zero,
}) =>
    (
      BuildContext context,
      int index,
      Animation<double> animation,
    ) =>
        FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: padding,
              child: child(index),
            ),
          ),
        );

// Widget Function(
//   BuildContext context,
//   Animation<double> animation,
// ) animationBuilder(
//   Widget child, {
//   double xOffset = 0,
//   EdgeInsets padding = EdgeInsets.zero,
// }) =>
//     (
//       BuildContext context,
//       Animation<double> animation,
//     ) =>
//         FadeTransition(
//           opacity: Tween<double>(
//             begin: 0,
//             end: 1,
//           ).animate(animation),
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset(xOffset, 0.1),
//               end: Offset.zero,
//             ).animate(animation),
//             child: Padding(
//               padding: padding,
//               child: child,
//             ),
//           ),
//         );

Widget gridIcon(String title) {
  switch (title) {
    case "0":
      return FaIcon(
        FontAwesomeIcons.phoneVolume,
        size: 45,
      );
    case "1":
      return FaIcon(
        FontAwesomeIcons.commentsDollar,
        size: 40,
      );
    case "2":
      return FaIcon(
        FontAwesomeIcons.mailBulk,
        size: 40,
      );
    case "3":
      return FaIcon(
        FontAwesomeIcons.clipboardCheck,
        size: 40,
      );
    case "4":
      return FaIcon(
        FontAwesomeIcons.cannabis,
        size: 40,
      );
    case "5":
      return FaIcon(
        FontAwesomeIcons.joint,
        size: 40,
      );

    default:
      return Container();
  }
}
