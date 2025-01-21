import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';
import 'dialog_toast.dart';
import '../widgets/ad_native.dart';
import '../data/status.dart';

class DriveBackupsList extends StatelessWidget {
  final List<dynamic> backupsData;
  const DriveBackupsList(this.backupsData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return backupsData.isEmpty
        ? Center(
            child: isPortrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_off, size: 60),
                      SizedBox(width: 20, height: 20),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'No se encontraron respaldos en su cuenta.',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_off, size: 60),
                      SizedBox(width: 40, height: 20),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'No se encontraron respaldos en su cuenta.',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          )
        : Container(
            height: 200,
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 2, right: 2, left: 2),
              itemCount: backupsData.length,
              itemBuilder: (context, index) =>
                  BackupItem(backupsData[index], index),
              // shrinkWrap: _verificando,
            ),
          );
  }
}

class BackupItem extends StatelessWidget {
  final Map<String, dynamic> backup;
  final int index;
  const BackupItem(this.backup, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return backup['date'] == null
        ? Center(
            child: isPortrait
                ? Column(
                    children: [
                      Padding(
                        padding: index == 0
                            ? const EdgeInsets.all(20)
                            : const EdgeInsets.only(top: 40),
                        child: const Icon(Icons.cloud_off, size: 70),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          index == 0
                              ? 'No se encontraron respaldos de éste dispositivo.'
                              : 'No se encontraron otros respaldos en su cuenta.',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      if (index != 1)
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Divider(
                            color: Theme.of(context).primaryColor,
                            thickness: 0.7,
                          ),
                        ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 70),
                          const SizedBox(width: 40, height: 40),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              index == 0
                                  ? 'No se encontraron respaldos de éste dispositivo.'
                                  : 'No se encontraron otros respaldos en su cuenta.',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      if (index != 1)
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Divider(
                            color: Theme.of(context).primaryColor,
                            thickness: 0.7,
                          ),
                        ),
                    ],
                  ),
          )
        : Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: backup['selected'] ? Colors.black12 : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.16,
                      child: Container(
                        child: const Icon(
                          Icons.cloud_done,
                          size: 35,
                        ),
                        padding: isPortrait
                            ? const EdgeInsets.only(
                                left: 25,
                              )
                            : const EdgeInsets.only(
                                left: 10,
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 5, bottom: 10),
                      width: isPortrait
                          ? screenWidth * 0.555
                          : screenWidth * 0.655,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              backup['currentDevice']
                                  ? "Respaldo de éste dispositivo"
                                  : "Otro respaldo",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fullHD ? 17 : 16,
                              ),
                            ),
                          ),
                          Text(
                            "Nombre de dispositivo: ${backup['deviceModel']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: fullHD ? 16 : 15,
                            ),
                          ),
                          Text(
                            "Fecha: ${backup['date']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: fullHD ? 16 : 15,
                            ),
                          ),
                          Text(
                            "Activos: ${backup['activeTrackings']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: fullHD ? 16 : 15,
                            ),
                          ),
                          Text(
                            "Archivados: ${backup['archivedTrackings']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: fullHD ? 16 : 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: backup['selected']
                          ? Icon(Icons.check_box,
                              size: 32, color: Theme.of(context).primaryColor)
                          : Icon(
                              Icons.check_box_outline_blank,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                      onPressed: () =>
                          Provider.of<Status>(context, listen: false)
                              .selectBackup(backup['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever, size: 32),
                      onPressed: () =>
                          ShowDialog.deleteDriveBackup(context, backup['id']),
                    ),
                  ],
                ),
              ),
              if (backup['currentDevice'])
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 0.7,
                  ),
                ),
              if (!premiumUser)
                Padding(
                  child: AdNative("medium"),
                  padding: EdgeInsets.only(bottom: 8),
                ),
            ],
          );
  }
}
