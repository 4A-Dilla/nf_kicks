import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:toast/toast.dart';

Row totalPriceCheckoutButton(
  BuildContext context,
  double totalPrice,
  DatabaseApi databaseApi,
  List<Map<String, dynamic>> productsList,
  String storeName,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Row(
        children: [
          Text(
            "Total Price:",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            totalPrice.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      FlatButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'An order has been made!',
              ),
              duration: Duration(
                seconds: 1,
              ),
            ),
          );

          databaseApi.createOrder(
            order: new Order(
              products: productsList,
              isComplete: false,
              totalPrice: totalPrice,
              readyForPickup: false,
              dateOpened: Timestamp.now(),
            ),
            storeName: storeName,
          );
        },
        child: Text(
          "Checkout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        color: Colors.deepOrangeAccent,
      ),
    ],
  );
}

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
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
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
    borderOnForeground: true,
    margin: EdgeInsets.only(top: 18, left: 18, right: 18),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrangeAccent, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "€${productPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.all(8),
                          child: Text(
                              "Quantity: ${productQuantity.toStringAsFixed(0)}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(productImage), fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(
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
    borderOnForeground: true,
    margin: EdgeInsets.only(top: 18, left: 18, right: 18),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrangeAccent, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "€${productPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.all(8),
                          child: Text(productStock.toStringAsFixed(0),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(productImage), fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(
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
