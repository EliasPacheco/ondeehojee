import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/store.dart';

class StoresManager extends ChangeNotifier{

  StoresManager(){
    _loadStoreList();
    _startTimer();
  }

  List<Store> stores = [];

  Timer _timer;

  final Firestore firestore = Firestore.instance;

  Future<void> _loadStoreList() async{

    final snapshot = await firestore.collection("stores").getDocuments();

    stores = snapshot.documents.map((e) => Store.fromDocument(e)).toList();

    notifyListeners();

  }

  void _startTimer(){
    Timer.periodic(const Duration(minutes: 0), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening(){
    for(final store in stores)
      store.updateStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

}



