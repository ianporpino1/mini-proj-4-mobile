import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Constructor that clones from an existing Product
  Product.fromProduct(Product _product)
      : id = _product.id,
        title = _product.title,
        description = _product.description,
        price = _product.price,
        imageUrl = _product.imageUrl,
        isFavorite = _product.isFavorite;

  // Factory method to create a Product instance from a JSON map
  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      title: json['title'],
      description: json['description'],
      price: json['price']
          .toDouble(), // Assuming 'price' is stored as a double in JSON
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ??
          false, // Default to false if 'isFavorite' is not present
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
    return data;
  }

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://miniproj4-9a218-default-rtdb.firebaseio.com/products/$id.json');

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      rethrow;
    }
  }
}
