import 'package:flutter/foundation.dart';

class CartItem {
  CartItem({
    @required this.id,
    @required this.productId,
    @required this.storeId,
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.image,
  });

  String id;
  String productId;
  String storeId;
  String name;
  double price;
  int quantity;
  String image;

  factory CartItem.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    return new CartItem(
      id: documentId,
      productId: data['productId'] ?? '',
      storeId: data['storeId'] ?? '',
      name: data['name'] ?? '',
      price: data['price'].toDouble() ?? 00.00,
      quantity: data['quantity'].toInt() ?? 0,
      image: data['image'].toString() ?? '',
    );
  }

  // Map<String, dynamic> toMap(int quantity) {
  //   return {
  //     'productId': id.toString(),
  //     'storeId': storeId.toString(),
  //     'name': name.toString(),
  //     'quantity': quantity,
  //     'price': price.toDouble(),
  //   };
  // }
}
