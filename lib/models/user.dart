import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loja/models/product.dart';
import 'package:loja/screens/address.dart';

class User{

  User({this.email, this.senha, this.name, this.id,this.favoritesProducts});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data["nome"] as String;
    email = document.data["email"] as String;
    favoritesProducts = document.data["favoritesProducts"] as List<String>;

    if(document.data.containsKey("address")){
      address = Address.fromMap(
        document.data["address"] as Map<String, dynamic>);
    }
  }

  String id;
  String name;
  String email;
  String cpf;
  String senha;

  List<String> favoritesProducts = [];

  String confirmPassword;

  bool admin = false;

  Address address;

  List<Product> allProducts = [];

  DocumentReference get firestoreRef => 
    Firestore.instance.document("users/$id");

  CollectionReference get cartReference =>
    firestoreRef.collection("cart");
  
  CollectionReference get tokensReference =>
    firestoreRef.collection("tokens");

  Future<void> saveData() async{
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      "nome" : name,
      "email" : email,
      "favoritesProducts": favoritesProducts,
      if(address != null)
        'address': address.toMap(),
    };
  }

  Future<void> saveToken() async{
    final token = await FirebaseMessaging().getToken();
    await tokensReference.document(token).setData({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }
}