import 'package:flutter/material.dart';
import 'package:nf_kicks/models/store.dart';

abstract class DatabaseApi {
  Stream<List<Store>> storesStream();
  Stream<Store> storeStream({@required String storeId});
}
