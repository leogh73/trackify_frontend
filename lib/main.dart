import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'initial_data.dart';

import 'providers/preferences.dart';
import 'providers/theme.dart';
import 'providers/status.dart';
import 'providers/trackings_active.dart';
import 'providers/trackings_archived.dart';
import '/providers/tracking_functions.dart';

import 'screens/main_screen.dart';

import '../widgets/ad_interstitial.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await dotenv.load();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    name: "TrackeAR",
    options: FirebaseOptions(
      apiKey: "${dotenv.env['FIRBASE_API_KEY']}",
      appId: "${dotenv.env['FIREBASE_APP_ID']}",
      messagingSenderId: "${dotenv.env['FIREBASE_MS_SENDER_ID']}",
      projectId: "${dotenv.env['FIREBASE_PROJECT_ID']}",
    ),
  );

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
                  create: (context) =>
                      UserPreferences(snapshot.data as StartData),
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
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 12,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, top: 20, bottom: 20),
                        child: Image.asset('assets/icon/icon.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: const CircularProgressIndicator(),
                    ),
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
  final GlobalKey<NavigatorState> navKey = GlobalKey();
  AdInterstitial? interstitialAd = AdInterstitial();
  late String userId;

  void firebaseSettings(context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        TrackingFunctions.loadNotificationData(
            false, message, navKey.currentContext!);
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
      TrackingFunctions.loadNotificationData(
          false, message, navKey.currentContext!);
    });
  }

  void syncData() async {
    Future.delayed(
      const Duration(seconds: 2),
      () => TrackingFunctions.syncronizeUserData(navKey.currentContext!),
    );
  }

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(
      (state) {
        if (state == AppState.foreground) {
          syncData();
          interstitialAd?.showInterstitialAd();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    userId = Provider.of<UserPreferences>(context, listen: false).userId;
    if (userId.isEmpty) {
      Provider.of<Status>(context, listen: false)
          .setStartError('User not initialized');
    }
    firebaseSettings(context);
    syncData();
    listenToAppStateChanges();
    interstitialAd?.createInterstitialAd();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     interstitialAd?.showInterstitialAd();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final MaterialColor mainColor = Provider.of<UserTheme>(context).startColor;
    final bool darkMode = Provider.of<UserTheme>(context).darkModeStatus;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    return MaterialApp(
      title: 'TrackeAR',
      navigatorKey: navKey,
      theme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: mainColor),
        switchTheme: const SwitchThemeData(),
        primarySwatch: mainColor,
        iconTheme: IconThemeData(color: mainColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
      ),
      darkTheme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: mainColor),
        primarySwatch: mainColor,
        primaryColor: mainColor,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: mainColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(userId),
    );
  }
}
