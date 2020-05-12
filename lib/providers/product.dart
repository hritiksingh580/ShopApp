import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _isFav(bool newFavStatus) {
    isFavorite = newFavStatus;
    notifyListeners();
  }

  Future<void> togglerFavorites() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://new-demo-app-8488d.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(url, body: json.encode({
      'isFavorite' : isFavorite,
    }));
    if(response.statusCode >= 400){
      _isFav(oldStatus);
    }
    } catch (error) {
      _isFav(oldStatus);
    }
  }
}
