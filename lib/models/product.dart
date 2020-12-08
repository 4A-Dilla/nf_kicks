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

    return new Product(
      id: documentId,
      storeId: data['storeId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'].toDouble() ?? 00.00,
      stock: data['stock'].toInt() ?? 0,
      image: data['image'] ?? '',
      inStock: data['inStock'] ?? false,
    );
  }

  Map<String, dynamic> toMap(int quantity) {
    double finalPrice = price.toDouble() * quantity;
    return {
      'productId': id.toString(),
      'storeId': storeId.toString(),
      'name': name.toString(),
      'quantity': quantity,
      'price': finalPrice,
      'image': image.toString(),
    };
  }
}
