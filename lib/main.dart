import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import 'package:shop_app/screens/user_products_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousProducts) => Orders(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.orders,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.red,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailsScreen.namedRoute: (ctx) => ProductDetailsScreen(),
              CartScreen.namedRoute: (ctx) => CartScreen(),
              OrdersScreen.namedRoute: (ctx) => OrdersScreen(),
              UserProductsScreen.namedRoute: (ctx) => UserProductsScreen(),
              EditProductScreen.namedRoute: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
