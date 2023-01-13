import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  UserProductItem(
      {required this.title, required this.imageUrl, required this.productId});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: productId);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(productId);
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(const SnackBar(
                      content: Text('Deleting Failed!',
                          style: TextStyle(color: Colors.white)),
                    ));
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}
