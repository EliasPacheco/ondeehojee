import 'package:flutter/material.dart';
import 'package:loja/common/custom_icon_buttom.dart';
import 'package:loja/models/store.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {
  const StoreCard(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    Color colorForStatus(StoreStatus status) {
      switch (status) {
        case StoreStatus.closed:
          return Colors.red;
        case StoreStatus.open:
          return Colors.green;
        case StoreStatus.closing:
          return Colors.blue;
        default:
          return Colors.green;
      }
    }
    
    void showError(){
      // ignore: deprecated_member_use
      // ignore: prefer_const_constructors
      Scaffold.of(context).showSnackBar(SnackBar(
          content:
              const Text("Esta função não está disponível neste dispositivo"),
          backgroundColor: Colors.red,
        )
      );
    }

    Future<void> openPhone() async {
      if (await canLaunch("tel:${store.cleanPhone}")) {
        launch("tel:${store.cleanPhone}");
      } else {
        showError();
      }
    }

    Future<void> openMap() async {
      try {
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
          context: context,
          builder: (_) {
            return SafeArea(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final map in availableMaps)
                  ListTile(
                    onTap: () {
                      map.showMarker(
                      coords: Coords(store.address.lat, store.address.long), 
                      title: store.name, 
                      description: store.addressText,
                      );
                      Navigator.of(context).pop();
                    },
                    title: Text(map.mapName),
                    leading: Image(
                      image: map.icon,
                      width: 30,
                      height: 30,
                    ),
                  )
              ],
            ));
          },
        );
      } catch (e) {
        showError();
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(
                store.image,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8))),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    store.statusText,
                    style: TextStyle(
                      color: colorForStatus(store.status),
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        store.addressText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Text(
                        store.openingText,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomIconButton(
                      iconData: Icons.map,
                      color: primaryColor,
                      onTap: openMap,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: primaryColor,
                      onTap: openPhone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
