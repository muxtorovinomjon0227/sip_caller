import 'package:flutter/material.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/presentation/common_widgets/kothon_header.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterWidget extends StatefulWidget {
  final SIPUAHelper _helper;
  RegisterWidget(this._helper, {Key key}) : super(key: key);
  @override
  _MyRegisterWidget createState() => _MyRegisterWidget();
}

class _MyRegisterWidget extends State<RegisterWidget>
    implements SipUaHelperListener {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _wsUriController = TextEditingController();
  TextEditingController _sipUriController = TextEditingController();
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _authorizationUserController = TextEditingController();
  Map<String, String> _wsExtraHeaders = {
    'Origin': "http://cld.alovoice.uz",
    'Host': "cld.alovoice.uz:61040"
  };
  SharedPreferences _preferences;
  RegistrationState _registerState;

  SIPUAHelper get helper => widget._helper;

  @override
  initState() {
    super.initState();
    _registerState = helper.registerState;
    helper.addSipUaHelperListener(this);
    _loadSettings();
  }

  @override
  deactivate() {
    super.deactivate();
    helper.removeSipUaHelperListener(this);
    _saveSettings();
  }

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    this.setState(() {
      _wsUriController.text =
          _preferences.getString('ws_uri') ?? 'wss://cld.alovoice.uz:61040/ws';
      _sipUriController.text =
          _preferences.getString('sip_uri') ?? 'sip:3006@cld.alovoice.uz';
      _displayNameController.text =
          _preferences.getString('display_name') ?? 'kothon_trunk';
      _passwordController.text = _preferences.getString('password') ?? "8b1e39";
      _authorizationUserController.text = _preferences.getString('auth_user') ?? '3006';
    });
  }

  void _saveSettings() {
    _preferences.setString('ws_uri', _wsUriController.text);
    _preferences.setString('sip_uri', _sipUriController.text);
    _preferences.setString('display_name', _displayNameController.text);
    _preferences.setString('password', _passwordController.text);
    _preferences.setString('auth_user', _authorizationUserController.text);
    // custom nb
    _preferences.setString('serverIP', _sipUriController.text.split('@')[1]);
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    this.setState(() {
      _registerState = state;
    });
  }

  void _alert(BuildContext context, String alertFieldName) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$alertFieldName is empty'),
          content: Text('Please enter $alertFieldName!'),
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
  }

  void _handleSave(BuildContext context) {
    if (_wsUriController.text == null) {
      _alert(context, "WebSocket URL");
    } else if (_sipUriController.text == null) {
      _alert(context, "SIP URI");
    }

    UaSettings settings = UaSettings();

    settings.webSocketUrl = _wsUriController.text;
    settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
    settings.webSocketSettings.allowBadCertificate = true;
    settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';

    settings.uri = _sipUriController.text;
    settings.authorizationUser = _authorizationUserController.text;
    settings.password = _passwordController.text;
    settings.displayName = _displayNameController.text;
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;
    settings.iceServers = [{'url': 'stun:stun.l.google.com:19302'}];
    // settings.iceGatheringTimeout = 1000;
    helper.start(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("SIP Account"),
        // ),
        body: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: KothonHeader(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 18.0, 48.0, 18.0),
                  child: Center(
                      child: Text(
                    'Register Status: ${EnumHelper.getName(_registerState.state)}',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 18.0, 48.0, 0),
                  child: Align(
                    child: Text('WebSocket:'),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                  child: TextFormField(
                    controller: _wsUriController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                  child: Align(
                    child: Text('SIP URI:'),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                  child: TextFormField(
                    controller: _sipUriController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                  child: Align(
                    child: Text('Authorization User:'),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                  child: TextFormField(
                    controller: _authorizationUserController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                      hintText:
                          _authorizationUserController.text?.isEmpty ?? true
                              ? '[Empty]'
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                  child: Align(
                    child: Text('Password:'),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                      hintText: _passwordController.text?.isEmpty ?? true
                          ? '[Empty]'
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                  child: Align(
                    child: Text('Display Name:'),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                  child: TextFormField(
                    controller: _displayNameController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 40.0,
              width: 160.0,
              child: MaterialButton(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: KothonColors.barIconColor,
                textColor: Colors.white,
                onPressed: () => _handleSave(context),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40.0,
              width: 160.0,
              child: MaterialButton(
                child: Text(
                  'Unregister',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () {
                  helper.stop();
                },
              ),
            )
          ]),
    ));
  }

  @override
  void callStateChanged(Call call, CallState state) {
    //NO OP
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // NO OP
  }
}
