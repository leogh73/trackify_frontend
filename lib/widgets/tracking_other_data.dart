import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../data/preferences.dart';

import 'ad_native.dart';

class TrackingOtherData extends StatefulWidget {
  final List<Map<String, dynamic>> moreDataList;
  const TrackingOtherData(this.moreDataList, {Key? key}) : super(key: key);

  @override
  State<TrackingOtherData> createState() => _TrackingOtherDataState();
}

class _TrackingOtherDataState extends State<TrackingOtherData> {
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
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
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
                  width: screenWidth * 0.2,
                  child: Padding(
                    padding: isPortrait
                        ? const EdgeInsets.only(left: 40)
                        : const EdgeInsets.only(right: 0),
                    child: Icon(MdiIcons.informationVariantCircleOutline),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: isPortrait ? screenWidth * 0.6 : screenWidth * 0.2,
                  child: Text(
                    texts[265],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: Padding(
                    padding: isPortrait
                        ? const EdgeInsets.only(right: 40)
                        : const EdgeInsets.only(right: 0),
                    child:
                        Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  ),
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
          widget.moreDataList.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!premiumUser)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 60),
                            child: AdNative("small"),
                          ),
                        Center(
                          child: Text(
                            texts[124]!,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        if (!premiumUser)
                          const Padding(
                            padding: EdgeInsets.only(top: 60, bottom: 10),
                            child: AdNative("small"),
                          )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        ...widget.moreDataList
                            .map(
                              (moreData) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8, bottom: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.2),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      // margin: EdgeInsets.only(bottom: 4, top: ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 12),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  moreData['title'],
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fullHD ? 16 : 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              thickness: 1),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                                children: (moreData['data']
                                                        as Map<String, dynamic>)
                                                    .entries
                                                    .map((entry) => ResponseRow(
                                                        entry.key,
                                                        entry.value.toString()))
                                                    .toList()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!premiumUser)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: AdNative("small"),
                                    ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
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
