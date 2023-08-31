import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:trackify/providers/http_request_handler.dart';
import 'package:trackify/widgets/ad_native.dart';

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
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    checkInput = checkData(widget.checkInput);
  }

  Future loadMoreItems() async {
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
    Object body = {
      'shippingIds': json.encode(shippingCheck),
      'httpHeaders': json.encode(httpHeaders)
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/mercadolibre/loadmore', body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
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
  }

  Future checkData(String checkInput) async {
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {
      'userId': _userId,
      'consultType': checkInput,
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/mercadolibre/consult', body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
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
          return itemsList.isEmpty && totalShippingsData.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          child: AdNative("medium"),
                          padding: EdgeInsets.only(top: 10, bottom: 30),
                        ),
                        const Icon(Icons.local_shipping_outlined, size: 80),
                        const SizedBox(width: 30, height: 30),
                        Text(
                          "No hay ${widget.checkInput == 'buyer' ? 'compras' : 'ventas'}",
                          style: const TextStyle(fontSize: 24),
                        ),
                        Padding(
                          child: AdNative("medium"),
                          padding: EdgeInsets.only(top: 30, bottom: 10),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: checkRemainingItems,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 6),
                          itemCount: itemsList.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              if (index == 0)
                                Padding(
                                    child: AdNative("small"),
                                    padding: EdgeInsets.only(bottom: 8)),
                              MercadoLibreItem(itemsList[index])
                            ]);
                          },
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
                                color: Theme.of(context).primaryColor,
                                fontSize: 14),
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
    String code = item['code'] ?? 'Sin datos';
    List<String> items = [];
    item['items'].forEach((item) => items.add(item));
    String creationDate = item['creationDate'];
    String lastUpdate = item['lastUpdate'];
    String origin = item['origin'];
    Map<dynamic, String> destination = {
      'address': item['destination']['address'],
      'name': item['destination']['name']
    };
    MeLiItemData newItem = MeLiItemData(
        title, code, items, creationDate, lastUpdate, origin, destination);
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
  final Map<dynamic, String> destination;
  MeLiItemData(
    this.title,
    this.code,
    this.items,
    this.creationDate,
    this.lastUpdate,
    this.origin,
    this.destination,
  );
}
