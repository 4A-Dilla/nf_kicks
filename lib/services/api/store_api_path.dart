class StoreAPIPath {
  static String stores() => 'stores';
  static String store(String storeId) => 'stores/$storeId';
  static String products(String storeId) => 'products';
  static String product(String productId) => 'products/$productId';
  static String userAccount(String uid) => 'users/$uid';
}
