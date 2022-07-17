import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

import 'package:provider/provider.dart';
import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/preferences.dart';

import 'search_list.dart';
import 'item_grid.dart';
import 'item_row.dart';
import 'item_card.dart';
import 'data_response.dart';
import 'dialog_and_toast.dart';

class DataCheck {
  BuildContext context;
  ItemTracking tracking;
  bool retry;

  DataCheck(
    this.context,
    this.tracking,
    this.retry,
  );

  Future startCheck() async {
    String userId = Provider.of<Preferences>(context, listen: false).userId;
    String url = "${dotenv.env['API_URL']}/api/user/$userId/add/";
    var response = await http.Client().post(Uri.parse(url), body: {
      'title': tracking.title,
      'service': tracking.service,
      'code': tracking.code,
    });
    // String url = "${dotenv.env['API_URL']}/api/user/prueba/";
    // var response = await http.Client().post(Uri.parse(url), body: {
    //   'title': tracking.title,
    //   'service': tracking.service,
    //   'code': tracking.code,
    // });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      ItemResponseData itemResponse = Response.start(tracking.service, data);
      if (retry) {
        Provider.of<ActiveTrackings>(context, listen: false)
            .loadStartData(tracking, itemResponse);
        GlobalToast(context, "Seguimiento agregado").displayToast();
        return;
      } else {
        return itemResponse;
      }
    } else if (response.statusCode == 204) {
      ShowDialog(context).trackingError(tracking.service);
    } else {
      ShowDialog(context).startCheckError();
    }
    return null;
    // throw Exception(
    //     'No se pudo obtener información, verifique el código ingresado o intente nuevamente más tarde.');
  }
}

class ProcessData extends StatelessWidget {
  final ItemTracking tracking;
  final bool retry;
  const ProcessData(this.tracking, this.retry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: DataCheck(context, tracking, retry).startCheck(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: const SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    Text(
                      'Verificando...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: fullHD ? 16 : 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case ConnectionState.none:
            // return Center(child: Text("error"));
            // Future(() => _errorConexion(context));
            // return null;
            break;
          case ConnectionState.active:
            // return null;
            break;
          case ConnectionState.done:
            if (snapshot.data != null) {
              Provider.of<ActiveTrackings>(context, listen: false)
                  .loadStartData(tracking, snapshot.data as ItemResponseData);
              Future(() =>
                  GlobalToast(context, "Seguimiento agregado").displayToast());
            } else {
              tracking.checkError = true;
            }
            return Results(tracking);

          default:
        }
        throw Exception('ERROR');
      },
    );
  }
}

class Results extends StatelessWidget {
  final ItemTracking tracking;
  const Results(this.tracking, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<WidgetList> widgetList = [
      WidgetList(ItemRow(tracking, false), "row"),
      WidgetList(ItemCard(tracking, false), "card"),
      WidgetList(ItemGrid(tracking, false), "grid")
    ];
    var startListView = Provider.of<Preferences>(context).startList;
    final widgetIndex =
        widgetList.indexWhere((element) => element.listView == startListView);
    return widgetList[widgetIndex].widgetList;
  }
}
