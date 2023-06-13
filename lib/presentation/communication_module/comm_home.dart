import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/logic/cubit/comm_bottom_nav_cubit.dart';
// import 'package:kothon_app/presentation/communication_module/page_view_items/dial_pad.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kothon_app/logic/cubit/comm_bottom_nav_cubit.dart';
import 'package:kothon_app/presentation/communication_module/widgets/comm_bottom_nav.dart';
import 'package:kothon_app/presentation/common_widgets/kothon_header.dart';
import 'package:kothon_app/presentation/communication_module/page_view_items/call_history.dart';
import 'package:kothon_app/presentation/communication_module/page_view_items/contacts.dart';
import 'package:kothon_app/presentation/communication_module/page_view_items/messages.dart';
import 'package:kothon_app/presentation/communication_module/page_view_items/speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class CommunicationHome extends StatefulWidget {
  final SIPUAHelper _helper;

  const CommunicationHome(this._helper, {Key key}) : super(key: key);

  @override
  _CommunicationHomeState createState() => _CommunicationHomeState();
}

class _CommunicationHomeState extends State<CommunicationHome>
    implements SipUaHelperListener {
  //
  final pageController = PageController(initialPage: 1);
  // final SIPUAHelper _helper = SIPUAHelper();

  String _dest;
  SIPUAHelper get helper => widget._helper;
  TextEditingController _textController;
  SharedPreferences _preferences;

  String receivedMsg;

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    _dest = _preferences.getString('dest') ?? 'sip:hello_jssip@tryit.jssip.net';
    _textController = TextEditingController(text: _dest);
    _textController.text = _dest;

    this.setState(() {});
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
    //
    // var btnId = context.watch<CommBottomNavCubit>().state.btnNo;

    final sHeight = MediaQuery.of(context).size.height;
    // final sWidth = MediaQuery.of(context).size.width;
    //
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: KothonHeader(),
          ),
          Container(
            padding: EdgeInsets.only(top: sHeight * 0.1),
            child: PageView(
              controller: pageController,
              pageSnapping: true,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                print(value);
                context.read<CommBottomNavCubit>().changeId(value);
              },
              children: [
                SpeedDial(helper),
                History(helper),
                Contacts(helper),
                Messages(),
              ],
            ),
          ),
          Align(
            // bottom: 10,
            // right: sWidth * 0.345,
            alignment: Alignment.bottomCenter,

            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Dial Pad ///
                  FloatingActionButton(
                    heroTag: 'tag1',
                    backgroundColor: KothonColors.greenBtn,
                    elevation: 0,
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DialPadWidget(_helper)));
                      Navigator.pushNamed(context, '/dialpad');
                    },
                    child: Icon(
                      CommunityMaterialIcons.dialpad,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),

                  /// Conference Call ///
                  FloatingActionButton(
                    heroTag: 'tag2',
                    backgroundColor: KothonColors.greenBtn,
                    elevation: 0,
                    onPressed: () {},
                    child: Icon(
                      CommunityMaterialIcons.account_group,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CommBottomNav(
        speedDialFunc: () {
          context.read<CommBottomNavCubit>().changeId(0);
          pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          );
        },
        historyFunc: () {
          context.read<CommBottomNavCubit>().changeId(1);
          pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          );
        },
        contactsFunc: () {
          context.read<CommBottomNavCubit>().changeId(2);
          pageController.animateToPage(
            2,
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          );
        },
        messagesFunc: () {
          context.read<CommBottomNavCubit>().changeId(3);
          pageController.animateToPage(
            3,
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
          );
        },
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
