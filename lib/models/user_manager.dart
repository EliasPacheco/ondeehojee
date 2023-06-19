import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loja/models/user.dart';
import 'package:loja/validators/firebase_error.dart';

class UserManager extends ChangeNotifier{

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;
   set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn({User user, Function onFail, Function onSucess}) async{
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
        email: user.email, password: user.senha);

      await _loadCurrentUser(firebaseUser: result.user);
      
      onSucess();

    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp({User user, Function onFail, Function onSucess}) async{
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
      email: user.email, password: user.senha);

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();
      
      user.saveToken();

      onSucess();

    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  void recoverPass(String email){
    auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async{
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection("users")
        .document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      user.saveToken();

      final docAdmin = await firestore.collection("admins").document(user.id).get();
      if(docAdmin.exists){
        user.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;

}