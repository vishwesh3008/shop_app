import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const namedRoute = '/user-product-screen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.namedRoute);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (ctx, i) => Column(children: <Widget>[
              UserProductItem(productData.items[i].title,
                  productData.items[i].imageUrl, productData.items[i].id),
              Divider(),
            ]),
          ),
        ),
      ),
    );
  }
}
