import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kothon_app/constants/custom_page_route.dart';
import 'package:kothon_app/logic/cubit/contact_storage_cubit.dart';
import 'package:kothon_app/logic/cubit/history_cubit.dart';
import 'package:kothon_app/logic/cubit/speed_dial_cubit.dart';
import 'package:kothon_app/presentation/communication_module/comm_home.dart';
import 'package:kothon_app/presentation/communication_module/page_view_items/dial_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sip_ua/sip_ua.dart';

import 'package:kothon_app/logic/cubit/comm_bottom_nav_cubit.dart';
import 'package:kothon_app/logic/cubit/contact_cubit.dart';
import 'package:kothon_app/logic/cubit/internet_cubit.dart';
import 'package:kothon_app/logic/cubit/toggle_button_cubit.dart';
import 'package:kothon_app/presentation/splash/splash_screen.dart';
import 'package:kothon_app/sip_ua/about.dart';
import 'package:kothon_app/sip_ua/callscreen.dart';
// import 'package:kothon_app/sip_ua/dialpad.dart';
import 'package:kothon_app/sip_ua/register.dart';
// import 'package:transition/transition.dart' as tos;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(MyApp(
    connectivity: Connectivity(),
  ));
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper helper, Object arguments]);

class MyApp extends StatefulWidget {
  final Connectivity connectivity;
  MyApp({
    Key key,
    @required this.connectivity,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SIPUAHelper _helper = SIPUAHelper();

  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper helper, Object arguments]) => SplashScreen(),
    // '/dialpad': ([SIPUAHelper helper, Object arguments]) =>
    //     DialPadWidget(helper),
    '/dialpad': ([SIPUAHelper helper, Object arguments]) => DialPadPage(helper),
    '/register': ([SIPUAHelper helper, Object arguments]) =>
        RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper helper, Object arguments]) =>
        CallScreenWidget(helper, arguments as Call),
    '/about': ([SIPUAHelper helper, Object arguments]) => AboutWidget(),
    '/commHome': ([SIPUAHelper helper, Object arguments]) =>
        CommunicationHome(helper),
  };

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final String name = settings.name;
    final PageContentBuilder pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) =>
                pageContentBuilder(_helper, settings.arguments));
        return route;
      } else {
        // final Route route = MaterialPageRoute<Widget>(
        //     builder: (context) => pageContentBuilder(_helper));
        final Route route =
            CustomPageRoute(widget: pageContentBuilder(_helper));
        return route;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ToggleButtonCubit(),
        ),
        BlocProvider(
          create: (context) => InternetCubit(connectivity: widget.connectivity),
        ),
        BlocProvider(
          create: (context) => CommBottomNavCubit(),
        ),
        BlocProvider(
          create: (context) => ContactCubit(),
        ),
        BlocProvider(
          create: (context) => SpeedDialCubit(),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(),
        ),
        BlocProvider(
          create: (context) => ContactStorageCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Kothon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF59E8F1),
          scaffoldBackgroundColor: Color(0xFFF9FAC7),
          fontFamily: 'Nunito',
        ),
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}
