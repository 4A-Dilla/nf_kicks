import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/something_went_wrong_page.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:provider/provider.dart';

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
          if (!snapshot.hasData) {
            return kLoadingLogo;
          }
          if (snapshot.hasError) {
            print("Errors: ${snapshot.error}");
            return kLoadingLogo;
          }
          return Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              title: Text(snapshot.data.name),
              backgroundColor: Colors.black,
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
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    "In-store shopping",
                                    style: GoogleFonts.permanentMarker(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                snapshot.data.inStorePickup
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    "In-store pick-up",
                                    style: GoogleFonts.permanentMarker(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
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
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 2,
                  child: StreamBuilder<List<Product>>(
                      stream: dataStore.productsStream(storeId: storeId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return kLoadingNoLogo;
                        }
                        if (snapshot.hasError) {
                          print("Errors: ${snapshot.error}");
                          return kLoadingLogo;
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data[index].name,
                                            softWrap: true,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  "€${snapshot.data[index].price.toStringAsFixed(2)}"),
                                              Text("|"),
                                              Text(
                                                  "Stock: ${snapshot.data[index].stock.toStringAsFixed(0)}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Image.network(
                                          snapshot.data[index].image,
                                        ),
                                      ),
                                    ),
                                  ],
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
