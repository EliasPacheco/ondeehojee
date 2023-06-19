import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/user.dart';


class OrdersManager extends ChangeNotifier{

  User user;


  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateUser(User user){
    this.user = user;

    _subscription?.cancel();
    if(user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection("orders").where("user", isEqualTo: user.id).snapshots().listen((event) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

}