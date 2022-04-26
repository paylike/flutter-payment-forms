import 'package:flutter/material.dart';
import 'package:paylike_flutter_engine/engine_widget.dart';
import 'package:paylike_flutter_engine/paylike_flutter_engine.dart';
import 'package:paylike_sdk/src/exceptions.dart';
import 'package:paylike_sdk/src/input/card_number_input.dart';
import 'package:paylike_sdk/src/input/cvc_input.dart';
import 'package:paylike_sdk/src/input/expiry_input.dart';
import 'package:paylike_sdk/src/repository/expiry.dart';
import 'package:paylike_sdk/src/repository/single.dart';

/// The most simple widget of the package built for providing
/// a simple card, expiry and cvc code field, optionally a pay button as well
class WhiteLabelWidget extends StatefulWidget {
  /// Required for completing a payment flow
  final PaylikeEngine engine;

  /// Contains the options for the payment to execute
  final BasePayment options;

  const WhiteLabelWidget(
      {Key? key, required this.engine, required this.options})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _WhiteLabelWidgetState();
}

class _WhiteLabelWidgetState extends State<WhiteLabelWidget> {
  /// Listens to engine events and updates the widget if anything happens
  void _engineListener() {
    setState(() => {});
  }

  @override
  void initState() {
    super.initState();
    widget.engine.addListener(_engineListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.engine.removeListener(_engineListener);
  }

  /// Executes a card payment based on the input information
  void executeCardPayment() async {
    try {
      var number = _cardNumberRepository.item.replaceAll(" ", "");
      var cvc = _cvcRepository.item;
      var tokenized = await widget.engine.tokenize(number, cvc);
      await widget.engine.createPayment(CardPayment.fromBasePayment(
          PaylikeCard(
            details: tokenized,
            expiry: _expiryRepository.parse,
          ),
          widget.options));
    } on NotFoundException catch (e) {
      /// TODO: Show validation error?
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SingleRepository<String> _cardNumberRepository = SingleRepository();
  final ExpiryRepository _expiryRepository = ExpiryRepository();
  final SingleRepository<String> _cvcRepository = SingleRepository();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              PaylikeEngineWidget(engine: widget.engine, showEmptyState: false),
            ]),
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
                onPressed: () => executeCardPayment(),
                child: const Text('Pay')),
          ],
        ));
  }
}
