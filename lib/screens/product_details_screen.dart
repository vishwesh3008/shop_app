import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const namedRoute = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 300,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Rs${loadedProduct.price}',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              cart.addItem(
                  loadedProduct.id, loadedProduct.title, loadedProduct.price);
              Navigator.of(context).pushReplacementNamed(CartScreen.namedRoute);
            },
            child: Text('Buy'),
            elevation: 5,
            color: Colors.indigo[500],
            visualDensity: VisualDensity(horizontal: 1.0),
          )
        ]),
      ),
    );
  }
}
