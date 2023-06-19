import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';
import 'package:loja/screens/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product, this.onSave);

  final Product product;

  final Function(List<dynamic> images) onSave;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images.isEmpty) return "Insira uma imagem";
        return null;
      },
      onSaved: onSave,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          
          state.didChange(state.value);
          onSave(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(image as File, fit: BoxFit.cover),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Excluir"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: <Widget>[
                                            const Text(
                                                "Deseja excluir esta foto?")
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          // ignore: sort_child_properties_last
                                          child: const Text(
                                            "Não",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            state.value.remove(image);
                                            state.didChange(state.value);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Sim",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ))
                    ],
                  );
                }).toList()
                  ..add(Material(
                    color: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      color: Theme.of(context).primaryColor,
                      iconSize: 50,
                      onPressed: () {
                        if (Platform.isAndroid)
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => ImageSourceSheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                        else
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => ImageSourceSheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                      },
                    ),
                  )),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
          ],
        );
      },
    );
  }
}
