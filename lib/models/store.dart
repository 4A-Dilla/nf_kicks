import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String name;
  String description;
  String address;
  String image;
  bool inStorePick;
  bool inStoreShopping;
  GeoPoint latLong;

  Store(
      {this.name,
      this.description,
      this.address,
      this.image,
      this.inStorePick,
      this.inStoreShopping,
      this.latLong});
}
