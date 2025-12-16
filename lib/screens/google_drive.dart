import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../data/classes.dart';
import '../data/trackings_active.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/drive_account.dart';
import '../widgets/drive_content.dart';

import '../data/../data/preferences.dart';
import '../data/status.dart';

class GoogleDrive extends StatefulWidget {
  const GoogleDrive({Key? key}) : super(key: key);

  @override
  State<GoogleDrive> createState() => _GoogleDriveState();
}

class _GoogleDriveState extends State<GoogleDrive> {
  late bool isLoggedIn = false;

  AdInterstitial adInterstitial = AdInterstitial();

  @override
  void initState() {
    super.initState();
    adInterstitial.createInterstitialAd();
  }

  Future googleAccount(String action) async {
    final BuildContext ctx = context;
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      "https://www.googleapis.com/auth/drive.appdata",
      'https://www.googleapis.com/auth/drive.file'
    ]);
    GoogleSignInAccount? userAccount;
    if (action == "login") {
      userAccount = await googleSignIn.signIn();
      if (userAccount != null) {
        if (!ctx.mounted) {
          return;
        }
        Provider.of<UserPreferences>(ctx, listen: false).initializeGoogle(
          ctx,
          userAccount.serverAuthCode!,
          userAccount.email,
        );
        setState(() {
          isLoggedIn = true;
        });
      } else {
        return;
      }
    } else {
      userAccount = await googleSignIn.signOut();
      setState(() {
        isLoggedIn = false;
      });
      if (!ctx.mounted) {
        return;
      }
      Provider.of<UserPreferences>(ctx, listen: false)
          .toggleGoogleStatus(false);
    }
  }

  void showEmailToast(email) {
    showToast(email,
        context: context,
        borderRadius: BorderRadius.circular(20),
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToRight,
        position: StyledToastPosition.top,
        startOffset: const Offset(1.0, 0.0),
        reverseEndOffset: const Offset(1.0, 0.0),
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final bool driveStatus = context
        .select((UserPreferences userPreferences) => userPreferences.gdStatus);
    final bool errorCheckDrive = context.select(
        (UserPreferences userPreferences) => userPreferences.errorOperationGD);
    final String driveEmail =
        context.select((Status status) => status.googleEmail);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Drive"),
        titleSpacing: 1.0,
        actions: [
          if (driveStatus)
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () => showEmailToast(driveEmail),
              tooltip: driveEmail,
            ),
          IconButton(
            icon: driveStatus
                ? const Icon(Icons.logout)
                : const Icon(Icons.login),
            onPressed: () {
              if (!premiumUser && trackingsList.isNotEmpty) {
                adInterstitial.showInterstitialAd();
              }
              driveStatus ? googleAccount('logout') : googleAccount('login');
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 60),
                child: premiumUser ? null : const AdNative("small"),
              ),
              if (isPortrait && !driveStatus)
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 25),
                  height: screenWidth * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.cloud_queue, size: 80),
                      Text(
                        texts[35]!,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isPortrait && !driveStatus)
                Container(
                  padding: const EdgeInsets.only(
                      right: 15, left: 20, top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: const Icon(Icons.cloud_queue, size: 80),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 20),
                          child: screenText(texts[35]!, fullHD),
                        ),
                      ),
                    ],
                  ),
                ),
              driveStatus
                  ? errorCheckDrive
                      ? DriveContent(
                          context,
                          false,
                          texts[36]!,
                          texts[37]!,
                          () => Provider.of<UserPreferences>(context,
                                  listen: false)
                              .toggleGDErrorStatus(false),
                          null,
                        )
                      : const GoogleDriveAccount()
                  : DriveContent(
                      context,
                      false,
                      '',
                      texts[38]!,
                      () {
                        if (!premiumUser && trackingsList.isNotEmpty) {
                          adInterstitial.showInterstitialAd();
                        }
                        googleAccount("login");
                      },
                      null,
                    ),
              if (!premiumUser && trackingsList.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: AdNative("medium"),
                ),
              const SizedBox(width: 50, height: 180),
            ],
          ),
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
