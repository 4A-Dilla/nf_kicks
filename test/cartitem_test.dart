import 'package:flutter_test/flutter_test.dart';
import 'package:nf_kicks/models/cartItem.dart';

void main() {
  group('Test CartItem.fromMap()', () {
    test('test with null data', () {
      final cartItem = CartItem.fromMap(null, 'documentId');
      expect(cartItem, null);
    });

    test('test with cartItem object', () {
      final cartItem = CartItem.fromMap({
        "productId": "productId",
        "storeId": "storeId",
        "name": "cart prod name",
        "price": 20.00,
        "quantity": 1,
        "image": "URL Here",
      }, 'documentId');
      expect(
          cartItem,
          CartItem(
            id: 'documentId',
            productId: "productId",
            storeId: "storeId",
            name: "cart prod name",
            price: 20.00,
            quantity: 1,
            image: "URL Here",
          ));
    });

    test('test store object with nulls', () {
      final cartItem = CartItem.fromMap({
        "productId": null,
        "storeId": null,
        "name": null,
        "price": null,
        "quantity": null,
        "image": null,
      }, 'documentId');
      expect(
          cartItem,
          CartItem(
            id: 'documentId',
            productId: "",
            storeId: "",
            name: "",
            price: 0.0,
            quantity: 0,
            image: "",
          ));
    });

    test('test cartItem object with missing value(s)', () {
      final cartItem = CartItem.fromMap({
        "productId": "productId",
        "storeId": "storeId",
        "name": "cart prod name",
        "quantity": 1,
        "image": "URL Here",
      }, 'documentId');
      expect(
          cartItem,
          CartItem(
            id: 'documentId',
            productId: "productId",
            storeId: "storeId",
            name: "cart prod name",
            price: 00.00,
            quantity: 1,
            image: "URL Here",
          ));
    });

    test('test cartItem object with wrong data types', () {
      final cartItem = CartItem.fromMap({
        "productId": 0,
        "storeId": 0,
        "name": 0,
        "quantity": "one",
        "image": 0.0,
      }, 'documentId');
      expect(
          cartItem,
          CartItem(
            id: 'documentId',
            productId: "",
            storeId: "",
            name: "",
            price: 00.00,
            quantity: 0,
            image: "",
          ));
    });

    test('test with store object with no documentId', () {
      final cartItem = CartItem.fromMap({
        "productId": "productId",
        "storeId": "storeId",
        "name": "cart prod name",
        "price": 20.00,
        "quantity": 1,
        "image": "URL Here",
      }, null);
      expect(
          cartItem,
          CartItem(
            id: null,
            productId: "productId",
            storeId: "storeId",
            name: "cart prod name",
            price: 20.00,
            quantity: 1,
            image: "URL Here",
          ));
    });
  });

  group('Test CartItem.toMap()', () {
    test('test cartItem object with null data', () {
      final cartItem = CartItem(
        id: null,
        productId: null,
        storeId: null,
        name: null,
        price: null,
        quantity: null,
        image: null,
      );
      expect(cartItem.toMap(), {
        'productId': '',
        'storeId': '',
        'name': '',
        'quantity': 0,
        'price': 0.0,
      });
    });

    test('test with cartItem object', () {
      final cartItem = CartItem(
        id: 'documentId',
        productId: "productId",
        storeId: "storeId",
        name: "cart prod name",
        price: 20.00,
        quantity: 1,
        image: "URL Here",
      );
      expect(cartItem.toMap(), {
        "productId": "documentId",
        "storeId": "storeId",
        "name": "cart prod name",
        "price": 20.00,
        "quantity": 1,
      });
    });

    test('test with missing value(s)', () {
      final cartItem = CartItem(
        id: 'documentId',
        productId: "productId",
        storeId: "storeId",
        name: "cart prod name",
        quantity: 1,
        image: "URL Here",
      );
      expect(cartItem.toMap(), {
        "productId": "documentId",
        "storeId": "storeId",
        "name": "cart prod name",
        "price": 00.00,
        "quantity": 1,
      });
    });
  });
}
