import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/badge.dart';

import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  List<Map<String, Object>> pages;
  int selectedPageIndex = 0;
  @override
  void initState() {
    pages = [
      {
        'title': 'Showall',
        'value': FilterOptions.All,
      },
      {
        'title': 'Favorites',
        'value': FilterOptions.Favorites,
      },
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void selectPage(int index) {
    selectedPageIndex = index;
    setState(() {
      if (pages[selectedPageIndex]['value'] == FilterOptions.Favorites) {
        _showFavoritesOnly = true;
      } else {
        _showFavoritesOnly = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.namedRoute);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavoritesOnly),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: selectedPageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text('Showall')),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), title: Text('Favorite')),
          ]),
    );
  }
}
