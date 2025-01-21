import 'package:flutter/material.dart';
import 'package:trackify/widgets/dialog_toast.dart';
import 'package:trackify/widgets/style_dark_mode.dart';
import 'package:trackify/widgets/style_view.dart';
import 'package:trackify/widgets/style_color.dart';

class OptionsStyle extends StatelessWidget {
  const OptionsStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuData = [
      {
        "text": "Color",
        "icon": Icons.palette,
      },
      {
        "text": "Vista",
        "icon": Icons.view_compact,
      },
      {
        "text": "Modo",
        "icon": Icons.brightness_4,
      }
    ];
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return PopupMenuButton<String>(
      icon: Icon(Icons.brush),
      iconSize: 25,
      // padding: EdgeInsets.zero,
      tooltip: 'Aspecto',
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 2,
      onSelected: (String value) {
        switch (value) {
          case 'Color':
            ShowDialog.styleDialog(context, isPortrait, StyleColor());
            break;
          case 'Vista':
            ShowDialog.styleDialog(context, isPortrait, StyleView());
            break;
          case 'Modo':
            ShowDialog.styleDialog(context, isPortrait, StyleDarkMode());
            break;
        }
      },
      itemBuilder: (BuildContext context) => menuData
          .map(
            (e) => PopupMenuItem<String>(
              value: e['text'],
              height: 35,
              child: Container(
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
                    Text(e["text"]),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
