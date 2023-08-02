import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/status.dart';

import '../widgets/details_other.dart';
import '../widgets/data_response.dart';

class ClicOh {
  List<Map<String, String>> generateEventList(eventsResponse) {
    List<Map<String, String>> events = [];
    Map<String, String> event;
    eventsResponse.forEach((e) => {
          event = {
            "date": e["date"],
            "time": e["time"],
            "description": e["description"],
          },
          events.add(event)
        });
    return events;
  }

  ItemResponseData createResponse(dynamic data) {
    String lastEvent = data['lastEvent'];
    List<List<String>> otherData = [];
    List<Map<String, String>> events = generateEventList(data['events']);
    List<String> origin = [
      data['origin']['address'],
      data['origin']['country'],
    ];
    List<String> destination = [
      data['destination']['address'],
      data['destination']['locality'],
      data['destination']['country'],
      data['destination']['administrative_area_level_1'],
      data['destination']['postal_code']
    ];
    List<String> receiver = [
      data['receiver']['dni'],
      data['receiver']['first_name'],
      data['receiver']['last_name'],
      data['receiver']['email'],
      data['receiver']['phone'],
      data['receiver']['address']
    ];
    List<String> other = [
      data['otherData']['clientName'],
    ];
    otherData.add(origin);
    otherData.add(destination);
    otherData.add(receiver);
    otherData.add(other);

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
    String lastEvent = data['result']['lastEvent'];

    return ItemResponseData(events, lastEvent, null, null, null, null);
  }
}

class MoreDataClicOh extends StatelessWidget {
  final List<List<String>>? otherData;
  const MoreDataClicOh(this.otherData, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          OtherData(
            DataRowHandler(
              otherData![0],
              [
                "Dirección",
                "País",
              ],
            ).createTable(),
            "ORIGEN",
          ),
          OtherData(
            DataRowHandler(
              otherData![1],
              ["Dirección", "Localidad", "País", "Provincia", "Código Postal"],
            ).createTable(),
            "DESTINO",
          ),
          OtherData(
            DataRowHandler(
              otherData![2],
              [
                "DNI",
                "Nombre",
                "Apellido",
                "Correo electrónico",
                "Teléfono",
                "Dirección"
              ],
            ).createTable(),
            "DESTINATARIO",
          ),
          OtherData(
            DataRowHandler(
              otherData![3],
              [
                "Nombre del remitente",
              ],
            ).createTable(),
            "OTROS DATOS",
          ),
        ],
      ),
    ));
  }
}

class EventListClicOh extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  const EventListClicOh(this.events, {Key? key}) : super(key: key);

  @override
  _EventListClicOhState createState() => _EventListClicOhState();
}

class _EventListClicOhState extends State<EventListClicOh> {
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
            EventClicOh(widget.events[index], index, widget.events.length),
        // shrinkWrap: _verificando,
      ),
    );
  }
}

class EventClicOh extends StatelessWidget {
  final Map<dynamic, String> event;
  final int index;
  final int listLength;
  const EventClicOh(this.event, this.index, this.listLength, {Key? key})
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
                            ? screenWidth * 0.472
                            : screenWidth * 0.48,
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
                            : screenWidth * 0.472,
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
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.local_shipping, size: 20),
                    SizedBox(
                      width: screenWidth - 60,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          event['description']!,
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
          if (!lastItem)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
        ],
      ),
    );
  }
}
