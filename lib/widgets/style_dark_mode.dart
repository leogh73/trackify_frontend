import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/theme.dart';

class StyleDarkMode extends StatelessWidget {
  const StyleDarkMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Provider.of<UserTheme>(context).darkModeStatus;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Icon(
          darkMode ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 4),
        SizedBox(
          height: 45,
          child: Switch(
            value: darkMode,
            onChanged: (_) =>
                Provider.of<UserTheme>(context, listen: false).toggleDarkMode(),
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }
}
