import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/enums.dart';
// import 'package:switcher_button/switcher_button.dart';

import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/logic/cubit/internet_cubit.dart';
import 'package:kothon_app/logic/cubit/toggle_button_cubit.dart';
import 'package:kothon_app/presentation/common_widgets/kothon_icons.dart';
import 'package:kothon_app/presentation/common_widgets/show_toast.dart';
// import 'package:kothon_app/presentation/common_widgets/show_toast.dart';

class KothonHeader extends StatefulWidget {
  KothonHeader({
    Key key,
  }) : super();
  @override
  KothonHeaderState createState() => KothonHeaderState();
}

class KothonHeaderState extends State<KothonHeader> {
  //
  // bool _isOnline = true;
  //
  @override
  Widget build(BuildContext context) {
    //
    var topPadding = MediaQuery.of(context).padding.top;
    var sWidth = MediaQuery.of(context).size.width;
    //
    return Container(
      width: sWidth,
      color: KothonColors.barBodyColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: topPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    KothonIcons().svg(),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'User Agent Name',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: KothonColors.logoTextColor,
                          fontSize: 18),
                    ),
                    // Transform.scale(
                    //   scale: 1,
                    //   child: Switch(
                    //     value: _isOnline,
                    //     onChanged: (_) {
                    //       setState(() {
                    //         _isOnline = !_isOnline;
                    //         print(_isOnline);
                    //       });
                    //     },
                    //     activeColor: KothonColors.switchActiveColor,
                    //     inactiveTrackColor: Colors.grey,
                    //     activeTrackColor: KothonColors.barIconColor,
                    //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Row(
                children: [
                  BlocConsumer<InternetCubit, InternetState>(
                    listener: (context, state) {
                      // do something
                    },
                    builder: (context, state) {
                      if (state is InternetConnected &&
                          state.connectionType == ConnectionType.Mobile) {
                        return FaIcon(
                          FontAwesomeIcons.mobileAlt,
                          size: 15,
                          color: Colors.green,
                        );
                      } else if (state is InternetConnected &&
                          state.connectionType == ConnectionType.Wifi) {
                        return FaIcon(
                          FontAwesomeIcons.wifi,
                          size: 15,
                          color: Colors.green,
                        );
                      } else {
                        return FaIcon(
                          FontAwesomeIcons.exclamationTriangle,
                          color: Colors.red,
                          size: 15,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  BlocConsumer<ToggleButtonCubit, ToggleButtonState>(
                    listener: (context, state) {
                      //implement listener
                      if (state.toggleValue) {
                        futureToast(context: context, message: 'Online');
                      } else {
                        futureToast(context: context, message: 'Offline');
                      }
                    },
                    builder: (context, state) {
                      return FlutterSwitch(
                        toggleSize: 15,
                        height: 22,
                        width: 50,
                        borderRadius: 30,
                        activeToggleColor: KothonColors.switchActiveColor,
                        activeColor: KothonColors.toggleBtnColor,
                        value: state.toggleValue,
                        onToggle: (value) {
                          context.read<ToggleButtonCubit>().onToggleButtonPress(
                              value: value, intValue: state.intValue + 1);
                        },
                      );
                    },
                  ),
                  // BlocBuilder<ToggleButtonCubit, ToggleButtonState>(
                  //   builder: (context, state) {
                  //     return SwitcherButton(
                  //       value: state.toggleValue,
                  //       onColor: KothonColors.switchActiveColor,
                  //       offColor: KothonColors.toggleBtnColor,
                  //       size: 50,
                  //       onChange: (value) {
                  //         // _isOnline = !value;
                  //         context.read<ToggleButtonCubit>().onToggleButtonPress(
                  //             value: !value, intValue: state.intValue + 1);
                  //         // print(value);
                  //         futureToast(
                  //           context: context,
                  //           // message: value ? "Online" : "Offline",
                  //           message: state.intValue.toString(),
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
