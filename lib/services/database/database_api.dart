import 'package:flutter/material.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';

abstract class DatabaseApi {
  Stream<List<Product>> productsStream({@required String storeId});
  Stream<Product> productStream({@required String productId});
  Stream<List<Store>> storesStream();
  Stream<Store> storeStream({@required String storeId});
}
