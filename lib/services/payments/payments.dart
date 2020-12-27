import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:nf_kicks/models/stripeTransactionResponse.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Payments {
  // Todo make getters to access values
  static final String apiUrl = 'https://api.stripe.com/v1';
  static final String _paymentApiUrl = '${Payments.apiUrl}/payment_intents';
  static final String secret = 'sk_test_77GGQnProPxjztAvaC3dCiUM00a1Xc5vdW';
  static final Map<String, String> headers = {
    'Authorization': 'Bearer ${Payments.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: "pk_test_uWsbmRDANMClUuQjJpY4cAxZ",
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await Payments.createPaymentIntent(amount);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return Payments.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': 'EUR',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(Payments._paymentApiUrl,
          body: body, headers: Payments.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
