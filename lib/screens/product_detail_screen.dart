import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments;
    final loadedProduct = Provider.of<Products>(context, listen: false)
        .findById(productId as String);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            height: 400,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            loadedProduct.price.toString(),
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(loadedProduct.description),
        ],
      ),
    );
  }
}
