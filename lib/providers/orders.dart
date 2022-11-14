import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop_app/models/http_exception.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  final String userId;
  final String authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final firebaseData = json.decode(response.body) as Map<String, dynamic>;
      if (firebaseData == null) {
        return;
      }
      firebaseData.forEach((id, data) {
        loadedOrders.add(OrderItem(
          id: id,
          amount: data['amount'],
          dateTime: DateTime.parse(data['dateTime']),
          products: (data['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity'],
                    title: e['title'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(json.decode(error.body));
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.parse(
        'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');

    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((prodItem) => {
                      'id': prodItem.id,
                      'title': prodItem.title,
                      'quantity': prodItem.quantity,
                      'price': prodItem.price,
                    })
                .toList(),
          }));

      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      );

      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteOrder(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId/$id.json?auth=$authToken');
    final existingOrderIndex = _orders.indexWhere((prod) => prod.id == id);
    var existingOrder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();
    final response = await http.delete(url);
    // print(response.body);
    if (response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException(message: 'Could not delete order.');
    }
    existingOrder = null;
  }
}
