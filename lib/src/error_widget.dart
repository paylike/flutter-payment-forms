import 'package:flutter/material.dart';

class WhitelabelErrorWidget extends StatelessWidget {
  final bool isVisible;
  final String message;

  const WhitelabelErrorWidget(
      {Key? key, required this.isVisible, this.message = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        child: Row(children: [
          Expanded(
              child: Container(
            child: Center(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 15, bottom: 15),
          )),
        ]));
  }
}
