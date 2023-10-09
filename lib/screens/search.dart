import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences.dart';
import '../providers/status.dart';

import '../widgets/search_list.dart';
import '../widgets/ad_banner.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            Provider.of<Status>(context, listen: false).toggleResultList(false);
          },
        ),
        title: SearchField(controller),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller.clear();
              Provider.of<Status>(context, listen: false)
                  .toggleResultList(false);
            },
          ),
        ],
      ),
      body: const SearchList(),
      bottomNavigationBar: premiumUser ? const SizedBox() : const AdBanner(),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  const SearchField(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Buscar...',
      ),
      controller: controller,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Colors.white),
      autofocus: true,
      cursorColor: Colors.white54,
      validator: (value) {
        if (value == null) {
          return 'Ingrese un código de seguimiento válido';
        }
        return null;
      },
      onChanged: (_) {
        if (controller.text.isEmpty) {
          Provider.of<Status>(context, listen: false).toggleResultList(false);
        } else {
          Provider.of<Status>(context, listen: false).toggleResultList(true);
          Provider.of<Status>(context, listen: false)
              .search(context, controller.text);
        }
      },
      onFieldSubmitted: (_) {
        if (controller.text.isNotEmpty)
          Provider.of<Status>(context, listen: false)
              .addSearch(controller.text);
      },
    );
  }
}
