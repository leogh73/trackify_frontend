import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/status.dart';

import '../widgets/details_other.dart';
import '../widgets/data_response.dart';

class Andreani {
  List<Map<String, String>> generateEventList(eventsResponse) {
    List<Map<String, String>> events = [];
    Map<String, String> event;
    eventsResponse.forEach((e) => {
          event = {
            "date": e["date"],
            "time": e["time"],
            "condition": e["condition"],
            "motive": e["motive"],
            "location": e["location"],
          },
          events.add(event)
        });
    return events;
  }

  ItemResponseData createResponse(dynamic data) {
    String lastEvent = data['lastEvent'];
    List<List<String>> otherData = [];
    List<Map<String, String>> events = generateEventList(data['events']);
    List<String> lastVisit = [
      data["visits"]['visits'][0]?["date"] ?? "Sin datos",
      data["visits"]['visits'][0]?["time"] ?? "Sin datos",
      data["visits"]['visits'][0]?["motive"] ?? "Sin datos",
    ];
    List<String> pendingVisits = [
      data["visits"]?["pendingVisits"].toString() ?? "Sin datos"
    ];
    otherData.add(lastVisit);
    otherData.add(pendingVisits);

    String checkDate = data['checkDate'];
    String checkTime = data['checkTime'];
    String trackingId = data['trackingId'];

    return ItemResponseData(
      events,
      lastEvent,
      otherData,
      checkDate,
      checkTime,
      trackingId,
    );
  }

  ItemResponseData lastEvent(dynamic data) {
    List<Map<String, String>> events =
        generateEventList(data['result']['events']);
    List<List<String>> otherData = [];
    List<String> lastVisit = [];
    if (data['result']["visits"]?["visits"].isNotEmpty)
      lastVisit = [
        data['result']["visits"]?["visits"][0]["date"] ?? "Sin datos",
        data['result']["visits"]?["visits"][0]["time"] ?? "Sin datos",
        data['result']["visits"]?["visits"][0]["motive"] ?? "Sin datos",
      ];
    List<String> pendingVisits = [
      data['result']["visits"]?["pendingVisits"].toString() ?? "Sin datos"
    ];
    otherData.add(lastVisit);
    otherData.add(pendingVisits);
    String lastEvent = data['result']['lastEvent'];

    return ItemResponseData(events, lastEvent, otherData, null, null, null);
  }
}

class MoreDataAndreani extends StatelessWidget {
  final List<List<String>>? otherData;
  const MoreDataAndreani(this.otherData, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          OtherData(
            DataRowHandler(
              otherData![0],
              [
                "Fecha",
                "Hora",
                "Motivo",
              ],
            ).createTable(),
            "ULTIMA VISITA",
          ),
          OtherData(
            DataRowHandler(
              otherData![1],
              ["Pendientes"],
            ).createTable(),
            "VISITAS PENDIENTES",
          ),
        ],
      ),
    );
  }
}

class EventListAndreani extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  const EventListAndreani(this.events, {Key? key}) : super(key: key);

  @override
  _EventListAndreaniState createState() => _EventListAndreaniState();
}

class _EventListAndreaniState extends State<EventListAndreani> {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 2, right: 2, left: 2),
        controller: _controller,
        itemCount: widget.events.length,
        itemBuilder: (context, index) =>
            EventAndreani(widget.events[index], index, widget.events.length),
        // shrinkWrap: _verificando,
      ),
    );
  }
}

class EventAndreani extends StatelessWidget {
  final Map<dynamic, String> event;
  final int index;
  final int listLength;
  const EventAndreani(this.event, this.index, this.listLength, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool lastItem = false;
    if (listLength - 1 == index) lastItem = true;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      // child: InkWell(
      //   splashColor: Theme.of(context).primaryColor,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      //       borderRadius: const BorderRadius.all(
      //         const Radius.circular(12.0),
      //       ),
      //     ),
      child: Column(
        children: [
          SizedBox(
            // padding: isPortrait && widget.modoSeleccion
            //     ? EdgeInsets.only(right: 4)
            //     : null,
            height: isPortrait ? 40 : 42,
            // alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isPortrait
                            ? screenWidth * 0.445
                            : screenWidth * 0.251,
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
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
                      if (!isPortrait)
                        SizedBox(
                          width: isPortrait
                              ? screenWidth * 0.445
                              : screenWidth * 0.475,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.place, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        child: Text(
                                          event['location']!,
                                          style: TextStyle(
                                              fontSize: fullHD ? 16 : 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isPortrait)
            Padding(
              padding: const EdgeInsets.only(left: 11, right: 11, top: 6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.place, size: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          child: Text(
                            event['location']!,
                            style: TextStyle(fontSize: fullHD ? 16 : 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Padding(
            padding: isPortrait
                ? const EdgeInsets.only(left: 11, right: 11, top: 12)
                : const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.local_shipping, size: 20),
                    SizedBox(
                      width: screenWidth - 62,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          event['condition']!,
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
          Padding(
            padding: isPortrait
                ? const EdgeInsets.only(
                    left: 11, right: 11, bottom: 10, top: 12)
                : const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, size: 20),
                    SizedBox(
                      width: screenWidth - 62,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          event['motive']!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: fullHD ? 16 : 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!lastItem)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
        ],
      ),
    );
  }
}
