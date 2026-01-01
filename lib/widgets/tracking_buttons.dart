import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/tracking_options.dart';

import '../data/classes.dart';
import '../data/preferences.dart';

class TrackingDetaiilButtons extends StatefulWidget {
  final ItemTracking tracking;
  const TrackingDetaiilButtons(this.tracking, {Key? key}) : super(key: key);

  @override
  State<TrackingDetaiilButtons> createState() => _TrackingDetaiilButtonsState();
}

class _TrackingDetaiilButtonsState extends State<TrackingDetaiilButtons> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        SizedBox(
          width: isPortrait ? screenWidth : screenWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                child: Icon(MdiIcons.dotsVerticalCircleOutline),
              ),
              Container(
                alignment: Alignment.center,
                width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    texts[268],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(
                width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                child: IconButton(
                  onPressed: () => setState(() {
                    expanded = !expanded;
                  }),
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ),
              )
            ],
          ),
        ),
        if (expanded)
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1.5,
          ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrackingOptions(
                  tracking: widget.tracking,
                  option: "elevatedButtons",
                  action: "rename",
                  detail: true,
                ),
                if (widget.tracking.archived == false)
                  TrackingOptions(
                    tracking: widget.tracking,
                    option: "elevatedButtons",
                    action: "archive",
                    detail: true,
                  ),
                TrackingOptions(
                  tracking: widget.tracking,
                  option: "elevatedButtons",
                  action: "remove",
                  detail: true,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ResponseRow extends StatelessWidget {
  final String rowKey;
  final String rowValue;
  const ResponseRow(this.rowKey, this.rowValue, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: isPortrait ? screenWidth * 0.2535 : screenWidth * 0.15,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                rowKey,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: fullHD ? 16 : 15,
                ),
              ),
            ),
          ),
          SizedBox(
            width: isPortrait ? screenWidth * 0.635 : screenWidth * 0.78,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                rowValue,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                  fontSize: fullHD ? 16 : 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
