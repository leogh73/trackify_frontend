import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';
import '../data/tracking_functions.dart';

import '../widgets/ad_native.dart';

class EventsList extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  final String service;
  const EventsList(this.events, this.service, {Key? key}) : super(key: key);

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  bool expanded = true;

  List<Map<String, dynamic>> eventData(
      String service, Map<dynamic, String> event) {
    const Map<String, IconData> iconsData = {
      "location": Icons.place,
      "motive": Icons.description,
      "sign": Icons.description,
      "condition": Icons.description,
      "description": Icons.local_shipping,
      "detail": Icons.local_shipping,
      "status": Icons.local_shipping,
      "place": Icons.location_city,
      "branch": Icons.location_city,
    };
    List<String> keys = event.keys.map((k) => k.toString()).toList();
    keys.removeWhere((k) => k == "date");
    keys.removeWhere((k) => k == "time");
    final List<Map<String, dynamic>> eventData = [];
    for (String key in keys) {
      eventData.add({
        "icon": iconsData[key],
        "text": event[key],
      });
    }
    return eventData;
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: isPortrait ? screenWidth : screenWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                child: Icon(MdiIcons.calendarMultiple),
              ),
              Container(
                alignment: Alignment.center,
                width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    texts[264],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 2, right: 2, left: 2),
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                return Event(
                  widget.events[index],
                  index,
                  widget.events.length,
                  index == widget.events.length,
                  eventData(widget.service, widget.events[index]),
                );
              },
            ),
          )
      ],
    );
  }
}

class Event extends StatelessWidget {
  final Map<dynamic, String> event;
  final int index;
  final int listLength;
  final bool lastItem;
  final List<Map<String, dynamic>> eventData;
  const Event(
      this.event, this.index, this.listLength, this.lastItem, this.eventData,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formatedDate =
        TrackingFunctions.formatEventDate(context, event['date']!);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    bool lastItem = false;
    if (listLength - 1 == index) lastItem = true;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        children: [
          if (index == 0 && !premiumUser)
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: AdNative("small"),
            ),
          if (index == 0 && !premiumUser)
            Divider(color: Theme.of(context).primaryColor, thickness: .5),
          SizedBox(
            height: isPortrait ? 45 : 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: isPortrait
                      ? const EdgeInsets.only(
                          left: 6, right: 8, bottom: 8, top: 8)
                      : const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isPortrait
                            ? screenWidth * 0.52
                            : screenWidth * 0.351,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.calendar_today),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 1, bottom: 1, right: 15),
                                      // width: 158,
                                      child: Text(
                                        formatedDate,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: fullHD ? 16 : 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: isPortrait
                            ? screenWidth * 0.35
                            : screenWidth * 0.225,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 7),
                                  child: Icon(Icons.access_time),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 1, bottom: 1),
                                      // width: 158,
                                      child: Text(
                                        event['time']!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: fullHD ? 16 : 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...eventData
              .map(
                (event) => Padding(
                  padding: isPortrait
                      ? const EdgeInsets.all(8)
                      : const EdgeInsets.only(
                          left: 9, right: 8, bottom: 10, top: 6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(event["icon"], size: 20),
                          SizedBox(
                            width: screenWidth - 62,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                              ),
                              child: Text(
                                event['text'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(fontSize: fullHD ? 16 : 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          if (!premiumUser)
            Divider(color: Theme.of(context).primaryColor, thickness: .5),
          if (!premiumUser)
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: AdNative("medium"),
            ),
          if (!lastItem)
            Divider(color: Theme.of(context).primaryColor, thickness: .5),
        ],
      ),
    );
  }
}
