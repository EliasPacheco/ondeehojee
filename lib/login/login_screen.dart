import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:loja/validators/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controllerEmail = TextEditingController();
  final _controllerSenha = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  // ignore: type_annotate_public_apis
  var blueColor = const Color(0xFFF090e42);

  @override
  void initState(){
    super.initState();
    _checkInternet();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
          key: _formKey,
          child: Consumer<UserManager>(builder: (_, userManager, __) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/degrade.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              
              padding: const EdgeInsets.all(18),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 150),
                      child: TextFormField(
                        controller: _controllerEmail,
                        enabled: !userManager.loading,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email) {
                          if (!emailValid(email)) return "E-mail inválido";
                          return null;
                        },
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _controllerSenha,
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      // ignore: avoid_bool_literals_in_conditional_expressions
                      obscureText: _showPassword == false ? true : false,
                      validator: (pass) {
                        if (pass.isEmpty || pass.length < 5)
                          return "Senha inválida";
                        return null;
                      },
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        // ignore: sort_child_properties_last
                        suffixIcon: GestureDetector(child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.black,),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          if(_controllerEmail.text.isEmpty)
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(
                              
                              const SnackBar(content: Text("Insira seu e-mail para recuperação!"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            else {
                              userManager.recoverPass(_controllerEmail.text);
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: const Text("Confira seu e-mail"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }, 
                        // ignore: sort_child_properties_last
                        child: const Text("Esqueci minha senha",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 10),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                          // ignore: sort_child_properties_last
                          child: userManager.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  "Entrar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                          color: Colors.black,
                          disabledColor: Colors.black.withAlpha(180),
                          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          textColor: Colors.white,
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (_formKey.currentState.validate()) {
                                    userManager.signIn(
                                        user: User(
                                            email: _controllerEmail.text,
                                            senha: _controllerSenha.text),
                                        onFail: (e) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                            content: Text("$e"),
                                            backgroundColor: Colors.blue,
                                            
                                          ));
                                        },
                                        onSucess: () {
                                          Navigator.of(context).pop();
                                        });
                                  }
                                }
                              ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: GestureDetector(
                        // ignore: sort_child_properties_last
                        child: const Text(
                          "Não tem uma conta? Cadastre-se!",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed("/cadastro");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
  _checkInternet() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      showNotification(
        "Sem conexão com a internet", 
        "Você está sem conexão com a internet, conecte-se a uma para continuar com seu login."
        );
    }
  }

  void showNotification(String title, String message){
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.wifi_off, color: Colors.white,),
    ).show(context);
  }
}
