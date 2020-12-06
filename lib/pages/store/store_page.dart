import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/something_went_wrong_page.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class StorePage extends StatelessWidget {
  final String storeId;
  final DatabaseApi dataStore;

  StorePage({
    @required this.storeId,
    @required this.dataStore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              child: StreamBuilder<Store>(
                  stream: dataStore.storeStream(storeId: storeId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return kLoadingNoLogo;
                    }
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(snapshot.data.storeImage),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          color: Colors.deepOrangeAccent,
                          child: Column(
                            children: [
                              Text('${snapshot.data.name}'),
                              Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      snapshot.data.inStorePickup
                                          ? Icons.check
                                          : Icons.close,
                                      color: snapshot.data.inStorePickup
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      size: 15,
                                    ),
                                    Text(
                                      "- In store pickup",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black),
                                    ),
                                    Icon(
                                      snapshot.data.inStoreShopping
                                          ? Icons.check
                                          : Icons.close,
                                      color: snapshot.data.inStoreShopping
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      size: 15,
                                    ),
                                    Text(
                                      "- In store shopping",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              height: 250,
              child: StreamBuilder<List<Product>>(
                  stream: dataStore.productsStream(storeId: storeId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return kLoadingNoLogo;
                    }
                    return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                  productId: snapshot.data[index].id,
                                  dataStore: dataStore),
                            ),
                          ),
                          child: new Card(
                            elevation: 2.6,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image:
                                      NetworkImage(snapshot.data[index].image),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data[index].name),
                                  Text(
                                      '€${snapshot.data[index].price.toStringAsFixed(2)}'),
                                ],
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
      ),
    );
  }
}
