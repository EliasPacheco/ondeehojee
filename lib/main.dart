import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loja/login/cadastro_screen.dart';
import 'package:loja/login/login_screen.dart';
import 'package:loja/models/admin_manager_user.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/orders_manager.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/stores_manages.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/base_screen.dart';
import 'package:loja/screens/edit_product_screen.dart';
import 'package:loja/screens/product_screen.dart';
import 'package:loja/screens/select_product_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
          ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
          ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
          ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) => 
          ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) => 
            adminUsersManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'Onde é hoje?',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color(0xffff6d00),
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/login":
              return MaterialPageRoute(
                builder: (_) => LoginScreen(),
              );
            case "/cadastro":
              return MaterialPageRoute(
                builder: (_) => SignUpScren(),
              );
            case "/select_product":
              return MaterialPageRoute(
                builder: (_) => SelectedProductScreen(),
              );
            case "/product":
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  settings.arguments as Product
                ),
              );
              case "/edit_product":
              return MaterialPageRoute(
                builder: (_) => EditProductScreen(
                  settings.arguments as Product
                ),
              );
            case "/":
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
