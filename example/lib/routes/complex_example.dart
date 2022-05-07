import 'package:example/routes/complex/name_input.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'complex/note_input.dart';

/// Shows off the minimal functionality of the white label component
class ComplexWhiteLabelExample extends StatelessWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Currencies supported by Paylike
  final PaylikeCurrencies currencies;
  const ComplexWhiteLabelExample(
      {Key? key, required this.engine, required this.currencies})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Complex white label demo')),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: ComplexWhiteLabelWidget(
                  engine: engine,
                  options: BasePayment(
                      amount: Money.fromDouble(
                          currencies.byCode(CurrencyCode.EUR), 11.5)),
                  extensions: [
                    CustomNameInput.init(),
                    CustomNoteInput.init(),
                  ],
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )))));
  }
}
