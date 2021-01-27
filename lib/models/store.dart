import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

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
      name: data['name'] is String ? data['name']?.toString() : '',
      description:
          data['description'] is String ? data['description']?.toString() : '',
      address: data['address'] is String ? data['address']?.toString() : '',
      image: data['image'] is String ? data['image']?.toString() : '',
      storeImage:
          data['storeImage'] is String ? data['storeImage']?.toString() : '',
      inStorePickup:
          data['inStorePickup'] is bool ? data['inStorePickup'] : false,
      inStoreShopping:
          data['inStoreShopping'] is bool ? data['inStoreShopping'] : false,
      latLong:
          data['latLong'] is GeoPoint ? data['latLong'] : new GeoPoint(0, 0),
    );
  }

  @override
  int get hashCode => hashValues(id, name, description, address, image,
      storeImage, inStorePickup, inStoreShopping, latLong);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Store otherStore = other;
    return id == otherStore.id &&
        name == otherStore.name &&
        description == otherStore.description &&
        address == otherStore.address &&
        image == otherStore.image &&
        storeImage == otherStore.storeImage &&
        inStorePickup == otherStore.inStorePickup &&
        inStoreShopping == otherStore.inStoreShopping &&
        latLong == otherStore.latLong;
  }

  @override
  String toString() =>
      'id: $id, name: $name, description: $description, address: $address, image: $image, storeImage: $storeImage, inStorePickup: $inStorePickup, inStoreShopping: $inStoreShopping, latLong: $latLong';
}
