import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';
import 'package:paylike_flutter_engine/paylike_flutter_engine.dart';

void main() {
  runApp(MyApp());
}

const clientId = '';

class MyApp extends StatelessWidget {
  final PaylikeEngine _engine = PaylikeEngine(clientId: clientId);
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paylike Payment Forms Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Paylike Payment Forms Demo'),
          ),
          body: SafeArea(
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(
            children: [WhiteLabelWidget(engine: _engine)],
            mainAxisAlignment: MainAxisAlignment.center,
          ))))),
    );
  }
}
