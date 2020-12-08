import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/services/database/database_api.dart';

import '../../constants.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final DatabaseApi dataStore;
  final String storeName;

  const ProductPage({
    Key key,
    @required this.productId,
    @required this.dataStore,
    @required this.storeName,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
        stream: widget.dataStore.productStream(productId: widget.productId),
        builder: (context, AsyncSnapshot<Product> snapshotData) {
          if (!snapshotData.hasData) {
            return kLoadingNoLogo;
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!snapshotData.data.inStock ||
                    snapshotData.data.stock == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('This product is out of stock'),
                    duration: Duration(seconds: 1),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Product was added to your cart!'),
                    duration: Duration(seconds: 1),
                  ));

                  widget.dataStore.addToCart(
                      product: snapshotData.data,
                      quantity: quantity,
                      storeName: widget.storeName);
                }
              },
              child: Icon(Icons.add_shopping_cart),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                snapshotData.data.name,
                style: GoogleFonts.permanentMarker(),
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 360,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(snapshotData.data.image),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  snapshotData.data.name.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "€${snapshotData.data.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => {
                                    if (snapshotData.data.inStock &&
                                        snapshotData.data.stock > 0)
                                      {
                                        if (quantity < 2)
                                          {
                                            print("You can't do that too..."),
                                          }
                                        else
                                          {
                                            setState(() {
                                              quantity--;
                                            }),
                                          }
                                      }
                                    else
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'This product is not in stock!',
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        ),
                                      },
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  snapshotData.data.inStock
                                      ? quantity.toString()
                                      : 0.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    if (snapshotData.data.inStock &&
                                        snapshotData.data.stock > 0)
                                      {
                                        if (quantity ==
                                            snapshotData.data.stock.toInt())
                                          {print("You can't do that...")}
                                        else
                                          {
                                            setState(() {
                                              quantity++;
                                            })
                                          },
                                      }
                                    else
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'This product is not in stock!',
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        ),
                                      },
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "in-Stock".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      "${snapshotData.data.stock.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshotData.data.description,
                          style: TextStyle(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 400,
                    child: StreamBuilder<List<Product>>(
                        stream: widget.dataStore
                            .productsStream(storeId: snapshotData.data.storeId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print("Errors: ${snapshot.error}");
                            return kLoadingNoLogo;
                          }
                          if (!snapshot.hasData) {
                            return kLoadingNoLogo;
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data[index].id ==
                                  snapshotData.data.id) {
                                return Container();
                              } else {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        productId: snapshot.data[index].id,
                                        dataStore: widget.dataStore,
                                        storeName: widget.storeName,
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
                                                      snapshot.data[index].name
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
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child: Text(
                                                            "€${snapshot.data[index].price.toStringAsFixed(2)}",
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
                                                              color:
                                                                  Colors.black,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child: Text(
                                                              "${snapshot.data[index].stock.toStringAsFixed(0)}",
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
                                                          snapshot.data[index]
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
                                );
                              }
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
