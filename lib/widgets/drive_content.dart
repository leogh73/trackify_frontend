import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';
import '../widgets/drive_backups_list.dart';
import '../data/status.dart';
import 'ad_native.dart';

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
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final List<dynamic> backupsData =
        context.select((Status status) => status.googleUserData);
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
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      child: SizedBox(
                        width: isLoggedIn ? 260 : 172,
                        child: ElevatedButton(
                          onPressed: createUpdate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isLoggedIn
                                  ? const Icon(Icons.cloud_upload)
                                  : const Icon(Icons.login),
                              const SizedBox(width: 15),
                              screenText(button, fullHD),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isLoggedIn)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: SizedBox(
                          width: 260,
                          child: ElevatedButton(
                            onPressed: restoreBackup,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLoggedIn
                                    ? const Icon(Icons.cloud_download)
                                    : const Icon(Icons.login),
                                const SizedBox(width: 15),
                                screenText(texts[169]!, fullHD),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (!premiumUser)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: AdNative("medium"),
                      ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (text.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: screenText(text, fullHD),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 5),
                          child: SizedBox(
                            width: 260,
                            child: ElevatedButton(
                              onPressed: createUpdate,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isLoggedIn
                                      ? const Icon(Icons.cloud_upload)
                                      : const Icon(Icons.login),
                                  const SizedBox(width: 15),
                                  screenText(button, fullHD),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isLoggedIn)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: SizedBox(
                              width: 260,
                              child: ElevatedButton(
                                onPressed: restoreBackup,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isLoggedIn
                                        ? const Icon(Icons.cloud_download)
                                        : const Icon(Icons.login),
                                    const SizedBox(width: 15),
                                    screenText(texts[169]!, fullHD),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!premiumUser)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: AdNative("medium"),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
