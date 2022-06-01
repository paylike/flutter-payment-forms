import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pay/pay.dart';
import 'package:paylike_flutter_engine/domain.dart';
import 'package:paylike_flutter_engine/exception.dart';
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
class PaylikeWhiteLabelWidget extends StatefulWidget {
  /// Required for completing a payment flow
  ///
  /// The engine is a ChangeNotifier and can emit events. Whenever an event is emitted,
  /// it changes state which you can access by [engine.current]. More information: [PaylikeEngine]
  final PaylikeEngine engine;

  /// Contains the options for the payment to execute
  ///
  /// This is required because we do not know
  /// if the user is going to pay by Apple Pay or card
  final BasePayment options;

  /// Can be used to simulate scenarios in our sandbox environment,
  /// [more info here.](https://github.com/paylike/api-reference/blob/main/payments/index.md#test)
  ///
  /// Optional, empty by default
  final Map<String, dynamic>? testConfig;

  /// Describes the style which we use to render the default input components
  ///
  /// Optional, material by default
  final PaylikeWidgetStyles style;

  /// Describes the name of the payment config
  ///
  /// You need to have a payment config json in your assets
  /// which describes to Apple Pay your payment.
  ///
  /// Optional, 'payment_config.json' by default
  final String paymentConfigName;

