import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/status.dart';

import '../widgets/search_list.dart';
import '../widgets/ad_banner.dart';

class Search extends StatelessWidget {
  static const routeName = "/search";

  const Search({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextEditingController mainController =
        Provider.of<Status>(context).primaryController;
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
        title: SearchField(mainController),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Provider.of<Status>(context, listen: false).cleanMainController();
              Provider.of<Status>(context, listen: false)
                  .toggleResultList(false);
            },
          ),
        ],
      ),
      body: const SearchList(),
      bottomNavigationBar: const BannerAdWidget(),
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
        hintText: 'Search...',
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
        if (controller.text.isEmpty) {
          return;
        }
        Provider.of<Status>(context, listen: false).addSearch(controller.text);
      },
    );
  }
}
