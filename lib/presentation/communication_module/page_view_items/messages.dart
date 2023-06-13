import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/kothon_colors.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 40,
            color: KothonColors.dialPadHeaderColor,
            width: sWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 16,
                      color: KothonColors.backgroundColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.sync,
                    size: 16,
                    color: KothonColors.backgroundColor,
                  ),
                  splashRadius: 1,
                  onPressed: () async {
                    // await getContacts();
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: Center(
              child: Text('No messages found!'),
            ),
          ),
        ],
      ),
    );
  }
}
