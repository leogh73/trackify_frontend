import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';

class ShowMessageAgain extends StatelessWidget {
  final String type;
  const ShowMessageAgain(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool showStatusMessageAgain =
        Provider.of<UserPreferences>(context).showStatusMessageAgain;
    final bool showPaymentErrorAgain =
        Provider.of<UserPreferences>(context).showPaymentErrorAgain;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => type == "status"
            ? Provider.of<UserPreferences>(context, listen: false)
                .setShowStatusMessageAgain(!showStatusMessageAgain)
            : Provider.of<UserPreferences>(context, listen: false)
                .setShowPaymentErrorAgain(!showPaymentErrorAgain),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            type == "status"
                ? showStatusMessageAgain
                    ? Icon(Icons.check_box_outline_blank)
                    : Icon(Icons.check_box)
                : showPaymentErrorAgain
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
