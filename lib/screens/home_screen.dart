import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer.dart';
import 'package:loja/models/add_section_widget.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/section_list.dart';
import 'package:loja/screens/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();

    _checkInternet();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              // ignore: unnecessary_const
              gradient: LinearGradient(colors: const [
                Color(0xffff8c00),
                Color(0xfff57c00)
                
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text("Novidades"),
                  centerTitle: true,
                ),
                actions: <Widget>[
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __) {
                      if (userManager.adminEnabled && !homeManager.loading) {
                        if (homeManager.editing) {
                          return PopupMenuButton(
                            onSelected: (e) {
                              if(e == "Salvar"){
                                homeManager.saveEditing();
                              } else{
                                homeManager.discardEditing();
                              }
                            },
                            itemBuilder: (_){
                              return ["Salvar", "Descartar"].map((e){
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            } 
                            );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: homeManager.enterEditing,
                          );
                        }
                      } else
                        return Container();
                    },
                  )
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {

                  if(homeManager.loading){
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white),
                          backgroundColor: Colors.transparent,
                      ),
                    );
                  }

                  final List<Widget> children =
                      homeManager.sections.map<Widget>((section) {
                    switch (section.type) {
                      case "List":
                        return SectionList(section);
                      case "Staggered":
                        return SectionStaggered(section);
                      default:
                        return Container();
                    }
                  }).toList();
                  if(homeManager.editing)
                    children.add(AddSectionWidget(homeManager));

                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  // ignore: always_declare_return_types
  _checkInternet() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      showNotification(
        "Sem conexão com a internet", 
        "Você está sem conexão com a internet, conecte-se a uma rede e entre novamente na aba Home para continuar e ver as propagandas"
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
