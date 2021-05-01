// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/models/stripe_transaction_response.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/services/payments/payments.dart';

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
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> payViaNewCard(BuildContext context) async {
    final StripeTransactionResponse response = await Payments.payWithNewCard(
      amount: widget.totalPrice
          .toStringAsFixed(2)
          .replaceAll(new RegExp(r"[^a-z0-9_]+"), ''),
    );
    if (response.success == true) {
      widget.dataStore.createOrder(
        order: Order(
          products: widget.productListMap,
          isComplete: false,
          totalPrice: widget.totalPrice,
          readyForPickup: false,
          dateOpened: Timestamp.now(),
        ),
        storeName: widget.currentTabName,
      );
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An order has been made!',
          ),
          duration: Duration(
            seconds: 1,
          ),
        ),
      );
    }

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration:
            Duration(milliseconds: response.success == true ? 1200 : 3000),
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
            const Text(
              "Total Price:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.totalPrice.toStringAsFixed(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        ButtonTheme(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
            ),
            onPressed: () => payViaNewCard(context),
            child: const Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
