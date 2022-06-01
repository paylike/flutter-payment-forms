# flutter-payment-forms
This is the high level SDK we provide for using the Paylike ecosystem with views included.

## Table of contents
* [Library navigator](#library-navigator)
* [Paylike white label widget](#paylikewhitelabelwidget)
* [Extendable white label widget](#paylikeextendablewhitelabelwidget)
* [Paylike styled pay widget](#paylikepaywidget)
* [Custom pay widget implementations](#custom-pay-widget-implementations)
  * [Business logic interface](#business-logic-interface)
  * [Example](#custom-pay-widget-example)

## Library navigator

This library was created to provide the simpliest way of integrating Paylike into your application. It provides a simple way to create a payment form and a simple way to handle the payment result.

If you are looking for our low level library supporting executing payments through our API, you are looking for our [Engine](https://github.com/paylike/flutter-engine) which is responsible for making the API integration including the webview required to execute TDS challenges

## PaylikeWhiteLabelWidget

This widget provides the most minimalistic way to implement a payment form.

Simple usage:
```dart
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

class YourPaymentScreen extends StatelessWidget {
  YourPaymentScreen({Key? key}) : super(key: key);
  final PaylikeEngine _engine = PaylikeEngine(clientId: 'YOUR_CLIENT_ID');
  final PaylikeCurrency _eur = PaylikeCurrencies().byCode(CurrencyCode.EUR);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment screen title')),
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
        children: [
          Container(
              margin: const EdgeInsets.all(10),
              child: PaylikeWhiteLabelWidget(
                engine: _engine,
                options: BasePayment(amount: Money.fromDouble(_eur, 11.5)),
              ))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )))),
    );
  }
}

```

## PaylikeExtendableWhiteLabelWidget

## PaylikePayWidget

## Custom pay widget implementation

As the SDK is built in a modular way you can decide how much customisation you would like to do.

`PaylikeWhiteLabelWidget` was designed to be an ancestor for all other payment widgets doing customisation. This also means that both `PaylikeExtendableWhiteLabelWidget` and `PaylikePayWidget` are descendants of `PaylikeWhiteLabelWidget`.

`PaylikeWhiteLabelWidget` is a `StatefulWidget` and we provide a handy modular way to extend its functionality by exporting our business logic in the following way:
```dart
class PaylikeFormWidgetState<T extends PaylikeWhiteLabelWidget>
    extends State<T>
```

This means that you can create a widget which is the descendant of `PaylikeWhiteLabelWidget` and customise it by creating a state like this:

```dart
class MyCustomPayWidget extends PaylikeWhiteLabelWidget{
  ///......
}
class _MyCustomPayWidgetState extends PaylikeFormWidgetState<MyCustomPayWidget> {
  ///......
}
```

### Business logic interface

Interface of the base widget:

```dart
/// The most simple widget of the package built for providing
/// a simple card, expiry and cvc code field, optionally a pay button as well
class PaylikeWhiteLabelWidget extends StatefulWidget {
  /// Required for completing a payment flow
  ///
  /// The engine is a ChangeNotifier and can emit events. Whenever an event is emitted,
  /// the engine changes its state which you can access by [engine.current]
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
  /// Optional, the default style is material
  final PaylikeWidgetStyles style;

  /// Describes the name of the payment config
  ///
  /// You need to have a payment config json in your assets
  /// which describes to Apple Pay your payment.
  ///
  /// Optional, 'payment_config.json' by default
  final String paymentConfigName;
}
```

In the state class after extending it, you can expect to have the following repositories and services:

```dart
  /// These repositories and services are responsible for storing and validating the user input
  /// They are not supposed to be overrided

  /// Stores error messages and exceptions
  final SingleRepository<PaylikeFormsError> errorMessageRepository =
      SingleRepository(validator: (e) => true);

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
```

If you want to manipulate the Form you can also do that by accessing:
```dart
  /// Used for tracking the state of the form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
```

The following functions are available over the state:
```dart
  /// Listens to engine events and updates the widget if anything happens
  void engineListener()

  /// Used for centralized error collection
  ///
  /// Receives a function in the parameter that can be async, after running it
  /// if an exception happened, it updates the [errorMessageRepository]
  Future<void> errorHandler(Function() fn)

  /// Used to add [engineListener] to the [engine]
  @override
  void initState()

  /// Used to remove [engineListener] from the [engine]
  @override
  void dispose()

  /// Validates input fields
  ///
  /// Essentially runs the validators of the available repositories. It is used
  /// directly before executing a payment initiation request
  bool inputsValid()

  /// Executes a card payment based on the input information
  void executeCardPayment()

  /// Executes an Apple Pay payment
  ///
  /// Requires the result to be from Apple API
  void executeApplePayPayment(Map<String, dynamic> result)

  /// Returns the raw version of the engine widget capable of showing the webview
  Widget get rawEngineWidget

  /*
    FUNCTIONS TO RENDER VIEW MODULES

    When something is annotated with @nonVirtual it means
    that you should not override those functions. If you would like to change
    the functionality in those "modules" then you should do that in the build function
  */

  /// Webview widget provided by [PaylikeEngineWidget]
  @nonVirtual
  Widget webview()

  /// Card number, expiry and CVC inputs
  @nonVirtual
  List<Widget> inputFields()

  /// Error message display
  @nonVirtual
  Widget formError()

  /// Loading indicator based on widget style
  @nonVirtual
  Widget loadingIndicator(BuildContext context)

  /// Card pay and apple pay button
  @nonVirtual
  List<Widget> payButtons(BuildContext context)
```

By default `build` is has an `@override` annotation, however, it throws an `UnimplementedException`. This is there to force 
you to implement your own build function. Our simple white label widget uses the following build function:

```dart
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
```

Essentially this gives you complete controll over what you would like to render and how.

### Custom pay widget example

`CustomPayWidget` hides the webview until the challenge is required then hides the payment form to let the webview take up the whole screen inside the safe area:

```dart
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Showcases how to override the default white label widget and extend it with custom logic
class CustomPayWidget extends PaylikeWhiteLabelWidget {
  const CustomPayWidget(
      {Key? key,
      required PaylikeEngine engine,
      required BasePayment options})
      : super(key: key, engine: engine, options: options);

  @override
  State<StatefulWidget> createState() => _CustomPayWidgetState();
}

class _CustomPayWidgetState extends PaylikeFormWidgetState<CustomPayWidget> {
  /// Notice that we are using the same logic as the default white label widget
  /// but we are overriding the `build` method to gain more control over what we show and when
  @override
  Widget build(BuildContext context) {
    /// If the webview should be active, render it with constraints covering the whole possible screen
    if (widget.engine.isWebviewActive) {
      return Container(
        child: rawEngineWidget,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
      );
    }

    /// If the transaction is done, let's just show a Success message
    /// but obviously you could do anything here
    if (widget.engine.current == EngineState.done) {
      return Text(
        "Success",
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 30),
      );
    }

    /// If we are waiting for input, render the usual form except for the webview
    return Form(
        key: formKey,
        child: Column(
          /// Notice that webview is missing compared to the simple white label widget
          children: [
            ...inputFields(),
            formError(),
            ...payButtons(context),
          ],
        ));
  }
}

```
