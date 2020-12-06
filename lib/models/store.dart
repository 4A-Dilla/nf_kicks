import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Store {
  Store({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.address,
    @required this.image,
    @required this.storeImage,
    @required this.inStorePickup,
    @required this.inStoreShopping,
    @required this.latLong,
  });

  String id;
  String name;
  String description;
  String address;
  String image;
  String storeImage;
  bool inStorePickup;
  bool inStoreShopping;
  GeoPoint latLong;

  factory Store.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    return new Store(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      image: data['image'] ?? '',
      storeImage: data['storeImage'] ?? '',
      inStorePickup: data['inStorePickup'] ?? false,
      inStoreShopping: data['inStoreShopping'] ?? false,
      latLong: data['latLong'] ?? new GeoPoint(0, 0),
    );
  }
}
