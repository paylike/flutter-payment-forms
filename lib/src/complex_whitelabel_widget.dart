import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Made to be extandable with additonal fields compared to [WhiteLabelWidget]
class ComplexWhiteLabelWidget extends WhiteLabelWidget {
  /// For more informations about options check also [WhiteLabelWidget]
  const ComplexWhiteLabelWidget(
      {Key? key,
      required PaylikeEngine engine,
      required BasePayment options,
      Map<String, dynamic>? testConfig,
      this.extensions = const [],
      String paymentConfigName = 'payment_config.json'})
      : super(
            key: key,
            engine: engine,
            options: options,
            testConfig: testConfig,
            paymentConfigName: paymentConfigName);

  /// Used for adding additional fields to the widget
  final List<PaylikeExtensionInputWidget> extensions;

  @override
  State<StatefulWidget> createState() => _ComplexWhiteLabelWidgetState();
}

class _ComplexWhiteLabelWidgetState extends WhiteLabelWidgetState {
  @override
  Widget build(BuildContext context) {
    var _widget = widget as ComplexWhiteLabelWidget;
    return Form(
        key: formKey,
        child: Column(
          children: [
            webview(),
            ...inputFields(),
            ..._widget.extensions,
            formError(),
            ...payButtons(),
          ],
        ));
  }

  /// Fiels the custom fields with the custom data from the extension widgets
  void _fillCustomFields() {
    var _widget = widget as ComplexWhiteLabelWidget;
    widget.options.custom = {
      ..._widget.options.custom,
      ..._widget.extensions
          .fold({}, (cur, e) => {...cur, ...e.repository.toJson()}),
    };
  }

  @override
  void executeCardPayment() {
    _fillCustomFields();
    super.executeCardPayment();
  }

  @override
  void executeApplePayPayment(Map<String, dynamic> result) {
    _fillCustomFields();
    super.executeApplePayPayment(result);
  }

  @override
  bool inputsValid() {
    var _widget = widget as ComplexWhiteLabelWidget;

    /// For every item in _widget.extensions
    for (var extension in _widget.extensions) {
      extension.service.change(extension.repository.isValid()
          ? InputStates.valid
          : InputStates.invalid);
    }

    return _widget.extensions
            .every((w) => w.service.current == InputStates.valid) &&
        super.inputsValid();
  }
}
