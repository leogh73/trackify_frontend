import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/widgets/dialog_and_toast.dart';

import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/status.dart';

import 'tracking_form.dart';

import '../widgets/navigation_drawer.dart';
import '../widgets/menu_appereance.dart';
import '../widgets/list_select.dart';
import '../widgets/menu_actions.dart';
import '../widgets/ad_banner.dart';

import 'search.dart';

class Main extends StatefulWidget {
  static const routeName = "/main";
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      String error =
          Provider.of<ActiveTrackings>(context, listen: false).loadStartError;
      if (error == 'User not found') ShowDialog(context).disabledUserError();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String error =
        Provider.of<ActiveTrackings>(context, listen: false).loadStartError;
    final bool selectionMode =
        Provider.of<ActiveTrackings>(context).selectionModeStatus;
    final bool endOfList = Provider.of<Status>(context).endOfList;
    final List<ItemTracking> selection =
        Provider.of<ActiveTrackings>(context).selectionElements;
    final List<ItemTracking> trackings =
        Provider.of<ActiveTrackings>(context).trackings;

    String _textSelection() {
      String text;
      text = '${selection.length}/${trackings.length}';
      return text;
    }

    return Scaffold(
      drawer: error.isEmpty ? const NavigationDrawer() : null,
      appBar: selectionMode
          ? AppBar(
              titleSpacing: 1.0,
              leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Provider.of<ActiveTrackings>(context, listen: false)
                        .toggleSelectionMode();
                  }),
              title: Text(
                _textSelection(),
                style: const TextStyle(fontSize: 19),
              ),
              actions: [
                if (selection.isNotEmpty)
                  ActionsMenu(
                    tracking: ItemTracking(
                        idMDB: 'idMDB',
                        code: 'code',
                        service: 'service',
                        events: [],
                        otherData: [],
                        checkError: false),
                    screen: "main",
                    menu: false,
                    detail: false,
                    action: "archive",
                    icon: 24,
                  ),
                if (selection.isNotEmpty)
                  ActionsMenu(
                    tracking: ItemTracking(
                        idMDB: 'idMDB',
                        code: 'code',
                        service: 'service',
                        events: [],
                        otherData: [],
                        checkError: false),
                    screen: "main",
                    menu: false,
                    detail: false,
                    action: "remove",
                    icon: 24,
                  ),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    Provider.of<ActiveTrackings>(context, listen: false)
                        .selectAll();
                  },
                ),
              ],
            )
          : AppBar(
              titleSpacing: 1.0,
              title: const Text(
                'Seguimientos',
                style: TextStyle(fontSize: 19),
              ),
              actions: <Widget>[
                // Estilo(),
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 20,
                  onPressed: () => {
                    Provider.of<Status>(context, listen: false)
                        .loadMainController(null),
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const Search(),
                      ),
                    ),
                    // Provider.of<Seguimientos>(context, listen: false)
                    //     .nuevaPantallaLista("busqueda"),
                    // Provider.of<ActiveTrackings>(context, listen: false)
                    //     .cargarControladorMain(controladorPrimario),
                    // showSearch(
                    //   context: context,
                    //   delegate: Busqueda(),
                    // ),ooo
                  },
                ),
                const AppereanceMenu(),
              ],
            ),
      body: Center(
        child: TrackingList(selectionMode, trackings),
      ),
      floatingActionButton: selectionMode || endOfList || error != ''
          ? null
          : FloatingActionButton(
              heroTag: 'agregar',
              onPressed: () => {},
              child: const AddTracking(32),
            ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

class AddTracking extends StatelessWidget {
  final double icono;
  const AddTracking(this.icono, {Key? key}) : super(key: key);
  void _addTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TrackingForm(
          edit: false,
          mercadoLibre: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      iconSize: icono,
      onPressed: () => _addTracking(context),
    );
  }
}
