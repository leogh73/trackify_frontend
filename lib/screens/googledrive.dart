import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:trackify/widgets/ad_banner.dart';
import 'package:trackify/widgets/drive_account.dart';
import 'package:trackify/widgets/drive_content.dart';

import '../providers/preferences.dart';
import '../providers/status.dart';

class GoogleDrive extends StatefulWidget {
  const GoogleDrive({Key? key}) : super(key: key);

  @override
  State<GoogleDrive> createState() => _GoogleDriveState();
}

class _GoogleDriveState extends State<GoogleDrive> {
  late bool isLoggedIn = false;

  Future googleAccount(String action, BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
      "https://www.googleapis.com/auth/drive.appdata",
      'https://www.googleapis.com/auth/drive.file'
    ]);
    GoogleSignInAccount? userAccount;
    if (action == "login") {
      userAccount = await _googleSignIn.signIn();
      if (userAccount != null) {
        Provider.of<Preferences>(context, listen: false).initializeGoogle(
          context,
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
      userAccount = await _googleSignIn.signOut();
      setState(() {
        isLoggedIn = true;
      });
      return Provider.of<Preferences>(context, listen: false)
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
    final bool driveStatus = Provider.of<Preferences>(context).gdStatus;
    final String driveEmail = Provider.of<Status>(context).googleEmail;
    final bool errorCheckDrive =
        Provider.of<Preferences>(context).errorOperationGD;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    String description =
        "Puede usar su cuenta de Google Drive para crear una copia de seguridad de sus seguimientos y preferencias, por cada dispositivo donde instale la aplicaci??n. Luego podr?? restaurar ??stos datos si cambia de dispositivo, o reinstala la aplicaci??n.";
    // print(email);
    // final gdrive.DriveApi driveApi =
    //     Provider.of<Preferences>(context).getDriveApi!;
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
            onPressed: driveStatus
                ? () => googleAccount('logout', context)
                : () => googleAccount('login', context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isPortrait && !driveStatus)
            Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 20, left: 25),
                  height: screenWidth * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.cloud_queue, size: 80),
                      Text(
                        description,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 1),
          if (!isPortrait && !driveStatus)
            Container(
              padding: const EdgeInsets.only(
                  right: 15, left: 20, top: 10, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        child: const Icon(Icons.cloud_queue, size: 80),
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      flex: 1),
                  const SizedBox(width: 25),
                  Expanded(
                      child: Container(
                        child: screenText(description, fullHD),
                        padding: const EdgeInsets.only(right: 20),
                      ),
                      flex: 6),
                ],
              ),
            ),
          driveStatus
              ? errorCheckDrive
                  ? DriveContent(
                      context,
                      false,
                      'Error de consulta a GoogleDrive',
                      'REINTENTAR',
                      () => Provider.of<Preferences>(context, listen: false)
                          .toggleGDErrorStatus(false),
                      null,
                    )
                  : const GoogleDriveAccount()
              : DriveContent(
                  context,
                  false,
                  'No ha ingresado a GoogleDrive',
                  'INGRESAR',
                  () => googleAccount("login", context),
                  null,
                )
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}
