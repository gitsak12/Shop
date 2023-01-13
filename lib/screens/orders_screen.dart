import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as ob;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {


  Future obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }
  late  Future ordersFuture= obtainOrdersFuture();
  @override
  void initState() {
    // TODO: implement initState
    ordersFuture = obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your Orders')),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (BuildContext context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            //error Handling
            return const Center(
              child: Text(
                'Error Occured',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => ob.OrderItem(orderData.orders[i]),
              ),
            );
          }
        },
      ),
    );
  }
}
