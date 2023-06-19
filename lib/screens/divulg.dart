import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class Contato extends StatelessWidget {
  Future<void> _launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false, forceSafariVC: false);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "Mais Informações",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xffff8c00),
        centerTitle: true,
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/contato.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
    );
  }
}
