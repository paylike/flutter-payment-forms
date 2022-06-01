import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Showcases how to override the default white label widget and extend it with custom logic
class CustomPayWidget extends PaylikeWhiteLabelWidget {
  const CustomPayWidget(
      {Key? key,
      required PaylikeEngine engine,
      required BasePayment options,
      required PaylikeWidgetStyles style})
      : super(key: key, engine: engine, options: options, style: style);

  @override
  State<StatefulWidget> createState() => _CustomPayWidgetState();
}

class _CustomPayWidgetState extends PaylikeFormWidgetState<CustomPayWidget> {
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
