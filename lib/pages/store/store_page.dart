import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';

import '../../constants.dart';

class StorePage extends StatelessWidget {
  static const String id = 'store_screen';

  final String storeId;
  final DatabaseApi dataStore;

  StorePage({
    @required this.storeId,
    @required this.dataStore,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Store>(
        stream: dataStore.storeStream(storeId: storeId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Errors: ${snapshot.error}");
            return kLoadingLogo;
          }

          if (!snapshot.hasData) {
            return kLoadingLogo;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                snapshot.data.name,
                style: GoogleFonts.permanentMarker(),
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                snapshot.data.inStoreShopping
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 25,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 25,
                                      ),
                                Flexible(
                                  child: Text(
                                    "In-store shopping",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                snapshot.data.inStorePickup
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 25,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 25,
                                      ),
                                Flexible(
                                  child: Text(
                                    "In-store pick-up",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.deepOrangeAccent, width: 2),
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data.storeImage),
                          fit: BoxFit.cover,
                          alignment: Alignment(-1.0, -1)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: StreamBuilder<List<Product>>(
                      stream: dataStore.productsStream(storeId: storeId),
                      builder:
                          (context, AsyncSnapshot<List<Product>> snapshotData) {
                        if (snapshotData.hasError) {
                          print("Errors: ${snapshotData.error}");
                          return kLoadingNoLogo;
                        }
                        if (!snapshotData.hasData) {
                          return kLoadingNoLogo;
                        }
                        return ListView.builder(
                          itemCount: snapshotData.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    productId: snapshotData.data[index].id,
                                    dataStore: dataStore,
                                    storeName: snapshot.data.name,
                                  ),
                                ),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                borderOnForeground: true,
                                margin: EdgeInsets.only(
                                    top: 18, left: 18, right: 18),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.deepOrangeAccent,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                right: 20, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshotData.data[index].name
                                                      .toUpperCase(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .deepOrangeAccent,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                        "€${snapshotData.data[index].price.toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                          "${snapshotData.data[index].stock.toStringAsFixed(0)}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
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
                                                  image: NetworkImage(
                                                      snapshotData
                                                          .data[index].image),
                                                  fit: BoxFit.cover),
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
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
