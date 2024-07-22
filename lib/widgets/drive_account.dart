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
import '../data/preferences.dart';

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
    Map<String, dynamic> googleData = json.decode(response.body);
    if (googleData['backups'].isNotEmpty) {
      Provider.of<Status>(context, listen: false)
          .loadGoogleBackups(googleData['backups'], login);
    }
    Provider.of<Status>(context, listen: false)
        .setGoogleEmail(googleData['email']);
    return googleData['backups'];
  }

  Future checkDriveAccount() async {
    String _userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'userId': _userId,
    };
    Response response =
        await HttpConnection.requestHandler('/api/googledrive/consult', body);
    if (response.statusCode == 200) {
      return loadFetchedData(response, true);
    } else {
      Provider.of<UserPreferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      Map<String, dynamic> responseData =
          HttpConnection.responseHandler(response, context);
      if (responseData['errorDisplayed'] == false)
        DialogError.googleDriveError(context);
    }
  }

  Future createUpdateBackup() async {
    Provider.of<Status>(context, listen: false).toggleGoogleProcess(true);
    Response response =
        await TrackingFunctions.updateCreateDriveBackup(false, context);
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> backupsData =
          Provider.of<Status>(context, listen: false).googleUserData;
      if (backupsData.isEmpty) {
        backupsData.insert(0, data);
      } else {
        backupsData[0] = data;
      }
      if (backupsData.length == 1) {
        backupsData.insert(1, {'date': null, 'currentDevice': false});
      }
      Provider.of<Status>(context, listen: false)
          .loadGoogleBackups(backupsData, false);
    } else {
      Provider.of<UserPreferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      if (response.body == "Server timeout") {
        return DialogError.serverTimeout(context);
      }
      if (response.body.startsWith("error")) {
        return DialogError.serverError(context);
      }
      DialogError.googleDriveError(context);
    }
    Provider.of<Status>(context, listen: false).toggleGoogleProcess(false);
  }

  @override
  void initState() {
    super.initState();
    checkDrive = checkDriveAccount();
    Provider.of<Status>(context, listen: false).cleanSelectedBackup();
  }

  void restoreDialog(bool fullHD, String selectedBackup) {
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
                  child: Icon(Icons.error_outline, size: 55)),
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  '¿Confirma restaurar respaldo encontrado? Se borrarán todos los datos actuales y la aplicación se reiniciará.',
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
        await StoredData().restoreBackupData(context, selectedBackup);
        Phoenix.rebirth(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool onGoogleProcess = Provider.of<Status>(context).onProcessStatus;
    final List<dynamic> backupData =
        Provider.of<Status>(context).googleUserData;
    final String selectedBackup = Provider.of<Status>(context).selectedBackup;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: checkDrive,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // print(backupData);
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
                        'En proceso...',
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
                  backupData.isEmpty
                      ? "Se creará un respaldo automáticamente, pero si lo desea, puede crear uno ahora."
                      : "Se actualizará el respaldo de éste dispositivo automáticamente, pero si lo desea, puede actualizarlo manualmente o restaurar otro respaldo de su cuenta.",
                  backupData.isEmpty || backupData[0]['date'] == null
                      ? "CREAR RESPALDO"
                      : "ACTUALIZAR RESPALDO",
                  () => createUpdateBackup(),
                  backupData.isEmpty || selectedBackup.isEmpty
                      ? null
                      : () => restoreDialog(fullHD, selectedBackup),
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
                  'Consultando...',
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
