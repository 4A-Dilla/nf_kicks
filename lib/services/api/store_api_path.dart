class StoreAPIPath {
  // Todo: Adding a slash at the end might solve the problem
  static String stores() => 'stores';
  static String store(String storeId) => 'stores/$storeId';
  static String storeProducts(String storeId) => 'stores/$storeId/products';
  static String storeProduct(String storeId, String productId) =>
      'stores/$storeId/products/$productId';
}
