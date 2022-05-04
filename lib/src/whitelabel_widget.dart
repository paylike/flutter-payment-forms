import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paylike_flutter_engine/engine_widget.dart';
import 'package:paylike_flutter_engine/paylike_flutter_engine.dart';
import 'package:paylike_sdk/src/domain/error.dart';
import 'package:paylike_sdk/src/exceptions.dart';
import 'package:paylike_sdk/src/input/card_number_input.dart';
import 'package:paylike_sdk/src/input/cvc_input.dart';
import 'package:paylike_sdk/src/input/expiry_input.dart';
import 'package:paylike_sdk/src/repository/expiry.dart';
import 'package:paylike_sdk/src/repository/single.dart';

import 'error_widget.dart';

/// The most simple widget of the package built for providing
/// a simple card, expiry and cvc code field, optionally a pay button as well
class WhiteLabelWidget extends StatefulWidget {
  /// Required for completing a payment flow
  final PaylikeEngine engine;

  /// Contains the options for the payment to execute
  final BasePayment options;

  /// Describes the name of the payment config
  ///
  /// You need to have a payment config json in your assets
  /// which describes to Apple Pay your payment. More information TODO
  final String paymentConfigName;

  const WhiteLabelWidget(
      {Key? key,
      required this.engine,
      required this.options,
      this.paymentConfigName = 'payment_config.json'})
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

  Future<void> _errorHandler(Function() fn) async {
    try {
      await fn();
    } on PaylikeException catch (e) {
      _errorMessageRepository.set(PaylikeFormsError(apiException: e));
      setState(() {});
    } on PaylikeEngineError catch (e) {
      _errorMessageRepository.set(PaylikeFormsError(engineError: e));
      setState(() {});
    } on Exception catch (e) {
      _errorMessageRepository.set(PaylikeFormsError(exception: e));
      setState(() {});
    }
  }

  /// Executes a card payment based on the input information
  void executeCardPayment() async {
    await _errorHandler(() async {
      var number = _cardNumberRepository.item.replaceAll(" ", "");
      var cvc = _cvcRepository.item;
      var tokenized = await widget.engine.tokenize(number, cvc);
      await widget.engine.createPayment(CardPayment.fromBasePayment(
          PaylikeCard(
            details: tokenized,
            expiry: _expiryRepository.parse,
          ),
          widget.options));
    });
  }

  void onApplePayResult(Map<String, dynamic> result) async {
    await _errorHandler(() async {
      var token = result['token'];
      var tokenized = await widget.engine.tokenizeAppleToken(token);
      await widget.engine.createPaymentWithApple(
          ApplePayPayment.fromBasePayment(tokenized, widget.options));
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SingleRepository<String> _cardNumberRepository = SingleRepository();
  final ExpiryRepository _expiryRepository = ExpiryRepository();
  final SingleRepository<String> _cvcRepository = SingleRepository();
  final SingleRepository<PaylikeFormsError> _errorMessageRepository =
      SingleRepository();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              PaylikeEngineWidget(engine: widget.engine, showEmptyState: true),
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
            WhitelabelErrorWidget(
                isVisible: _errorMessageRepository.isAvailable,
                message: _errorMessageRepository.isAvailable
                    ? _errorMessageRepository.item.displayMessage
                    : ''),
            Row(children: [
              const Spacer(),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () => executeCardPayment(),
                      child: const Text('Pay'))),
              const Spacer(),
            ]),
            Visibility(
                visible: Platform.isIOS,
                child: Container(
                  child: const Text('OR'),
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                )),
            Visibility(
                visible: Platform.isIOS,
                child: Row(children: [
                  const Spacer(),
                  Expanded(
                      child: ApplePayButton(
                    paymentConfigurationAsset: widget.paymentConfigName,
                    paymentItems: [
                      PaymentItem(
                          label: 'Total',
                          amount: widget.options.amount!.toRepresentationString(
                              options: const PaymentAmountStringOptions(
                                  currency: false)),
                          status: PaymentItemStatus.final_price)
                    ],
                    style: ApplePayButtonStyle.black,
                    type: ApplePayButtonType.buy,
                    onPaymentResult: onApplePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )),
                  const Spacer(),
                ])),
          ],
        ));
  }
}
