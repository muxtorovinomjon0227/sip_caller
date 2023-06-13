import 'package:flutter/material.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/presentation/common_widgets/kothon_icons.dart';
import 'package:kothon_app/presentation/home/home.dart';
import 'package:kothon_app/presentation/login/widgets/login_field.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:permission_handler/permission_handler.dart';
import 'package:transition/transition.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // final String assetName = 'assets/images/logo.svg';
    // final Widget svg = SvgPicture.asset(
    //   assetName,
    //   semanticsLabel: 'Kothon Logo',
    //   width: 35,
    //   height: 35,
    // );
    // final String mainIcon = 'assets/images/logowtext.svg';
    // final Widget icon = SvgPicture.asset(
    //   mainIcon,
    //   semanticsLabel: 'Kothon Logo with Text',
    //   width: 150,
    //   height: 150,
    // );
    // final sWidth = MediaQuery.of(context).size.width;
    // final sHeight = MediaQuery.of(context).size.width;
    //
    final serverUriController = TextEditingController();
    final userNameController = TextEditingController();
    final passwordController = TextEditingController();
    //
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned(
            //   top: 0,
            //   child: Container(
            //     width: sWidth,
            //     height: sHeight * 0.13,
            //     color: KothonColors.barBodyColor,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         SizedBox(
            //           width: 20,
            //         ),
            //         KothonIcons().svg(),
            //         SizedBox(
            //           width: 10,
            //         ),
            //         Text(
            //           'KOTHON',
            //           style: TextStyle(
            //               fontWeight: FontWeight.w900,
            //               color: KothonColors.logoTextColor,
            //               fontSize: 18),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KothonIcons().icon(),
                  SizedBox(
                    height: 30,
                  ),

                  /// ServerUri Field ///
                  LoginField(
                    serverUriController: serverUriController,
                    header: 'Server Uri',
                    hintText: '',
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /// Username Field ///
                  LoginField(
                    serverUriController: userNameController,
                    header: 'Username',
                    hintText: '',
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /// Password Field ///
                  LoginField(
                    serverUriController: passwordController,
                    header: 'Password',
                    hintText: '',
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  /// Login Button ///
                  MaterialButton(
                    height: 40,
                    minWidth: 120,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    color: KothonColors.barIconColor,
                    splashColor: KothonColors.rippleColor,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  HomeScreen()),
                      );
                      // Navigator.push(
                      //   context,
                      //   Transition(
                      //     child: HomeScreen(),
                      //     transitionEffect: TransitionEffect.fade,
                      //   ).builder(),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<PermissionStatus> getPermissions() async {
    // final PermissionStatus permission = await Permission.contacts.status;

    // if (permission != PermissionStatus.granted &&
    //     permission != PermissionStatus.denied) {
    //   final Map<Permission, PermissionStatus> permissionStatus = await [
    //     Permission.contacts,
    //     Permission.camera,
    //     Permission.microphone,
    //   ].request();

    //   return permissionStatus[Permission.contacts] ??
    //       PermissionStatus.undetermined;
    // } else {
    //   return permission;
    // }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.camera,
      Permission.microphone,
      Permission.phone,
    ].request();

    print(statuses[Permission.contacts]);
    print(statuses[Permission.camera]);
    print(statuses[Permission.microphone]);
    return null;
  }
}
