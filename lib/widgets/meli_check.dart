import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/preferences.dart';

import 'dialog_and_toast.dart';
import 'meli_item.dart';

class MeLiCheck extends StatefulWidget {
  final String checkInput;
  const MeLiCheck(this.checkInput, {Key? key}) : super(key: key);

  @override
  _MeLiCheckState createState() => _MeLiCheckState();
}

class _MeLiCheckState extends State<MeLiCheck> {
  late ScrollController _controller;

  _scrollListener() {
    if (_controller.offset == _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (totalShippingsData.length == itemsList.length) {
        setState(() {
          endOfList = true;
        });
      }
    } else {
      setState(() {
        endOfList = false;
      });
    }
  }

  List<MeLiItemData> itemsList = [];
  List<Object> totalShippingsData = [];
  bool endOfList = false;
  bool loadMore = false;
  int indexLoadMore = 0;
  late Object httpHeaders;
  late Future checkInput;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    checkInput = checkData(widget.checkInput);
  }

  Future loadMoreItems() async {
    // String _userId = Provider.of<ActiveTrackings>(context, listen: false).userId;
    setState(() {
      indexLoadMore = indexLoadMore + 10;
    });
    int totalCheck = indexLoadMore + 10;
    if (totalShippingsData.length - itemsList.length < 10) {
      totalCheck = totalShippingsData.length;
    }
    List<Object> shippingCheck = [];
    for (var i = indexLoadMore; totalCheck > i; i++) {
      Object id = totalShippingsData[i];
      shippingCheck.add(id);
    }
    // String url = '';
    var response = await http.Client().post(
        Uri.parse("${dotenv.env['API_URL']}/api/mercadolibre/loadmore"),
        body: {
          'shippingIds': json.encode(shippingCheck),
          'httpHeaders': json.encode(httpHeaders)
        });
    if (response.statusCode == 200) {
      var fetchedData = json.decode(response.body);
      List<MeLiItemData> responseData = processMLData(fetchedData);
      setState(() {
        for (var element in responseData) {
          itemsList.add(element);
        }
        loadMore = false;
      });
    } else {
      ShowDialog(context).meLiCheckError();
    }
    return null;
  }

  Future checkData(String checkInput) async {
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    // String url = '';
    var response = await http.Client().post(
        Uri.parse("${dotenv.env['API_URL']}/api/mercadolibre/consult"),
        body: {
          'userId': _userId,
          'consultType': checkInput,
        });
    if (response.statusCode == 200) {
      var fetchedData = json.decode(response.body);
      List<MeLiItemData> responseData =
          processMLData(fetchedData['shippingsData']);
      setState(() {
        totalShippingsData = [...fetchedData['shippingsTotal']];
        itemsList = responseData;
        httpHeaders = fetchedData['httpHeaders'];
      });
      return responseData;
    } else {
      Provider.of<Preferences>(context, listen: false)
          .toggleMeLiErrorStatus(true);
      ShowDialog(context).meLiCheckError();
    }
  }

  bool checkRemainingItems(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter == 0) {
        if (totalShippingsData.length == itemsList.length) {
          setState(() {
            endOfList = true;
          });
        }
        if (endOfList == false) {
          setState(() {
            loadMore = true;
          });
          loadMoreItems();
        }
      } else {
        setState(() {
          loadMore = false;
          endOfList = false;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;

    return FutureBuilder(
      future: checkInput,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: checkRemainingItems,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 6),
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) =>
                        MercadoLibreItem(itemsList[index]),
                  ),
                ),
              ),
              if (endOfList)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: Text(
                      'No hay más datos',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                  ),
                ),
              if (loadMore)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 22, bottom: 22),
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20, right: 6),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
              Text(
                'Consultando...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: fullHD ? 16 : 15,
                ),
              )
            ],
          );
        }
      },
    );
  }
}

List<MeLiItemData> processMLData(dynamic fetchedData) {
  List<MeLiItemData> responseList = [];
  fetchedData.forEach((item) {
    String title = item['title'];
    String code = item['code'];
    List<String> items = [];
    item['items'].forEach((item) => items.add(item));
    String creationDate = item['creationDate'];
    String lastUpdate = item['lastUpdate'];
    String origin = item['origin'];
    Map<dynamic, String> destiny = {
      'address': item['destiny']['address'],
      'name': item['destiny']['name']
    };
    MeLiItemData newItem = MeLiItemData(
        title, code, items, creationDate, lastUpdate, origin, destiny);
    responseList.add(newItem);
  });

  return responseList;
}

class MeLiItemData {
  final String title;
  final String code;
  final List<String> items;
  final String creationDate;
  final String lastUpdate;
  final String origin;
  final Map<dynamic, String> destiny;
  MeLiItemData(
    this.title,
    this.code,
    this.items,
    this.creationDate,
    this.lastUpdate,
    this.origin,
    this.destiny,
  );
}
