import 'package:flutter/material.dart';
import 'package:nf_kicks/models/cartItem.dart';
import 'package:nf_kicks/models/nfkicksUser.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';

abstract class DatabaseApi {
  Stream<List<Product>> productsStream({@required String storeId});

  Stream<Product> productStream({@required String productId});

  Stream<List<Store>> storesStream();

  Stream<Store> storeStream({@required String storeId});

  Stream<List<CartItem>> storeCartStream({@required String storeCartName});

  Stream<List<Order>> ordersStream({@required String storeOrderName});

  Stream<Order> orderStream(
      {@required String storeOrderName, @required String orderId});

  Future<void> addToCart(
      {@required Product product,
      @required int quantity,
      @required String storeName});

  Future<void> createOrder({@required Order order, @required String storeName});

  Future<void> deleteCartItem(
      {@required String cartItemId, @required String storeCartName});

  Future<void> createUser({@required Map<String, dynamic> user});

  Stream<NfkicksUser> getUserInformation({@required String uid});

  Future<void> updateUserInformation(
      {@required NfkicksUser user, @required String uid});

  Future<void> deleteUserInformation({@required String uid});
}
