import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trackify/widgets/dialog_toast.dart';

import 'initial_data.dart';
import 'database.dart';

import 'data/classes.dart';
import 'data/preferences.dart';
import 'data/theme.dart';
import 'data/services.dart';
import 'data/status.dart';
import 'data/tracking_functions.dart';
import 'data/trackings_active.dart';
import 'data/trackings_archived.dart';

import 'screens/main_screen.dart';

import 'widgets/ad_interstitial.dart';

void main() async {
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
                  create: (context) => Services(snapshot.data as StartData),
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
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: CircularProgressIndicator(color: Colors.teal),
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
  final AdInterstitial? interstitialAd = AdInterstitial();
  late Map<String, dynamic> servicesData;
  bool isPremium = false;

  void firebaseSettings(context) {
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

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(
      (state) async {
        if (state == AppState.foreground) {
          List<ItemTracking> trackingsList =
              await StoredData().loadActiveTrackings();
          if (!isPremium && trackingsList.isNotEmpty) {
            interstitialAd?.showInterstitialAd();
            ShowDialog.goPremiumDialog(navKey.currentContext!);
          }
          Future.delayed(
            const Duration(seconds: 2),
            () => TrackingFunctions.syncronizeUserData(navKey.currentContext!),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    firebaseSettings(context);
    listenToAppStateChanges();
    interstitialAd?.createInterstitialAd();
  }

  void togglePremiumStatus() {
    setState(() {
      isPremium = !isPremium;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    if (premiumUser != isPremium) togglePremiumStatus();
    final MaterialColor mainColor =
        context.select((UserTheme theme) => theme.startColor);
    final bool darkMode =
        context.select((UserTheme theme) => theme.darkModeStatus);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
    return MaterialApp(
      title: texts[1]!,
      navigatorKey: navKey,
      theme: ThemeData(
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
        appBarTheme: AppBarTheme(
          backgroundColor: mainColor,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle:
              TextStyle(color: Colors.white, fontSize: fullHD ? 19 : 17),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: mainColor,
          foregroundColor: Colors.white,
          splashColor: Colors.white,
        ),
        iconTheme: IconThemeData(color: mainColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
        disabledColor: Colors.grey[700],
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.grey[100]),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.grey[100],
          elevation: 2,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        dialogBackgroundColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.grey[100],
        drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[100]),
        tabBarTheme: TabBarTheme(
          dividerHeight: 0,
          indicator: const UnderlineTabIndicator(
            insets: EdgeInsets.only(bottom: 0.5),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          labelPadding: EdgeInsets.zero,
          labelColor: Colors.white,
          unselectedLabelColor: mainColor.shade100,
        ),
        primaryColor: mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.grey),
            bodyLarge: TextStyle(color: Colors.grey)),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white10,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle:
              TextStyle(color: Colors.white, fontSize: fullHD ? 19 : 17),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: mainColor,
          foregroundColor: Colors.white,
          splashColor: Colors.white,
        ),
        iconTheme: IconThemeData(color: mainColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.grey[800]),
        ),
        disabledColor: Colors.white12,
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.grey[800],
          elevation: 2,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        dialogBackgroundColor: Colors.grey[850],
        scaffoldBackgroundColor: Colors.grey[850],
        drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[850]),
        tabBarTheme: const TabBarTheme(
          dividerHeight: 0,
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.only(bottom: 0.5),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          labelPadding: EdgeInsets.zero,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
        ),
        primaryColor: mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
      // home: const FormAdd(storeName: ""),
    );
  }
}
