import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:trackify/providers/tracking_functions.dart';
import 'package:trackify/screens/services_status.dart';
import 'package:trackify/widgets/ad_interstitial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'providers/preferences.dart';
import 'providers/theme.dart';
import 'providers/status.dart';
import 'providers/trackings_active.dart';
import 'providers/trackings_archived.dart';

import 'screens/main_screen.dart';
import 'screens/archived.dart';
import 'screens/search.dart';

import 'initial_data.dart';

void main() async {
  await dotenv.load();
  tz.initializeTimeZones();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
      name: "TrackeAR",
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

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  AdInterstitial interstitialAd = AdInterstitial();

  void firebaseSettings(context) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      print(newToken);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        TrackingFunctions.loadNotificationData(
            false, message, navigatorKey.currentContext!);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        TrackingFunctions.loadNotificationData(true, message, context);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      TrackingFunctions.loadNotificationData(false, message, context);
    });
  }

  void listenToAppStateChanges(BuildContext context, AdInterstitial intAd) {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(
      (state) => {
        if (state == AppState.foreground)
          TrackingFunctions.syncronizeUserData(context, intAd),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    String userId = Provider.of<Preferences>(context, listen: false).userId;
    print("USERID_$userId");
    if (userId.isEmpty)
      Provider.of<Status>(context, listen: false)
          .setStartError('User not created');
    firebaseSettings(context);
    interstitialAd.createInterstitialAd();
    listenToAppStateChanges(context, interstitialAd);
    Future.delayed(
      const Duration(seconds: 2),
      () => TrackingFunctions.syncronizeUserData(context, null),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) ;
  // }

  @override
  Widget build(BuildContext context) {
    MaterialColor mainColor = Provider.of<UserTheme>(context).startColor;
    bool darkMode = Provider.of<UserTheme>(context).darkModeStatus;
    String userId = Provider.of<Preferences>(context, listen: false).userId;
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
      home: MainScreen(userId),
      routes: {
        MainScreen.routeName: (context) => MainScreen(userId),
        Archived.routeName: (context) => const Archived(),
        Search.routeName: (context) => const Search(),
      },
    );
  }
}
