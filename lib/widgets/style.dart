import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/preferences.dart';
import '../providers/theme.dart';

class ColorsStyle extends StatefulWidget {
  const ColorsStyle({Key? key}) : super(key: key);

  @override
  _ColorsStyleState createState() => _ColorsStyleState();
}

class _ColorsStyleState extends State<ColorsStyle> {
  late MaterialColor startColor;
  List<ModelGridItem> grid = [];
  final List<MaterialColor> colors = [
    Colors.teal,
    Colors.indigo,
    Colors.green,
    Colors.pink,
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.amber,
    Colors.lime,
    Colors.cyan,
    Colors.yellow,
    Colors.grey,
    Colors.lightBlue
  ];

  @override
  void initState() {
    super.initState();
    grid = colors.map((color) => ModelGridItem(false, color)).toList();
    startColor = Provider.of<UserTheme>(context, listen: false).startColor;
    int colorIndex =
        grid.indexWhere((gridItem) => gridItem.color == startColor);
    grid[colorIndex].selected = true;
  }

  @override
  Widget build(BuildContext context) {
    // final chosenColor =
    //     Provider.of<EstiloColorInicial>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        // Container(
        //   padding: isPortrait
        //       ? EdgeInsets.only(top: 6, bottom: 12)
        //       : EdgeInsets.only(top: 10, bottom: 10),
        //   child: Text(
        //     'COLOR',
        //     style:
        //         TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        //   ),
        // ),
        // SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            // padding: EdgeInsets.only(right: 6),
            width: isPortrait ? screenWidth * 0.65 : screenWidth * 0.342,
            height: isPortrait
                ? (screenWidth * 0.65) * 0.98
                : (screenWidth * 0.345) * 0.965,
            child: GridView.count(
              // shrinkWrap: true,
              padding: const EdgeInsets.only(right: 5, left: 5),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 4,
              children: List.generate(
                grid.length,
                (index) => InkWell(
                  onTap: () {
                    setState(() {
                      for (var gridItem in grid) {
                        gridItem.selected = false;
                      }
                      grid[index].selected = true;
                    });
                    MaterialColor chosenColor = grid[index].color;
                    Provider.of<UserTheme>(context, listen: false)
                        .loadNewColor(chosenColor);
                    // Provider.of<EstiloColorInicial>(context, listen: false)
                    //     .cargarNuevoColor();
                  },
                  child: GridItem(grid[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  final ModelGridItem _gridItem;
  const GridItem(this._gridItem, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _gridItem.color,
        border: _gridItem.selected
            ? Border.all(color: Colors.black45, width: 2)
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: _gridItem.selected
          ? const Icon(
              Icons.check,
              color: Colors.black45,
            )
          : null,
    );
  }
}

class ModelGridItem {
  bool selected;
  MaterialColor color;
  ModelGridItem(this.selected, this.color);
}

class StyleList extends StatefulWidget {
  const StyleList({Key? key}) : super(key: key);

  @override
  _StyleListState createState() => _StyleListState();
}

class _StyleListState extends State<StyleList> {
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
    chosenView = Provider.of<Preferences>(context, listen: false).startList;
    int listIndex = viewTypes.indexWhere((type) => type.chosen == chosenView);
    viewTypes[listIndex].selected = true;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          // padding: EdgeInsets.only(right: 8, left: 4),
          width: isPortrait ? screenWidth * 0.65 : screenWidth * 0.385,
          height: isPortrait
              ? (screenWidth * 0.65) * 0.59
              : (screenWidth * 0.385) * 0.59,
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
                  Provider.of<Preferences>(context, listen: false)
                      .loadNewView(chosenView);
                  // ListaElegida(chosenView);
                },
                child: ListType(viewTypes[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListType extends StatelessWidget {
  final ListModelType _itemLista;

  const ListType(this._itemLista, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: _itemLista.selected
            ? Border.all(color: Colors.black45, width: 2)
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: _itemLista.selected
            ? const BorderRadius.all(
                Radius.circular(10.0),
              )
            : const BorderRadius.all(
                Radius.circular(0),
              ),
        child: Stack(
          children: [
            _itemLista.image,
            _itemLista.selected
                ? const Center(
                    child: Icon(
                      Icons.check,
                    ),
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
  final Image image;
  final String chosen;
  ListModelType(this.selected, this.image, this.chosen);
}

class StyleMode extends StatelessWidget {
  static bool darkMode = false;

  const StyleMode({Key? key}) : super(key: key);

  void _toggleMode(BuildContext context) {
    darkMode = !darkMode;
    Provider.of<UserTheme>(context, listen: false).toggleMode();
  }

  @override
  Widget build(BuildContext context) {
    darkMode = Provider.of<UserTheme>(context).darkModeStatus;
    return Padding(
      padding: const EdgeInsets.only(right: 26.0, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            darkMode ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 45,
            child: Switch(
              value: darkMode,
              onChanged: (_) => _toggleMode(context),
            ),
          ),
        ],
      ),
    );
    //   ],
    // ),
  }
}
