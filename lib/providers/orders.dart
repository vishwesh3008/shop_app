import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authtoken;
  final String userId;

  Orders(this.authtoken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-a84dd.firebaseio.com/orders/$userId.json?auth=$authtoken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ));

    notifyListeners();
  }

  Future<void> fetchAndSet() async {
    final url =
        'https://flutter-a84dd.firebaseio.com/orders/$userId.json?auth=$authtoken';
    final response = await http.get(url);
    final List<OrderItem> loadedorders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedorders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((items) => CartItem(
                  id: items['id'],
                  title: items['title'],
                  quantity: items['quantity'],
                  price: items['price']))
              .toList(),
        ),
      );
    });
    _orders = loadedorders.reversed.toList();
    notifyListeners();
  }

  int orderCount() {
    return orders.length;
  }
}
