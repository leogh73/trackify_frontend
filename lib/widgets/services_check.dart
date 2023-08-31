import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/http_request_handler.dart';
import '../providers/preferences.dart';
import './dialog_and_toast.dart';

class ServicesCheck extends StatefulWidget {
  const ServicesCheck({super.key});

  @override
  State<ServicesCheck> createState() => _ServicesCheckState();
}

class _ServicesCheckState extends State<ServicesCheck> {
  List<ServiceStatusItem> itemsList = [];
  late Future checkStatus;

  @override
  void initState() {
    super.initState();
    checkStatus = checkServices();
  }

  Future checkServices() async {
    String _userId = Provider.of<Preferences>(context, listen: false).userId;
    Object body = {
      'userId': _userId,
    };
    dynamic response =
        await HttpRequestHandler.newRequest('/api/user/servicesCheck', body);
    if (response is Map)
      return ShowDialog(context).connectionServerError(false);
    Map<String, dynamic> fetchedData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<ServiceStatusItem> list = [];
      for (Map<String, dynamic> result in fetchedData["checkResults"]) {
        list.add(ServiceStatusItem(result['service'], result['status']));
      }
      setState(() {
        itemsList = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: checkStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return itemsList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 80),
                    const SizedBox(width: 40, height: 40),
                    Text(
                      "No se pudo verificar. Reintente más tarde",
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(children: itemsList);
        } else {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 20, right: 6),
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
              )
            ],
          );
        }
      },
    );
  }
}

class ServiceStatusItem extends StatelessWidget {
  final String service;
  final String status;
  const ServiceStatusItem(this.service, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Image> imagesList = {
      "Andreani": Image.asset('assets/services/andreani.png'),
      "ClicOh": Image.asset('assets/services/clicoh.png'),
      "Correo Argentino": Image.asset('assets/services/correoargentino.png'),
      "DHL": Image.asset('assets/services/dhl.png'),
      "EcaPack": Image.asset('assets/services/ecapack.png'),
      "Enviopack": Image.asset('assets/services/enviopack.png'),
      "FastTrack": Image.asset('assets/services/fasttrack.png'),
      "MDCargas": Image.asset('assets/services/mdcargas.png'),
      "OCA": Image.asset('assets/services/oca.png'),
      "OCASA": Image.asset('assets/services/ocasa.png'),
      "Renaper": Image.asset('assets/services/renaper.png'),
      "Urbano": Image.asset('assets/services/urbano.png'),
      "ViaCargo": Image.asset('assets/services/viacargo.png'),
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: imagesList[service]!,
          width: 150,
          height: 40,
        ),
        StatusSelect(status)
      ],
    );
  }
}

class StatusSelect extends StatelessWidget {
  final String status;
  const StatusSelect(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Map<String, String> selectStatus = {
      "ok": "Correcto",
      "delayed": "Demora",
      "failed": "Falla",
    };
    final Map<String, Widget> selectIcon = {
      "ok": Icon(Icons.check_circle_outline),
      "delayed": Icon(Icons.warning_amber_outlined),
      "failed": Icon(Icons.error_outline),
    };
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          selectIcon[status]!,
          SizedBox(
            height: 20,
            width: 20,
          ),
          Text(
            selectStatus[status]!,
            style: TextStyle(
              fontSize: fullHD ? 17 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
