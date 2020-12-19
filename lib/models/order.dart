import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order {
  Order(
      {this.id,
      @required this.dateOpened,
      @required this.isComplete,
      @required this.readyForPickup,
      @required this.products,
      @required this.totalPrice});

  String id;
  Timestamp dateOpened;
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
      dateOpened: data['dateOpened'] ?? Timestamp.now(),
      isComplete: data['isComplete'] ?? false,
      readyForPickup: data['readyForPickup'] ?? false,
      products: new List<Map<String, dynamic>>.from(data['products']) ??
          new List<Map<String, dynamic>>(),
      totalPrice: data['totalPrice'].toDouble() ?? 00.00,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateOpened': Timestamp.now(),
      'isComplete': false,
      'readyForPickup': false,
      'products': products,
      'totalPrice': totalPrice.toDouble(),
    };
  }
}
