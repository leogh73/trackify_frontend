import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/claim.dart';

import '../data/preferences.dart';
import '../data/services.dart';

import '../widgets/ad_native.dart';

class TrackingClaim extends StatefulWidget {
  final String serviceName;
  const TrackingClaim(this.serviceName, {Key? key}) : super(key: key);

  @override
  State<TrackingClaim> createState() => _TrackingClaimState();
}

class _TrackingClaimState extends State<TrackingClaim> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final Widget serviceLogo = Image.network(
        Provider.of<Services>(context, listen: false)
            .servicesData[widget.serviceName]['logoUrl']);
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() {
            expanded = !expanded;
          }),
          child: SizedBox(
            height: 45,
            width: isPortrait ? screenWidth : screenWidth * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                  child: const Icon(Icons.warning),
                ),
                Container(
                  alignment: Alignment.center,
                  width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      texts[267],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: isPortrait ? screenWidth * 0.3 : screenWidth * 0.2,
                  child: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                )
              ],
            ),
          ),
        ),
        if (expanded)
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.5,
            height: 1.5,
          ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  height: 75,
                  width: isPortrait ? screenWidth : screenWidth * 0.6,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: .5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  // margin: EdgeInsets.only(bottom: 4, top: ),
                  child: InkWell(
                    onTap: () {
                      Provider.of<Services>(context, listen: false)
                          .loadService(widget.serviceName, context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceClaim(widget.serviceName),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: isPortrait
                              ? screenWidth * 0.2
                              : screenWidth * 0.15,
                          child: serviceLogo,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: isPortrait
                              ? screenWidth * 0.45
                              : screenWidth * 0.25,
                          child: Text(
                            texts[271],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          width: isPortrait
                              ? screenWidth * 0.2
                              : screenWidth * 0.15,
                          child: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!premiumUser)
                  const Padding(
                      padding: EdgeInsets.all(8), child: AdNative("small"))
              ],
            ),
          ),
      ],
    );
  }
}

class ResponseRow extends StatelessWidget {
  final String rowKey;
  final String rowValue;
  const ResponseRow(this.rowKey, this.rowValue, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: isPortrait ? screenWidth * 0.2535 : screenWidth * 0.15,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                rowKey,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: fullHD ? 16 : 15,
                ),
              ),
            ),
          ),
          SizedBox(
            width: isPortrait ? screenWidth * 0.635 : screenWidth * 0.78,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                rowValue,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                  fontSize: fullHD ? 16 : 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
