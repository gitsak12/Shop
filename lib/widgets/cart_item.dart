import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  late final String id;
  late final double price;
  late final String productId;
  late final String title;
  late final int quantity;

  CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.title,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    final tile = Provider.of<Cart>(context);
    return Dismissible(
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      onDismissed: (direction) {
        return tile.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog<bool>(
            // By default it returns future
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                title: Text('Are you Sure?'),
                content: Text('Do you want to remove the item from the Cart'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("NO"),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("YES"),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                  ),
                ],
              );
            });
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FittedBox(
                      child: Text(
                    '$price',
                  ))),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Total: ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
