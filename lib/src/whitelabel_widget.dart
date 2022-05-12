import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paylike_flutter_engine/engine_widget.dart';
import 'package:paylike_flutter_engine/paylike_flutter_engine.dart';
import 'package:paylike_sdk/src/domain/error.dart';
import 'package:paylike_sdk/src/input/base_input.dart';
import 'package:paylike_sdk/src/input/card_number_input.dart';
import 'package:paylike_sdk/src/input/cvc_input.dart';
import 'package:paylike_sdk/src/input/display_service.dart';
import 'package:paylike_sdk/src/input/expiry_input.dart';
import 'package:paylike_sdk/src/localization/localizator.dart';
import 'package:paylike_sdk/src/repository/expiry.dart';
import 'package:paylike_sdk/src/repository/single.dart';
import 'package:paylike_sdk/src/validators/card_number.dart';
import 'package:paylike_sdk/src/validators/cvc.dart';
import 'package:paylike_sdk/src/validators/expiry.dart';

import 'error_widget.dart';
import 'styling/styles.dart';

/// The most simple widget of the package built for providing
/// a simple card, expiry and cvc code field, optionally a pay button as well
class WhiteLabelWidget extends StatefulWidget {
  /// Required for completing a payment flow
  final PaylikeEngine engine;

  /// Contains the options for the payment to execute
  final BasePayment options;

  /// Can be used to simulate scenarios in our sandbox environment,
  /// [more info here.](https://github.com/paylike/api-reference/blob/main/payments/index.md#test)
  final Map<String, dynamic>? testConfig;

  /// Describes the style which we use to render the default input components
  final PaylikeWidgetStyles style;

  /// Describes the name of the payment config
  ///
  /// You need to have a payment config json in your assets
  /// which describes to Apple Pay your payment. More information TODO
  final String paymentConfigName;

  const WhiteLabelWidget(
      {Key? key,
      required this.engine,
      required this.options,
      this.paymentConfigName = 'payment_config.json',
      this.testConfig,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => WhiteLabelWidgetState();
}

class WhiteLabelWidgetState extends State<WhiteLabelWidget> {
  /// Listens to engine events and updates the widget if anything happens
  void _engineListener() {
    setState(() {
      if (widget.engine.current == EngineState.errorHappened) {
        _errorMessageRepository.set(PaylikeFormsError(
            engineError: widget.engine.error as PaylikeEngineError));
        return;
      }
      _errorMessageRepository.reset();
    });
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

  /// Validates input fields
  bool inputsValid() {
    _cvcService.change(
        _cvcRepository.isValid() ? InputStates.valid : InputStates.invalid);
    _expiryService.change(
        _expiryRepository.isValid() ? InputStates.valid : InputStates.invalid);
    _cardService.change(_cardNumberRepository.isValid()
        ? InputStates.valid
        : InputStates.invalid);
    return ([_cvcService, _expiryService, _cardService]
        .every((e) => e.current == InputStates.valid));
  }

  /// Executes a card payment based on the input information
  void executeCardPayment() async {
    await _errorHandler(() async {
      if (!inputsValid()) {
        throw Exception('Invalid input information. Please try again.');
      }
      var number = _cardNumberRepository.item.replaceAll(" ", "");
      var cvc = _cvcRepository.item;
      var tokenized = await widget.engine.tokenize(number, cvc);
      await widget.engine.createPayment(
          CardPayment.fromBasePayment(
              PaylikeCard(
                details: tokenized,
                expiry: _expiryRepository.parse,
              ),
              widget.options),
          testConfig: widget.testConfig);
    });
  }

  /// Executes an Apple Pay payment
  void executeApplePayPayment(Map<String, dynamic> result) async {
    await _errorHandler(() async {
      var token = result['token'];
      var tokenized = await widget.engine.tokenizeAppleToken(token);
      await widget.engine.createPaymentWithApple(
          ApplePayPayment.fromBasePayment(tokenized, widget.options),
          testConfig: widget.testConfig);
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Card number

  final SingleRepository<String> _cardNumberRepository =
      SingleRepository(validator: CardNumberValidator.isValid);
  final InputDisplayService _cardService = InputDisplayService();

  /// Expiry

  final ExpiryRepository _expiryRepository =
      ExpiryRepository(validator: ExpiryValidator.isValid);
  final InputDisplayService _expiryService = InputDisplayService();

  /// CVC

  final SingleRepository<String> _cvcRepository =
      SingleRepository(validator: CVCValidator.isValid);
  final InputDisplayService _cvcService = InputDisplayService();

  /// Errors

  final SingleRepository<PaylikeFormsError> _errorMessageRepository =
      SingleRepository(validator: (e) => true);

  /// Webview widget provided by [PaylikeEngineWidget]
  @nonVirtual
  Widget webview() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      PaylikeEngineWidget(engine: widget.engine, showEmptyState: true),
    ]);
  }

  /// Card number, expiry and CVC inputs
  @nonVirtual
  List<Widget> inputFields() {
    return [
      CardInput(
          repository: _cardNumberRepository,
          service: _cardService,
          style: widget.style),
      Row(
        children: [
          Expanded(
              child: ExpiryInput(
                  repository: _expiryRepository,
                  service: _expiryService,
                  style: widget.style)),
          const Spacer(),
          Expanded(
              child: CVCInput(
                  repository: _cvcRepository,
                  service: _cvcService,
                  style: widget.style)),
        ],
      )
    ];
  }

  /// Error message display
  @nonVirtual
  Widget formError() {
    return WhitelabelErrorWidget(
        isVisible: _errorMessageRepository.isAvailable,
        message: _errorMessageRepository.isAvailable
            ? _errorMessageRepository.item.displayMessage
            : '');
  }

  /// Card pay and apple pay button
  @nonVirtual
  List<Widget> payButtons(BuildContext context) {
    Widget payButton = ElevatedButton(
        onPressed: () => executeCardPayment(),
        child: Text(PaylikeLocalizator.getKey('PAY')));

    var backgroundColor =
        Theme.of(context).backgroundColor; // this color could be anything
    var applePayColor = backgroundColor.computeLuminance() > 0.5
        ? ApplePayButtonStyle.black
        : ApplePayButtonStyle.white;
    if (widget.style == PaylikeWidgetStyles.cupertino) {
      payButton = CupertinoButton(
          child: Text(PaylikeLocalizator.getKey('PAY')),
          onPressed: () => executeCardPayment());
      backgroundColor = CupertinoTheme.of(context)
          .scaffoldBackgroundColor; // this color could be anything
      applePayColor = backgroundColor.computeLuminance() > 0.5
          ? ApplePayButtonStyle.black
          : ApplePayButtonStyle.white;
    }
    return [
      Row(children: [
        const Spacer(),
        Expanded(child: payButton),
        const Spacer(),
      ]),
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
                        options:
                            const PaymentAmountStringOptions(currency: false)),
                    status: PaymentItemStatus.final_price)
              ],
              style: applePayColor,
              type: ApplePayButtonType.buy,
              onPaymentResult: executeApplePayPayment,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            )),
            const Spacer(),
          ]))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            webview(),
            ...inputFields(),
            formError(),
            ...payButtons(context),
          ],
        ));
  }
}
