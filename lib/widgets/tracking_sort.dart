import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';
import '../data/theme.dart';

class TrackingSort extends StatefulWidget {
  final bool activeTrackings;
  const TrackingSort(this.activeTrackings, {Key? key}) : super(key: key);

  @override
  State<TrackingSort> createState() => _TrackingSortState();
}

class _TrackingSortState extends State<TrackingSort> {
  bool reverseList = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<int, dynamic> texts =
          Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
      final int option = Provider.of<UserPreferences>(context, listen: false)
          .sortTrackingsOption;
      Provider.of<UserPreferences>(context, listen: false)
          .sortTrackingsList(texts[option]!, context, widget.activeTrackings);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final List<String> menuOptions =
        Provider.of<UserPreferences>(context, listen: false)
            .sortOptionsList(texts);
    final MaterialColor mainColor =
        context.select((UserTheme theme) => theme.startColor);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final int sortTrackingsOption = context.select(
        (UserPreferences userPreferences) =>
            userPreferences.sortTrackingsOption);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          SizedBox(
            height: 24,
            width: isPortrait ? screenWidth * .77 : screenWidth * .35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      reverseList = !reverseList;
                    });
                    Provider.of<UserPreferences>(context, listen: false)
                        .reverseTrackingsList(context, widget.activeTrackings);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: reverseList
                            ? Icon(MdiIcons.sortDescending, size: 18)
                            : Icon(MdiIcons.sortAscending, size: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: Text(
                                texts[204]!,
                                style: TextStyle(
                                  fontSize: fullHD ? 16 : 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButton(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  iconEnabledColor: mainColor,
                  value: texts[sortTrackingsOption],
                  isDense: true,
                  borderRadius: BorderRadius.circular(10),
                  underline: Container(),
                  onChanged: (dynamic option) {
                    if (texts[sortTrackingsOption] == option) {
                      return;
                    }
                    setState(() {
                      reverseList = false;
                    });
                    Provider.of<UserPreferences>(context, listen: false)
                        .sortTrackingsList(
                            option, context, widget.activeTrackings);
                  },
                  items: menuOptions
                      .map<DropdownMenuItem<String>>((String option) {
                    return DropdownMenuItem<String>(
                        value: option,
                        child: SizedBox(
                          child: Text(
                            option,
                            style: TextStyle(
                                fontSize: fullHD ? 16 : 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color),
                          ),
                        ));
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Divider(
              color: Theme.of(context).primaryColor,
              thickness: .15,
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionModel {
  final String text;
  final int value;
  OptionModel(this.text, this.value);
}
