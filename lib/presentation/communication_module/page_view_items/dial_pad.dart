import 'package:community_material_icon/community_material_icon.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/data/models/history_model.dart';
import 'package:kothon_app/logic/cubit/history_cubit.dart';
import 'package:kothon_app/presentation/common_widgets/show_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class DialPadPage extends StatefulWidget {
  final SIPUAHelper _helper;

  const DialPadPage(this._helper, {Key key}) : super(key: key);

  @override
  _DialPadPageState createState() => _DialPadPageState();
}

class _DialPadPageState extends State<DialPadPage>
    implements SipUaHelperListener {
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
  initState() {
    super.initState();
    // receivedMsg = "";
    _bindEventListeners();
    _loadSettings();
    // getPermissions();
  }

  @override
  void deactivate() {
    helper.removeSipUaHelperListener(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 100),
              child: _dialPadWidget(context: context, topPadding: topPadding),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    backgroundColor: KothonColors.greenBtn,
                    heroTag: 'tag3',
                    elevation: 0,
                    child: FaIcon(
                      FontAwesomeIcons.phoneAlt,
                    ),
                    onPressed: () {
                      if (dialNum == null || dialNum.isEmpty) {
                        futureToast(
                            context: context, message: 'Invalid Number!');
                        return null;
                      }
                      print('sip:$dialNum@$_serverIP');

                      //============================== Connection Check ============================//
                      if (EnumHelper.getName(helper.registerState.state) !=
                          'Registered') {
                        // Navigator.pop(context);
                        futureToast(
                            context: context,
                            message: 'Please connect to your office network!');
                        return null;
                      }

                      //============================== Call History Add ===========================//
                      context.read<HistoryCubit>().addHistory(HistoryModel(
                          'N/A',
                          dialNum,
                          DateTimeFormat.format(DateTime.now(),
                              format: 'M j, Y, h:i a')));

                      return _handleCall(context, true);
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    backgroundColor: KothonColors.greenBtn,
                    heroTag: 'tag4',
                    elevation: 0,
                    child: FaIcon(
                      FontAwesomeIcons.video,
                    ),
                    onPressed: () {
                      if (dialNum == null || dialNum.isEmpty) {
                        futureToast(
                            context: context, message: 'Invalid Number!');
                        return null;
                      }

                      //============================== Connection Check ============================//
                      if (EnumHelper.getName(helper.registerState.state) !=
                          'Registered') {
                        // Navigator.pop(context);
                        futureToast(
                            context: context,
                            message: 'Please connect to your office network!');
                        return null;
                      }

                      context.read<HistoryCubit>().addHistory(HistoryModel(
                          'N/A',
                          dialNum,
                          DateTimeFormat.format(DateTime.now(),
                              format: 'M j, Y, h:i a')));

                      return _handleCall(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _dialPadWidget({
    @required BuildContext context,
    @required double topPadding,
  }) {
    TextStyle style1 = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );
    TextStyle style2 = TextStyle(
      fontWeight: FontWeight.bold,
    );

    TextStyle style3 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    // String displayNumber;

    // _backSpace() {
    //   displayNumber = '';
    // }

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Back Button and Top Dark Area ///
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFF3C5364),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: KothonColors.backgroundColor,
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Status: ${EnumHelper.getName(helper.registerState.state)}',
          ),
          Text('Server IP: $_serverIP'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 54, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        // left: BorderSide(color: KothonColors.numpadDivColor),
                        // right: BorderSide(color: KothonColors.numpadDivColor),
                        // top: BorderSide(color: KothonColors.numpadDivColor),
                        bottom: BorderSide(
                          color: KothonColors.numpadDivColor,
                          width: 2,
                        ),
                      ),
                    ),
                    child: dialNum == ''
                        ? Text(
                            'Enter a Number',
                            style: style3.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        : Text(
                            dialNum,
                            style: style3,
                          ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),

                /// BACK SPACE ///
                GestureDetector(
                  child: FaIcon(
                    FontAwesomeIcons.backspace,
                    size: 35,
                  ),

                  /// for single press ///
                  onTap: () {
                    if (dialNum.length == 0) {
                      return;
                    }

                    setState(() {
                      dialNum = dialNum.substring(0, dialNum.length - 1);
                    });
                  },

                  /// for long press ///
                  onLongPress: () {
                    if (dialNum.length == 0) {
                      return;
                    }

                    setState(() {
                      dialNum = '';
                    });
                  },
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// KEY 1 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    // left: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    // top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '1',
                        style: style1,
                      ),
                      Icon(Icons.voicemail),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '1';
                    });
                  },
                ),
              ),

              /// KEY 2 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    // top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '2',
                        style: style1,
                      ),
                      Text(
                        'ABC',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '2';
                    });
                  },
                ),
              ),

              /// KEY 3 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    // right: BorderSide(color: KothonColors.numpadDivColor),
                    // top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '3',
                        style: style1,
                      ),
                      Text(
                        'DEF',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '3';
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// KEY 4 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    // left: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '4',
                        style: style1,
                      ),
                      Text(
                        'GHI',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '4';
                    });
                  },
                ),
              ),

              /// KEY 5 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '5',
                        style: style1,
                      ),
                      Text(
                        'JKL',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '5';
                    });
                  },
                ),
              ),

              /// KEY 6 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    // right: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '6',
                        style: style1,
                      ),
                      Text(
                        'MNO',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '6';
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// KEY 7 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    // left: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '7',
                        style: style1,
                      ),
                      Text(
                        'PQRS',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '7';
                    });
                  },
                ),
              ),

              /// KEY 8 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '8',
                        style: style1,
                      ),
                      Text(
                        'TUV',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '8';
                    });
                  },
                ),
              ),

              /// KEY 9 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    bottom: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '9',
                        style: style1,
                      ),
                      Text(
                        'WXYZ',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '9';
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// KEY */+ ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(
                      color: KothonColors.numpadDivColor,
                    ),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '*';
                    });
                  },
                  child: Center(
                    child: Icon(
                      CommunityMaterialIcons.asterisk,
                      size: 30,
                    ),
                  ),
                ),
              ),

              /// KEY 0 ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                    right: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Column(
                    children: [
                      Text(
                        '0',
                        style: style1,
                      ),
                      Text(
                        '+',
                        style: style2,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '0';
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      dialNum = dialNum + '+';
                    });
                  },
                ),
              ),

              /// KEY # ///
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: KothonColors.numpadDivColor),
                    top: BorderSide(color: KothonColors.numpadDivColor),
                  ),
                ),
                child: MaterialButton(
                  height: 100,
                  minWidth: 100,
                  child: Text(
                    '#',
                    style: style1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      dialNum = dialNum + '#';
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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
