import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/status.dart';

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
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No se encontraron respaldos en su cuenta.',
                          style: TextStyle(fontSize: 20),
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
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No se encontraron respaldos en su cuenta.',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
          )
        : Padding(
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

  void deleteDialog(BuildContext context, bool fullHD, String id) {
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
          content: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(Icons.error_outline, size: 45),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: Text(
                  '¿Desea eliminar éste respaldo? Ésta acción no puede deshacerse.',
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.only(bottom: 9, top: 2),
                      child: ElevatedButton(
                        child: const Text(
                          "ELIMINAR",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () => {
                          Navigator.of(context).pop(),
                          Provider.of<Status>(context, listen: false)
                              .deleteBackup(context, id),
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
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return backup['date'] == null
        ? Center(
            child: isPortrait
                ? Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: index == 0
                            ? const EdgeInsets.all(20)
                            : const EdgeInsets.only(top: 40),
                        child: const Icon(Icons.cloud_off, size: 70),
                      ),

                      // SizedBox(width: 40, height: 40),
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
                          deleteDialog(context, fullHD, backup['id']),
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
            ],
          );
  }
}

// List<Widget> backupsWidgets(
//     backupData, screenWidth, isPortrait, fullHD, isLoggedIn) {
//   List<Widget> backupsList = [];
//   if (backupData == null) {
//     if (isPortrait) {
//       backupsList.add(
//         Row(
//           children: [
//             SizedBox(
//               width: screenWidth * 0.16,
//               child: Container(
//                 child: const Icon(
//                   Icons.cloud_off_outlined,
//                   size: 35,
//                 ),
//                 padding: isPortrait
//                     ? const EdgeInsets.only(
//                         left: 25,
//                       )
//                     : const EdgeInsets.only(
//                         left: 10,
//                       ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
//               width: screenWidth * 0.785,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: isLoggedIn
//                         ? const EdgeInsets.only(bottom: 6)
//                         : const EdgeInsets.only(top: 6, bottom: 6),
//                     child: Text(
//                       "Respaldo",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: fullHD ? 17 : 16,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "Sin datos",
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 3,
//                     style: TextStyle(
//                       fontSize: fullHD ? 16 : 15,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     if (!isPortrait) {
//       backupsList.add(
//         Row(
//           children: [
//             Expanded(
//               child: SizedBox(
//                 width: screenWidth * 0.16,
//                 child: Container(
//                   child: const Icon(
//                     Icons.cloud_off_outlined,
//                     size: 35,
//                   ),
//                   padding: isPortrait
//                       ? const EdgeInsets.only(
//                           left: 25,
//                         )
//                       : const EdgeInsets.only(
//                           left: 10,
//                         ),
//                 ),
//               ),
//               flex: 1,
//             ),
//             Expanded(
//               flex: 4,
//               child: Container(
//                 padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: isLoggedIn
//                           ? const EdgeInsets.only(bottom: 6)
//                           : const EdgeInsets.only(top: 6, bottom: 6),
//                       child: Text(
//                         "Respaldo",
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: fullHD ? 17 : 16,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "Sin datos",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         fontSize: fullHD ? 16 : 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: SizedBox(
//                 width: screenWidth * 0.16,
//                 child: Container(
//                   child: Icon(
//                     isLoggedIn ? Icons.account_circle : Icons.no_accounts,
//                     size: 35,
//                   ),
//                   padding: isPortrait
//                       ? const EdgeInsets.only(
//                           left: 25,
//                         )
//                       : const EdgeInsets.only(
//                           left: 10,
//                         ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Container(
//                 padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 6, bottom: 6),
//                       child: Text(
//                         "Cuenta",
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: fullHD ? 17 : 16,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "Sin datos",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         fontSize: fullHD ? 16 : 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   } else {
//     for (Map<String, dynamic> backup in backupData) {
//       backupsList.add(
//         Row(
//           children: [
//             SizedBox(
//               width: screenWidth * 0.16,
//               child: Container(
//                 child: Icon(
//                   isLoggedIn
//                       ? backup['date'] != "Sin datos"
//                           ? Icons.cloud_done
//                           : Icons.cloud_off_outlined
//                       : Icons.cloud_off_outlined,
//                   size: 35,
//                 ),
//                 padding: isPortrait
//                     ? const EdgeInsets.only(
//                         left: 25,
//                       )
//                     : const EdgeInsets.only(
//                         left: 10,
//                       ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
//               width: screenWidth * 0.785,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: isLoggedIn
//                         ? const EdgeInsets.only(bottom: 6)
//                         : const EdgeInsets.only(top: 6, bottom: 6),
//                     child: Text(
//                       "Respaldo",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: fullHD ? 17 : 16,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     isLoggedIn && backup['date'] != "Sin datos"
//                         ? "Fecha: ${backup['date']}"
//                         : "Sin datos",
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 3,
//                     style: TextStyle(
//                       fontSize: fullHD ? 16 : 15,
//                     ),
//                   ),
//                   if (isLoggedIn && backup['active'] != 'null')
//                     Text(
//                       "Activos: ${backup['active']}",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         fontSize: fullHD ? 16 : 15,
//                       ),
//                     ),
//                   if (isLoggedIn && backup['archived'] != 'null')
//                     Text(
//                       "Archivados: ${backup['archived']}",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         fontSize: fullHD ? 16 : 15,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//   return backupsList;
// }
