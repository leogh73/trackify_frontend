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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoggedIn) DriveBackupsList(backupsData),
        Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: isPortrait
              ? Column(
                  children: [
                    if (text.isNotEmpty) screenText(text, fullHD),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: SizedBox(
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
                    ),
                    if (isLoggedIn)
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: SizedBox(
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
                      ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (text.isNotEmpty)
                      Expanded(
                        child: Padding(
                          child: screenText(text, fullHD),
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 5),
                          child: SizedBox(
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
                        ),
                        if (isLoggedIn)
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 10),
                            child: SizedBox(
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
                          ),
                      ],
                    ),
                    // Padding(
                    //     child: AdNative("medium"),
                    //     padding: EdgeInsets.only(bottom: 8)),
                  ],
                ),
        ),
        // Padding(child: AdNative("medium"), padding: EdgeInsets.only(bottom: 8)),
      ],
    );
  }
}
