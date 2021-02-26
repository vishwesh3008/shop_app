import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItems extends StatefulWidget {
  final OrderItem order;
  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Rs${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            ),
          ),
          if (_expanded)
            Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                height: min(widget.order.products.length * 20.0 + 30.0, 100),
                child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${prod.quantity} x Rs${prod.price}')
                            ],
                          ))
                      .toList(),
                )),
        ],
      ),
    );
  }
}
