import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer.dart';
import 'package:loja/models/stores_manages.dart';
import 'package:loja/screens/store_card.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatefulWidget {
  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {

  @override
  void initState() {
    super.initState();

    _checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("Lojas"),
        centerTitle: true,
        backgroundColor: const Color(0xffff6d00),
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __){
          if(storesManager.stores.isEmpty){
            return const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white,),
              backgroundColor: Colors.transparent,
            );
          }
          return ListView.builder(
            itemCount: storesManager.stores.length,
            itemBuilder: (_, index){
              return StoreCard(storesManager.stores[index]);
            }
            );
        },
      ),
    );
  }

  _checkInternet() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      showNotification(
        "Sem conexão com a internet", 
        "Você está sem conexão com a internet, conecte-se a uma rede e entre novamente na aba Lojas para continuar e ver as lojas", 
        );
    }
  }

  void showNotification(String title, String message){
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.wifi_off, color: Colors.white,),
    ).show(context);
  }
}