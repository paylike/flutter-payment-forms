import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

void main() {
  runApp(MyApp());
}

/// Replace this with your own client ID
///
/// Don't have a client ID? Head to [our platform](https://app.paylike.io) and create one
const clientId = 'e393f9ec-b2f7-4f81-b455-ce45b02d355d';

class MyApp extends StatelessWidget {
  final PaylikeCurrencies currencies = PaylikeCurrencies();
  final PaylikeEngine _engine = PaylikeEngine(clientId: clientId);
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paylike Payment Forms Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Paylike Payment Forms Demo'),
          ),
          body: SafeArea(
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(
            children: [
              WhiteLabelWidget(
                engine: _engine,
                options: BasePayment(
                    amount: Money.fromDouble(
                        currencies.byCode(CurrencyCode.EUR), 11.5)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ))))),
    );
  }
}
