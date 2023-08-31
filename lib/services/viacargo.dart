import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/widgets/ad_native.dart';

import '../providers/status.dart';

import '../widgets/details_other.dart';
import '../widgets/data_response.dart';

class ViaCargo {
  List<Map<String, String>> generateEventList(eventsResponse) {
    List<Map<String, String>> events = [];
    Map<String, String> event;
    eventsResponse.forEach((e) => {
          event = {
            "date": e["date"],
            "time": e["time"],
            "location": e["location"],
            "status": e["status"],
          },
          events.add(event)
        });
    return events;
  }

  ItemResponseData createResponse(dynamic data) {
    List<Map<String, String>> events = generateEventList(data['events']);

    String lastEvent = data['lastEvent'];
    List<String> origin = [
      data['origin']['senderName'],
      data['origin']['senderDni'],
      data['origin']['address'],
      data['origin']['zipCode'],
      data['origin']['state'],
      data['origin']['date'],
      data['origin']['time'],
    ];
    List<String> destination = [
      data['destination']['receiverName'],
      data['destination']['receiverDni'],
      data['destination']['address'],
      data['destination']['zipCode'],
      data['destination']['state'],
      data['destination']['phone'],
      data['destination']['dateDelivered'],
      data['destination']['timeDelivered']
    ];
    List<String> otherData = [
      data['aditional']['weightDeclared'],
      data['aditional']['numberOfPieces'].toString(),
      data['aditional']['service'],
      data['aditional']['sign']
    ];
    List<List<String>> aditional = [origin, destination, otherData];
    String checkDate = data['checkDate'];
    String checkTime = data['checkTime'];
    String trackingId = data['trackingId'];

    return ItemResponseData(
      events,
      lastEvent,
      aditional,
      checkDate,
      checkTime,
      trackingId,
    );
  }

  ItemResponseData lastEvent(dynamic data) {
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

class MoreDataViaCargo extends StatelessWidget {
  final List<List<String>>? otherData;
  const MoreDataViaCargo(this.otherData, {Key? key}) : super(key: key);
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
                  "Remitente",
                  "DNI",
                  "Dirección",
                  "Código postal",
                  "Provincia",
                  "Fecha",
                  "Hora",
                ],
              ).createTable(),
              "ORIGEN",
            ),
            Padding(
                child: AdNative("medium"), padding: EdgeInsets.only(bottom: 8)),
            OtherData(
              DataRowHandler(
                otherData![1],
                [
                  "Destinatario",
                  "DNI",
                  "Dirección",
                  "Código postal",
                  "Provincia",
                  "Teléfono",
                  "Fecha de entrega",
                  "Hora de entrega",
                ],
              ).createTable(),
              "DESTINO",
            ),
            Padding(
                child: AdNative("medium"), padding: EdgeInsets.only(bottom: 8)),
            OtherData(
              DataRowHandler(
                otherData![2],
                [
                  "Peso declarado",
                  "Cantidad de piezas",
                  "Servicio",
                  "Firma",
                ],
              ).createTable(),
              "OTROS DATOS",
            ),
            Padding(
                child: AdNative("medium"), padding: EdgeInsets.only(bottom: 8)),
          ],
        ),
      ),
    );
  }
}

class EventListViaCargo extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  const EventListViaCargo(this.events, {Key? key}) : super(key: key);

  @override
  _EventListViaCargoState createState() => _EventListViaCargoState();
}

class _EventListViaCargoState extends State<EventListViaCargo> {
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
            EventViaCargo(widget.events[index], index, widget.events.length),
      ),
    );
  }
}

class EventViaCargo extends StatelessWidget {
  final Map<dynamic, String> event;
  final int index;
  final int listLength;
  const EventViaCargo(this.event, this.index, this.listLength, {Key? key})
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
          if (index == 0)
            Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: AdNative("medium")),
          if (index == 0)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
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
                ? const EdgeInsets.only(
                    left: 11, right: 11, bottom: 10, top: 12)
                : const EdgeInsets.only(left: 9, right: 9, bottom: 10, top: 6),
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
                          event['status']!,
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
          Divider(color: Theme.of(context).primaryColor, thickness: 1),
          Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: AdNative("medium")),
          if (!lastItem)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
        ],
      ),
    );
  }
}
