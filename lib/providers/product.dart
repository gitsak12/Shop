import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  late var id;
  late final String title;
  late final String description;
  late final double price;
  late final String imageUrl;
  late bool isFavourite;

  Product(
      {this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false,});

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavourite
      };

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-update-94173-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    try {
      var response = await http.patch(url,
          body: json.encode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
