import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/cartItem.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class CartPage extends StatefulWidget {
  final DatabaseApi dataStore;

  const CartPage({Key key, this.dataStore}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Store>>(
      stream: widget.dataStore.storesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Errors: ${snapshot.error}");
          return kLoadingLogo;
        }

        if (!snapshot.hasData) {
          return kLoadingLogo;
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Cart",
                style: GoogleFonts.permanentMarker(),
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: [
                  for (final tab in snapshot.data)
                    Tab(
                      child: Text(tab.name),
                    ),
                ],
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: TabBarView(
              children: [
                for (final tab in snapshot.data)
                  StreamBuilder<List<CartItem>>(
                    stream: widget.dataStore
                        .storeCartStream(storeCartName: tab.name),
                    builder:
                        (context, AsyncSnapshot<List<CartItem>> snapshotData) {
                      double _totalPrice = 0;
                      List<Map<String, dynamic>> _myList =
                          new List<Map<String, dynamic>>();

                      if (snapshotData.hasError) {
                        print("Errors: ${snapshotData.error}");
                        return kLoadingNoLogo;
                      }
                      if (!snapshotData.hasData) {
                        return kLoadingNoLogo;
                      }

                      snapshotData.data.forEach((cartItem) {
                        _totalPrice += cartItem.price;
                        _myList.add(cartItem.toMap());
                      });

                      return ListView.builder(
                        itemCount: snapshotData.data.length,
                        itemBuilder: (context, index) {
                          if (snapshotData.data.isNotEmpty) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                            _totalPrice.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'An order has been made!'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );

                                          widget.dataStore.createOrder(
                                              order: new Order(
                                                products: _myList,
                                                isComplete: false,
                                                totalPrice: _totalPrice,
                                                readyForPickup: false,
                                                dateOpened: Timestamp.now(),
                                              ),
                                              storeName: tab.name);
                                        },
                                        child: Text(
                                          "Checkout",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ],
                                  ),
                                  Dismissible(
                                    background: Container(
                                      color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                    key: Key(snapshotData.data[index].id),
                                    onDismissed: (direction) {
                                      widget.dataStore.deleteCartItem(
                                          cartItemId:
                                              snapshotData.data[index].id,
                                          storeCartName: tab.name);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Product deleted!',
                                          ),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                            productId: snapshotData
                                                .data[index].productId,
                                            dataStore: widget.dataStore,
                                            storeName: tab.name,
                                          ),
                                        ),
                                      ),
                                      child: productCard(
                                          productName:
                                              snapshotData.data[index].name,
                                          productPrice:
                                              snapshotData.data[index].price,
                                          productQuantity:
                                              snapshotData.data[index].quantity,
                                          productImage:
                                              snapshotData.data[index].image),
                                    ),
                                  ),
                                ],
                              );
                            }
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
                              key: Key(snapshotData.data[index].id),
                              onDismissed: (direction) {
                                widget.dataStore.deleteCartItem(
                                    cartItemId: snapshotData.data[index].id,
                                    storeCartName: tab.name);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Product deleted!',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                      productId:
                                          snapshotData.data[index].productId,
                                      dataStore: widget.dataStore,
                                      storeName: tab.name,
                                    ),
                                  ),
                                ),
                                child: productCard(
                                    productName: snapshotData.data[index].name,
                                    productPrice:
                                        snapshotData.data[index].price,
                                    productQuantity:
                                        snapshotData.data[index].quantity,
                                    productImage:
                                        snapshotData.data[index].image),
                              ),
                            );
                          } else {
                            return kLoadingNoLogo;
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Dismissible dismissibleProductCard(
  String id,
    DatabaseApi databaseApi,
    String storeName,
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
    key: Key(id),
    onDismissed: (direction) {
      databaseApi.deleteCartItem(
          cartItemId: id, storeCartName: storeName);
      Toast()
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product deleted!',
          ),
          duration: Duration(seconds: 1),
        ),
      );
    },
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(
            productId: snapshotData.data[index].productId,
            dataStore: widget.dataStore,
            storeName: tab.name,
          ),
        ),
      ),
      child: productCard(
          productName: snapshotData.data[index].name,
          productPrice: snapshotData.data[index].price,
          productQuantity: snapshotData.data[index].quantity,
          productImage: snapshotData.data[index].image),
    ),
  );
}

Row totalPriceCheckoutButton() {}
