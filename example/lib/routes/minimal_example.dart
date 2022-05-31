import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Shows off the minimal functionality of the white label component
class MinimalWhitelabelExample extends StatelessWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;

  /// Currencies supported by Paylike
  final PaylikeCurrencies currencies;
  const MinimalWhitelabelExample(
      {Key? key,
      required this.engine,
      required this.currencies,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var content = SafeArea(
        child: Center(
            child: SingleChildScrollView(
                child: Column(
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: PaylikeWhiteLabelWidget(
              style: style,
              engine: engine,
              options: BasePayment(
                  amount: Money.fromDouble(
                      currencies.byCode(CurrencyCode.EUR), 11.5)),
            ))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ))));

    if (style == PaylikeWidgetStyles.cupertino) {
      return CupertinoPageScaffold(
        child: content,
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Minimal white label demo'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Minimal white label demo')),
      body: content,
    );
  }
}
