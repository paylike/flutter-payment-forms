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
      String paymentConfigName = 'payment_config.json'})
      : super(
            key: key,
            engine: engine,
            options: options,
            testConfig: testConfig,
            paymentConfigName: paymentConfigName);

  @override
  State<StatefulWidget> createState() => _ComplexWhiteLabelWidgetState();
}

class _ComplexWhiteLabelWidgetState extends WhiteLabelWidgetState {
  @override
  Widget build(BuildContext context) {
    var _widget = widget as ComplexWhiteLabelWidget;
    return super.build(context);
  }

  @override
  bool inputsValid() {
    return super.inputsValid();
  }
}
