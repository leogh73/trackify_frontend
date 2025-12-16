import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';
import '../data/services.dart';

class ServicesList extends StatelessWidget {
  final BuildContext? dialogContext;
  final List<ServiceItemModel> servicesList;
  final ServiceItemModel? selectedService;
  final bool isPortrait;
  final double screenWidth;
  final bool fullHD;
  const ServicesList(this.dialogContext, this.servicesList,
      this.selectedService, this.isPortrait, this.screenWidth, this.fullHD,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final String searchInput =
        context.select((Services services) => services.getSearchInput);
    final List<ServiceItemModel> detectedServices =
        context.select((Services services) => services.getDetectedServices);
    final List<ServiceItemModel> finalList =
        detectedServices.isEmpty ? servicesList : detectedServices;
    final List<ServiceItemModel> filteredList = searchInput.isEmpty
        ? finalList
        : context.select((Services services) => services.getFilteredList);
    return filteredList.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                texts[200]!,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ))
            ],
          )
        : ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ServiceItem(
                filteredList[index],
                selectedService,
                isPortrait,
                screenWidth,
                fullHD,
                servicesList.length - 1 == index,
                () {
                  if (selectedService != null &&
                      selectedService!.name == filteredList[index].name) {
                    return;
                  }
                  Provider.of<Services>(context, listen: false)
                      .loadService(filteredList[index].name, context);
                  if (dialogContext != null) {
                    Navigator.of(dialogContext!).pop();
                    return;
                  }
                  Provider.of<Services>(context, listen: false)
                      .toggleIsExpanded(false);
                },
              );
            },
          );
  }
}

class ServiceItem extends StatelessWidget {
  final ServiceItemModel service;
  final ServiceItemModel? selectedService;
  final bool isPortrait;
  final double screenWidth;
  final bool fullHD;
  final bool lastItem;
  final VoidCallback function;
  const ServiceItem(this.service, this.selectedService, this.isPortrait,
      this.screenWidth, this.fullHD, this.lastItem, this.function,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: selectedService != null &&
                    service.name == selectedService!.name
                ? Border.all(color: Theme.of(context).primaryColor, width: 1)
                : null,
          ),
          child: InkWell(
            onTap: function,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  height: 35,
                  width: isPortrait ? screenWidth * 0.25 : screenWidth * 0.15,
                  child: service.logo,
                ),
                SizedBox(
                  width: isPortrait ? screenWidth * 0.55 : screenWidth * 0.3,
                  child: Text(
                    service.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: fullHD ? 17 : 16),
                  ),
                )
              ],
            ),
          ),
        ),
        if (!lastItem)
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: .15,
            height: 10,
          )
      ],
    );
  }
}
