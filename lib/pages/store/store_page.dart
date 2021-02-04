import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';

import '../../widgets/constants.dart';

class StorePage extends StatelessWidget {
  final String storeId;
  final DatabaseApi dataStore;

  const StorePage({
    Key key,
    @required this.storeId,
    @required this.dataStore,
  }) : super(key: key);

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
                              child: productCard(
                                  productName: snapshotData.data[index].name,
                                  productPrice: snapshotData.data[index].price,
                                  productImage: snapshotData.data[index].image,
                                  productStock: snapshotData.data[index].stock),
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
