import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Shows off the minimal functionality of the white label component
class MinimalWhitelabelExample extends StatelessWidget {
  final PaylikeEngine engine;
  final PaylikeCurrencies currencies;
  const MinimalWhitelabelExample(
      {Key? key, required this.engine, required this.currencies})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Minimal white label demo'),
        ),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
          children: [
            WhiteLabelWidget(
              engine: engine,
              options: BasePayment(
                  amount: Money.fromDouble(
                      currencies.byCode(CurrencyCode.EUR), 11.5)),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )))));
  }
}
