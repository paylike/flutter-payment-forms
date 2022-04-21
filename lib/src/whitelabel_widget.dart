import 'package:flutter/material.dart';
import 'package:paylike_flutter_engine/paylike_flutter_engine.dart';

/// The most simple widget of the package built for providing
/// a simple card, expiry and cvc code field, optionally a pay button as well
class WhiteLabelWidget extends StatefulWidget {
  /// Required for completing a payment flow
  final PaylikeEngine engine;
  const WhiteLabelWidget({Key? key, required this.engine}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WhiteLabelWidgetState();
}

class _WhiteLabelWidgetState extends State<WhiteLabelWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Card field"),
            const Text("Expiry + CVC"),
            ElevatedButton(
                onPressed: () => print('yo'), child: const Text('Pay')),
          ],
        ));
  }
}
