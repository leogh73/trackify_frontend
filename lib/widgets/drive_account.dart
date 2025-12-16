import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:trackify/widgets/dialog_toast.dart';

import '../database.dart';
import '../data/http_connection.dart';
import '../data/tracking_functions.dart';
import '../data/status.dart';
import '../data/../data/preferences.dart';

import 'dialog_error.dart';
import '../widgets/drive_content.dart';

class GoogleDriveAccount extends StatefulWidget {
  const GoogleDriveAccount({Key? key}) : super(key: key);

  @override
  State<GoogleDriveAccount> createState() => _GoogleDriveAccountState();
}

class _GoogleDriveAccountState extends State<GoogleDriveAccount> {
  late Future checkDrive;
  bool restoringBackup = false;

  List<Map<String, dynamic>> loadFetchedData(response, bool login) {
    final Map<String, dynamic> googleData = json.decode(response.body);
    if (googleData['backups'].isNotEmpty) {
      Provider.of<Status>(context, listen: false)
          .loadGoogleBackups(googleData['backups'], login);
    }
    Provider.of<Status>(context, listen: false)
        .setGoogleEmail(googleData['email']);
    return googleData['backups'];
  }

  Future checkDriveAccount() async {
    final BuildContext ctx = context;
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    final Object body = {
      'userId': userId,
    };
    final Response response =
        await HttpConnection.requestHandler('/api/googledrive/consult', body);
    if (response.statusCode == 200) {
      return loadFetchedData(response, true);
    } else {
      if (!ctx.mounted) {
        return;
      }
      Provider.of<UserPreferences>(ctx, listen: false)
          .toggleGDErrorStatus(true);
      final Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, ctx);
      if (responseData['serverError'] == null) {
        DialogError.show(ctx, 12, "");
      }
    }
  }

  Future createUpdateBackup() async {
    final BuildContext ctx = context;
    Provider.of<Status>(ctx, listen: false).toggleGoogleProcess(true);
    final Response response =
        await TrackingFunctions.updateCreateDriveBackup(false, context);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    if (response.statusCode == 200) {
      final List<dynamic> backupsData =
          Provider.of<Status>(ctx, listen: false).googleUserData;
      if (backupsData.isEmpty) {
        backupsData.insert(0, responseData);
      } else {
        backupsData[0] = responseData;
      }
      if (backupsData.length == 1) {
        backupsData.insert(1, {'date': null, 'currentDevice': false});
      }
      Provider.of<Status>(ctx, listen: false)
          .loadGoogleBackups(backupsData, false);
    } else {
      Provider.of<UserPreferences>(ctx, listen: false)
          .toggleGDErrorStatus(true);
      if (responseData['serverError'] == null) {
        DialogError.show(ctx, 12, "");
      }
    }
    Provider.of<Status>(ctx, listen: false).toggleGoogleProcess(false);
  }

  @override
  void initState() {
    super.initState();
    checkDrive = checkDriveAccount();
    Provider.of<Status>(context, listen: false).cleanSelectedBackup();
  }

  void restoreDialog(
      bool fullHD, String selectedBackup, Map<int, dynamic> texts) {
    ShowDialog.restoreDriveBackup(
      context,
      selectedBackup,
      restoringBackup
          ? [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
              Text(
                'Restaurando...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: fullHD ? 16 : 15,
                ),
              ),
            ]
          : [
              Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const Icon(Icons.error_outline, size: 55)),
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  texts[154]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fullHD ? 16 : 15,
                  ),
                ),
              )
            ],
      () async {
        setState(() {
          restoringBackup = true;
        });
        final BuildContext ctx = context;
        await StoredData().restoreBackupData(ctx, selectedBackup);
        if (!ctx.mounted) {
          return;
        }
        Phoenix.rebirth(ctx);
      },
      texts,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool onGoogleProcess =
        context.select((Status status) => status.onProcessStatus);
    final List<dynamic> backupData =
        context.select((Status status) => status.googleUserData);
    final String selectedBackup =
        context.select((Status status) => status.selectedBackup);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: checkDrive,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return onGoogleProcess
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 25),
                        child: const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Text(
                        texts[155]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: fullHD ? 16 : 15,
                        ),
                      ),
                    ],
                  ),
                )
              : DriveContent(
                  context,
                  true,
                  backupData.isEmpty ? texts[156]! : texts[157]!,
                  backupData.isEmpty || backupData[0]['date'] == null
                      ? texts[158]!
                      : texts[159]!,
                  () => createUpdateBackup(),
                  backupData.isEmpty || selectedBackup.isEmpty
                      ? null
                      : () => restoreDialog(fullHD, selectedBackup, texts),
                );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                ),
                Text(
                  texts[160]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: fullHD ? 16 : 15,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
