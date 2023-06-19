import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loja/common/abririmage.dart';
import 'package:loja/common/custom_icon_buttom.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/size_widget.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  bool favIcon = false;

  @override
  Widget build(BuildContext context) {
    void showError() {
      // ignore: prefer_const_constructors
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            const Text("Esta função não está disponível neste dispositivo"),
        backgroundColor: Colors.red,
      ));
    }

    Future<void> _launchLink(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: false, forceSafariVC: false);
      } else {}
    }

    Future<void> openPhone() async {
      if (await canLaunch("tel:${widget.product.telefone}")) {
        launch("tel:${widget.product.telefone}");
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
                          coords:
                              Coords(widget.product.lat, widget.product.long),
                          title: widget.product.name,
                          description:
                              "${widget.product.rua}, ${widget.product.numero}\n${widget.product.bairro}\n${widget.product.cidade}");
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

    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: widget.product,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.product.name),
          backgroundColor: const Color(0xffff8c00),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.isLoggedIn) {
                    return GestureDetector(
                      onTap: () {
                        if (favIcon == false) _checkFavoritefalse();
                        if (favIcon == true) _checkFavoritetrue();

                        setState(() {
                          favIcon = !favIcon;
                        });
                      },
                      child: Icon(
                        favIcon == false
                            ? Icons.favorite_border_rounded
                            : Icons.favorite,
                        color: Colors.white,
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled && !widget.product.deleted) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          "/edit_product",
                          arguments: widget.product);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Abrirmage(widget.product)));
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: Carousel(
                  images: widget.product.images.map((url) {
                    return Image.network(
                      url,
                      errorBuilder: (BuildContext context, Object error,
                              StackTrace stackTrace) =>
                          Image.asset("assets/loading.gif"),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    );
                  }).toList(),
                  dotSize: 4,
                  dotSpacing: 15,
                  dotBgColor: Colors.transparent,
                  dotColor: primaryColor,
                  autoplay: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Bem vindo ao ${widget.product.name}",
                      textScaleFactor: 1.3,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Horário de Funcionamento:",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                      onPressed: () {
                        _abrirDialogo(context);
                      },
                      // ignore: sort_child_properties_last
                      child: const Text(
                        "Horários",
                        textScaleFactor: 1.1,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: const Color(0xffff6d00),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Descrição:",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Text(
                    "${widget.product.description}\n\nRede Social:",
                    textScaleFactor: 1.1,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchLink(widget.product.instagram);
                    },
                    child: Text(
                      "@${widget.product.ig}",
                      textScaleFactor: 1.1,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.product.deleted)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 22, bottom: 8),
                        child: Text(
                          "Local Indisponível",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                      ),
                    )
                  else ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        "Preços:",
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    if (widget.product.sizes.isNotEmpty)
                      Wrap(
                          spacing: 2,
                          runSpacing: 4,
                          children: widget.product.sizes.map((s) {
                            return SizeWidget(size: s);
                          }).toList()),
                    if (widget.product.sizes.isEmpty)
                      const Text("Este local preferiu não informar os preços",
                          textScaleFactor: 1.2,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        "Endereço:",
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    if (widget.product.rua.isNotEmpty &&
                        widget.product.numero.isNotEmpty)
                      Text(
                          "${widget.product.rua}, ${widget.product.numero}\n${widget.product.bairro}\n${widget.product.cidade} - PI\n${widget.product.complemento}",
                          textScaleFactor: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    if (widget.product.lat == null &&
                        widget.product.long == null)
                      const Text("Este local não possui ponto físico",
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    if (widget.product.lat != null &&
                        widget.product.long != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: openMap,
                            child: const Text(
                              "Localização",
                              textScaleFactor: 1.1,
                              // ignore: unnecessary_const
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 19,
                              ),
                            ),
                          ),
                          CustomIconButton(
                            iconData: Icons.map,
                            color: primaryColor,
                            onTap: openMap,
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: openPhone,
                          child: const Text(
                            "Clique para ligar",
                            textScaleFactor: 1.1,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.phone,
                          color: primaryColor,
                          onTap: openPhone,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _abrirDialogo(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Horário de Funcionamento:"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text(
                      "Seg: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario.isNotEmpty)
                      Text(
                        "${widget.product.horario}-${widget.product.horario5}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Ter: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario1.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario1.isNotEmpty)
                      Text(
                        "${widget.product.horario1}-${widget.product.horario6}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Qua: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario2.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario2.isNotEmpty)
                      Text(
                        "${widget.product.horario2}-${widget.product.horario7}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Qui: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario3.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario3.isNotEmpty)
                      Text(
                        "${widget.product.horario3}-${widget.product.horario8}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Sex: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario4.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario4.isNotEmpty)
                      Text(
                        "${widget.product.horario4}-${widget.product.horario9}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Sab: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario10.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario10.isNotEmpty)
                      Text(
                        "${widget.product.horario10}-${widget.product.horario11}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Dom: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textScaleFactor: 1,
                    ),
                    if (widget.product.horario12.isEmpty)
                      const Text(
                        "Fechado",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    if (widget.product.horario12.isNotEmpty)
                      Text(
                        "${widget.product.horario12}-${widget.product.horario13}",
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                  ],
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        });
  }

  // ignore: always_declare_return_types
  _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showNotification(
        "Sem conexão com a internet",
        "Você está sem conexão com a internet, conecte-se a uma rede e entre novamente na aba Produtos para continuar e ver os locais",
      );
    }
  }

  _checkFavoritefalse() async {
    if (favIcon == false) {
      showNotificationfalse(
        widget.product.name,
        "Favoritado com sucesso",
      );
    }
  }

  _checkFavoritetrue() async {
    if (favIcon == true) {
      showNotificationtrue(
        widget.product.name,
        "removido dos favoritos!",
      );
    }
  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.wifi_off,
        color: Colors.white,
      ),
    ).show(context);
  }

  void showNotificationfalse(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.favorite,
        color: Colors.white,
      ),
    ).show(context);
  }

  void showNotificationtrue(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.favorite_outline_outlined,
        color: Colors.white,
      ),
    ).show(context);
  }
}
