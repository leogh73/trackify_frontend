import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/trackings_archived.dart';
import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';

import 'item_grid.dart';

class ListGrid extends StatelessWidget {
  final bool selectionMode;
  final List<ItemTracking> trackingsData;

  const ListGrid(this.selectionMode, this.trackingsData, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    PageStorageKey<String> listKey = const PageStorageKey<String>("Grid");
    // final selectionMode =
    //     Provider.of<ActiveTrackings>(context).estadoModoSelection;
    // final trackingsData =
    //     Provider.of<ActiveTrackings>(context).seguimientos;
    return selectionMode
        ? ListGridSelection(selectionMode, trackingsData, listKey)
        : ListGridNormal(selectionMode, trackingsData, listKey);
  }
}

class ListGridNormal extends StatefulWidget {
  final bool selection;
  final List<ItemTracking> trackingsData;
  final PageStorageKey<String>? listKey;

  const ListGridNormal(this.selection, this.trackingsData, this.listKey,
      {Key? key})
      : super(key: key);

  @override
  _ListGridNormalState createState() => _ListGridNormalState();
}

class _ListGridNormalState extends State<ListGridNormal> {
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
    // final selectionMode =
    //     Provider.of<ActiveTrackings>(context).estadoModoSelection;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    // final trackingsData = Provider.of<ActiveTrackings>(context);
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool portraitfullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    return GridView.count(
      key: widget.listKey,
      controller: _controller,
      childAspectRatio: isPortrait
          ? portraitfullHD
              ? 2 / 2.449
              : 2 / 2.622
          : landscapeFullHD
              ? 2 / 2.025
              : 2 / 2.288,
      padding: const EdgeInsets.all(4),
      crossAxisCount: isPortrait ? 2 : 3,
      children: List.generate(
        widget.trackingsData.length,
        (index) => ItemGrid(
          widget.trackingsData[index],
          widget.selection,
        ),
      ),
    );
  }
}

class ListGridSelection extends StatefulWidget {
  final bool selection;
  final List<ItemTracking> trackingsData;
  final PageStorageKey<String>? listKey;

  const ListGridSelection(this.selection, this.trackingsData, this.listKey,
      {Key? key})
      : super(key: key);

  @override
  _ListGridSelectionState createState() => _ListGridSelectionState();
}

class _ListGridSelectionState extends State<ListGridSelection> {
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
    // final selectionMode =
    //     Provider.of<ActiveTrackings>(context).estadoModoSelection;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    // final trackingsData = Provider.of<ActiveTrackings>(context);
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool portraitfullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    return GridView.count(
      key: widget.listKey,
      childAspectRatio: isPortrait
          ? portraitfullHD
              ? 2 / 2.449
              : 2 / 2.622
          : landscapeFullHD
              ? 2 / 2.025
              : 2 / 2.288,
      padding: const EdgeInsets.all(4),
      crossAxisCount: isPortrait ? 2 : 3,
      children: List.generate(
        widget.trackingsData.length,
        (index) => ItemGrid(widget.trackingsData[index], widget.selection),
      ),
    );
  }
}
