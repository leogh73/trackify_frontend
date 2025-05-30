import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';
import '../widgets/ad_native.dart';
import '../data/services.dart';
import '../data/status.dart';

class EventsList extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  final String service;
  const EventsList(this.events, this.service, {Key? key}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late ScrollController _controller;

  _scrollListener() {
    if (_controller.offset == _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      Provider.of<Status>(context, listen: false).toggleEventsEndStatus(true);
    } else {
      Provider.of<Status>(context, listen: false).toggleEventsEndStatus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 2, right: 2, left: 2),
        controller: _controller,
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          return Event(
            widget.events[index],
            index,
            widget.events.length,
            index == widget.events.length,
            Provider.of<Services>(context, listen: false)
                .eventData(widget.service, widget.events[index]),
          );
        },
      ),
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
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    bool lastItem = false;
    if (listLength - 1 == index) lastItem = true;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    const Widget smallAd = Padding(
      child: AdNative("small"),
      padding: EdgeInsets.zero,
    );
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        children: [
          if (index == 0 && !premiumUser) ...[
            smallAd,
            SizedBox(height: 3),
            smallAd
          ],
          if (index == 0 && !premiumUser)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
          SizedBox(
            height: isPortrait ? 40 : 42,
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
                            ? screenWidth * 0.445
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
                                          top: 2, bottom: 2, right: 15),
                                      // width: 158,
                                      child: Text(
                                        event['date']!,
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
                            ? screenWidth * 0.445
                            : screenWidth * 0.225,
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 7),
                                  child: Icon(Icons.access_time),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 2, bottom: 2),
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
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
          if (!premiumUser) ...[smallAd, SizedBox(height: 5), smallAd],
          if (!lastItem)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
        ],
      ),
    );
  }
}
