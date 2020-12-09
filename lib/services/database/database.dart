import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nf_kicks/models/cartItem.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/services/api/store_api_path.dart';
import 'package:nf_kicks/services/database/database_api.dart';

class Database implements DatabaseApi {
  Database({@required this.uid});

  final String uid;

  @override
  Stream<Store> storeStream({String storeId}) {
    final path = StoreAPIPath.store(storeId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => Store.fromMap(
        snapshot.data(),
        snapshot.id,
      ),
    );
  }

  @override
  Stream<Product> productStream({String productId}) {
    final path = StoreAPIPath.product(productId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => Product.fromMap(
        snapshot.data(),
        snapshot.id,
      ),
    );
  }

  @override
  Stream<List<Store>> storesStream() {
    final path = StoreAPIPath.stores();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) => Store.fromMap(
              snapshot.data(),
              snapshot.id,
            ),
          )
          .toList(),
    );
  }

  @override
  Stream<List<Product>> productsStream({String storeId}) {
    final path = StoreAPIPath.products(storeId);
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where('storeId', isEqualTo: storeId);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) => Product.fromMap(
              snapshot.data(),
              snapshot.id,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> addToCart(
      {Product product, int quantity, String storeName}) async {
    final String storeNameCart =
        "${storeName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Cart";
    final path = StoreAPIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    final collection = documentReference.collection(storeNameCart);
    await collection.add(product.toMap(quantity));
  }

  @override
  Future<void> createUser({Map<String, dynamic> user}) async {
    final path = StoreAPIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(user);
  }

  @override
  Stream<List<CartItem>> storeCartStream({String storeCartName}) {
    final String storeNameCart =
        "${storeCartName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Cart";
    final path = StoreAPIPath.storeCart(uid, storeNameCart);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) => CartItem.fromMap(
              snapshot.data(),
              snapshot.id,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> deleteCartItem({String cartItemId, String storeCartName}) async {
    final String storeNameCart =
        "${storeCartName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Cart";
    final path = StoreAPIPath.storeCartItem(uid, storeNameCart, cartItemId);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.delete();
  }
}
