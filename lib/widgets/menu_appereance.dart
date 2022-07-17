import 'package:flutter/material.dart';
import 'style.dart';

class AppereanceMenu extends StatelessWidget {
  const AppereanceMenu({Key? key}) : super(key: key);

  void _changeColor(context, isPortrait) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Column(
            children: [
              Container(
                // width: isPortrait ? 260 : 223,
                // height: isPortrait ? 245 : 197,
                // height: isPortrait ? 280 : 400,
                padding: isPortrait
                    ? const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      )
                    : const EdgeInsets.only(top: 8),
                child: Column(
                  children: const [ColorsStyle()],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 135,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                        child: const Text(
                          'ACEPTAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                            }),
                  ),
                ],
                // ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeView(context, isPortrait) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Column(
            children: [
              Container(
                // width: isPortrait ? 280 : 240,
                // height: isPortrait ? 171 : 163,
                // height: isPortrait ? 280 : 400,
                padding: isPortrait
                    ? const EdgeInsets.only(
                        top: 16, right: 5, left: 7, bottom: 2)
                    : const EdgeInsets.only(
                        top: 16, right: 10, left: 14, bottom: 2),
                child: Column(
                  children: const [StyleList()],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 135,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                        child: const Text(
                          'ACEPTAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                            }),
                  ),
                ],
                // ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeMode(context, isPortrait) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Column(
            children: [
              Container(
                // width: isPortrait ? 145 : 145,
                // height: isPortrait ? 60 : 57,
                // height: isPortrait ? 280 : 400,
                padding: isPortrait
                    ? const EdgeInsets.only(
                        top: 15,
                        // right: 10,
                        left: 35,
                      )
                    : const EdgeInsets.only(top: 12, left: 35),
                child: Column(
                  children: const [StyleMode()],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 135,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                        child: const Text(
                          'ACEPTAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                            }),
                  ),
                ],
                // ),
              ),
            ],
          ),
        );
      },
    );
  }

  optionMenu(String texto, BuildContext context, IconData icono) {
    return PopupMenuItem<String>(
      value: texto,
      height: 35,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 15),
            child: Icon(icono, color: Theme.of(context).iconTheme.color),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Text(texto),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return PopupMenuButton<String>(
      // padding: EdgeInsets.zero,
      tooltip: 'Opciones',
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 2,
      // icon: Icon(Icons.more_vert),
      onSelected: (String value) {
        switch (value) {
          case 'Color':
            _changeColor(context, isPortrait);
            break;
          case 'Vista':
            _changeView(context, isPortrait);
            break;
          case 'Modo':
            _changeMode(context, isPortrait);
            break;
          // case 'Compartir':
          // _editarSeguimiento(context);
          //   break;
          // case 'Eliminar':
          //   _dialogoEliminar(context);
          //   break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        optionMenu('Color', context, Icons.palette),
        optionMenu('Vista', context, Icons.view_compact),
        optionMenu('Modo', context, Icons.brightness_4),
        // optionMenu('Compartir', context, Icons.share),
        // optionMenu('Eliminar', context, Icons.delete),
      ],
    );
  }
}
