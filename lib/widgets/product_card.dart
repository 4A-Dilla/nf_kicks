// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:toast/toast.dart';

// Project imports:
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/constants.dart';

Dismissible dismissibleProductCard(
  BuildContext context,
  String cartId,
  DatabaseApi databaseApi,
  String storeName,
  String productId,
  String productName,
  double productPrice,
  int productQuantity,
  String productImage,
) {
  return Dismissible(
    background: Container(
      color: kNfkicksRed,
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: Icon(Icons.delete, color: kSecondaryColor),
      ),
    ),
    key: Key(cartId),
    onDismissed: (direction) {
      databaseApi.deleteCartItem(cartItemId: cartId, storeCartName: storeName);
      showToast(context, "Product deleted!", gravity: Toast.CENTER);
    },
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(
            productId: productId,
            dataStore: databaseApi,
            storeName: storeName,
          ),
        ),
      ),
      child: cartProductCard(
        productName: productName,
        productPrice: productPrice,
        productQuantity: productQuantity,
        productImage: productImage,
      ),
    ),
  );
}

Card cartProductCard(
    {String productName,
    double productPrice,
    int productQuantity,
    String productImage}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 5,
    margin: const EdgeInsets.only(top: 18, left: 18, right: 18),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "€${productPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                              "Quantity: ${productQuantity.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(productImage), fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Card productCard(
    {String productName,
    double productPrice,
    int productStock,
    String productImage}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 5,
    margin: const EdgeInsets.only(top: 18, left: 18, right: 18),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "€${productPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: kNfkicksBlack,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(8),
                          child: Text(productStock.toStringAsFixed(0),
                              style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(productImage), fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showToast(BuildContext context, String msg, {int duration, int gravity}) {
  Toast.show(msg, context, duration: duration ?? 1, gravity: gravity);
}
