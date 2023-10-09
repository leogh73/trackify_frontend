import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/tracking.list.dart';

import '../providers/classes.dart';
import '../providers/status.dart';

class SearchList extends StatelessWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool resultList = Provider.of<Status>(context).resultList;
    return resultList ? const SearchListResult() : const SearchRecentList();
  }
}

class SearchListResult extends StatelessWidget {
  const SearchListResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ItemTracking> searchResults =
        Provider.of<Status>(context).searchResult;
    return Scaffold(
      body: searchResults.isEmpty
          ? const Center(
              child: Text(
                'No hay resultados para la búsqueda especificada.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          : TrackingList(searchResults),
    );
  }
}

class SearchRecentList extends StatelessWidget {
  const SearchRecentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> recentList = Provider.of<Status>(context).recentSearch;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 2, right: 2, left: 2),
      itemCount: recentList.length,
      itemBuilder: (context, index) => ItemSearch(recentList[index]),
    );
  }
}

class ItemSearch extends StatelessWidget {
  final String _itemSearch;
  const ItemSearch(this._itemSearch, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Provider.of<Status>(context, listen: false)
            .search(context, _itemSearch);
        Provider.of<Status>(context, listen: false).toggleResultList(true);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth - 52),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, right: 14),
                  child: Icon(Icons.update),
                ),
                Text(_itemSearch),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Provider.of<Status>(context, listen: false)
                  .removeSearch(_itemSearch);
            },
          ),
        ],
      ),
    );
  }
}
