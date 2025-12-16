import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    List<Map<String, dynamic>> content = [
      {"question": texts[39], "answer": texts[40], 'showAd': false},
      {"question": texts[41], "answer": texts[42], 'showAd': false},
      {"question": texts[43], "answer": texts[44], 'showAd': false},
      {"question": texts[45], "answer": texts[46], 'showAd': true},
      {"question": texts[47], "answer": texts[48], 'showAd': false},
      {"question": texts[49], "answer": texts[50], 'showAd': false},
      {"question": texts[51], "answer": texts[52], 'showAd': false},
      {"question": texts[53], "answer": texts[54], 'showAd': true},
      {"question": texts[55], "answer": texts[56], 'showAd': false},
      {"question": texts[57], "answer": texts[58], 'showAd': false},
      {"question": texts[59], "answer": texts[60], 'showAd': false},
    ];
    final List<Widget> contentList = content
        .map((item) =>
            HelpItem(item["question"]!, item["answer"]!, item["showAd"]))
        .toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: const Text(
          'Ayuda',
          style: TextStyle(fontSize: 19),
        ),
        actions: const <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!premiumUser) const AdNative("small"),
            const SizedBox(height: 8),
            ...contentList,
            if (!premiumUser) const AdNative("small"),
          ],
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}

class HelpItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool showAd;
  const HelpItem(this.question, this.answer, this.showAd, {super.key});

  @override
  State<HelpItem> createState() => _HelpItemState();
}

class _HelpItemState extends State<HelpItem> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                expand = !expand;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: .5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              padding: isPortrait
                  ? const EdgeInsets.only(right: 7, left: 7, top: 8, bottom: 8)
                  : const EdgeInsets.only(right: 2, left: 7, top: 8, bottom: 8),
              child: Column(
                children: [
                  Container(
                    padding: isPortrait
                        ? const EdgeInsets.only(right: 4)
                        : !isPortrait
                            ? const EdgeInsets.only(right: 2)
                            : null,
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width:
                              isPortrait ? screenWidth * .79 : screenWidth * .9,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.question,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fullHD ? 17 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                              expand ? Icons.expand_less : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              expand = !expand;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (expand)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 12, right: 8, left: 8, bottom: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: isPortrait
                                    ? screenWidth - 54
                                    : screenWidth - 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    widget.answer,
                                    style:
                                        TextStyle(fontSize: fullHD ? 17 : 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: premiumUser ? 0 : 8, bottom: 8),
          child: premiumUser
              ? null
              : widget.showAd
                  ? const AdNative("small")
                  : null,
        ),
      ],
    );
  }
}
