

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/section.dart';
import 'package:loja/models/section_item.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.item);

  final SectionItem item;

  @override
  Widget build(BuildContext context) {

    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: (){
        if(item.product != null){
          final product = context.read<ProductManager>()
            .findProductById(item.product);
          if(product != null){
            Navigator.of(context).pushNamed("/product", arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing ? () {
        showDialog(
          context: context,
          builder: (_){
            final product = context.read<ProductManager>()
              .findProductById(item.product);
            return AlertDialog(
              title: const Text("Editar Item"),
              content: product != null 
              ? ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.network(product.images.first),
                // ignore: prefer_const_constructors
                title: Text(product.name, style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900
                ),),
                // ignore: prefer_const_constructors
                subtitle: Text("R\$ ${product.basePrice.toStringAsFixed(2)}", style: TextStyle(
                  color: Colors.black, fontSize: 16
                ),),
              ) 
              : null,
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    context.read<Section>().removeItem(item);
                    Navigator.of(context).pop();
                  }, 
                  textColor: Colors.red,
                  child: const Text("Excluir"),
                  ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () async{
                    if(product != null){
                      item.product = null;
                    } else{
                      final Product product = 
                        await Navigator.of(context).pushNamed("/select_product") as Product;
                      item.product = product?.id;

                    }
                    Navigator.of(context).pop();
                  }, 
                  child: Text(
                    product != null 
                      ? "Desvincular"
                      : "Vincular"
                  )
                  )
              ],
            );
          }
          );
      } : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String ?
        FadeInImage.assetNetwork(
          placeholder: 'assets/load.gif', 
          image: item.image as String,
          fit: BoxFit.cover,
          imageErrorBuilder: (BuildContext context, Object error, StackTrace stackTrace) =>
          Image.asset("assets/loading.gif"),
          )
          : Image.file(item.image as File, fit: BoxFit.cover),
      ),
    );
  }
}
