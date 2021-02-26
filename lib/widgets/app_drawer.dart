import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';

import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final admin = '7ZQj9L6wN9Tpa1WsRMki9fHLsYF3';
    print(auth.userId);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.namedRoute);
            },
          ),
          (auth.userId == admin)
              ? Column(children: <Widget>[
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Manage Products'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserProductsScreen.namedRoute);
                    },
                  ),
                ])
              : SizedBox(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
