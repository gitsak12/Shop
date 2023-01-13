import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class CartItem {
  late final String id;
  late final String title;
  late final int quantity;
  late final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});

  Map toJson() {
    return {
      'title': this.title,
      'quantity': this.quantity,
      'price': this.price
    };
  }
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, item) {
      total += (item.price * item.quantity);
    });
    return total;
  }

  int get itemCount {
    return _items.length == null ? 0 : _items.length;
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // changequantity
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    var t = _items[productId]?.quantity;
    if (t! > 1) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
