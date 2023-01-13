import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';

import '../providers/cart.dart'
    show Cart; // this is will give us only Cart class
import '../providers/orders.dart';
import '../widgets/cart_item.dart' as ci; // this will name our class as ci

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Spacer(),
                    Chip(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        label: Text(
                          cart.totalAmount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    Spacer(),
                    OrderButton(cart, order),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, i) {
                return ci.CartItem(
                  productId: cart.items.keys.toList()[i],
                  title: cart.items.values.toList()[i].title,
                  id: cart.items.values.toList()[i].id!,
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                );
              },
              itemCount: cart.items.length,
            ))
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  final cart;
  final order;

  OrderButton(this.cart, this.order);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: (widget.cart.totalAmount <= 0 || isLoading)
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await widget.order.addOrder(
                      widget.cart.items.values.toList(),
                      widget.cart.totalAmount,
                    );
                    setState(() {
                      isLoading = false;
                    });
                    widget.cart.clearCart();
                    Navigator.of(context).pushNamed(OrdersScreen.routeName);
                  },
            child: Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ));
  }
}
