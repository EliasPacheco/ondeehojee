import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/products_list_tile.dart';
import 'package:loja/screens/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

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
        title: Consumer<ProductManager>(builder: (_, productManager, __) {
          if (productManager.search.isEmpty) {
            return const Text("Locais");
          } else {
            return LayoutBuilder(
              builder: (_, constraints) {
                return GestureDetector(
                  onTap: () async {
                    final search = await showDialog<String>(
                        context: context, builder: (_) => SearchDialog(
                          productManager.search
                        ));

                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                  child: Container(
                    width: constraints.biggest.width,
                   child: Text(productManager.search,
                    textAlign: TextAlign.center,
                   ),
                  )
                );
              },
            );
          }
        }
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context, builder: (_) => SearchDialog(
                          productManager.search
                        ));

                    if (search != null) {
                      productManager.search = search;
                    }
                  });
            } else {
              return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    productManager.search = "";
                  });
            }
          },
          ),
          Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled){
                  return IconButton(
                    icon: const Icon(Icons.add), 
                    onPressed: (){
                      Navigator.of(context).pushNamed("/edit_product");
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
        ],
        backgroundColor: const Color(0xffff8c00),
      ),
      body: Container(
        decoration: const BoxDecoration(
              // ignore: unnecessary_const
              gradient: LinearGradient(colors: const [
                Color(0xffff8c00),
                Color(0xfff57c00)
                
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
        child: Consumer<ProductManager>(builder: (_, productManager, __) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                return ProductListTile(filteredProducts[index]);
              });
        }),
      ),
    );
  }

  // ignore: always_declare_return_types
  _checkInternet() async{
    final result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      showNotification(
        "Sem conexão com a internet", 
        "Você está sem conexão com a internet, conecte-se a uma rede e entre novamente na aba Produtos para continuar e ver os locais", 
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
