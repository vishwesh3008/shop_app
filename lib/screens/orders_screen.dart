import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const namedRoute = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    print("printing Orders");
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null) {
              return Center(
                child: Text('There is a Error'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, _) => ListView.builder(
                  itemCount: ordersData.orderCount(),
                  itemBuilder: (ctx, i) => OrderItems(ordersData.orders[i]),
                ),
              );
            }
          }),
    );
  }
}
