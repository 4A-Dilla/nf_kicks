import 'package:flutter/material.dart';

Card productCard(
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
