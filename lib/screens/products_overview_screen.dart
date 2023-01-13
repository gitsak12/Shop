import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

enum FiltersOptions {
  // this return
  Favourites, // 0
  All, // 1
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFav = false;
  var _init = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      print('before');
      setState(() {
        _isLoading = true;
      });
      print('after');
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }); // listenn : false means whole ui doesn not rebuild when there induced some changes

    }
    _init = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('MY Shop'), actions: [
        PopupMenuButton(
          onSelected: (FiltersOptions selectedValue) {
            setState(() {
              if (selectedValue == FiltersOptions.Favourites) {
                _showFav = true;
              } else {
                _showFav = false;
              }
            });
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: FiltersOptions.Favourites,
                child: Text('Only Favourites'),
              ),
              const PopupMenuItem(
                value: FiltersOptions.All,
                child: Text('Show All'),
              ),
            ];
          },
          icon: Icon(Icons.more_vert),
        ),
        Consumer<Cart>(builder: (context, cart, child) {
          return Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            value: cart.itemCount.toString(),
          );
        }),
      ]),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : ProductsGrid(_showFav),
    );
  }
}
