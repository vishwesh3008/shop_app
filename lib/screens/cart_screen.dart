import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const namedRoute = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart!'),
      ),
      body: Column(
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          'Rs${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  // ignore: deprecated_member_use
                                  .title
                                  .color),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      OrderButton(cart: cart)
                    ]),
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => ci.CartItem(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price,
                    )),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
