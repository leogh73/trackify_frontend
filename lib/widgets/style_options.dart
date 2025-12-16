import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';

import '../widgets/dialog_toast.dart';
import '../widgets/style_dark_mode.dart';
import '../widgets/style_view.dart';
import '../widgets/style_color.dart';

class StyleOptions extends StatelessWidget {
  const StyleOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final Map<String, String> translate = {
      "Color": "color",
      "Vista": "view",
      "Modo": "mode",
      "View": "view",
      "Mode": "mode",
    };
    final List<Map<String, dynamic>> menuData = [
      {
        "text": "Color",
        "icon": Icons.palette,
      },
      {
        "text": texts[181],
        "icon": Icons.view_quilt,
      },
      {
        "text": texts[182],
        "icon": Icons.brightness_4,
      }
    ];
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return PopupMenuButton<String>(
      constraints: const BoxConstraints.expand(width: 125, height: 125),
      icon: const Icon(Icons.brush),
      iconSize: 25,
      tooltip: texts[183],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 2,
      onSelected: (String value) {
        switch (value) {
          case "color":
            ShowDialog.styleDialog(
              context,
              isPortrait,
              const StyleColor(),
              texts,
            );
            break;
          case 'view':
            ShowDialog.styleDialog(
              context,
              isPortrait,
              const StyleView(),
              texts,
            );
            break;
          case 'mode':
            ShowDialog.styleDialog(
              context,
              isPortrait,
              const StyleDarkMode(),
              texts,
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => menuData
          .map(
            (e) => PopupMenuItem<String>(
              value: translate[e['text']],
              height: 35,
              child: SizedBox(
                width: 82,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        e["icon"],
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    Text(e["text"],
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color)),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
