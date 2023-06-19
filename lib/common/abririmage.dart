import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';
import 'package:provider/provider.dart';

class Abrirmage extends StatefulWidget {
  const Abrirmage(this.product);

  final Product product;

  @override
  _AbrirmageState createState() => _AbrirmageState();
}

class _AbrirmageState extends State<Abrirmage> {

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.name),
          centerTitle: true,
          backgroundColor: const Color(0xffff8c00),
        ),
        backgroundColor: Colors.black,
        body: ChangeNotifierProvider.value(
          value: widget.product,
          child: InteractiveViewer(
            child: Carousel(
              boxFit: BoxFit.contain,
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
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
        ));
  }

  _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showNotification(
        "Sem conexão com a internet",
        "Você está sem conexão com a internet, conecte-se a uma rede e entre novamente na aba Produtos para continuar e ver os locais",
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
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.wifi_off,
        color: Colors.white,
      ),
    ).show(context);
  }
}
