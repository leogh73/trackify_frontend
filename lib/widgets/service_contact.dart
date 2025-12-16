import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/http_connection.dart';
import '../data/preferences.dart';

import '../widgets/dialog_error.dart';

class ServiceContact extends StatefulWidget {
  final String serviceName;
  const ServiceContact(this.serviceName, {Key? key}) : super(key: key);

  @override
  State<ServiceContact> createState() => _ServiceContactState();
}

class _ServiceContactState extends State<ServiceContact> {
  late Future fetchServiceData;

  @override
  void initState() {
    super.initState();
    fetchServiceData = fetchData();
  }

  Future fetchData() async {
    final BuildContext ctx = context;
    final Object body = {'serviceName': widget.serviceName};
    final Response response =
        await HttpConnection.requestHandler('/api/user/serviceContact', body);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    if (response.statusCode != 200 && responseData['serverError'] == null) {
      DialogError.show(ctx, 21, "");
    }
    return responseData;
  }

  void buttonHandler(String type, String data) async {
    String prefix = '';
    if (type == "phone") prefix = "tel:";
    if (type == "email") prefix = "mailto:";
    if (type == "whatsapp") prefix = "whatsapp://send?phone=";
    String url = "$prefix$data";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  List<List<Widget>> buttonList(
      BuildContext context, List<dynamic> buttonsData) {
    Widget generateButton(Map<String, dynamic> bData) {
      Map<String, IconData> icons = {
        "phone": Icons.phone,
        "email": Icons.email,
        "whatsapp": MdiIcons.whatsapp,
        "instagram": MdiIcons.instagram,
        "link": Icons.link,
      };
      return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 130,
          height: 130,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icons[bData["type"]], size: 30),
                const SizedBox(height: 5),
                Text(
                  bData["title"],
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio >
                            1079)
                        ? 17
                        : 16,
                  ),
                ),
              ],
            ),
            onPressed: () => buttonHandler(bData["type"], bData["data"]),
          ),
        ),
      );
    }

    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    List<Widget> list = [];
    for (dynamic bData in buttonsData) {
      list.add(generateButton(bData));
    }
    List<List<Widget>> chunks = [];
    int chunkSize = isPortrait ? 2 : 3;
    for (int i = 0; i < list.length; i += chunkSize) {
      int endIndex =
          (i + chunkSize < list.length) ? (i + chunkSize) : list.length;
      chunks.add(list.sublist(i, endIndex));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: fetchServiceData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Map<String, dynamic> responseData =
              snapshot.data as Map<String, dynamic>;
          return responseData["error"] == null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 20, left: 10, bottom: 10, right: 10),
                    child: Column(
                      children: [
                        ...buttonList(context, responseData['data']['list'])
                            .map((e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: e,
                                )),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "${texts[9]} ${responseData["data"]["source"]}",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (MediaQuery.of(context).size.width *
                                          MediaQuery.of(context)
                                              .devicePixelRatio >
                                      1079)
                                  ? 17
                                  : 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox();
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.only(top: 60, bottom: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Text(
                    texts[160]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: fullHD ? 16 : 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
