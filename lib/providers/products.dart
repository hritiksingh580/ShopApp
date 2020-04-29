import 'package:flutter/material.dart';

import '../models/products.dart';

class Products with ChangeNotifier{
  List<Product> _item = [];

  List<Product> get item {
    return [..._item];
  }

  void addProduct() {
    //_item.add(value)
    notifyListeners();
  }

}