import 'package:flutter/cupertino.dart';
import 'package:nf_kicks/models/cartItem.dart';

class Order {
  Order(
      {this.id,
      @required this.dateOpened,
      @required this.isComplete,
      @required this.readyForPickup,
      @required this.products,
      @required this.totalPrice});

  String id;
  DateTime dateOpened;
  bool isComplete;
  bool readyForPickup;
  List<Map<String, dynamic>> products;
  double totalPrice;

  factory Order.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    return new Order(
      id: documentId,
      dateOpened: data['dateOpened'] ?? DateTime.now(),
      isComplete: data['isComplete'] ?? false,
      readyForPickup: data['readyForPickup'] ?? false,
      products: new List<Map<String, dynamic>>.from(data['products']) ??
          new List<Map<String, dynamic>>(),
      totalPrice: data['totalPrice'].toDouble() ?? 00.00,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateOpened': DateTime.now(),
      'isComplete': false,
      'readyForPickup': false,
      'products': products,
      'totalPrice': totalPrice.toDouble(),
    };
  }
}
