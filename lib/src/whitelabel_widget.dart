import 'package:flutter/material.dart';
import 'package:paylike_flutter_engine/paylike_flutter_engine.dart';
import 'package:paylike_sdk/src/input/card_number_input.dart';
import 'package:paylike_sdk/src/input/cvc_input.dart';
import 'package:paylike_sdk/src/input/expiry_input.dart';
import 'package:paylike_sdk/src/repository/single.dart';

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
  final SingleRepository<String> _cardNumberRepository = SingleRepository();
  final SingleRepository<String> _expiryRepository = SingleRepository();
  final SingleRepository<String> _cvcRepository = SingleRepository();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardInput(fieldRepository: _cardNumberRepository),
            Row(
              children: [
                Expanded(
                    child: ExpiryInput(expiryRepository: _expiryRepository)),
                const Spacer(),
                Expanded(child: CVCInput(cvcRepository: _cvcRepository)),
              ],
            ),
            ElevatedButton(
                onPressed: () => print('yo'), child: const Text('Pay')),
          ],
        ));
  }
}
