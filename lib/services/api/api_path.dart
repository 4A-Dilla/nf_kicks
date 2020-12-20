class APIPath {
  static String stores() => 'stores';

  static String store(String storeId) => 'stores/$storeId';

  static String products(String storeId) => 'products';

  static String product(String productId) => 'products/$productId';

  static String userAccount(String uid) => 'users/$uid';

  static String storeCart(String uid, String storeCart) =>
      'users/$uid/$storeCart';

  static String storeCartItem(
          String uid, String storeCart, String cartItemId) =>
      'users/$uid/$storeCart/$cartItemId';

  static String storeOrders(String uid, String storeOrder) =>
      'users/$uid/$storeOrder';

  static String storeOrder(
          String uid, String storeOrder, String storeOrderId) =>
      'users/$uid/$storeOrder/$storeOrderId';
}
