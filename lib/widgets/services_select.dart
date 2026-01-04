import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/services_list.dart';
import '../widgets/services_text_field_smart_.dart';

import '../data/preferences.dart';
import '../data/services.dart';

class ServiceSelect extends StatelessWidget {
  final bool mustShowDialog;
  final TextEditingController serviceController;
  final List<ServiceItemModel> servicesList;
  final ServiceItemModel? preLoadedService;
  final bool claimService;
  const ServiceSelect(
    this.mustShowDialog,
    this.serviceController,
    this.servicesList,
    this.preLoadedService,
    this.claimService, {
    Key? key,
  }) : super(key: key);

  void showServiceDialog(BuildContext context, bool isPortrait,
      double screenWidth, bool fullHD, Map<int, dynamic> texts) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final List<Map<String, dynamic>> servicesToFilter =
            servicesList.map((s) {
          return {
            "logo": s.logo,
            "name": Services.filterString(s.name),
            "originalName": s.name,
          };
        }).toList();
        return Dialog(
          insetPadding: const EdgeInsets.all(15),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: isPortrait ? screenWidth : screenWidth * 0.6,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width:
                          isPortrait ? screenWidth * 0.68 : screenWidth * 0.5,
                      padding:
                          const EdgeInsets.only(top: 5, bottom: 5, left: 5),
                      child: TextFormField(
                          focusNode: FocusNode(),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: const SizedBox(child: Icon(Icons.close)),
                                onPressed: () {
                                  serviceController.clear();
                                  Provider.of<Services>(context, listen: false)
                                      .clearFilteredList();
                                }),
                            labelText: texts[6]!,
                            contentPadding: const EdgeInsets.only(top: 5),
                          ),
                          controller: serviceController,
                          textInputAction: TextInputAction.next,
                          autofocus: serviceController.text.isNotEmpty,
                          onChanged: (_) {
                            Provider.of<Services>(context, listen: false)
                                .filterServicesList(
                                    context,
                                    serviceController.text,
                                    servicesToFilter,
                                    "");
                          }),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                      ),
                      child: const Icon(Icons.close, size: 24),
                    )
                  ],
                ),
                Expanded(
                  child: ServicesList(
                    dialogContext,
                    servicesList,
                    preLoadedService,
                    isPortrait,
                    screenWidth,
                    fullHD,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return mustShowDialog
        ? preLoadedService == null
            ? Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1)),
                    child: InkWell(
                      onTap: () => showServiceDialog(
                          context, isPortrait, screenWidth, fullHD, texts),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 15),
                            height: 35,
                            width: isPortrait
                                ? screenWidth * 0.25
                                : screenWidth * 0.15,
                            child: const Icon(
                              Icons.local_shipping,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: isPortrait
                                ? screenWidth * 0.55
                                : screenWidth * 0.3,
                            child: Text(
                              texts[201]!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: fullHD ? 17 : 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : ServiceItem(
                preLoadedService!,
                preLoadedService,
                isPortrait,
                screenWidth,
                fullHD,
                true,
                () => showServiceDialog(
                    context, isPortrait, screenWidth, fullHD, texts),
              )
        : ServicesTextFieldSmart(
            serviceController,
            servicesList,
            preLoadedService,
          );
  }
}
