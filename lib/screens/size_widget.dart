import 'package:flutter/material.dart';
import 'package:loja/models/item_size.dart';
import 'package:loja/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({this.size});

  final ItemSize size;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;

    Color color;
    if (selected)
      color = Colors.blue;
    else
      color = const Color(0xffff6d00);

    return GestureDetector(
      onTap: () {
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            color: color,
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Text(
              size.name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          if(size.price == 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Gratis",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          if(size.price != 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "R\$ ${size.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
        ]),
      ),
    );
  }
}
