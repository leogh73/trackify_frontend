import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/data/trackings_active.dart';
import 'package:trackify/data/trackings_archived.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/status.dart';

import '../widgets/ad_banner.dart';
import '../widgets/tracking_list.dart';

class Search extends StatefulWidget {
  final String screenName;
  const Search(this.screenName, {Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final List<ItemTracking> trackingsList = widget.screenName == "active"
        ? context.read<ActiveTrackings>().trackings
        : context.read<ArchivedTrackings>().trackings;
    final String searchInput =
        context.select((Status status) => status.getSearchInput);
    final List<ItemTracking> searchResults = searchInput.isEmpty
        ? trackingsList
        : context.select((Status status) => status.searchResult);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              Provider.of<Status>(context, listen: false).clearSearchResults();
            },
          ),
        ],
        title: TextFormField(
          decoration: InputDecoration(
            hintText: texts[121]!,
          ),
          controller: _controller,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          cursorColor: Colors.white54,
          onChanged: (_) {
            if (trackingsList.isEmpty) {
              return;
            }
            Provider.of<Status>(context, listen: false)
                .search(context, _controller.text, trackingsList);
          },
        ),
      ),
      body: searchResults.isEmpty
          ? Center(
              child: Text(
                trackingsList.isEmpty ? texts[243]! : texts[200]!,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          : TrackingList(searchResults),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
