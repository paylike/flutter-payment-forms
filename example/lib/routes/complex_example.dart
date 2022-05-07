import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

class _CustomNoteInput extends PaylikeExtensionInputWidget<String> {
  const _CustomNoteInput(
      {required SingleCustomRepository<String> repository,
      required InputDisplayService service})
      : super(repository: repository, service: service);

  _CustomNoteInput.init()
      : super(
            service: InputDisplayService(),
            repository: SingleCustomRepository<String>(
                validator: (String value) => value.isNotEmpty,
                serializer: (String value) => {'note': value}));
  @override
  State<StatefulWidget> createState() => _CustomNoteInputState();
}

class _CustomNoteInputState extends State<_CustomNoteInput>
    with EmptyBuildCounter {
  final TextEditingController _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                controller: _ctrl,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Note (optional)'),
                style: const TextStyle(color: Colors.amber),
                onChanged: (String? value) {
                  if (value != null) {
                    widget.repository.set(value);
                  }
                })),
      ],
    );
  }
}

/// Shows off the minimal functionality of the white label component
class ComplexWhiteLabelExample extends StatelessWidget {
  /// Engine for the example
  final PaylikeEngine engine;

  /// Currencies supported by Paylike
  final PaylikeCurrencies currencies;
  const ComplexWhiteLabelExample(
      {Key? key, required this.engine, required this.currencies})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Complex white label demo')),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: ComplexWhiteLabelWidget(
                  engine: engine,
                  options: BasePayment(
                      amount: Money.fromDouble(
                          currencies.byCode(CurrencyCode.EUR), 11.5)),
                  extensions: [
                    _CustomNoteInput.init(),
                  ],
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )))));
  }
}
