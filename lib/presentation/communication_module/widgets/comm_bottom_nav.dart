// import 'package:Kothon_App/state_management/providers.dart';
// import 'package:Kothon_App/views/speed_dial.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/presentation/communication_module/page_view_items/settings.dart';
import 'package:transition/transition.dart';
// import 'package:kothon_app/sip_ua/register.dart';
// import 'package:sip_ua/sip_ua.dart';
// import 'package:transition/transition.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommBottomNav extends StatefulWidget {
  final Function speedDialFunc;
  final Function historyFunc;
  final Function contactsFunc;
  final Function messagesFunc;
  final int pageNo;

  CommBottomNav({
    @required this.speedDialFunc,
    @required this.historyFunc,
    @required this.contactsFunc,
    @required this.messagesFunc,
    this.pageNo,
  });

  @override
  _CommBottomNavState createState() => _CommBottomNavState();
}

class _CommBottomNavState extends State<CommBottomNav> {
  Color activeColor1 = KothonColors.barIconColor;
  Color activeColor2 = KothonColors.barIconColor;
  Color activeColor3 = KothonColors.barIconColor;
  Color activeColor4 = KothonColors.barIconColor;

  _activeBtn1() {
    setState(() {
      activeColor1 = KothonColors.activeColor;
      activeColor2 = KothonColors.barIconColor;
      activeColor3 = KothonColors.barIconColor;
      activeColor4 = KothonColors.barIconColor;
    });
  }

  _activeBtn2() {
    setState(() {
      activeColor2 = KothonColors.activeColor;
      activeColor1 = KothonColors.barIconColor;
      activeColor3 = KothonColors.barIconColor;
      activeColor4 = KothonColors.barIconColor;
    });
  }

  _activeBtn3() {
    setState(() {
      activeColor3 = KothonColors.activeColor;
      activeColor1 = KothonColors.barIconColor;
      activeColor2 = KothonColors.barIconColor;
      activeColor4 = KothonColors.barIconColor;
    });
  }

  _activeBtn4() {
    setState(() {
      activeColor4 = KothonColors.activeColor;
      activeColor1 = KothonColors.barIconColor;
      activeColor2 = KothonColors.barIconColor;
      activeColor3 = KothonColors.barIconColor;
    });
  }

  void activePageFunc() {
    if (widget.pageNo == 0) {
      _activeBtn1();
    } else if (widget.pageNo == 1) {
      _activeBtn2();
    } else if (widget.pageNo == 2) {
      _activeBtn3();
    } else if (widget.pageNo == 3) {
      _activeBtn4();
    }
  }

  // final SIPUAHelper _helper = SIPUAHelper();

  @override
  void initState() {
    super.initState();
    _activeBtn2();
    activePageFunc();
  }

  @override
  Widget build(BuildContext context) {
    // final stateNotifer = useProvider(countStateNotifierProvider);
    return SafeArea(
      child: Container(
        color: KothonColors.navBarColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.ellipsisV,
                      size: 20,
                    ),
                    onPressed: null,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.speedDialFunc();
                          _activeBtn1();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.phoneAlt,
                                size: 18,
                                color: activeColor1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: Text(
                                'Speed Dial',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: activeColor1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.historyFunc();
                          _activeBtn2();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.solidClock,
                                size: 18,
                                color: activeColor2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: Text(
                                'History',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: activeColor2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.contactsFunc();
                          _activeBtn3();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.solidAddressBook,
                                size: 18,
                                color: activeColor3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: Text(
                                'Contacts',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: activeColor3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.messagesFunc();
                          _activeBtn4();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.solidComments,
                                size: 18,
                                color: activeColor4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: Text(
                                'Messages',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: activeColor4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10),
                //   child: FaIcon(
                //     FontAwesomeIcons.ellipsisV,
                //     size: 20,
                //     color: KothonColors.barIconColor,
                //   ),
                // ),
                fMenu(context),
              ],
            ),
            Container(
              // padding: EdgeInsets.only(bottom: 20),
              height: 20,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFF59E8F1),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    'Powered by KOTHON',
                    style: TextStyle(
                      color: KothonColors.barIconColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pop Up Menu ///
  Widget fMenu(BuildContext context) {
    var normColor = KothonColors.barIconColor;
    var flashyColor = KothonColors.offWhite;
    bool _isSelected = false;
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.35,
      blurSize: 0,
      menuItemExtent: 50,
      menuBoxDecoration: BoxDecoration(
          // color: KothonColors.dialPadHeaderColor.withOpacity(0),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 5,
            )
          ]
          // borderRadius: BorderRadius.all(
          //   Radius.circular(0.0),
          // ),
          ),

      // duration: Duration(milliseconds: 100),
      animateMenuItems: false,
      blurBackgroundColor: Colors.black12.withOpacity(0.1),
      openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
      // menuOffset: 10.0, // Offset value to show menuItem from the selected item
      bottomOffsetHeight:
          90.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
      // child: Container(
      //   // padding: const EdgeInsets.only(right: 10),
      //   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      //   child: FaIcon(
      //     FontAwesomeIcons.ellipsisV,
      //     size: 20,
      //     // color: KothonColors.barIconColor,
      //     color: _isSelected ? flashyColor : normColor,
      //   ),
      // ),
      child: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.ellipsisV,
          size: 20,
          color: _isSelected ? flashyColor : normColor,
        ),
        onPressed: null,
      ),

      onPressed: () {
        setState(() {
          _isSelected = true;
        });
      },
      menuItems: <FocusedMenuItem>[
        // Add Each FocusedMenuItem  for Menu Options
        FocusedMenuItem(
            backgroundColor: KothonColors.dialPadHeaderColor,
            title: Text(
              "Account",
              style: TextStyle(
                color: KothonColors.offWhite,
              ),
            ),
            trailingIcon: Icon(
              Icons.account_box,
              color: KothonColors.offWhite,
            ),
            onPressed: () {
              print('open');
              // Navigator.push(context,
              //     Transition(child: RegisterWidget(_helper)).builder());
              Navigator.pushNamed(context, '/register');
            }),
        FocusedMenuItem(
            backgroundColor: KothonColors.dialPadHeaderColor,
            title: Text(
              "Settings",
              style: TextStyle(
                color: KothonColors.offWhite,
              ),
            ),
            trailingIcon: Icon(
              Icons.settings,
              color: KothonColors.offWhite,
            ),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     Transition(
              //             child: SettingsScreen(),
              //             transitionEffect: TransitionEffect.fade)
              //         .builder());
            }),
        FocusedMenuItem(
            backgroundColor: KothonColors.dialPadHeaderColor,
            title: Text(
              "About",
              style: TextStyle(
                color: KothonColors.offWhite,
              ),
            ),
            trailingIcon: Icon(
              Icons.info,
              color: KothonColors.offWhite,
            ),
            onPressed: () {}),
        FocusedMenuItem(
            backgroundColor: KothonColors.dialPadHeaderColor,
            title: Text(
              "Log Out",
              style: TextStyle(
                color: KothonColors.offWhite,
              ),
            ),
            trailingIcon: Icon(
              Icons.logout,
              color: KothonColors.offWhite,
            ),
            onPressed: () {}),
      ],
    );
  }
}
