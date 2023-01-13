import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  // late final String id;
  @override
  Widget build(BuildContext context) {
    final productContainer =
        Provider.of<Product>(context, // Instance of Product class
            listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // listen false implies the the function further does ont take any data
    // When data changes the whole build method runs
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              setState(() {
                productContainer.toggleFavouriteStatus();
              });
            },
            icon: Icon(productContainer.isFavourite
                ? Icons.favorite
                : Icons.favorite_outline),
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(productContainer.id!, productContainer.price,
                  productContainer.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.blueAccent,
                    onPressed: () {
                      cart.removeSingleItem(productContainer.id!);
                    },
                  ),
                  content: Text(
                    'Added Item To Cart',
                    style: TextStyle(color: Colors.white),
                  ))); //This will goes to the nearest scaffold page
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(
            productContainer.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: Consumer<Product>(
          // uses when only data changes as it has listen: true
          builder: (context, product, child) {
            return GestureDetector(
              onTap: () {
                // Navigator.of(context)
                //    .push(MaterialPageRoute(builder: (ctx) => ProductDetailScreen(title,)));
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
