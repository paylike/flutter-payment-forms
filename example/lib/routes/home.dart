import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// Home screen of the example application
class HomeScreen extends StatelessWidget {
  final PaylikeEngine engine;
  const HomeScreen({Key? key, required this.engine}) : super(key: key);

  Function() _navigateTo(BuildContext context, String path) {
    return () {
      engine.restart();
      Navigator.pushNamed(context, path);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Paylike Payment Forms Demo'),
        ),
        body: SafeArea(
            child: Column(
          children: [
            ExpansionTile(
                title: const Text('Simple whitelabel example'),
                children: [
                  const Text(
                      'Example to showcase the most simple functionality of our whitelabel widget'),
                  const Text('Available: iOS, Android'),
                  ElevatedButton(
                    onPressed: _navigateTo(context, '/example/minimal'),
                    child: const Text('See example'),
                  ),
                ]),
          ],
        )));
  }
}
