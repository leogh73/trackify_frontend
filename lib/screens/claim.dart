import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/service_contact.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/services.dart';
import '../data/trackings_active.dart';

import '../widgets/ad_native.dart';
import '../widgets/ad_banner.dart';
import '../widgets/services_select.dart';

class ServiceClaim extends StatefulWidget {
  final String serviceName;
  const ServiceClaim(this.serviceName, {Key? key}) : super(key: key);

  @override
  State<ServiceClaim> createState() => _ServiceClaimState();
}

class _ServiceClaimState extends State<ServiceClaim> {
  ServiceItemModel? selectedService;
  late List<ServiceItemModel> services;
  final TextEditingController serviceController = TextEditingController();
  final FocusNode serviceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    services =
        Provider.of<Services>(context, listen: false).itemModelList(true);
    if (widget.serviceName.isNotEmpty) {
      selectedService =
          services.firstWhere((service) => service.name == widget.serviceName);
    }
  }

  @override
  void dispose() {
    serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final ServiceItemModel? selectedService =
        context.select((Services services) => services.chosenService);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<ServiceItemModel> servicesList =
        Provider.of<Services>(context, listen: false).itemModelList(true);
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: Text(texts[10]!),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: premiumUser ? null : const AdNative("small"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  Text(
                    texts[11]!,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[400],
                      fontSize: fullHD ? 17 : 16,
                    ),
                  ),
                  Text(
                    texts[12]!,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fullHD ? 17 : 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ServiceSelect(
                      true,
                      serviceController,
                      servicesList,
                      selectedService,
                      true,
                    ),
                  ),
                  if (selectedService != null)
                    ServiceContact(
                      selectedService.name,
                      key:
                          Key(DateTime.now().millisecondsSinceEpoch.toString()),
                    ),
                  if (!premiumUser && trackingsList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: premiumUser ? null : const AdNative("medium"),
                    ),
                  const SizedBox(width: 50, height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
