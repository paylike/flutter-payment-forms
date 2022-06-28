import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Shows off the minimal functionality of the paylike style component
class PaylikeStyleExample extends StatelessWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Describes the style of the example
  final PaylikeWidgetStyles style;

  const PaylikeStyleExample(
      {Key? key,
      required this.engine,
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
            child: PaylikePayWidget(
              style: style,
              engine: engine,
              options: BasePayment(amount: Money.fromDouble('EUR', 11.5)),
            ))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ))));

    if (style == PaylikeWidgetStyles.cupertino) {
      return CupertinoPageScaffold(
        child: content,
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Paylike style Pay widget'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Paylike style Pay widget')),
      body: content,
    );
  }
}
