import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/cartItem.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';

import '../../constants.dart';

class CartPage extends StatefulWidget {
  final DatabaseApi dataStore;

  const CartPage({Key key, this.dataStore}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 0;
  TabController _tabController;

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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.deepOrangeAccent,
              elevation: 4.0,
              label:
                  Text("Checkout: ${totalPrice.toStringAsFixed(2).toString()}"),
              onPressed: () {},
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Cart",
                style: GoogleFonts.permanentMarker(),
              ),
              automaticallyImplyLeading: true,
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
              controller: _tabController,
              children: [
                for (final tab in snapshot.data)
                  StreamBuilder<List<CartItem>>(
                    stream: widget.dataStore
                        .storeCartStream(storeCartName: tab.name),
                    builder:
                        (context, AsyncSnapshot<List<CartItem>> snapshotData) {
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
                          if (snapshotData.data.isNotEmpty) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  Text("Total Price: "),
                                  GestureDetector(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${snapshotData.data[index].name}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Text(
                                                              "€${snapshotData.data[index].price.toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
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
                                                                color: Colors
                                                                    .black,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Text(
                                                                "Quantity: ${snapshotData.data[index].quantity.toStringAsFixed(0)}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
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
                                                                .data[index]
                                                                .image),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                  ),
                                ],
                              );
                            }
                            return GestureDetector(
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
                                                  "${snapshotData.data[index].name}",
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
                                                          "Quantity: ${snapshotData.data[index].quantity.toStringAsFixed(0)}",
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
