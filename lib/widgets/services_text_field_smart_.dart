import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/data/status.dart';

import '../data/preferences.dart';
import '../data/services.dart';
import '../data/theme.dart';

import '../widgets/services_list.dart';

class ServicesTextFieldSmart extends StatefulWidget {
  final TextEditingController serviceController;
  final List<ServiceItemModel> servicesList;
  final ServiceItemModel? preLoadedService;
  const ServicesTextFieldSmart(
      this.serviceController, this.servicesList, this.preLoadedService,
      {super.key});

  @override
  State<ServicesTextFieldSmart> createState() => _ServicesTextFieldSmartState();
}

class _ServicesTextFieldSmartState extends State<ServicesTextFieldSmart> {
  final FocusNode serviceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    serviceFocus.addListener(() {
      if (serviceFocus.hasFocus) {
        context.read<Services>().toggleIsExpanded(true);
      }
    });
  }

  @override
  void dispose() {
    serviceFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isAutodetecting =
        context.select((Services services) => services.isAutodetecting);
    final bool expand =
        context.select((Services services) => services.isExpanded);
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final MaterialColor primaryColor =
        context.select((UserTheme userTheme) => userTheme.startColor);
    final String codeInput =
        context.select((Status status) => status.codeInput);
    final Widget serviceSearch = Padding(
      padding: const EdgeInsets.only(left: 8, top: 2),
      child: TextFormField(
        focusNode: serviceFocus,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.preLoadedService == null ? texts[245]! : texts[6],
          suffixIcon: IconButton(
            onPressed: () {
              widget.serviceController.text = "";
              Provider.of<Services>(context, listen: false)
                  .filterServicesList(context, "", widget.servicesList, "");
            },
            icon: const Icon(Icons.close, size: 17),
          ),
        ),
        controller: widget.serviceController,
        textInputAction: TextInputAction.next,
        onChanged: (String? value) {
          Provider.of<Services>(context, listen: false).filterServicesList(
              context, value!, widget.servicesList, codeInput);
        },
      ),
    );
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.read<Services>().toggleIsExpanded(!expand),
          child: Container(
            decoration: BoxDecoration(
              border: expand && !isAutodetecting
                  ? Border.all(color: primaryColor, width: 2)
                  : Border.all(color: primaryColor, width: .8),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 46,
                      width: isPortrait ? screenWidth * .75 : screenWidth * .38,
                      alignment: Alignment.centerLeft,
                      child: isAutodetecting
                          ? Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 15,
                                    top: 13,
                                    bottom: 12,
                                  ),
                                  child: const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                                const SizedBox(width: 22),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    texts[247]!,
                                    style: TextStyle(
                                      fontSize: fullHD ? 16 : 15,
                                      color: primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : widget.preLoadedService == null
                              ? serviceSearch
                              : Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 15),
                                      height: 35,
                                      width: isPortrait
                                          ? screenWidth * 0.25
                                          : screenWidth * 0.15,
                                      child: widget.preLoadedService!.logo,
                                    ),
                                    SizedBox(
                                      width: isPortrait
                                          ? screenWidth * 0.45
                                          : screenWidth * 0.2,
                                      child: Text(
                                        widget.preLoadedService!.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: fullHD ? 17 : 16),
                                      ),
                                    )
                                  ],
                                ),
                    ),
                    if (!isAutodetecting)
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: Icon(
                              expand ? Icons.expand_less : Icons.expand_more),
                          onPressed: () => context
                              .read<Services>()
                              .toggleIsExpanded(!expand),
                        ),
                      ),
                  ],
                ),
                if (expand && !isAutodetecting)
                  Column(
                    children: [
                      Divider(
                        color: primaryColor,
                        thickness: .5,
                        height: 4,
                      ),
                      if (widget.preLoadedService != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 22),
                          child: serviceSearch,
                        ),
                      if (widget.preLoadedService != null)
                        Divider(
                          color: primaryColor,
                          thickness: .5,
                          height: 4,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          height:
                              isPortrait ? screenWidth * .5 : screenWidth * .1,
                          child: ServicesList(
                            null,
                            widget.servicesList,
                            widget.preLoadedService,
                            isPortrait,
                            screenWidth,
                            fullHD,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
