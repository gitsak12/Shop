import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var showFavouritesOnly = false;
  //
  // void showFavourites() {
  //   showFavouritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   showFavouritesOnly = false;
  //   notifyListeners();
  // }  // Now this filters apply to all pages in the app

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var loadedProducts = _items;
      extractedData.forEach((prodId, prodData) {
        loadedProducts.insert(
            0,
            Product(
                id: prodId,
                title: prodData['title'],
                description: prodData['description'],
                price: prodData['price'],
                imageUrl: prodData['imageUrl'],
                isFavourite: prodData['isFavourite']));
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      var response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('ok');
      print(error);
      throw error;
      // TODO
    }

    // this then takes the result of upper future
    //print(json.decode(response.body)); // it will be map of product object making at that point {name : ('some id')}

    // .then((value) => print(value))
    // .catchError((error) {
    //   throw FormatException();
    // }); // produces null as
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
      var response = await http.patch(url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'imageUrl': updatedProduct.imageUrl,
          }));
      _items[productIndex] = updatedProduct;
    }
    notifyListeners();
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    int? existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url, body: json.encode({}));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Products');
    }
    existingProduct = null;
    existingProductIndex = null;
  }
}
