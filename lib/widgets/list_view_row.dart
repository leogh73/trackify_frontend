import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/ad_native.dart';

import '../providers/trackings_archived.dart';
import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';

import 'ad_interstitial.dart';
import 'item_row.dart';

class ListRow extends StatelessWidget {
  final bool selectionMode;
  final List<ItemTracking> trackingsData;
  const ListRow(this.selectionMode, this.trackingsData, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    PageStorageKey<String> listKey = const PageStorageKey<String>("Row");
    // final selectionMode =
    //     Provider.of<ActiveTrackings>(context).estadoModoSelection;
    // final trackingsData =
    //     Provider.of<ActiveTrackings>(context).seguimientos;
    return selectionMode
        ? ListRowSelection(selectionMode, trackingsData, listKey)
        : ListRowNormal(selectionMode, trackingsData, listKey);
  }
}

class ListRowNormal extends StatefulWidget {
  final bool selection;
  final List<ItemTracking> trackingsData;
  final PageStorageKey<String>? listKey;

  const ListRowNormal(this.selection, this.trackingsData, this.listKey,
      {Key? key})
      : super(key: key);

  @override
  _ListRowNormalState createState() => _ListRowNormalState();
}

class _ListRowNormalState extends State<ListRowNormal> {
  late ScrollController _controller;
  AdInterstitial interstitialAd = AdInterstitial();

  _scrollListener() {
    if (_controller.offset == _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      Provider.of<Status>(context, listen: false).toggleListEndStatus(true);
    } else {
      Provider.of<Status>(context, listen: false).toggleListEndStatus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    interstitialAd.createInterstitialAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.listKey,
      padding: const EdgeInsets.only(top: 8, right: 2, left: 2),
      controller: _controller,
      itemCount: widget.trackingsData.length,
      itemBuilder: (context, index) => Column(
        children: [
          if (index == 0)
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: AdNative("small")),
          ItemRow(widget.trackingsData[index], widget.selection, interstitialAd)
        ],
      ),
    );
  }
}

class ListRowSelection extends StatefulWidget {
  final bool selection;
  final List<ItemTracking> trackingsData;
  final PageStorageKey<String>? listKey;

  const ListRowSelection(this.selection, this.trackingsData, this.listKey,
      {Key? key})
      : super(key: key);

  @override
  _ListRowSelectionState createState() => _ListRowSelectionState();
}

class _ListRowSelectionState extends State<ListRowSelection> {
  late int _startSelection;

  @override
  void initState() {
    super.initState();
    if (!widget.trackingsData[0].archived!) {
      _startSelection = Provider.of<ActiveTrackings>(context, listen: false)
          .activatedSelection;
    } else if (widget.trackingsData[0].archived!) {
      _startSelection = Provider.of<ArchivedTrackings>(context, listen: false)
          .activatedSelection;
    }
    int startIndex = widget.trackingsData
        .indexWhere((element) => element.idSB == _startSelection);
    widget.trackingsData[startIndex].selected = true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.listKey,
      padding: const EdgeInsets.only(top: 8, right: 2, left: 2),
      itemCount: widget.trackingsData.length,
      itemBuilder: (context, index) => Column(children: [
        if (index == 0)
          Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: AdNative("small")),
        ItemRow(widget.trackingsData[index], widget.selection, null),
      ]),
    );
  }
}
