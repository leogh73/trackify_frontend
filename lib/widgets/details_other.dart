import 'package:flutter/material.dart';
import 'package:trackify/widgets/ad_native.dart';

class ResponseRow extends StatelessWidget {
  final String type;
  final String data;
  const ResponseRow(this.type, this.data, {Key? key}) : super(key: key);
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
                type,
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
                data,
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

class DataRowHandler {
  final List<String> dataList;
  final List<String> typeList;
  DataRowHandler(this.dataList, this.typeList);
  createTable() {
    List<ResponseRow> dataTable = [];
    for (var i = 0; i < dataList.length; i++) {
      dataTable.add(ResponseRow(
        typeList[i],
        dataList[i],
      ));
    }
    return dataTable;
  }
}

class OtherData extends StatelessWidget {
  final List<ResponseRow> dataTable;
  final String categoryTitle;
  const OtherData(this.dataTable, this.categoryTitle, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        // margin: EdgeInsets.only(bottom: 4, top: ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  alignment: Alignment.center,
                  child: Text(
                    categoryTitle,
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
            Divider(color: Theme.of(context).primaryColor, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: dataTable,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

class NoMoreData extends StatelessWidget {
  const NoMoreData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
