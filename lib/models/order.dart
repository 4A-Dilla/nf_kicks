import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Order {
  Order({
    @required this.id,
    @required this.dateOpened,
    @required this.isComplete,
    @required this.readyForPickup,
    @required this.products,
    @required this.totalPrice,
  });

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
      dateOpened: data['dateOpened'] is Timestamp
          ? data['dateOpened']
          : Timestamp.now(),
      isComplete: data['isComplete'] is bool ? data['isComplete'] : false,
      readyForPickup:
          data['readyForPickup'] is bool ? data['readyForPickup'] : false,
      products: new List<Map<String, dynamic>>.from(data['products'])
              is List<Map<String, dynamic>>
          ? new List<Map<String, dynamic>>.from(data['products'])
          : new List<Map<String, dynamic>>(),
      totalPrice:
          data['totalPrice'] is num ? data['totalPrice']?.toDouble() : 00.00,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateOpened': dateOpened is Timestamp ? dateOpened : Timestamp.now(),
      'isComplete': isComplete is bool ? isComplete : false,
      'readyForPickup': readyForPickup is bool ? readyForPickup : false,
      'products': products is List<Map<String, dynamic>>
          ? products
          : new List<Map<String, dynamic>>(),
      'totalPrice': totalPrice is num ? totalPrice?.toDouble() : 00.00,
    };
  }

  @override
  int get hashCode => hashValues(
      id, dateOpened, isComplete, readyForPickup, products, totalPrice);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Order otherOrder = other;
    return id == otherOrder.id &&
        dateOpened == otherOrder.dateOpened &&
        isComplete == otherOrder.isComplete &&
        readyForPickup == otherOrder.readyForPickup &&
        products == otherOrder.products &&
        totalPrice == otherOrder.totalPrice;
  }

  @override
  String toString() =>
      'id: $id, dateOpened: $dateOpened, isComplete: $isComplete, readyForPickup: $readyForPickup, products: $products, totalPrice: $totalPrice';
}
