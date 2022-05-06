import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Shows off the minimal functionality of the white label component
class ErrorLocalisationExample extends StatefulWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Currencies supported by Paylike
  final PaylikeCurrencies currencies;
  const ErrorLocalisationExample(
      {Key? key, required this.engine, required this.currencies})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ErrorLocalisationExampleState();
}

class _ErrorLocalisationExampleState extends State<ErrorLocalisationExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Error & localisation demo')),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: WhiteLabelWidget(
                  engine: widget.engine,
                  options: BasePayment(
                      amount: Money.fromDouble(
                          widget.currencies.byCode(CurrencyCode.EUR), 11.5)),
                  testConfig: {
                    'card': {
                      'balance': {
                        'currency':
                            widget.currencies.byCode(CurrencyCode.EUR).code,
                        'value': 0,
                        'exponent': 0,
                      }
                    }
                  },
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )))));
  }
}
