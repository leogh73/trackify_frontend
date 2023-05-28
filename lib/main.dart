import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'providers/preferences.dart';
import 'providers/theme.dart';
import 'providers/status.dart';
import 'providers/trackings_active.dart';
import 'providers/trackings_archived.dart';

import 'screens/main.dart';
import 'screens/archived.dart';
import 'screens/search.dart';

import 'initial_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  tz.initializeTimeZones();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
      name: "Trackify",
      options: FirebaseOptions(
        apiKey: "${dotenv.env['FIRBASE_API_KEY']}",
        appId: "${dotenv.env['FIREBASE_APP_ID']}",
        messagingSenderId: "${dotenv.env['FIREBASE_MS_SENDER_ID']}",
        projectId: "${dotenv.env['FIREBASE_PROJECT_ID']}",
      ));

  runApp(
    Phoenix(child: const TrackeAR()),
  );
}

class TrackeAR extends StatelessWidget {
  const TrackeAR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: FutureBuilder(
        future: Init.loadStartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => Status(snapshot.data as StartData),
                ),
                ChangeNotifierProvider(
                  create: (context) => Preferences(snapshot.data as StartData),
                ),
                ChangeNotifierProvider(
                  create: (context) => UserTheme(snapshot.data as StartData),
                ),
                ChangeNotifierProvider(
                  create: (context) =>
                      ActiveTrackings(snapshot.data as StartData),
                ),
                ChangeNotifierProvider(
                  create: (context) =>
                      ArchivedTrackings(snapshot.data as StartData),
                ),
              ],
              child: const App(),
            );
          } else {
            return Material(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(140),
                      child: Image.asset('assets/icon/icon.png'),
                    ),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  void startSettings(context) async {
    ActiveTrackings activeTrackings =
        Provider.of<ActiveTrackings>(context, listen: false);
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      print(newToken);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        activeTrackings.loadNotificationData(false, message,
            navigatorKey.currentState, navigatorKey.currentContext!);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        activeTrackings.loadNotificationData(true, message,
            navigatorKey.currentState, navigatorKey.currentContext!);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      activeTrackings.loadNotificationData(false, message,
          navigatorKey.currentState, navigatorKey.currentContext!);
    });
  }

  void startSync(BuildContext context) async {
    Provider.of<ActiveTrackings>(context, listen: false)
        .sincronizeUserData(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startSettings(context);
    Future.delayed(const Duration(seconds: 2), () => startSync(context));
    print("RESTARTED!");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        navigatorKey.currentContext != null) {
      startSync(navigatorKey.currentContext!);
      String error = Provider.of<ActiveTrackings>(navigatorKey.currentContext!,
              listen: false)
          .loadStartError;
      if (error == 'User not found') {
        ShowDialog(navigatorKey.currentContext!).disabledUserError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor mainColor = Provider.of<UserTheme>(context).startColor;
    bool darkMode = Provider.of<UserTheme>(context).darkModeStatus;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    return MaterialApp(
      title: 'TrackeAR',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: mainColor),
        switchTheme: const SwitchThemeData(),
        primarySwatch: mainColor,
        // accentColor: mainColor,
        // accentColorBrightness: Brightness.light,
        iconTheme: IconThemeData(color: mainColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
      ),
      darkTheme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: mainColor),
        primarySwatch: mainColor,
        primaryColor: mainColor,
        // accentColor: mainColor,
        brightness: Brightness.dark,
        // accentColorBrightness: Brightness.light,
        iconTheme: IconThemeData(color: mainColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const Main(),
      routes: {
        Main.routeName: (context) => const Main(),
        Archived.routeName: (context) => const Archived(),
        Search.routeName: (context) => const Search(),
      },
    );
  }
}
