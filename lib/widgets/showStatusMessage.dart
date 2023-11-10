import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences.dart';

class ShowAgainStatusMessage extends StatelessWidget {
  const ShowAgainStatusMessage({super.key});

  void toggleShowMessage(BuildContext context, bool showMessageAgain) {
    Provider.of<UserPreferences>(context, listen: false)
        .setShowMessageAgain(showMessageAgain);
  }

  @override
  Widget build(BuildContext context) {
    bool? showMessageAgain =
        Provider.of<UserPreferences>(context).showMessageAgain;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => toggleShowMessage(context, !showMessageAgain!),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showMessageAgain!
                ? Icon(Icons.check_box_outline_blank)
                : Icon(Icons.check_box),
            SizedBox(width: 10),
            Container(
              width: 180,
              child: Text(
                "No volver a mostrar éste mensaje.",
                maxLines: 2,
                style: TextStyle(
                    fontSize: fullHD ? 16 : 15, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
