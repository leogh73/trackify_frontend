import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';

class ShowPaymentMessageAgain extends StatelessWidget {
  const ShowPaymentMessageAgain({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool showPaymentErrorAgain = context.select(
        (UserPreferences userPreferences) =>
            userPreferences.showPaymentErrorAgain);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => Provider.of<UserPreferences>(context, listen: false)
            .setShowPaymentErrorAgain(!showPaymentErrorAgain),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showPaymentErrorAgain
                ? const Icon(Icons.check_box_outline_blank)
                : const Icon(Icons.check_box),
            const SizedBox(width: 10),
            SizedBox(
              width: 180,
              child: Text(
                texts[202]!,
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
