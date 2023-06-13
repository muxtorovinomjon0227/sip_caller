import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/data/models/contact_model.dart';
// import 'package:kothon_app/data/models/contact_model.dart';
import 'package:kothon_app/data/models/history_model.dart';
import 'package:kothon_app/data/models/speed_dial_model.dart';
import 'package:kothon_app/logic/cubit/contact_cubit.dart';
import 'package:kothon_app/logic/cubit/contact_storage_cubit.dart';
// import 'package:kothon_app/logic/cubit/contact_storage_cubit.dart';
import 'package:kothon_app/logic/cubit/history_cubit.dart';
import 'package:kothon_app/logic/cubit/speed_dial_cubit.dart';
import 'package:kothon_app/presentation/common_widgets/show_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class Contacts extends StatefulWidget {
  final SIPUAHelper _helper;

  const Contacts(this._helper, {Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> implements SipUaHelperListener {
  // Iterable<Contact> _contacts;
  var temp;
  // List<ContactModel> _contactModelList;

  List<ContactModel> _contactModelList;

  Future<void> getContacts() async {
    // Make sure we already have permissions for contacts when we get to
    // this page. Then we retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    // setState(() {
    //   _contacts = contacts;
    // });
    context.read<ContactCubit>().contactLoad(contacts);

    context.read<ContactStorageCubit>().removeAllContacts();

    // testing purpose

    for (int i = 0; i < contacts.length; i++) {
      context.read<ContactStorageCubit>().addContact(ContactModel(
          contacts.elementAt(i).displayName,
          contacts
              .elementAt(i)
              .phones
              .firstWhere((element) => element != null)
              .value));
    }
  }

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
    // getContacts();
  }

  @override
  void deactivate() {
    helper.removeSipUaHelperListener(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // var sHeight = MediaQuery.of(context).size.height;
    var sWidth = MediaQuery.of(context).size.width;
    //
    _contactModelList =
        context.watch<ContactStorageCubit>().state.contactModelList;

    return Scaffold(
      body: BlocConsumer<ContactStorageCubit, ContactStorageState>(
        listener: (context, state) {
          //
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
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
                        'Contact List',
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
                          await getContacts();
                        }),
                  ],
                ),
              ),
              (_contactModelList.length < 1)
                  ? Flexible(
                      child: Center(
                        child: TextButton(
                          child: Text(
                            'Click Here to import contact list',
                            style: TextStyle(color: Colors.black87),
                          ),
                          onPressed: () async {
                            await getContacts();
                          },
                        ),
                      ),
                    )
                  : Flexible(
                      child: Container(
                        // padding: EdgeInsets.only(top: 40),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.black,
                              height: 2,
                            ),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _contactModelList.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading:
                                    // (contact.avatar != null && contact.avatar.isNotEmpty)
                                    // ? CircleAvatar(
                                    // backgroundImage: MemoryImage(contact.avatar),
                                    // )
                                    // :
                                    CircleAvatar(
                                  child: Text(
                                      _contactModelList[index].displayName[0]),
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                ),
                                title: Text(
                                    _contactModelList[index].displayName ??
                                        'No Name'),
                                // subtitle: Text(contact.phones.elementAt(0).value),
                                // subtitle: Text((contact.phones.length > 0)
                                //     ? contact.phones.first.value
                                //     : "No contact"),
                                subtitle:
                                    Text(_contactModelList[index].contactNo),

                                onTap: () {
                                  showTheBottomSheet(
                                    context: context,
                                    contactName:
                                        _contactModelList[index].displayName ??
                                            'No Name',
                                    contactNumber:
                                        _contactModelList[index].contactNo,
                                  );
                                },
                                // contentPadding: EdgeInsets.all(10),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  showTheBottomSheet({
    BuildContext context,
    String contactName,
    String contactNumber,
  }) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.6),
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

                          //============================== Connection Check ============================//
                          if (EnumHelper.getName(helper.registerState.state) !=
                              'Registered') {
                            Navigator.pop(context);
                            futureToast(
                                context: context,
                                message:
                                    'Please connect to your office network!');
                            return null;
                          }

                          context.read<HistoryCubit>().addHistory(HistoryModel(
                              contactName,
                              dialNum,
                              DateTimeFormat.format(DateTime.now(),
                                  format: 'M j, Y, h:i a')));

                          Navigator.pop(context);

                          if (EnumHelper.getName(helper.registerState.state) !=
                              'Registered') {
                            futureToast(
                                context: context,
                                message:
                                    'Please connect to your office network!');
                            return null;
                          }

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

                          //============================== Connection Check ============================//
                          if (EnumHelper.getName(helper.registerState.state) !=
                              'Registered') {
                            Navigator.pop(context);
                            futureToast(
                                context: context,
                                message:
                                    'Please connect to your office network!');
                            return null;
                          }

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
                        backgroundColor: KothonColors.greenBtn,
                        elevation: 0,
                        child: FaIcon(FontAwesomeIcons.plus),
                        onPressed: () {
                          context
                              .read<SpeedDialCubit>()
                              .addSpeedDial(SpeedDialModel(
                                name: contactName,
                                contact: contactNumber,
                              ));
                          Navigator.pop(context);
                          futureToast(
                              context: context, message: "Added to speed dial");
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Speed Dial',
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