  const PaylikeWhiteLabelWidget(
      {Key? key,
      required this.engine,
      required this.options,
      this.paymentConfigName = 'payment_config.json',
      this.testConfig,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _WhiteLabelWidgetState();
}

/// Describe the ancestor state for the payment forms widget
///
/// Take a look at [PaylikeExtendableWhiteLabelWidget] to see how to use this state as an ancestor
class PaylikeFormWidgetState<T extends PaylikeWhiteLabelWidget>
    extends State<T> {
  /// Stores error messages and exceptions
  final SingleRepository<PaylikeFormsError> errorMessageRepository =
      SingleRepository(validator: (e) => true);

  /// Used for tracking the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Card number

  final SingleRepository<String> cardNumberRepository =
      SingleRepository(validator: CardNumberValidator.isValid);
  final InputDisplayService cardService = InputDisplayService();

  /// Expiry

  final ExpiryRepository expiryRepository =
      ExpiryRepository(validator: ExpiryValidator.isValid);
  final InputDisplayService expiryService = InputDisplayService();

  /// CVC

  final SingleRepository<String> cvcRepository =
      SingleRepository(validator: CVCValidator.isValid);
  final InputDisplayService cvcService = InputDisplayService();

  /// Tracks if the payment is in progress or not
  bool isLoading = false;

  /// Listens to engine events and updates the widget if anything happens
  void engineListener() {
    setState(() {
      if (widget.engine.current == EngineState.errorHappened) {
        errorMessageRepository.set(PaylikeFormsError(
            engineError: widget.engine.error as PaylikeEngineError));
        isLoading = false;
        return;
      }
      errorMessageRepository.reset();
      if (widget.engine.current == EngineState.done) {
        isLoading = false;
        return;
      }
      isLoading = widget.engine.current != EngineState.waitingForInput;
    });
  }

  /// Used for centralized error collection
  ///
  /// Receives a function in the parameter that can be async, after running it
  /// if an exception happened, it updates the [errorMessageRepository]
  Future<void> errorHandler(Function() fn) async {
    try {
      await fn();
    } on PaylikeException catch (e) {
      errorMessageRepository.set(PaylikeFormsError(apiException: e));
      setState(() {});
    } on PaylikeEngineError catch (e) {
      errorMessageRepository.set(PaylikeFormsError(engineError: e));
      setState(() {});
    } on Exception catch (e) {
      errorMessageRepository.set(PaylikeFormsError(exception: e));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.engine.addListener(engineListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.engine.removeListener(engineListener);
  }

  /// Validates input fields
  ///
  /// Essentially runs the validators of the available repositories. It is used
  /// directly before executing a payment initiation request
  bool inputsValid() {
    cvcService.change(
        cvcRepository.isValid() ? InputStates.valid : InputStates.invalid);
    expiryService.change(
        expiryRepository.isValid() ? InputStates.valid : InputStates.invalid);
    cardService.change(cardNumberRepository.isValid()
        ? InputStates.valid
        : InputStates.invalid);
    return ([cvcService, expiryService, cardService]
        .every((e) => e.current == InputStates.valid));
  }

  /// Executes a card payment based on the input information
  void executeCardPayment() async {
    if (isLoading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isLoading = true);
    await errorHandler(() async {
      if (!inputsValid()) {
        throw Exception('Invalid input information. Please try again.');
      }
      var number = cardNumberRepository.item.replaceAll(" ", "");
      var cvc = cvcRepository.item;
      var tokenized = await widget.engine.tokenize(number, cvc);
      await widget.engine.createPayment(
          CardPayment.fromBasePayment(
              PaylikeCard(
                details: tokenized,
                expiry: expiryRepository.parse,
              ),
              widget.options),
          testConfig: widget.testConfig);
    });
  }

  /// Executes an Apple Pay payment
  ///
  /// Requires the result to be from Apple API
  void executeApplePayPayment(Map<String, dynamic> result) async {
    if (isLoading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isLoading = true);
    await errorHandler(() async {
      var token = result['token'];
      var tokenized = await widget.engine.tokenizeAppleToken(token);
      await widget.engine.createPaymentWithApple(
          ApplePayPayment.fromBasePayment(tokenized, widget.options),
          testConfig: widget.testConfig);
    });
  }

  /// Returns the raw version of the engine widget capable of showing the webview
  Widget get rawEngineWidget =>
      PaylikeEngineWidget(engine: widget.engine, showEmptyState: true);

  /// Webview widget provided by [PaylikeEngineWidget]
  @nonVirtual
  Widget webview() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [rawEngineWidget]);
  }

  /// Card number, expiry and CVC inputs
  @nonVirtual
  List<Widget> inputFields() {
    return [
      CardInput(
          repository: cardNumberRepository,
          service: cardService,
          style: widget.style),
      Row(
        children: [
          Expanded(
              child: ExpiryInput(
                  repository: expiryRepository,
                  service: expiryService,
                  style: widget.style)),
          const Spacer(),
          Expanded(
              child: CVCInput(
                  repository: cvcRepository,
                  service: cvcService,
                  style: widget.style)),
        ],
      )
    ];
  }

  /// Error message display
  @nonVirtual
  Widget formError() {
    return WhitelabelErrorWidget(
        isVisible: errorMessageRepository.isAvailable,
        message: errorMessageRepository.isAvailable
            ? errorMessageRepository.item.displayMessage
            : '');
  }

  /// Loading indicator based on widget style
  @nonVirtual
  Widget loadingIndicator(BuildContext context) {
    if (widget.style == PaylikeWidgetStyles.material) {
      return SpinKitDualRing(color: Theme.of(context).colorScheme.primary);
    } else {
      return SpinKitDualRing(color: CupertinoTheme.of(context).primaryColor);
    }
  }

  /// Card pay and apple pay button
  @nonVirtual
  List<Widget> payButtons(BuildContext context) {
    if (isLoading) {
      return [loadingIndicator(context)];
    }
    Widget payButton = ElevatedButton(
        onPressed: () => executeCardPayment(),
        child: Text(PaylikeLocalizator.getKey('PAY')));
    var backgroundColor = Theme.of(context).backgroundColor;
    var applePayColor = backgroundColor.computeLuminance() > 0.5
        ? ApplePayButtonStyle.black
        : ApplePayButtonStyle.white;
    if (widget.style == PaylikeWidgetStyles.cupertino) {
      payButton = CupertinoButton(
          child: Text(PaylikeLocalizator.getKey('PAY')),
          onPressed: () => executeCardPayment());
      backgroundColor = CupertinoTheme.of(context).scaffoldBackgroundColor;
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
    throw UnimplementedError();
  }
}

class _WhiteLabelWidgetState extends PaylikeFormWidgetState {
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
