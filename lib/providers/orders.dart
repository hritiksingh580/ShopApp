import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndGetOrders() async {
    try {
    const url = 'https://new-demo-app-8488d.firebaseio.com/orders.json';
      final response = await http.get(url);
      final List<OrderItem> loadedOrder = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData.length == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrder.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['product'] as List<dynamic>)
                .map((orderItem) => CartItem(
                    id: orderItem['id'],
                    title: orderItem['title'],
                    price: orderItem['price'],
                    quantity: orderItem['quantity'])
                    )
                .toList())
                );
      });
      _orders = loadedOrder;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    const url = 'https://new-demo-app-8488d.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'product': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));
    notifyListeners();
  }
}
