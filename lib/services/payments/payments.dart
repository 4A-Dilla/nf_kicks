// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:stripe_payment/stripe_payment.dart';

// Project imports:
import 'package:nf_kicks/models/stripe_transaction_response.dart';

// final String _apiUrl = FlutterConfig.get('STRIPE_API_URL').toString();
final String _apiUrl = env['STRIPE_API_URL'].toString();
final String _paymentApiUrl = '$_apiUrl/payment_intents';
// final String _secret = FlutterConfig.get('STRIPE_SECRET').toString();
final String _secret = env['STRIPE_SECRET'].toString();
final Map<String, String> _headers = {
  'Authorization': 'Bearer $_secret',
  'Content-Type': 'application/x-www-form-urlencoded'
};

StripeTransactionResponse _getPlatformExceptionErrorResult(error) {
  String message = 'Something went wrong';
  if (error.code == 'cancelled') {
    message = 'Transaction cancelled';
  }

  return StripeTransactionResponse(message: message, success: false);
}

Future<Map<String, dynamic>> _createPaymentIntent(String amount) async {
  try {
    final Map<String, dynamic> body = {
      'amount': amount,
      'currency': 'EUR',
      'payment_method_types[]': 'card'
    };
    final Response response =
        await http.post(_paymentApiUrl, body: body, headers: _headers);
    return jsonDecode(response.body) as Map<String, dynamic>;
  } catch (error) {
    print('err charging user: ${error.toString()}');
  }
  return null;
}

class Payments {
  static void init() {
    StripePayment.setOptions(
      StripeOptions(
          // publishableKey: FlutterConfig.get('PUBLISHABLE_KEY').toString(),
          publishableKey: env['PUBLISHABLE_KEY'].toString(),
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount}) async {
    try {
      final PaymentMethod paymentMethod =
          await StripePayment.paymentRequestWithCardForm(
              CardFormPaymentRequest());
      final Map<String, dynamic> paymentIntent =
          await _createPaymentIntent(amount);
      final PaymentIntentResult response =
          await StripePayment.confirmPaymentIntent(
        PaymentIntent(
            clientSecret: paymentIntent['client_secret'].toString(),
            paymentMethodId: paymentMethod.id),
      );
      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (error) {
      return _getPlatformExceptionErrorResult(error);
    } catch (error) {
      return StripeTransactionResponse(
          message: 'Transaction failed: ${error.toString()}', success: false);
    }
  }
}
