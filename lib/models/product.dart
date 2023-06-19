import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product(
      {this.id,
      this.name,
      this.description,
      this.horario,
      this.horario1,
      this.horario2,
      this.horario3,
      this.horario4,
      this.horario5,
      this.horario6,
      this.horario7,
      this.horario8,
      this.horario9,
      this.horario10,
      this.horario11,
      this.horario12,
      this.horario13,
      this.bairro,
      this.cidade,
      this.complemento,
      this.estado,
      this.numero,
      this.rua,
      this.telefone,

      this.lat,
      this.long,

      this.instagram,
      this.ig,

      this.images,
      this.sizes,
      this.deleted = false}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document["name"] as String;
    description = document["description"] as String;
    horario = document["horario"] as String;
    horario1 = document["horario1"] as String;
    horario2 = document["horario2"] as String;
    horario3 = document["horario3"] as String;
    horario4 = document["horario4"] as String;
    horario5 = document["horario5"] as String;
    horario6 = document["horario6"] as String;
    horario7 = document["horario7"] as String;
    horario8 = document["horario8"] as String;
    horario9 = document["horario9"] as String;
    horario10 = document["horario10"] as String;
    horario11 = document["horario11"] as String;
    horario12 = document["horario12"] as String;
    horario13 = document["horario13"] as String;
    rua = document["rua"] as String;
    numero = document["numero"] as String;
    telefone = document["telefone"] as String;
    complemento = document["complemento"] as String;
    bairro = document["bairro"] as String;
    cidade = document["cidade"] as String;
    estado = document["estado"] as String;

    lat = document["lat"] as double;
    long = document["long"] as double;

    instagram = document["instagram"] as String;
    ig = document["ig"] as String;

    images = List<String>.from(document.data["images"] as List<dynamic>);
    
    deleted = (document.data["deleted"] ?? false) as bool;
    sizes = (document.data["sizes"] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document("products/$id");
  StorageReference get storageRef => storage.ref().child("products").child(id);

  String rua;
  String numero;
  String telefone;
  String complemento;
  String bairro;
  String cidade;
  String estado;

  String instagram;
  String ig;

  String id;
  String name;
  String description;
  String horario;
  String horario1;
  String horario2;
  String horario3;
  String horario4;
  String horario5;
  String horario6;
  String horario7;
  String horario8;
  String horario9;
  String horario10;
  String horario11;
  String horario12;
  String horario13;

  double lat;
  double long;

  List<String> images;
  List<ItemSize> sizes;

  bool deleted;

  List<dynamic> newImages = [];

  bool _loading = false;
  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest) lowest = size.price;
    }
    return lowest;
  }

  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "horario": horario,
      "horario1": horario1,
      "horario2": horario2,
      "horario3": horario3,
      "horario4": horario4,
      "horario5": horario5,
      "horario6": horario6,
      "horario7": horario7,
      "horario8": horario8,
      "horario9": horario9,
      "horario10": horario10,
      "horario11": horario11,
      "horario12": horario12,
      "horario13": horario13,
      "rua": rua,
      "telefone": telefone,
      "bairro": bairro,
      "complemento": complemento,
      "cidade": cidade,
      "estado": estado,
      "numero": numero,

      "lat": lat,
      "long": long,

      "instagram": instagram,
      "ig": ig,
      
      "sizes": exportSizeList(),
      "deleted": deleted,
    };

    if (id == null) {
      final doc = await firestore.collection("products").add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    final List<String> updateImages = [];

      for (final newImage in newImages ?? []) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      
      }
    }
    
      for (final image in images) {
      // ignore: null_aware_in_logical_operator
      if (!newImages?.contains(image) ?? false ) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e) {
          debugPrint("Falha ao deletar $image");
        }
      }
    }


    await firestoreRef.updateData({"images": updateImages});

    images = updateImages;

    loading = false;
  }

  void delete() {
    firestoreRef.updateData({"deleted": true});
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      horario: horario,
      horario1: horario1,
      horario2: horario2,
      horario3: horario3,
      horario4: horario4,
      horario5: horario5,
      horario6: horario6,
      horario7: horario7,
      horario8: horario8,
      horario9: horario9,
      horario10: horario10,
      horario11: horario11,
      horario12: horario12,
      horario13: horario13,
      rua: rua,
      telefone: telefone,
      bairro: bairro,
      cidade: cidade,
      complemento: complemento,
      estado: estado,
      numero: numero,

      lat: lat,
      long: long,

      instagram:instagram,
      ig: ig,

      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return "Product{id: $id, name: $name, description: $description,horario: $horario, horario1: $horario1, horario2: $horario2, horario3: $horario3, horario4: $horario4, horario5: $horario5, horario6: $horario6, horario7: $horario7, horario8: $horario8, horario9: $horario9, horario10: $horario10, horario11: $horario11, horario12: $horario12, horario13: $horario13, rua: $rua, telefone: $telefone, bairro: $bairro, cidade: $cidade, numero: $numero, estado: $estado, complemento: $complemento,lat: $lat, long: $long,instagram: $instagram,ig: $ig, images: $images, sizes: $sizes, newImages: $newImages}";
  }
}
