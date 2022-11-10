import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop_app/api/api_key.dart';
import 'package:my_shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expityDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlString) async {
    final url = Uri.parse(urlString);
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
    return _authenticate(email, password, url);
  }
}
