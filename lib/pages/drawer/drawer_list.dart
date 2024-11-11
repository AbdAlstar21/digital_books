// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  final String drawer_name;
  final Icon drawer_icon_leading;
  final Icon? drawer_icon_trailing;
  const DrawerList({
    required this.drawer_name,
    required this.drawer_icon_leading,
    this.drawer_icon_trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: ListTile(
                title: Text(drawer_name,
                    style: const TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 15,
                        color: Colors.black)),
                leading: drawer_icon_leading,
                trailing: drawer_icon_trailing),
          ),
          Divider(
            color: Colors.grey[500],
          )
        ],
      ),
    );
  }
}
