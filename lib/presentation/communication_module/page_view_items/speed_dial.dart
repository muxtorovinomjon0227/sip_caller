import 'dart:ui';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/data/models/history_model.dart';
import 'package:kothon_app/data/models/speed_dial_model.dart';
import 'package:kothon_app/logic/cubit/history_cubit.dart';
import 'package:kothon_app/logic/cubit/speed_dial_cubit.dart';
import 'package:kothon_app/presentation/common_widgets/show_toast.dart';
import 'package:kothon_app/presentation/communication_module/widgets/speed_dial_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class SpeedDial extends StatefulWidget {
  final SIPUAHelper _helper;

  const SpeedDial(this._helper, {Key key}) : super(key: key);

  @override
  _SpeedDialState createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial> implements SipUaHelperListener {
  List<SpeedDialModel> speedDialList = [];

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  // SpeedDialModel speedDialModel = SpeedDialModel();

  // void addToList() {
  //   speedDialList.add(SpeedDialModel(name: "Niloy", contact: '1234'));
  //   speedDialList.add(SpeedDialModel(name: "Biswas", contact: '1234'));
  //   speedDialList.add(SpeedDialModel(name: "Monkey", contact: '1234'));
  //   speedDialList.add(SpeedDialModel(name: "D Nil", contact: '1234'));
  // }

  String _dest;
  String _serverIP;
  SIPUAHelper get helper => widget._helper;
  TextEditingController _textController;
  SharedPreferences _preferences;

  String receivedMsg;

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    _serverIP = _preferences.getString('serverIP') ?? 'N/A';
    _dest = _preferences.getString('dest') ?? 'sip:hello_jssip@tryit.jssip.net';
    _textController = TextEditingController(text: _dest);
    _textController.text = _dest;

    this.setState(() {});
  }

  Widget _handleCall(BuildContext context, [bool voiceonly = false]) {
    // var dest = _textController.text;
    var dest = 'sip:$dialNum@$_serverIP';

    if (dest == null || dest.isEmpty) {
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Target is empty.'),
            content: Text('Please enter a SIP URI or username!'),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }
    helper.call(dest, voiceonly);
    _preferences.setString('dest', dest);
    return null;
  }

  //
  String dialNum = '';
  //

  void _bindEventListeners() {
    helper.addSipUaHelperListener(this);
  }

  @override
  void initState() {
    super.initState();
    _bindEventListeners();
    _loadSettings();
    // addToList();
  }

  @override
  void deactivate() {
    helper.removeSipUaHelperListener(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //
    var sWidth = MediaQuery.of(context).size.width;
    // var sHeight = MediaQuery.of(context).size.height;

    speedDialList = context.watch<SpeedDialCubit>().state.speedDialList;
    //
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.all(10),
        width: sWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: BoxDecoration(
                color: KothonColors.dialPadHeaderColor,
                // borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Opacity(
                  //   opacity: 0,
                  //   child: IconButton(
                  //     icon: FaIcon(FontAwesomeIcons.plus),
                  //     onPressed: null,
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Speed Dial',
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
                        FontAwesomeIcons.plus,
                        size: 16,
                        color: KothonColors.backgroundColor,
                      ),
                      onPressed: () async {
                        await speedDialAddDialog(
                          context: context,
                          nameController: _nameController,
                          contactController: _contactController,
                        );
                        print(_nameController.text);
                        print(_contactController.text);
                      }),
                ],
              ),
            ),
            // Divider(
            //   height: 5,
            //   color: Colors.black,
            // ),
            (speedDialList.length < 1)
                ? Flexible(
                    child: Center(
                      child: TextButton(
                        child: Text(
                          'Click here to add speed dials',
                          style: TextStyle(color: Colors.black87),
                        ),
                        onPressed: () async {
                          await speedDialAddDialog(
                            context: context,
                            nameController: _nameController,
                            contactController: _contactController,
                          );
                          print(_nameController.text);
                          print(_contactController.text);
                        },
                      ),
                    ),
                  )
                : Flexible(
                    child: Container(
                      // height: sHeight * 0.77,
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.separated(
                          // separatorBuilder: (context, index) {
                          // return Divider(
                          // height: 5,
                          // );
                          // },
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: speedDialList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(speedDialList[index].name[0]),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                              title: Text(speedDialList[index].name),
                              subtitle: Text(speedDialList[index].contact),
                              onTap: () {
                                // context
                                //     .read<SpeedDialCubit>()
                                //     .delSpeedDial(index);
                                showTheBottomSheet(
                                  context: context,
                                  contactName: speedDialList[index].name,
                                  contactNumber: speedDialList[index].contact,
                                  index: index,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  showTheBottomSheet({
    BuildContext context,
    String contactName,
    String contactNumber,
    int index,
  }) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: KothonColors.dialPadHeaderColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Text(
                    contactName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: KothonColors.backgroundColor,
                    ),
                  ),
                  Text(
                    contactNumber,
                    style: TextStyle(
                      color: KothonColors.backgroundColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: KothonColors.greenBtn,
                        elevation: 0,
                        child: FaIcon(FontAwesomeIcons.phoneAlt),
                        onPressed: () {
                          setState(() {
                            dialNum = contactNumber;
                          });
                          context.read<HistoryCubit>().addHistory(HistoryModel(
                              contactName,
                              dialNum,
                              DateTimeFormat.format(DateTime.now(),
                                  format: 'M j, Y, h:i a')));

                          Navigator.pop(context);
                          return _handleCall(context, true);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Audio Call',
                          style: TextStyle(
                            color: KothonColors.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: KothonColors.greenBtn,
                        elevation: 0,
                        child: FaIcon(FontAwesomeIcons.video),
                        onPressed: () {
                          setState(() {
                            dialNum = contactNumber;
                          });

                          context.read<HistoryCubit>().addHistory(HistoryModel(
                              contactName,
                              dialNum,
                              DateTimeFormat.format(DateTime.now(),
                                  format: 'M j, Y, h:i a')));

                          Navigator.pop(context);
                          return _handleCall(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Video Call',
                          style: TextStyle(
                            color: KothonColors.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: KothonColors.greenBtn,
                        elevation: 0,
                        child: FaIcon(FontAwesomeIcons.solidComments),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Message',
                          style: TextStyle(
                            color: KothonColors.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.redAccent,
                        elevation: 0,
                        child: FaIcon(FontAwesomeIcons.trash),
                        onPressed: () {
                          context.read<SpeedDialCubit>().delSpeedDial(index);
                          Navigator.pop(context);
                          futureToast(
                              context: context,
                              message: "Removed from speed dial");
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: KothonColors.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    this.setState(() {});
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void callStateChanged(Call call, CallState callState) {
    if (callState.state == CallStateEnum.CALL_INITIATION) {
      Navigator.pushNamed(context, '/callscreen', arguments: call);
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    //Save the incoming message to DB
    String msgBody = msg.request.body as String;
    setState(() {
      receivedMsg = msgBody;
    });
  }
}
