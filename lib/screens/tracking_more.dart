import 'package:flutter/material.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';

class TrackingMore extends StatelessWidget {
  final List<Map<String, dynamic>> moreDataList;
  const TrackingMore(this.moreDataList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text("Más datos"),
      ),
      body: moreDataList.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      child: AdNative("medium"),
                      padding: EdgeInsets.only(top: 10, bottom: 60),
                    ),
                    Center(
                      child: Text(
                        'No hay más datos',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Padding(
                      child: AdNative("medium"),
                      padding: EdgeInsets.only(top: 60, bottom: 10),
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
                    Padding(
                      child: AdNative("medium"),
                      padding: EdgeInsets.only(bottom: 8),
                    ),
                    ...moreDataList
                        .map(
                          (moreData) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, left: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
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
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            alignment: Alignment.center,
                                            child: Text(
                                              moreData['title'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fullHD ? 16 : 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                          color: Theme.of(context).primaryColor,
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
                              Padding(
                                child: AdNative("medium"),
                                padding: EdgeInsets.only(bottom: 8),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const AdBanner(),
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
