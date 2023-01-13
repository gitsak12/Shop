import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  late final String id;
  late final double amount;
  late final List<CartItem> products;
  late final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});

  Map toJson() {
    return {
      'id': this.id,
      'amount': this.amount,
      'products': this.products,
      'dateTime': this.dateTime,
    };
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];

  List<OrderItem> get _orders {
    return [...orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    var loadedOrders = orders;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.insert(
          0,
          OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((e) => CartItem(
                      id: e['id'],
                      title: e['title'],
                      quantity: e['quantity'],
                      price: e['price']))
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime'])));
    });
    loadedOrders = orders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.parse(
        'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
  }
}
