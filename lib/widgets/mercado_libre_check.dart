import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import '../data/http_connection.dart';
import '../data/preferences.dart';

import '../widgets/ad_native.dart';
import '../widgets/dialog_error.dart';
import '../widgets/mercado_libre_item.dart';

class MercadoLibreCheck extends StatefulWidget {
  final String checkInput;
  const MercadoLibreCheck(this.checkInput, {Key? key}) : super(key: key);

  @override
  MercadoLibreCheckState createState() => MercadoLibreCheckState();
}

class MercadoLibreCheckState extends State<MercadoLibreCheck>
    with AutomaticKeepAliveClientMixin<MercadoLibreCheck> {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final BuildContext ctx = context;
    Response response =
        await HttpConnection.requestHandler('/api/mercadolibre/loadmore', body);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    if (response.statusCode == 200) {
      List<MeLiItemData> meliItems = processMLData(responseData['items']);
      setState(() {
        for (MeLiItemData item in meliItems) {
          itemsList.add(item);
        }
        loadMore = false;
      });
    } else {
      if (responseData['serverError'] == null) DialogError.show(ctx, 9, "");
    }
  }

  Future checkData(String checkInput) async {
    final BuildContext ctx = context;
    final String userId =
        Provider.of<UserPreferences>(ctx, listen: false).userId;
    final Object body = {
      'userId': userId,
      'consultType': checkInput,
    };
    final Response response =
        await HttpConnection.requestHandler('/api/mercadolibre/consult', body);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    if (response.statusCode == 200) {
      List<MeLiItemData> meliItems =
          processMLData(responseData['shippingsData']);
      setState(() {
        totalShippingsData = [...responseData['shippingsTotal']];
        itemsList = meliItems;
        httpHeaders = responseData['httpHeaders'];
      });
      return meliItems;
    } else {
      Provider.of<UserPreferences>(ctx, listen: false)
          .toggleMeLiErrorStatus(true);
      if (responseData['serverError'] == null) {
        DialogError.show(ctx, 9, "");
      }
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
    super.build(context);
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
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
                      children: [
                        if (!premiumUser)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 30),
                            child: AdNative("medium"),
                          ),
                        const Icon(Icons.local_shipping_outlined, size: 80),
                        const SizedBox(width: 30, height: 30),
                        Text(
                          widget.checkInput == 'buyer'
                              ? texts[170]!
                              : texts[171]!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        if (!premiumUser)
                          const Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 10),
                            child: AdNative("medium"),
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
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: premiumUser
                                      ? null
                                      : const AdNative("small"),
                                ),
                              MercadoLibreItem(itemsList[index]),
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
                            texts[172]!,
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
                      ),
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
                texts[160]!,
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

  @override
  bool get wantKeepAlive => true;
}

List<MeLiItemData> processMLData(fetchedData) {
  List<MeLiItemData> responseList = [];
  fetchedData.forEach((item) {
    String shippingId = item['shippingId'];
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
      shippingId,
      title,
      code,
      items,
      creationDate,
      lastUpdate,
      origin,
      destination,
    );
    responseList.add(newItem);
  });

  return responseList;
}

class MeLiItemData {
  final String shippingId;
  final String title;
  final String code;
  final List<String> items;
  final String creationDate;
  final String lastUpdate;
  final String origin;
  final Map<dynamic, String> destination;
  MeLiItemData(
    this.shippingId,
    this.title,
    this.code,
    this.items,
    this.creationDate,
    this.lastUpdate,
    this.origin,
    this.destination,
  );
}
