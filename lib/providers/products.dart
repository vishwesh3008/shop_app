import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authtoken;
  final String userId;
  Products(this.authtoken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    final url =
        'https://flutter-a84dd.firebaseio.com/products.json?auth=$authtoken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      if (extractedData == null) {
        return;
      }
      final url1 =
          'https://flutter-a84dd.firebaseio.com/userFavorites/$userId.json?auth=$authtoken';
      final favoriteResponse = await http.get(url1);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedData.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false),
        );
      });

      _items = loadedData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-a84dd.firebaseio.com/products.json?auth=$authtoken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String prodId, Product newProd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == prodId);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-a84dd.firebaseio.com/products/$prodId.json?auth=$authtoken';
      await http.patch(url,
          body: json.encode({
            'title': newProd.title,
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
          }));
      _items[prodIndex] = newProd;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-a84dd.firebaseio.com/products/$id.json?auth=$authtoken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("could not delete product");
    }
    existingProduct = null;
  }
}
