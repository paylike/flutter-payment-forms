import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Made to be extandable with additonal fields compared to [PaylikeWhiteLabelWidget]
class PaylikeExtendableWhiteLabelWidget extends PaylikeWhiteLabelWidget {
  /// For more informations about options check also [PaylikeWhiteLabelWidget]
  const PaylikeExtendableWhiteLabelWidget(
      {Key? key,
      required PaylikeEngine engine,
      required BasePayment options,
      Map<String, dynamic>? testConfig,
      this.extensions = const [],
      String paymentConfigName = 'payment_config.json',
      PaylikeWidgetStyles style = PaylikeWidgetStyles.material})
      : super(
            key: key,
            engine: engine,
            options: options,
            testConfig: testConfig,
            paymentConfigName: paymentConfigName,
            style: style);

  /// Used for adding additional fields to the widget
  final List<PaylikeExtensionInputWidget> extensions;

  @override
  State<StatefulWidget> createState() => _ExtendableWhiteLabelWidgetState();
}

/// State of [PaylikeExtendableWhiteLabelWidget]
///
/// Provides an override for [inputsValid], [executeCardPayment], [executeApplePayPayment] to
/// incorporate additional extension inputs as well
class _ExtendableWhiteLabelWidgetState
    extends PaylikeFormWidgetState<PaylikeExtendableWhiteLabelWidget> {
  @override
  Widget build(BuildContext context) {
    widget.extensions.sort((a, b) => a.order.compareTo(b.order));
    return Form(
        key: formKey,
        child: Column(
          children: [
            ...widget.extensions.where((e) => e.order < 0),
            webview(),
            ...widget.extensions.where((e) => e.order == 0),
            ...inputFields(),
            ...widget.extensions.where((e) => e.order == 1),
            formError(),
            ...payButtons(context),
            ...widget.extensions.where((e) => e.order > 1),
          ],
        ));
  }

  /// Fills the custom fields with the custom data from the extension widgets
  void _fillCustomFields() {
    widget.options.custom = {
      ...widget.options.custom,
      ...widget.extensions
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
    for (var extension in widget.extensions) {
      extension.service.change(extension.repository.isValid()
          ? InputStates.valid
          : InputStates.invalid);
    }
    var extensionValid =
        widget.extensions.every((w) => w.service.current == InputStates.valid);
    var builtInValid = super.inputsValid();
    return extensionValid && builtInValid;
  }
}
