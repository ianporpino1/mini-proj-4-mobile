import 'package:f08_eshop_app/model/cart_item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    return _items.values
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void addItem(String productId, String title, double price) {
    print(productId);
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: title,
          price: price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items[productId] = CartItem(
        id: productId,
        title: title,
        price: price,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId)) {
      if (newQuantity > 0) {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: newQuantity,
          ),
        );
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
