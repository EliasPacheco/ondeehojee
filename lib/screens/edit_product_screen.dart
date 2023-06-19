import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/stores_manages.dart';
import 'package:loja/screens/images_form.dart';
import 'package:loja/screens/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String emptyValidator(String text) =>
      text.isEmpty ? "Campo Obrigatório" : null;
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
          appBar: AppBar(
            title: Text(editing ? "Editar Produto" : "Criar Produto"),
            centerTitle: true,
            key: _scaffoldKey,
            actions: <Widget>[
              if (editing)
                IconButton(
                  icon: const Icon(Icons.delete),
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
                                  const Text("Deseja excluir este produto?")
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
                                  context
                                      .read<ProductManager>()
                                      .delete(product);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Sim",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          );
                        }
                        );
                  },
                )
            ],
          ),
          backgroundColor: Colors.white,
          body: Consumer<StoresManager>(
            builder: (_, storesManager, __) {
              return Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    ImagesForm(product, (images) {
                      product.newImages = images;
                    }),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            initialValue: product.name,
                            decoration: const InputDecoration(
                                hintText: "Título", border: InputBorder.none),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                            validator: (name) {
                              if (name.length < 5) return "Título muito curto";
                              return null;
                            },
                            onSaved: (name) => product.name = name,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Descrição:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                          TextFormField(
                            initialValue: product.description,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            decoration: const InputDecoration(
                              hintText: "Descrição",
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            validator: (desc) {
                              if (desc.length < 5)
                                return "Descrição muito curta";
                              return null;
                            },
                            onSaved: (desc) => product.description = desc,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              "Horário:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Segunda",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour) => product.horario = hour,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario1,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Terça",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour1) =>
                                        product.horario1 = hour1,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario2,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Quarta",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour2) =>
                                        product.horario2 = hour2,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario3,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Quinta",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour3) =>
                                        product.horario3 = hour3,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario4,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Sexta",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour4) =>
                                        product.horario4 = hour4,
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario5,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Segunda",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour5) =>
                                        product.horario5 = hour5,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario6,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Terça",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour6) =>
                                        product.horario6 = hour6,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario7,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Quarta",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour7) =>
                                        product.horario7 = hour7,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario8,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Quinta",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour8) =>
                                        product.horario8 = hour8,
                                  )),
                              const SizedBox(width: 4),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario9,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Sexta",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour9) =>
                                        product.horario9 = hour9,
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario10,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Sábado",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour10) =>
                                        product.horario10 = hour10,
                                  )),
                              const SizedBox(width: 8),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario11,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Sábado",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour11) =>
                                        product.horario11 = hour11,
                                  )),
                              const SizedBox(width: 8),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario12,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Domingo",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour12) =>
                                        product.horario12 = hour12,
                                  )),
                              const SizedBox(width: 8),
                              Expanded(
                                  flex: 30,
                                  child: TextFormField(
                                    initialValue: product.horario13,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                      hintText: "Domingo",
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      HoraInputFormatter()
                                    ],
                                    onSaved: (hour13) =>
                                        product.horario13 = hour13,
                                  )),
                            ],
                          ),
                          SizesForm(product),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Endereço:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                          /*Teste(product),*/
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.rua,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Rua/Avenida:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                    hintText: "Av. Brasil",
                                  ),
                                  onSaved: (rua) => product.rua = rua,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.bairro,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Bairro:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                    hintText: "Jockey",
                                  ),
                                  onSaved: (bai) => product.bairro = bai,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 30,
                                child: TextFormField(
                                  initialValue: product.numero,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      labelText: "Número:",
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                      hintText: "123"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    // ignore: deprecated_member_use
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  onSaved: (ero) => product.numero = ero,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.complemento,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Complemento(Opcional):",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                    hintText: "Próximo ao ...",
                                  ),
                                  onSaved: (comp) => product.complemento = comp,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.telefone,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      labelText: "Telefone:",
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                      hintText: "(DDD) 0000-0000"),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    TelefoneInputFormatter(),
                                  ],
                                  validator: emptyValidator,
                                  onSaved: (tel) => product.telefone = tel,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.cidade,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Cidade:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                    hintText: "Teresina",
                                  ),
                                  onSaved: (cid) => product.cidade = cid,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.estado,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Estado:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                    hintText: "Estado",
                                  ),
                                  onSaved: (est) => product.estado = est,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.lat?.toString(),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Latitude:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  onSaved: (lat) =>
                                      product.lat = double.tryParse(lat),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.long?.toString(),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Longitude:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  onSaved: (long) =>
                                      product.long = double.tryParse(long),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 50,
                                child: TextFormField(
                                  initialValue: product.instagram,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Instagram:",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  validator: emptyValidator,
                                  onSaved: (insta) => product.instagram = insta,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 15,
                                child: TextFormField(
                                  initialValue: product.ig,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Ig:",
                                    prefixText: "@",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  validator: emptyValidator,
                                  onSaved: (ig) => product.ig = ig,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Consumer<Product>(
                            builder: (_, product, __) {
                              return SizedBox(
                                height: 44,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  onPressed: !product.loading
                                      ? () async {
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();

                                            await product.save();

                                            context
                                                .read<ProductManager>()
                                                .update(product);

                                            Navigator.of(context).pop();
                                          }
                                        }
                                      : null,
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  disabledColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(120),
                                  child: product.loading
                                      ? const CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        )
                                      : const Text(
                                          "Salvar",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
