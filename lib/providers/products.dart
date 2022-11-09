import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop_app/models/http_exception.dart';
import 'package:my_shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  // MOVING FILTERING LOGIC TO A WIDGET INSTEAD OF STATE WIDE PROVIDER
  // var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      final firebaseData = json.decode(response.body) as Map<String, dynamic>;
      if (firebaseData == null) {
        return;
      }
      firebaseData.forEach((id, data) {
        loadedProducts.add(Product(
          id: id,
          description: data['description'],
          imageUrl: data['imageUrl'],
          price: data['price'],
          title: data['title'],
          isFavorite: data['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(json.decode(error.body));
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-df07c-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: 'Could not delete product.');
    }
    existingProduct = null;
  }
}
