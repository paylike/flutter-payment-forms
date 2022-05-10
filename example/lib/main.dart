import 'package:example/routes/complex_example.dart';
import 'package:example/routes/error_localisation_example.dart';
import 'package:example/routes/home.dart';
import 'package:example/routes/minimal_example.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

/// Replace this with your own client ID
///
/// Don't have a client ID? Head to [our platform](https://app.paylike.io) and create one
const clientId = 'e393f9ec-b2f7-4f81-b455-ce45b02d355d';

/// Showcases that the SDK works with Material design
class MyApp extends StatefulWidget {
  final PaylikeCurrencies _currencies = PaylikeCurrencies();
  final PaylikeEngine _engine = PaylikeEngine(clientId: clientId);
  MyApp({Key? key}) : super(key: key) {
    /// Change this to use a different language
    PaylikeLocalizator.current = Languages.en;
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PaylikeWidgetStyles style = PaylikeWidgetStyles.material;
  bool _themeChange = false;

  void _changeTheme() {
    switch (style) {
      case PaylikeWidgetStyles.cupertino:
        setState(() {
          style = PaylikeWidgetStyles.material;
          _themeChange = true;
        });
        break;
      case PaylikeWidgetStyles.material:
        setState(() {
          style = PaylikeWidgetStyles.cupertino;
          _themeChange = true;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_themeChange) {
        showSimpleNotification(
            style == PaylikeWidgetStyles.material
                ? const Text("Theme changed to material")
                : const Text("Theme changed to cupertino"),
            background: Colors.green,
            position: NotificationPosition.bottom);
      }
    });
    var routes = {
      '/': (context) =>
          HomeScreen(engine: widget._engine, changeTheme: _changeTheme),
      '/example/minimal': (context) => MinimalWhitelabelExample(
          engine: widget._engine, currencies: widget._currencies, style: style),
      '/example/complex': (context) => ComplexWhiteLabelExample(
          engine: widget._engine, currencies: widget._currencies),
      '/example/error-localisation': (context) => ErrorLocalisationExample(
          engine: widget._engine, currencies: widget._currencies)
    };
    if (style == PaylikeWidgetStyles.cupertino) {
      return OverlaySupport.global(
          child: CupertinoApp(
              title: 'Paylike Payment Forms Demo',
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              initialRoute: '/',
              routes: routes));
    }
    return OverlaySupport.global(
        child: MaterialApp(
            title: 'Paylike Payment Forms Demo',
            initialRoute: '/',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            ),
            routes: routes));
  }
}
