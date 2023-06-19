import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer_header.dart';
import 'package:loja/common/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xfff57c00), 
                      Color(0xffd81b60),
                      ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              const DrawerTile(
                iconData: Icons.notifications_none,
                title: "Novidades",
                page: 0,
              ),
              const DrawerTile(
                  iconData: Icons.location_on_sharp, title: "Locais", page: 1),
              /*const DrawerTile(
                  iconData: Icons.shopping_cart, title: "Lojas", page: 2),*/
              const DrawerTile(
                  iconData: Icons.info_outline_rounded, title: "Informações", page: 2),
              ],
          ),
        ],
      ),
    );
  }
}
