import 'package:flutter/material.dart';

enum ListMenuItem {
  Delete,
}

class ListPopUpMenu extends StatelessWidget {
  final ValueChanged<ListMenuItem> onSelected;
  const ListPopUpMenu({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ListMenuItem>(
      onSelected: onSelected,
      itemBuilder: (context) {
        return ListMenuItem.values
            .map<PopupMenuEntry<ListMenuItem>>(
              (item) => PopupMenuItem(
                child: Text(
                  item.toString().split('.')[1],
                ),
                value: item,
              ),
            )
            .toList();
      },
    );
  }
}
