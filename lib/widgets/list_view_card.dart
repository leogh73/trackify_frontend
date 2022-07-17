import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/trackings_archived.dart';
import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';

import 'item_card.dart';

class ListCard extends StatelessWidget {
  final bool selectionMode;
  final List<ItemTracking> trackingsData;
  const ListCard(this.selectionMode, this.trackingsData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageStorageKey<String> listKey = const PageStorageKey<String>("Card");
    // final selectionMode =
    //     Provider.of<ActiveTrackings>(context).estadoModoSelection;
    // final trackingsData =
    //     Provider.of<ActiveTrackings>(context).seguimientos;
    return selectionMode
        ? ListCardSelection(selectionMode, trackingsData, listKey)
        : ListCardNormal(selectionMode, trackingsData, listKey);
  }
}

class ListCardNormal extends StatefulWidget {
  final bool selection;
  final List<ItemTracking> trackingsData;
  final PageStorageKey<String>? listKey;

  const ListCardNormal(this.selection, this.trackingsData, this.listKey,
      {Key? key})
      : super(key: key);

  @override
  _ListCardNormalState createState() => _ListCardNormalState();
}

class _ListCardNormalState extends State<ListCardNormal> {
  late ScrollController _controller;

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
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller.addListener(_scrollListener);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.listKey,
      padding: const EdgeInsets.only(top: 8, right: 2, left: 2),
      itemCount: widget.trackingsData.length,
      controller: _controller,
      itemBuilder: (context, index) =>
          ItemCard(widget.trackingsData[index], widget.selection),
    );
  }
}

class ListCardSelection extends StatefulWidget {
  final bool selection;
  final List<ItemTracking> trackingsData;
  final PageStorageKey<String>? listKey;

  const ListCardSelection(this.selection, this.trackingsData, this.listKey,
      {Key? key})
      : super(key: key);

  @override
  _ListCardSelectionState createState() => _ListCardSelectionState();
}

class _ListCardSelectionState extends State<ListCardSelection> {
  late int _startSelection;

  @override
  void initState() {
    super.initState();
    var listScreen = "main";
    if (widget.trackingsData[0].archived!) {
      listScreen = "archived";
    }
    if (listScreen == "main") {
      _startSelection = Provider.of<ActiveTrackings>(context, listen: false)
          .activatedSelection;
    } else if (listScreen == "archived") {
      _startSelection = Provider.of<ArchivedTrackings>(context, listen: false)
          .activatedSelection;
    }
    int indiceInicial = widget.trackingsData
        .indexWhere((element) => element.idSB == _startSelection);
    widget.trackingsData[indiceInicial].selected = true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.listKey,
      padding: const EdgeInsets.only(top: 8, right: 2, left: 2),
      itemCount: widget.trackingsData.length,
      itemBuilder: (context, index) =>
          ItemCard(widget.trackingsData[index], widget.selection),
    );
  }
}
