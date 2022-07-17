import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drive_backups_list.dart';
import '../providers/status.dart';

Text screenText(String text, bool fullHD) {
  return Text(
    text,
    maxLines: 5,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: fullHD ? 17 : 16,
    ),
  );
}

class DriveContent extends StatelessWidget {
  final BuildContext context;
  final bool isLoggedIn;
  final String text;
  final String button;
  final VoidCallback? createUpdate;
  final VoidCallback? restoreBackup;
  const DriveContent(this.context, this.isLoggedIn, this.text, this.button,
      this.createUpdate, this.restoreBackup,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> backupsData =
        Provider.of<Status>(context).googleUserData;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Expanded(
      child: Column(
        children: [
          if (isLoggedIn)
            Expanded(flex: 5, child: DriveBackupsList(backupsData)),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              color: Theme.of(context).primaryColor,
              thickness: 0.7,
            ),
          ),
          if (!isLoggedIn)
            Container(
              padding: const EdgeInsets.only(
                  right: 15, left: 20, top: 10, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        child: const Icon(Icons.cloud_off_outlined, size: 50),
                        padding: const EdgeInsets.only(right: 10),
                      ),
                      flex: 1),
                  const SizedBox(width: 25),
                  Expanded(
                      child: Container(
                        child: screenText('No hay datos para mostrar', fullHD),
                        padding: const EdgeInsets.only(right: 20),
                      ),
                      flex: 6),
                ],
              ),
            ),
          if (!isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Divider(
                color: Theme.of(context).primaryColor,
                thickness: 0.7,
              ),
            ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: isPortrait
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        screenText(text, fullHD),
                        SizedBox(
                          width: isLoggedIn ? 260 : 172,
                          child: ElevatedButton(
                            child: Row(
                              children: [
                                isLoggedIn
                                    ? const Icon(Icons.cloud_upload)
                                    : const Icon(Icons.login),
                                const SizedBox(width: 15),
                                screenText(button, fullHD),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            onPressed: createUpdate,
                          ),
                        ),
                        if (isLoggedIn)
                          SizedBox(
                            width: 260,
                            child: ElevatedButton(
                              child: Row(
                                children: [
                                  isLoggedIn
                                      ? const Icon(Icons.cloud_download)
                                      : const Icon(Icons.login),
                                  const SizedBox(width: 15),
                                  screenText('RESTAURAR RESPALDO', fullHD),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onPressed: restoreBackup,
                            ),
                          ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: screenText(text, fullHD), flex: 5),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 260,
                                child: ElevatedButton(
                                  child: Row(
                                    children: [
                                      isLoggedIn
                                          ? const Icon(Icons.cloud_upload)
                                          : const Icon(Icons.login),
                                      const SizedBox(width: 15),
                                      screenText(button, fullHD),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  onPressed: createUpdate,
                                ),
                              ),
                              if (isLoggedIn)
                                SizedBox(
                                  width: 260,
                                  child: ElevatedButton(
                                    child: Row(
                                      children: [
                                        isLoggedIn
                                            ? const Icon(Icons.cloud_download)
                                            : const Icon(Icons.login),
                                        const SizedBox(width: 15),
                                        screenText(
                                            'RESTAURAR RESPALDO', fullHD),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                    onPressed: restoreBackup,
                                  ),
                                ),
                            ],
                          ),
                          flex: 4,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
