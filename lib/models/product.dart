// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';

class Product {
  Product({
    @required this.id,
    @required this.storeId,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.stock,
    @required this.image,
    @required this.inStock,
  });

  String id;
  String storeId;
  String name;
  String description;
  double price;
  int stock;
  String image;
  bool inStock;

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    return Product(
      id: documentId,
      storeId: data['storeId'] is String ? data['storeId']?.toString() : '',
      name: data['name'] is String ? data['name']?.toString() : '',
      description:
          data['description'] is String ? data['description']?.toString() : '',
      price: data['price'] is num ? data['price']?.toDouble() as double : 00.00,
      stock: data['stock'] is num ? data['stock']?.toInt() as int : 0,
      image: data['image'] is String ? data['image']?.toString() : '',
      inStock: data['inStock'] is bool ? data['inStock'] as bool : false,
    );
  }

  Map<String, dynamic> toMap(int quantity) {
    final double finalPrice =
        price is num ? price.toDouble() * quantity : 00.00;
    return {
      'productId': id is String ? id?.toString() : '',
      'storeId': storeId is String ? storeId?.toString() : '',
      'name': name is String ? name?.toString() : '',
      'quantity': quantity is num ? quantity?.toInt() : 0,
      'price': finalPrice is num ? finalPrice?.toDouble() : 00.00,
      'image': image is String ? image?.toString() : '',
    };
  }

  @override
  int get hashCode =>
      hashValues(id, storeId, name, description, price, stock, image, inStock);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Object otherProduct = other;
    return otherProduct is Product &&
        id == otherProduct.id &&
        storeId == otherProduct.storeId &&
        name == otherProduct.name &&
        description == otherProduct.description &&
        price == otherProduct.price &&
        stock == otherProduct.stock &&
        image == otherProduct.image &&
        inStock == otherProduct.inStock;
  }

  @override
  String toString() =>
      'id: $id, storeId: $storeId, name: $name, description: $description, price: $price, stock: $stock, image: $image, inStock: $inStock';
}
