import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Products()),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProvider(create: (context) => Orders()),
          ChangeNotifierProvider(create: (context) => Auth()),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.orange)
                        .copyWith(secondary: Colors.deepOrange),
              ),
              routes: {
                ProductsOverviewScreen.routeName: (context) =>
                    ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrdersScreen.routeName: (context) => (OrdersScreen()),
                UserProductsScreen.routeName: (context) => UserProductsScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            );
          },
        ));
  }
}
