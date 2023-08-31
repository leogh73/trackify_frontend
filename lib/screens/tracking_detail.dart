// import 'package:Trackify/screens/detalle_seg_mas.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trackify/providers/tracking_functions.dart';
import 'package:trackify/services/ecapack.dart';
import 'package:trackify/services/enviopack.dart';
import 'package:trackify/services/fasttrack.dart';
import 'package:trackify/services/mdcargas.dart';
import 'package:trackify/services/renaper.dart';
import 'package:trackify/services/urbano.dart';
import 'package:trackify/widgets/details_other.dart';

import '../providers/classes.dart';
import '../providers/status.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/menu_actions.dart';
import '../widgets/ad_banner.dart';

import '../services/clicoh.dart';
import '../services/andreani.dart';
import '../services/correo_argentino.dart';
import '../services/dhl.dart';
import '../services/oca.dart';
import '../services/ocasa.dart';
import '../services/viacargo.dart';

class TrackingDetail extends StatefulWidget {
  final ItemTracking tracking;
  const TrackingDetail(this.tracking, {Key? key}) : super(key: key);

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    bool checking = Provider.of<Status>(context).checkingStatus;
    bool endList = Provider.of<Status>(context).endOfEvents;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    var screenList = "main";
    if (widget.tracking.search!) {
      screenList = "search";
    } else if (widget.tracking.archived!) {
      screenList = "archived";
    }
    List<Map<String, String>> events = widget.tracking.events!;
    final Map<String, dynamic> responseList = {
      "Andreani": EventListAndreani(events),
      "ClicOh": EventListClicOh(events),
      "Correo Argentino": EventListCorreoArgentino(events),
      "DHL": EventListDHL(events),
      "EcaPack": EventListEcaPack(events),
      "Enviopack": EventListEnviopack(events),
      "FastTrack": EventListFastTrack(events),
      "MDCargas": EventListMDCargas(events),
      "OCA": EventListOCA(events),
      "OCASA": EventListOCASA(events),
      "Renaper": EventListRenaper(events),
      "Urbano": EventListUrbano(events),
      "ViaCargo": EventListViaCargo(events),
    };
    Widget result = responseList[widget.tracking.service];

    return WillPopScope(
      onWillPop: () => Future.value(!checking),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 1.0,
          title: Text(
            widget.tracking.title!,
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
                tracking: widget.tracking,
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
                            widget.tracking.otherData!,
                            widget.tracking.service,
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
            // Padding(
            //     padding: EdgeInsets.only(top: 10, bottom: 10),
            //     child: AdNative("medium")),
            if (checking)
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
        floatingActionButton: checking || endList
            ? null
            : FloatingActionButton(
                heroTag: 'events',
                onPressed: () => {
                  interstitialAd.showInterstitialAd(),
                  TrackingFunctions.searchUpdates(context, widget.tracking),
                },
                child: const Icon(Icons.update, size: 29),
              ),
        bottomNavigationBar: const AdBanner(),
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
  final String service;
  const MoreData(this.otherData, this.service, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget noMoreData = const NoMoreData();
    final Map<String, dynamic> responseList = {
      "Andreani": MoreDataAndreani(otherData),
      "ClicOh": MoreDataClicOh(otherData),
      "Correo Argentino": noMoreData,
      "DHL": MoreDataDHL(otherData),
      "EcaPack": noMoreData,
      "Enviopack": MoreDataEnviopack(otherData),
      "FastTrack": noMoreData,
      "MDCargas": noMoreData,
      "OCA": MoreDataOCA(otherData),
      "OCASA": MoreDataOCASA(otherData),
      "Renaper": MoreDataRenaper(otherData),
      "Urbano": MoreDataUrbano(otherData),
      "ViaCargo": MoreDataViaCargo(otherData),
    };

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text("Más datos"),
      ),
      body: responseList[service],
      bottomNavigationBar: const AdBanner(),
    );
  }
}
