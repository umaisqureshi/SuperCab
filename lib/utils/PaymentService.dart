import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:supercab/models/customerModel.dart';
import 'package:supercab/models/errorModel.dart';

class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static final StripeService _stripeService = StripeService._internal();

  factory StripeService() {
    return _stripeService;
  }

  StripeService._internal();

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      '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';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  init() {
  /*  StripePayment.setOptions(StripeOptions(
      publishableKey:
          "pk_live_51IJcgHI3kUuPjRdVNvevID4sI4KaYo2HemI1xvt3ypMbaNmdXEZKAVtdoZ5CSoG1cPGzKZXA1iKHu5vtDRUQgcPX00ntlouHcv",
      merchantId: Platform.isIOS ? 'test' : '17219220232680698158',
      androidPayMode: 'production',
    ));*/
  }

  getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  nativePay(int totalCost) async {
/*    await StripePayment.canMakeNativePayPayments([]);
    await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: totalCost.toString(),
        currencyCode: "USD",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'US',
        currencyCode: 'USD',
        items: [
          ApplePayItem(
            label: 'Test',
            amount: '13',
          )
        ],
      ),
    );
    await StripePayment.completeNativePayRequest();*/
  }

  /*Future<PaymentMethod> createPaymentMethod(CreditCard card) async {
    return await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card));
  }*/

/*  Future confirmPayment(
      {String amount, String currency, id, customerId}) async {
    var paymentIntent =
        await createCustomerPaymentIntent(amount, currency, customerId);

    var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent['client_secret'], paymentMethodId: id));
    print(response.status);

    if (response.status == 'succeeded') {
      print(response.paymentIntentId);
      print(response.paymentMethodId);

      return new StripeTransactionResponse(
          message: 'Transaction successful', success: true);
    } else {
      return new StripeTransactionResponse(
          message: 'Transaction failed', success: false);
    }
  }*/

  Future<Map<String, dynamic>> createCustomerPaymentIntent(
      String amount, String currency, customerId) async {
    print("Customer id in payment Intent ::::::::::::::::: $customerId");
    print("Amount in payment Intent ::::::::::::::::: $amount");
    print("Currency in payment Intent ::::::::::::::::: $currency");
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'customer': customerId.toString(),
        'payment_method_types[]': 'card',
        // 'setup_future_usage':'off_session'
      };
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: StripeService.headers);
      print(response.body);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

  Future<StripeTransactionResponse> getCustomerID(id, name) async {
    try {
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/customers'),
          headers: StripeService.headers,
          body: {"description": name, "payment_method": id});
      var result = json.decode(response.body);
      //return response.statusCode==200? result['data'][0]['id']:'';
      return response.statusCode == 200
          ? StripeTransactionResponse(
              message: CustomerModel.fromJson(result).data[0].id, success: true)
          : StripeTransactionResponse(
              message: "Something went wrong", success: false);
    } catch (e) {
      if (e.toString().contains('error')) {
        throw StripeTransactionResponse(
            message: StripeErrorModel.fromJson(json.decode(e)).error.message,
            success: false);
      } else {
        throw e.toString();
      }
    }
  }
}
