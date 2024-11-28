import 'package:f08_eshop_app/model/cart_item.dart';
import 'package:f08_eshop_app/model/order.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  final _baseUrl = 'https://miniproj4-9a218-default-rtdb.firebaseio.com/';
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<List<Order>> fetchOrders(String? userId) async {
    List<Order> orders = [];

    final response =
        await http.get(Uri.parse('$_baseUrl/users/$userId/orders.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> _ordersJson = jsonDecode(response.body);
      _ordersJson.forEach((id, order) {
        orders.add(Order.fromJson(id, order));
      });
      _orders = orders;
      return _orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> placeOrder(String? userId, List<CartItem> items) async {
    final order = Order(
      date: DateTime.now(),
      items: items,
      totalAmount:
          items.fold(0.0, (sum, item) => sum + item.price * item.quantity),
    );

    final response = await http.post(
        Uri.parse('$_baseUrl/users/$userId/orders.json'),
        body: json.encode(order.toJson()));
    notifyListeners();
    if (response.statusCode != 200) {
      throw Exception('Failed to place order');
    }
  }
}
