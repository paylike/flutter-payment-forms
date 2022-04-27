import 'package:example/routes/home.dart';
import 'package:example/routes/minimal_example.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

void main() {
  runApp(MyApp());
}

/// Replace this with your own client ID
///
/// Don't have a client ID? Head to [our platform](https://app.paylike.io) and create one
const clientId = 'e393f9ec-b2f7-4f81-b455-ce45b02d355d';

class MyApp extends StatelessWidget {
  final PaylikeCurrencies _currencies = PaylikeCurrencies();
  final PaylikeEngine _engine = PaylikeEngine(clientId: clientId);
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Paylike Payment Forms Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(engine: _engine),
          '/example/minimal': (context) =>
              MinimalWhitelabelExample(engine: _engine, currencies: _currencies)
        });
  }
}
