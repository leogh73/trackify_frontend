import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/database.dart';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:trackify/providers/tracking_functions.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:trackify/widgets/drive_content.dart';

import '../providers/status.dart';
import '../providers/preferences.dart';

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
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {
      'userId': _userId,
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/google/consult', body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
    if (response.statusCode == 200) {
      return loadFetchedData(response, true);
    } else {
      Provider.of<Preferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      ShowDialog(context).googleDriveError();
    }
  }

  Future createUpdateBackup() async {
    Provider.of<Status>(context, listen: false).toggleGoogleProcess(true);
    var response =
        await TrackingFunctions.updateCreateDriveBackup(false, context);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
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
      Provider.of<Preferences>(context, listen: false)
          .toggleGDErrorStatus(true);
      ShowDialog(context).googleDriveError();
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
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: restoringBackup
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
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
                          'Restaurando...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: fullHD ? 16 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Icon(Icons.error_outline, size: 45),
                    ),
                    Container(
                      width: 245,
                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                      child: Text(
                        '¿Confirma restaurar respaldo encontrado? Se borrarán todos los datos actuales y la aplicación se reiniciará.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD ? 16 : 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            padding: const EdgeInsets.only(bottom: 9, top: 2),
                            child: ElevatedButton(
                                child: const Text(
                                  'CANCELAR',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () => {
                                      Navigator.pop(context),
                                    }),
                          ),
                          Container(
                            width: 120,
                            padding: const EdgeInsets.only(bottom: 9, top: 2),
                            child: ElevatedButton(
                              child: const Text(
                                "RESTAURAR",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              onPressed: () async {
                                setState(() {
                                  restoringBackup = true;
                                });
                                restoreDialog(fullHD, selectedBackup);
                                await StoredData()
                                    .restoreBackupData(context, selectedBackup);
                                Phoenix.rebirth(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final String driveEmail = Provider.of<Status>(context).googleEmail;
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
