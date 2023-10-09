import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme.dart';

class StyleColor extends StatefulWidget {
  const StyleColor({Key? key}) : super(key: key);

  @override
  _StyleColorState createState() => _StyleColorState();
}

class _StyleColorState extends State<StyleColor> {
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
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
