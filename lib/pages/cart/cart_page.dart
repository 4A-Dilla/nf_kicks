import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/cartItem.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';

import '../../constants.dart';

class CartPage extends StatelessWidget {
  final DatabaseApi dataStore;

  const CartPage({Key key, this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Store>>(
      stream: dataStore.storesStream(),
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
                    stream: dataStore.storeCartStream(storeCartName: tab.name),
                    builder:
                        (context, AsyncSnapshot<List<CartItem>> snapshotData) {
                      double _totalPrice = 0;
                      List<Map<String, dynamic>> _productListMap =
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
                        _productListMap.add(cartItem.toMap());
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
                                  totalPriceCheckoutButton(context, _totalPrice,
                                      dataStore, _productListMap, tab.name),
                                  dismissibleProductCard(
                                    context,
                                    snapshotData.data[index].id,
                                    dataStore,
                                    tab.name,
                                    snapshotData.data[index].productId,
                                    snapshotData.data[index].name,
                                    snapshotData.data[index].price,
                                    snapshotData.data[index].quantity,
                                    snapshotData.data[index].image,
                                  ),
                                ],
                              );
                            }
                            return dismissibleProductCard(
                              context,
                              snapshotData.data[index].id,
                              dataStore,
                              tab.name,
                              snapshotData.data[index].productId,
                              snapshotData.data[index].name,
                              snapshotData.data[index].price,
                              snapshotData.data[index].quantity,
                              snapshotData.data[index].image,
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
