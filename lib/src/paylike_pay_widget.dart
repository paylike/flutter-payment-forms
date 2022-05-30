import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Made to be styled with Paylike style out of the box to increase customer trust
class PaylikePayWidget extends ComplexWhiteLabelWidget {
  final buttonColors = [
    const Color(0xFF0F754B),
    const Color(0xFF459A42),
    const Color(0xFF59CE55)
  ];

  // Executed when a payment is successful and the animation of the widget is done
  final void Function()? onPaymentDone;

  PaylikePayWidget(
      {Key? key,
      required PaylikeEngine engine,
      required BasePayment options,
      Map<String, dynamic>? testConfig,
      List<PaylikeExtensionInputWidget> extensions = const [],
      String paymentConfigName = 'payment_config.json',
      PaylikeWidgetStyles style = PaylikeWidgetStyles.material,
      this.onPaymentDone})
      : super(
            key: key,
            engine: engine,
            options: options,
            testConfig: testConfig,
            extensions: extensions,
            paymentConfigName: paymentConfigName,
            style: style);

  @override
  State<StatefulWidget> createState() => _PaylikePayWidgetState();
}

class _PaylikePayWidgetState extends PaylikeFormWidgetState<PaylikePayWidget> {
  void _animationTriggerListener() {
    if (widget.engine.current == EngineState.done) {
      setState(() {
        _animationOpacity = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.engine.addListener(_animationTriggerListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.engine.removeListener(_animationTriggerListener);
  }

  double _animationCheckMarkTopPosition = -100;
  double _animationOpacity = 0;
  List<Widget> animatedButtons(BuildContext context) {
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
    if (widget.extensions.isNotEmpty) {
      widget.extensions.sort((a, b) => a.order.compareTo(b.order));
    }

    return Column(children: [
      Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
                opacity: _animationOpacity,
                duration: const Duration(milliseconds: 500),
                onEnd: () => setState(() {
                      _animationCheckMarkTopPosition = -1;
                    }),
                child: Container(
                    child: FittedBox(
                        child: Stack(
                      children: [
                        AnimatedPositioned(
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                          ),
                          top: _animationCheckMarkTopPosition,
                          left: 1,
                          duration: const Duration(milliseconds: 500),
                          onEnd: () => widget.onPaymentDone?.call(),
                        ),
                        const Icon(Icons.circle_outlined, color: Colors.white)
                      ],
                    )),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            transform:
                                const GradientRotation(pi / 1.090909090909),
                            colors: widget.buttonColors)))),
          ),
          AnimatedOpacity(
              opacity: 1 - _animationOpacity,
              duration: const Duration(milliseconds: 500),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ...widget.extensions.where((e) => e.order < 0),
                      webview(),
                      ...widget.extensions.where((e) => e.order == 0),
                      ...inputFields(),
                      ...widget.extensions.where((e) => e.order == 1),
                      formError(),
                      ...animatedButtons(context),
                    ],
                  )))
        ],
      ),
      Container(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset("lib/assets/paylike_logo.png",
                        package: "paylike_sdk"),
                  )),
              Text(PaylikeLocalizator.getKey("POWERED_BY"),
                  style: const TextStyle(color: Color(0xFF2B8742))),
            ],
          )),
    ]);
  }
}
