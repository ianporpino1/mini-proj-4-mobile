import 'package:f08_eshop_app/model/cart_item.dart';

class Order {
  String? id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;

  Order({
    this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
  });

  factory Order.fromJson(String id, Map<String, dynamic> json) {
    return Order(
      id: id,
      date: DateTime.parse(json['date']),
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'items': items
          .map((item) => {
                'id': item.id,
                'title': item.title,
                'price': item.price,
                'quantity': item.quantity,
              })
          .toList(),
      'totalAmount': totalAmount,
    };
  }
}
