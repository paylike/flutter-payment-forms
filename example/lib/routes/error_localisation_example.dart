import 'package:example/routes/error_localisation/error_scenario_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'error_localisation/language_input.dart';
import 'error_localisation/scenarios.dart';

/// Shows off the minimal functionality of the white label component
class ErrorLocalisationExample extends StatefulWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;

  /// Currencies supported by Paylike
  final PaylikeCurrencies currencies;
  const ErrorLocalisationExample(
      {Key? key,
      required this.engine,
      required this.currencies,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ErrorLocalisationExampleState();
}

class _ErrorLocalisationExampleState extends State<ErrorLocalisationExample> {
  ErrorScenario current = ErrorScenarios.insufficentFunds;

  Widget content(BuildContext context) {
    return SafeArea(
        child: Center(
            child: SingleChildScrollView(
                child: Column(
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: ComplexWhiteLabelWidget(
              style: widget.style,
              engine: widget.engine,
              options: BasePayment(
                  amount: Money.fromDouble(
                      widget.currencies.byCode(CurrencyCode.EUR), 11.5)),
              testConfig: current.testConfig,
              extensions: [
                LanguageInput.init(
                  onChange: () => setState(() {}),
                  style: widget.style,
                ),
                ErrorScenarioInput.init(
                  current: current,
                  onChanged: (ErrorScenario? to) => setState(() {
                    current = to as ErrorScenario;
                  }),
                  style: widget.style,
                ),
              ],
            ))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ))));
  }

  @override
  Widget build(BuildContext context) {
    return widget.style == PaylikeWidgetStyles.material
        ? Scaffold(
            appBar: AppBar(title: const Text('Error localisation example')),
            body: content(context),
          )
        : CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Error localisation example'),
            ),
            child: content(context));
  }
}
