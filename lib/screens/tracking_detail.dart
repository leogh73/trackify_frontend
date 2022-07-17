// import 'package:Trackify/screens/detalle_seg_mas.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/widgets/services/ecapack.dart';
import 'package:trackify/widgets/services/fasttrack.dart';
import 'package:trackify/widgets/services/renaper.dart';
import 'package:trackify/widgets/services/urbano.dart';
import '../providers/trackings_active.dart';
import '../widgets/services/clicoh.dart';

import '../providers/classes.dart';
import '../providers/status.dart';

import '../widgets/menu_actions.dart';
import '../widgets/ad_banner.dart';

import '../widgets/services/andreani.dart';
import '../widgets/services/correo_argentino.dart';
import '../widgets/services/dhl.dart';
import '../widgets/services/oca.dart';
import '../widgets/services/ocasa.dart';
import '../widgets/services/viacargo.dart';

class TrackingDetail extends StatelessWidget {
  final ItemTracking tracking;
  const TrackingDetail(this.tracking, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _checking = Provider.of<Status>(context).checkingStatus;
    bool _endList = Provider.of<Status>(context).endOfEvents;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    var screenList = "main";
    if (tracking.search!) {
      screenList = "search";
    } else if (tracking.archived!) {
      screenList = "archived";
    }
    List<DetailsWidget> responseList = [
      DetailsWidget(EventListAndreani(tracking.events!), "Andreani"),
      DetailsWidget(EventListClicOh(tracking.events!), "ClicOh"),
      DetailsWidget(
          EventListCorreoArgentino(tracking.events!), "Correo Argentino"),
      DetailsWidget(EventListDHL(tracking.events!), "DHL"),
      DetailsWidget(EventListEcaPack(tracking.events!), "EcaPack"),
      DetailsWidget(EventListFastTrack(tracking.events!), "FastTrack"),
      DetailsWidget(EventListOCA(tracking.events!), "OCA"),
      DetailsWidget(EventListOCASA(tracking.events!), "OCASA"),
      DetailsWidget(EventListRenaper(tracking.events!), "Renaper"),
      DetailsWidget(EventListUrbano(tracking.events!), "Urbano"),
      DetailsWidget(EventListViaCargo(tracking.events!), "ViaCargo")
    ];
    int widgetIndex = responseList
        .indexWhere((element) => element.service == tracking.service);
    Widget result = responseList[widgetIndex].dataList;

    return WillPopScope(
      onWillPop: () => Future.value(!_checking),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 1.0,
          title: Text(
            tracking.title!,
            maxLines: 2,
            style: TextStyle(fontSize: fullHD ? 18 : 17),
          ),
          actions: [
            if (screenList != "search")
              ActionsMenu(
                action: '',
                screen: screenList,
                menu: true,
                detail: true,
                tracking: tracking,
                // accion: "eliminar",
                icon: 24,
              ),
            if (screenList == "search")
              PopupMenuButton<String>(
                // padding: EdgeInsets.zero,
                tooltip: 'Opciones',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                elevation: 2,
                // icon: Icon(Icons.more_vert),
                onSelected: (String value) {
                  switch (value) {
                    case 'Más datos':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MoreData(
                            tracking.otherData!,
                            tracking.service,
                          ),
                        ),
                      );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Más datos",
                    height: 35,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 15),
                          child: Icon(
                            Icons.info,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.zero,
                          child: Text("Más datos"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: Column(
          children: [
            if (_checking)
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 25, bottom: 20, right: 6),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Divider(
                      height: 1,
                      color: Theme.of(context).primaryColor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            Expanded(
              child: result,
            ),
          ],
        ),
        floatingActionButton: _checking || _endList
            ? null
            : FloatingActionButton(
                heroTag: 'events',
                onPressed: () => {
                  Provider.of<ActiveTrackings>(context, listen: false)
                      .searchUpdates(context, tracking.idMDB!)
                },
                child: const Icon(Icons.update, size: 29),
              ),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }
}

class DetailsWidget {
  Widget dataList;
  String service;
  DetailsWidget(
    this.dataList,
    this.service,
  );
}

class MoreData extends StatelessWidget {
  final List<List<String>> otherData;
  final String correo;
  const MoreData(this.otherData, this.correo, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<DetailsWidget> responseList = [
      DetailsWidget(MoreDataAndreani(otherData), "Andreani"),
      DetailsWidget(MoreDataClicOh(otherData), "ClicOh"),
      DetailsWidget(const MoreDataCorreoArgentino(), "Correo Argentino"),
      DetailsWidget(MoreDataDHL(otherData), "DHL"),
      DetailsWidget(const MoreDataEcaPack(), "EcaPack"),
      DetailsWidget(const MoreDataFastTrack(), "FastTrack"),
      DetailsWidget(MoreDataOCA(otherData), "OCA"),
      DetailsWidget(MoreDataOCASA(otherData), "OCASA"),
      DetailsWidget(MoreDataRenaper(otherData), "Renaper"),
      DetailsWidget(MoreDataUrbano(otherData), "Urbano"),
      DetailsWidget(MoreDataViaCargo(otherData), "ViaCargo"),
    ];
    int widgetIndex =
        responseList.indexWhere((element) => element.service == correo);
    Widget result = responseList[widgetIndex].dataList;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text("Más datos"),
      ),
      body: result,
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}
