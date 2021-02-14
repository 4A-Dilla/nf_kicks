import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nf_kicks/models/store.dart';

void main() {
  group('Test Store.fromMap()', () {
    test('test with null data', () {
      final store = Store.fromMap(null, 'documentId');
      expect(store, null);
    });

    test('test with store object', () {
      final store = Store.fromMap({
        "name": "Nike Shoes",
        "description": "Lorem Ipsum",
        "address": "123 Main Street",
        "image": "URL Here",
        "storeImage": "URL Here",
        "inStorePickup": true,
        "inStoreShopping": true,
        "latLong": const GeoPoint(0, 0),
      }, 'documentId');
      expect(
          store,
          Store(
            id: 'documentId',
            name: "Nike Shoes",
            description: "Lorem Ipsum",
            address: "123 Main Street",
            image: "URL Here",
            storeImage: "URL Here",
            inStorePickup: true,
            inStoreShopping: true,
            latLong: const GeoPoint(0, 0),
          ));
    });

    test('test store object with nulls', () {
      final store = Store.fromMap({
        "storeId": null,
        "name": null,
        "description": null,
        "price": null,
        "stock": null,
        "image": null,
        "inStock": null,
        "latLong": null,
      }, 'documentId');
      expect(
          store,
          Store(
            id: 'documentId',
            name: "",
            description: "",
            address: "",
            image: "",
            storeImage: "",
            inStorePickup: false,
            inStoreShopping: false,
            latLong: const GeoPoint(0, 0),
          ));
    });

    test('test store object with missing value(s)', () {
      final store = Store.fromMap({
        "name": "Nike Shoes",
        "description": "Lorem Ipsum",
        "address": "123 Main Street",
        "storeImage": "URL Here",
        "inStorePickup": true,
        "inStoreShopping": true,
        "latLong": const GeoPoint(0, 0),
      }, 'documentId');
      expect(
          store,
          Store(
            id: 'documentId',
            name: "Nike Shoes",
            description: "Lorem Ipsum",
            address: "123 Main Street",
            image: "",
            storeImage: "URL Here",
            inStorePickup: true,
            inStoreShopping: true,
            latLong: const GeoPoint(0, 0),
          ));
    });

    test('test store object with wrong data types', () {
      final store = Store.fromMap({
        "name": 0.0,
        "description": 0.0,
        "address": 0.0,
        "storeImage": 0.0,
        "inStorePickup": "might be true",
        "inStoreShopping": "might be true",
        "latLong": const GeoPoint(0, 0),
      }, 'documentId');
      expect(
          store,
          Store(
            id: 'documentId',
            name: "",
            description: "",
            address: "",
            image: "",
            storeImage: "",
            inStorePickup: false,
            inStoreShopping: false,
            latLong: const GeoPoint(0, 0),
          ));
    });

    test('test with store object with no documentId', () {
      final store = Store.fromMap({
        "name": "Nike Shoes",
        "description": "Lorem Ipsum",
        "address": "123 Main Street",
        "image": "URL Here",
        "storeImage": "URL Here",
        "inStorePickup": true,
        "inStoreShopping": true,
        "latLong": const GeoPoint(0, 0),
      }, null);
      expect(
          store,
          Store(
            id: null,
            name: "Nike Shoes",
            description: "Lorem Ipsum",
            address: "123 Main Street",
            image: "URL Here",
            storeImage: "URL Here",
            inStorePickup: true,
            inStoreShopping: true,
            latLong: const GeoPoint(0, 0),
          ));
    });
  });
}
