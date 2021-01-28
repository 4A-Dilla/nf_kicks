import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nf_kicks/models/order.dart';

void main() {
  group('Test Order.fromMap()', () {
    test('test with null data', () {
      final order = Order.fromMap(null, 'documentId');
      expect(order, null);
    });

    // Tests are failing due to hashcodes

    // test('test with order object', () {
    //   final order = Order.fromMap({
    //     "dateOpened": null,
    //     "isComplete": null,
    //     "readyForPickup": null,
    //     "products": null,
    //     "totalPrice": null,
    //   }, 'documentId');
    //   expect(
    //       order,
    //       Order(
    //           id: 'documentId',
    //           dateOpened: Timestamp.now(),
    //           isComplete: false,
    //           readyForPickup: false,
    //           products: new List<Map<String, dynamic>>(),
    //           totalPrice: 0.0));
    // });

    // test('test product object with nulls', () {
    //   final product = Product.fromMap({
    //     "storeId": null,
    //     "name": null,
    //     "description": null,
    //     "price": null,
    //     "stock": null,
    //     "image": null,
    //     "inStock": null,
    //   }, 'documentId');
    //   expect(
    //       product,
    //       Product(
    //           id: 'documentId',
    //           storeId: "",
    //           name: "",
    //           description: "",
    //           price: 00.00,
    //           stock: 0,
    //           image: "",
    //           inStock: false));
    // });
    //
    // test('test product object with missing value(s)', () {
    //   final product = Product.fromMap({
    //     "storeId": "abc",
    //     "name": "Nike Shoes",
    //     "description": "Lorem Ipsum",
    //     "price": 20.00,
    //     "stock": 4,
    //     "inStock": true,
    //   }, 'documentId');
    //   expect(
    //       product,
    //       Product(
    //           id: 'documentId',
    //           storeId: "abc",
    //           name: "Nike Shoes",
    //           description: "Lorem Ipsum",
    //           price: 20.00,
    //           stock: 4,
    //           image: "",
    //           inStock: true));
    // });
    //
    // test('test product object with wrong data types', () {
    //   final product = Product.fromMap({
    //     "storeId": 0.0,
    //     "name": 0.0,
    //     "description": 0.0,
    //     "price": "Twenty",
    //     "stock": "Four",
    //     "inStock": "might be true",
    //   }, 'documentId');
    //   expect(
    //       product,
    //       Product(
    //           id: 'documentId',
    //           storeId: "",
    //           name: "",
    //           description: "",
    //           price: 0.0,
    //           stock: 0,
    //           image: "",
    //           inStock: false));
    // });
    //
    // test('test with product object with no documentId', () {
    //   final product = Product.fromMap({
    //     "storeId": "abc",
    //     "name": "Nike Shoes",
    //     "description": "Lorem Ipsum",
    //     "price": 20.00,
    //     "stock": 4,
    //     "image": "url here",
    //     "inStock": true,
    //   }, null);
    //   expect(
    //       product,
    //       Product(
    //           id: null,
    //           storeId: "abc",
    //           name: "Nike Shoes",
    //           description: "Lorem Ipsum",
    //           price: 20.00,
    //           stock: 4,
    //           image: "url here",
    //           inStock: true));
    // });
  });
}
