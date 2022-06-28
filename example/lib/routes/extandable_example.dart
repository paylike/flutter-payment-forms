import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

import 'extendable/note_input.dart';
import 'extendable/name_input.dart';

/// Shows off the minimal functionality of the white label component
class ExtendableWhiteLabelExample extends StatelessWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;
  const ExtendableWhiteLabelExample(
      {Key? key,
      required this.engine,
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
              options: BasePayment(amount: Money.fromDouble('EUR', 11.5)),
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
