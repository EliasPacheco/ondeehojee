import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/validators/validators.dart';
import 'package:provider/provider.dart';

class SignUpScren extends StatefulWidget {
  @override
  _SignUpScrenState createState() => _SignUpScrenState();
}

class _SignUpScrenState extends State<SignUpScren> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  bool _showPassword = false;

  @override
  void initState(){
    super.initState();
    _checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Cadastro", style: TextStyle(fontWeight: FontWeight.w900),),
        backgroundColor: const Color(0xffffa000),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Consumer<UserManager>(
            builder: (_, userManager, __) {
              return Container(
                decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/degrade.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView (
                  padding: const EdgeInsets.only(bottom:16, top: 210, left: 16,right: 32),
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Nome e Sobrenome",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                    enabled: !userManager.loading,
                    validator: (name) {
                      if (name.isEmpty)
                        return "Campo Obrigatório";
                      else if (name.trim().split(" ").length <= 1)
                        return "Preencha seu Nome e Sobrenome";
                      return null;
                    },
                    onSaved: (name) => user.name = name,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    enabled: !userManager.loading,
                    validator: (email) {
                      if (email.isEmpty)
                        return "Campo Obrigatório";
                      else if (!emailValid(email)) return "E-mail inválido";
                      return null;
                    },
                    onSaved: (email) => user.email = email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha", hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                      suffixIcon: GestureDetector(
                        // ignore: sort_child_properties_last
                        child: Icon(
                          _showPassword == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white
                    ),
                    enabled: !userManager.loading,
                    // ignore: avoid_bool_literals_in_conditional_expressions
                    obscureText: _showPassword == false ? true : false,
                    validator: (pass) {
                      if (pass.isEmpty)
                        return "Campo Obrigatório";
                      else if (pass.length < 6)
                        return "Preencha com no mínimo 6 caracteres";
                      return null;
                    },
                    onSaved: (senha) => user.senha = senha,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Repita a Senha", hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                      suffixIcon: GestureDetector(
                        // ignore: sort_child_properties_last
                        child: Icon(
                          _showPassword == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    enabled: !userManager.loading,
                    // ignore: avoid_bool_literals_in_conditional_expressions
                    obscureText: _showPassword == false ? true : false,
                    validator: (pass) {
                      if (pass.isEmpty)
                        return "Campo Obrigatório";
                      else if (pass.length < 6)
                        return "Preencha com no mínimo 6 caracteres";
                      return null;
                    },
                    onSaved: (senha) => user.confirmPassword = senha,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        color: Colors.black,
                        disabledColor: Colors.black.withAlpha(180),
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                        textColor: Colors.black,
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  if (user.senha != user.confirmPassword) {
                                    // ignore: deprecated_member_use
                                    _scaffoldKey.currentState.showSnackBar(
                                      // ignore: prefer_const_constructors
                                      SnackBar(
                                        content:
                                            const Text("Senhas não coincidem!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  userManager.signUp(
                                      user: user,
                                      onSucess: () {
                                        Navigator.of(context).pop();
                                      },
                                      onFail: (e) {
                                        _scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            .showSnackBar(SnackBar(
                                          content: Text("$e"),
                                          backgroundColor: Colors.blue,
                                        ));
                                      });
                                }
                              },
                        child: userManager.loading
                            // ignore: prefer_const_constructors
                            ? CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                "Criar Conta",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              ),
                      ),
                    ),
                  ),
                ],
                ),
              );
            },
          )),
    );
  }
  
  _checkInternet() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      showNotification(
        "Sem conexão com a internet", 
        "Você está sem conexão com a internet, conecte-se a uma para continuar e criar sua conta."
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
