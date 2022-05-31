import 'package:example/routes/complex/name_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'complex/note_input.dart';

/// Shows off the minimal functionality of the white label component
class ExtendableWhiteLabelExample extends StatelessWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Currencies supported by Paylike
  final PaylikeCurrencies currencies;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;
  const ExtendableWhiteLabelExample(
      {Key? key,
      required this.engine,
      required this.currencies,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key);

  Widget content() {
    return SafeArea(
        child: Center(
            child: SingleChildScrollView(
                child: Column(
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: PaylikeExtendableWhiteLabelWidget(
              style: style,
              engine: engine,
              options: BasePayment(
                  amount: Money.fromDouble(
                      currencies.byCode(CurrencyCode.EUR), 11.5)),
              extensions: [
                CustomNameInput.init(style: style),
                CustomNoteInput.init(style: style),
              ],
            ))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ))));
  }

  @override
  Widget build(BuildContext context) {
    return style == PaylikeWidgetStyles.material
        ? Scaffold(
            appBar: AppBar(title: const Text('Complex white label demo')),
            body: content(),
          )
        : CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Complex white label demo'),
            ),
            child: content());
  }
}
