import 'package:flutter_test/flutter_test.dart';
import 'package:nf_kicks/models/product.dart';

void main() {
  group('Test Product.fromMap()', () {
    test('test with null data', () {
      final product = Product.fromMap(null, 'documentId');
      expect(product, null);
    });

    test('test with product object', () {
      final product = Product.fromMap({
        "storeId": "abc",
        "name": "Nike Shoes",
        "description": "Lorem Ipsum",
        "price": 20.00,
        "stock": 4,
        "image": "url here",
        "inStock": true,
      }, 'documentId');
      expect(
          product,
          Product(
              id: 'documentId',
              storeId: "abc",
              name: "Nike Shoes",
              description: "Lorem Ipsum",
              price: 20.00,
              stock: 4,
              image: "url here",
              inStock: true));
    });

    test('test product object with nulls', () {
      final product = Product.fromMap({
        "storeId": null,
        "name": null,
        "description": null,
        "price": null,
        "stock": null,
        "image": null,
        "inStock": null,
      }, 'documentId');
      expect(
          product,
          Product(
              id: 'documentId',
              storeId: "",
              name: "",
              description: "",
              price: 00.00,
              stock: 0,
              image: "",
              inStock: false));
    });

    test('test product object with missing value(s)', () {
      final product = Product.fromMap({
        "storeId": "abc",
        "name": "Nike Shoes",
        "description": "Lorem Ipsum",
        "price": 20.00,
        "stock": 4,
        "inStock": true,
      }, 'documentId');
      expect(
          product,
          Product(
              id: 'documentId',
              storeId: "abc",
              name: "Nike Shoes",
              description: "Lorem Ipsum",
              price: 20.00,
              stock: 4,
              image: "",
              inStock: true));
    });

    test('test product object with wrong data types', () {
      final product = Product.fromMap({
        "storeId": 0.0,
        "name": 0.0,
        "description": 0.0,
        "price": "Twenty",
        "stock": "Four",
        "inStock": "might be true",
      }, 'documentId');
      expect(
          product,
          Product(
              id: 'documentId',
              storeId: "",
              name: "",
              description: "",
              price: 0.0,
              stock: 0,
              image: "",
              inStock: false));
    });

    test('test with product object with no documentId', () {
      final product = Product.fromMap({
        "storeId": "abc",
        "name": "Nike Shoes",
        "description": "Lorem Ipsum",
        "price": 20.00,
        "stock": 4,
        "image": "url here",
        "inStock": true,
      }, null);
      expect(
          product,
          Product(
              id: null,
              storeId: "abc",
              name: "Nike Shoes",
              description: "Lorem Ipsum",
              price: 20.00,
              stock: 4,
              image: "url here",
              inStock: true));
    });
  });
  group('Test Product.toMap()', () {
    test('test product object with null data', () {
      final product = Product(
          id: null,
          storeId: null,
          name: null,
          description: null,
          price: null,
          stock: null,
          image: null,
          inStock: null);
      expect(product.toMap(null), {
        'productId': '',
        'storeId': '',
        'name': '',
        'quantity': 0,
        'price': 0.0,
        'image': '',
      });
    });
    test('test with product object', () {
      final product = Product(
          id: 'documentId',
          storeId: "abc",
          name: "Nike Shoes",
          description: "Lorem Ipsum",
          price: 20.00,
          stock: 4,
          image: "url here",
          inStock: true);
      expect(product.toMap(1), {
        'productId': 'documentId',
        'storeId': "abc",
        'name': "Nike Shoes",
        'quantity': 1,
        'price': 20.00,
        'image': "url here",
      });
    });
    test('test with missing value(s)', () {
      final product = Product(
          id: 'documentId',
          name: "Nike Shoes",
          description: "Lorem Ipsum",
          price: 20.00,
          stock: 4,
          image: "url here",
          inStock: true);
      expect(product.toMap(1), {
        'productId': 'documentId',
        'storeId': "",
        'name': "Nike Shoes",
        'quantity': 1,
        'price': 20.00,
        'image': "url here",
      });
    });
  });
}
