import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nf_kicks/models/cartItem.dart';
import 'package:nf_kicks/models/nfkicksUser.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/services/api/api_path.dart';
import 'package:nf_kicks/services/database/database_api.dart';

class Database implements DatabaseApi {
  Database({@required this.uid});

  final String uid;

  @override
  Stream<Store> storeStream({String storeId}) {
    final path = APIPath.store(storeId);
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
    final path = APIPath.product(productId);
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
    final path = APIPath.stores();
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
    final path = APIPath.products(storeId);
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
  Future<void> createOrder({Order order, String storeName}) async {
    final String storeNameOrder =
        "${storeName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Order";
    final path = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    final collection = documentReference.collection(storeNameOrder);
    print("here: ${order.toMap()}");

    await collection.add(order.toMap());
    emptyCart(storeName: storeName);
  }

  Future<void> emptyCart({String storeName}) async {
    final String storeNameCart =
        "${storeName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Cart";
    final cartPath = APIPath.storeCart(uid, storeNameCart);
    final cartCollectionReference =
        FirebaseFirestore.instance.collection(cartPath);
    cartCollectionReference.get().then((snapshot) async {
      for (DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
    });
  }

  @override
  Future<void> addToCart(
      {Product product, int quantity, String storeName}) async {
    final String storeNameCart =
        "${storeName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Cart";
    final path = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    final collection = documentReference.collection(storeNameCart);
    await collection.doc(product.id).set(product.toMap(quantity));
  }

  @override
  Future<void> createUser({Map<String, dynamic> user}) async {
    final path = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(user);
  }

  @override
  Stream<List<Order>> ordersStream({String storeOrderName}) {
    final String storeNameOrder =
        "${storeOrderName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Order";
    final path = APIPath.storeCart(uid, storeNameOrder);
    final reference = FirebaseFirestore.instance
        .collection(path)
        .orderBy('dateOpened', descending: true);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) => Order.fromMap(
              snapshot.data(),
              snapshot.id,
            ),
          )
          .toList(),
    );
  }

  @override
  Stream<List<CartItem>> storeCartStream({String storeCartName}) {
    final String storeNameCart =
        "${storeCartName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Cart";
    final path = APIPath.storeCart(uid, storeNameCart);
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
    final path = APIPath.storeCartItem(uid, storeNameCart, cartItemId);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.delete();
  }

  @override
  Stream<Order> orderStream({String storeOrderName, String orderId}) {
    final String storeNameOrder =
        "${storeOrderName.toLowerCase().replaceAll(new RegExp(r"\s+"), "")}Order";
    final path = APIPath.storeOrder(uid, storeNameOrder, orderId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => Order.fromMap(
        snapshot.data(),
        snapshot.id,
      ),
    );
  }

  @override
  Stream<NfkicksUser> getUserInformation({String uid}) {
    final path = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    final snapshots = documentReference.snapshots();
    return snapshots.map(
      (snapshot) => NfkicksUser.fromMap(
        snapshot.data(),
        snapshot.id,
      ),
    );
  }

  @override
  Future<void> updateUserInformation({NfkicksUser user, String uid}) async {
    final path = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.update(user.toMap());
  }

  @override
  Future<void> deleteUserInformation({String uid}) async {
    final path = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.delete();
  }

  @override
  Future<void> uploadUserAvatar({String uid, File imageFile}) async {
    String fileName = basename(imageFile.path);
    final path = APIPath.userImageLocation(uid, fileName);
    final firebaseStorageRef = FirebaseStorage.instance.ref(path);
    await firebaseStorageRef.putFile(imageFile);

    final accountPath = APIPath.userAccount(uid);
    final documentReference = FirebaseFirestore.instance.doc(accountPath);
    await documentReference
        .update({'image': await firebaseStorageRef.getDownloadURL()});
  }
}
