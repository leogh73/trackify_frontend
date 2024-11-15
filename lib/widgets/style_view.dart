import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/../data/preferences.dart';

class StyleView extends StatefulWidget {
  const StyleView({Key? key}) : super(key: key);

  @override
  _StyleViewState createState() => _StyleViewState();
}

class _StyleViewState extends State<StyleView> {
  late String chosenView;
  List<ListModelType> viewTypes = [
    ListModelType(
      false,
      Image.asset('assets/listView/row.png'),
      "row",
    ),
    ListModelType(
      false,
      Image.asset('assets/listView/card.png'),
      "card",
    ),
    ListModelType(
      false,
      Image.asset('assets/listView/grid.png'),
      "grid",
    ),
  ];

  @override
  void initState() {
    super.initState();
    chosenView = Provider.of<UserPreferences>(context, listen: false).startList;
    int listIndex = viewTypes.indexWhere((type) => type.chosen == chosenView);
    viewTypes[listIndex].selected = true;
  }

  @override
  Widget build(BuildContext context) {
    String chosenView =
        Provider.of<UserPreferences>(context, listen: false).startList;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Column(
        children: [
          SizedBox(
            // padding: EdgeInsets.only(right: 8, left: 4),
            width: isPortrait ? screenWidth * 0.65 : screenWidth * 0.385,
            height: isPortrait
                ? (screenWidth * 0.65) * 0.59
                : (screenWidth * 0.35) * 0.59,
            child: GridView.count(
              // shrinkWrap: true,
              childAspectRatio: 1 / 1.8,
              crossAxisSpacing: 8,
              // mainAxisSpacing: 8,
              crossAxisCount: 3,
              children: List.generate(
                viewTypes.length,
                (index) => InkWell(
                  onTap: () {
                    setState(() {
                      for (var gridItem in viewTypes) {
                        gridItem.selected = false;
                      }
                      viewTypes[index].selected = true;
                    });
                    chosenView = viewTypes[index].chosen;
                    Provider.of<UserPreferences>(context, listen: false)
                        .loadNewView(chosenView);
                    // ListaElegida(chosenView);
                  },
                  child: ListType(viewTypes[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListType extends StatelessWidget {
  final ListModelType listItem;

  const ListType(this.listItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: listItem.selected
            ? Border.all(color: Colors.black45, width: 2)
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: listItem.selected
            ? const BorderRadius.all(
                Radius.circular(10.0),
              )
            : const BorderRadius.all(
                Radius.circular(0),
              ),
        child: Stack(
          children: [
            listItem.logo,
            listItem.selected
                ? const Center(
                    child: Icon(Icons.check),
                  )
                : const Center(),
          ],
        ),
      ),
      // width: 80,
      // padding: const EdgeInsets.only(left: 5, right: 5),
    );
  }
}

class ListModelType {
  bool selected;
  final Image logo;
  final String chosen;
  ListModelType(
    this.selected,
    this.logo,
    this.chosen,
  );
}
