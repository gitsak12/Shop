import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool fav;

  ProductsGrid(this.fav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final List<Product> products =
        fav ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            // preferred to use where in list and grid views type widgets
            value: products[index], // instance of products class
            child: ProductItem(
                // id: products[index].id,
                // title: products[index].title,
                // imageUrl: products[index].imageUrl),
                ));
      },
    );
  }
}
