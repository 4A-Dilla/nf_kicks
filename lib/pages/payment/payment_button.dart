import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/services/payments/payments.dart';
import 'package:nf_kicks/utils/end_to_end_encryption.dart';

class PaymentsButton extends StatefulWidget {
  final double totalPrice;
  final DatabaseApi dataStore;
  final List<Map<String, dynamic>> productListMap;
  final String currentTabName;

  const PaymentsButton(
      {Key key,
      @required this.totalPrice,
      @required this.dataStore,
      @required this.productListMap,
      @required this.currentTabName})
      : super(key: key);

  @override
  _PaymentsButtonState createState() => _PaymentsButtonState();
}

class _PaymentsButtonState extends State<PaymentsButton> {
  payViaNewCard(BuildContext context) async {
    var dialog =
        showProgressDialog(context: context, loadingText: 'Please wait...');
    var response = await Payments.payWithNewCard(
      amount: widget.totalPrice
          .toStringAsFixed(2)
          .replaceAll(new RegExp(r"[^a-z0-9_]+"), ''),
    );
    if (response.success == true) {
      widget.dataStore.createOrder(
        order: new Order(
          products: widget.productListMap,
          isComplete: false,
          totalPrice: widget.totalPrice,
          readyForPickup: false,
          dateOpened: Timestamp.now(),
        ),
        storeName: widget.currentTabName,
      );

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
    }
    dialog.dismiss();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration:
            new Duration(milliseconds: response.success == true ? 1200 : 3000),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Payments.init();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.totalPrice.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        FlatButton(
          onPressed: () {
            payViaNewCard(context);
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
}
