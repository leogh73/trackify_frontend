import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/status.dart';

import '../details_other.dart';
import '../data_response.dart';

class DataDHL {
  final dynamic data;
  DataDHL(this.data);

  List<Map<String, String>> generateEventList(eventsResponse) {
    List<Map<String, String>> events = [];
    Map<String, String> event;
    eventsResponse.forEach((e) => {
          event = {
            "date": e["date"],
            "time": e["time"],
            "location": e["location"],
            "description": e["description"],
          },
          events.add(event)
        });
    return events;
  }

  createResponse() {
    List<Map<String, String>> events = generateEventList(data['events']);
    String lastEvent = data['lastEvent'];
    List<String> shipping = [
      data["shipping"]["id"],
      data["shipping"]["service"],
      data["shipping"]["origin"],
      data["shipping"]["destiny"],
    ];
    List<String> status = [
      data["shipping"]["status"]["date"],
      data["shipping"]["status"]["time"],
      data["shipping"]["status"]["location"],
      data["shipping"]["status"]["statusCode"],
      data["shipping"]["status"]["status"],
      data["shipping"]["status"]["description"],
      data["shipping"]["status"]["moreDetails"],
      data["shipping"]["status"]["nextStep"],
    ];
    List<String> detail = [
      data["details"]["date"],
      data["details"]["time"],
      data["details"]["signatureUrl"],
      data["details"]["documentUrl"],
      "${data["details"]["totalPieces"]}",
      data["details"]["signedType"],
      data["details"]["signedName"],
    ];
    List<String> piecesIds = [data["details"]["pieceIds"].join(" - ")];

    List<List<String>> otherData = [];
    otherData.add(shipping);
    otherData.add(status);
    otherData.add(detail);
    otherData.add(piecesIds);

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
    List<String> status = [
      data['result']['shipping']["status"]["date"],
      data['result']['shipping']["status"]["time"],
      data['result']['shipping']["status"]["location"],
      data['result']['shipping']["status"]["statusCode"],
      data['result']['shipping']["status"]["status"],
      data['result']['shipping']["status"]["description"],
      data['result']['shipping']["status"]["moreDetails"],
      data['result']['shipping']["status"]["nextStep"],
    ];
    List<List<String>?>? otherData = [null, status, null, null];

    return ItemResponseData(
      events,
      lastEvent,
      otherData,
      null,
      null,
      null,
    );
  }
}

class MoreDataDHL extends StatelessWidget {
  final List<List<String>>? otherData;
  const MoreDataDHL(this.otherData, {Key? key}) : super(key: key);
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
                  "ID",
                  "Servicio",
                  "Origen",
                  "Destino",
                ],
              ).createTable(),
              "INFORMACI??N DE ENVIO",
            ),
            OtherData(
              DataRowHandler(
                otherData![1],
                [
                  "Fecha",
                  "Hora",
                  "Ubicaci??n",
                  "C??digo de status",
                  "Estado",
                  "Descripci??n",
                  "M??s detalles",
                  "Siguiente paso"
                ],
              ).createTable(),
              "INFORMACI??N DE ESTADO",
            ),
            OtherData(
              DataRowHandler(
                otherData![2],
                [
                  "Fecha",
                  "Hora",
                  "Firma",
                  "Documento",
                  "Total de piezas",
                  "Tipo de firma",
                  "Firmado por",
                ],
              ).createTable(),
              "DETALLE DEL ENVIO",
            ),
            OtherData(
              DataRowHandler(
                otherData![3],
                ["Id/s"],
              ).createTable(),
              "INFORMACI??N DE PIEZAS",
            ),
          ],
        ),
      ),
    );
  }
}

class EventListDHL extends StatefulWidget {
  final List<Map<dynamic, String>> events;
  const EventListDHL(this.events, {Key? key}) : super(key: key);

  @override
  _EventListDHLState createState() => _EventListDHLState();
}

class _EventListDHLState extends State<EventListDHL> {
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
            EventDHL(widget.events[index], index, widget.events.length),
      ),
    );
  }
}

class EventDHL extends StatelessWidget {
  final Map<dynamic, String> event;
  final int index;
  final int listLength;
  const EventDHL(this.event, this.index, this.listLength, {Key? key})
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
                            : screenWidth * 0.245,
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
                    left: 11, right: 11, bottom: 10, top: 10)
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
          if (!lastItem)
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
        ],
      ),
    );
  }
}
