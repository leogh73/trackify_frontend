import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/theme.dart';

class StyleDarkMode extends StatelessWidget {
  const StyleDarkMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkMode =
        context.select((UserTheme theme) => theme.darkModeStatus);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Icon(
          darkMode ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 35,
          child: Switch(
            activeColor: Colors.grey[500],
            value: darkMode,
            onChanged: (_) =>
                Provider.of<UserTheme>(context, listen: false).toggleDarkMode(),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
