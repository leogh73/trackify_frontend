import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/status.dart';

import '../details_other.dart';
import '../data_response.dart';

class DataRenaper {
  final dynamic data;
  DataRenaper(this.data);

  List<Map<String, String>> generateEventList(eventsResponse) {
    List<Map<String, String>> events = [];
    Map<String, String> event;
    eventsResponse.forEach((e) => {
          event = {
            "date": e["date"],
            "time": e["time"],
            "description": e["description"],
            "motive": e["motive"],
            "plant": e["plant"],
          },
          events.add(event)
        });
    return events;
  }

  createResponse() {
    List<Map<String, String>> events = generateEventList(data['events']);

    String lastEvent = data['lastEvent'];
    List<List<String>> otherData = [
      [
        data['details']['paperClass'],
        data['details']['paperKind'],
        data['details']['description'],
        data['details']['pickUp']
      ],
      [
        data['origin']['description'],
        data['origin']['address'],
        data['origin']['state'],
        data['origin']['zipCode'],
      ]
    ];
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

  lastEvent() {
    List<Map<String, String>> events =
        generateEventList(data['result']['events']);
    String lastEvent = data['result']['lastEvent'];

    return ItemResponseData(
      events,
      lastEvent,
      null,
      null,
      null,
      null,
    );
  }
}

class MoreDataRenaper extends StatelessWidget {
  final List<List<String>>? otherData;
  const MoreDataRenaper(this.otherData, {Key? key}) : super(key: key);
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
                "Clase",
                "Tipo",
                "Descripci??n",
                "Retiro",
              ],
            ).createTable(),
            "TR??MITE",
          ),
          OtherData(
            DataRowHandler(
              otherData![1],
              [
                "Nombre",
                "Direcci??n",
                "Provincia",
                "C??digo postal",
              ],
            ).createTable(),
            "OFICINA DE ORIGEN",
          ),
        ],
      ),
    );
  }
}

class EventListRenaper extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  const EventListRenaper(this.events, {Key? key}) : super(key: key);

  @override
  _EventListRenaperState createState() => _EventListRenaperState();
}

class _EventListRenaperState extends State<EventListRenaper> {
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
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
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
            EventRenaper(widget.events[index], index, widget.events.length),
      ),
    );
  }
}

class EventRenaper extends StatelessWidget {
  final Map<dynamic, String> event;
  final int index;
  final int listLength;
  const EventRenaper(this.event, this.index, this.listLength, {Key? key})
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
      padding: const EdgeInsets.only(right: 8, left: 8, top: 2),
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
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isPortrait
                            ? screenWidth * 0.445
                            : screenWidth * 0.245,
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
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2),
                                        child: Text(
                                          event['plant']!,
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
              padding: const EdgeInsets.only(left: 11, right: 11, top: 3),
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
                            event['plant']!,
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
                ? const EdgeInsets.only(left: 11, right: 11, bottom: 6, top: 11)
                : const EdgeInsets.only(left: 10, right: 10, bottom: 6, top: 6),
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
                          event['description']!,
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
          Padding(
            padding: isPortrait
                ? const EdgeInsets.only(left: 11, right: 11, bottom: 10, top: 8)
                : const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 8),
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
