import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';

class ProductListTile extends StatefulWidget {
  const ProductListTile(this.product);

  final Product product;

  @override
  _ProductListTileState createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {

  bool favIcon = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/product", arguments: widget.product);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              if (widget.product.images.isNotEmpty)
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.product.images.first,
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
                  ),
                ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                    widget.product.name,
                    textScaleFactor: 1.1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Mais informações >>>",
                      textScaleFactor: 1.1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  /*const Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Entrada:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if(product.basePrice == 0)
                    Text("Grátis",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                  if(product.basePrice != 0)
                    Text(
                    "R\$: ${product.basePrice.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                    ),
                  ),*/
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
