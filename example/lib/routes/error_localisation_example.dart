import 'package:example/routes/error_localisation/error_scenario_input.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'error_localisation/language_input.dart';
import 'error_localisation/scenarios.dart';

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
  ErrorScenario current = ErrorScenarios.insufficentFunds;
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
                child: ComplexWhiteLabelWidget(
                  engine: widget.engine,
                  options: BasePayment(
                      amount: Money.fromDouble(
                          widget.currencies.byCode(CurrencyCode.EUR), 11.5)),
                  testConfig: current.testConfig,
                  extensions: [
                    LanguageInput.init(
                      onChange: () => setState(() {}),
                    ),
                    ErrorScenarioInput.init(
                      current: current,
                      onChanged: (ErrorScenario? to) => setState(() {
                        current = to as ErrorScenario;
                      }),
                    ),
                  ],
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )))));
  }
}
