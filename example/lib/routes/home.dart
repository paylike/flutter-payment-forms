import 'package:example/tools/availability.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paylike_sdk/paylike_sdk.dart';

/// HomeItem is used for collecting core information and displaying it to the user
/// about given demo scenarios
class HomeItem extends StatelessWidget {
  /// Title of the collapse component
  final String title;

  /// Description of the demo scenario
  final String description;

  /// Platforms that the component available on
  final List<AvailabilityPlatforms> platforms;

  /// Called when the example button is pressed
  final void Function() onPressed;

  const HomeItem({
    Key? key,
    required this.title,
    required this.description,
    required this.platforms,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text(title),
        childrenPadding: const EdgeInsets.only(left: 20, right: 20),
        children: [
          Row(children: const [
            Text('Description',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ]),
          Text(description),
          const SizedBox(height: 20),
          Availability(platforms: platforms),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('See example'),
          ),
        ]);
  }
}

/// Home screen of the example application
class HomeScreen extends StatelessWidget {
  /// Describes the style of the example
  final PaylikeWidgetStyles style;

  /// Engine for the example
  final PaylikeEngine engine;

  /// Called when theme change is initiated
  final Function() changeTheme;
  const HomeScreen(
      {Key? key,
      required this.engine,
      required this.changeTheme,
      this.style = PaylikeWidgetStyles.material})
      : super(key: key);

  Function() _navigateTo(BuildContext context, String path) {
    return () {
      engine.restart();
      Navigator.pushNamed(context, path);
    };
  }

  /// Renders the theme change button according to style
  Widget themeChangerButton(BuildContext context) {
    return Row(children: [
      const Text('Material'),
      style == PaylikeWidgetStyles.material
          ? Switch(
              onChanged: (_) => changeTheme(),
              value: false,
              inactiveTrackColor: Theme.of(context).colorScheme.primary,
            )
          : CupertinoSwitch(onChanged: (_) => changeTheme(), value: true),
      const Text('Cupertino'),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  @override
  Widget build(BuildContext context) {
    var content = SafeArea(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        themeChangerButton(context),
        HomeItem(
          title: 'Simple white label example',
          description:
              'Example to showcase the most simple functionality of our white label widget. You can only customize the colors of this widget by setting the colorSchema of the theme. This is the quickest way to integrate payments.',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/minimal'),
        ),
        HomeItem(
          title: 'Error & localisation example',
          description:
              'Examples of different error scenarios and languages to showcase the most common error scenarios your application can encounter and how can we support you with localising these issues.',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/error-localisation'),
        ),
        HomeItem(
          title: 'Extendable white label example',
          description:
              'Example to showcase the capabilities of our PaylikeExtendableWhitelabelWidget that provides you with the possibility to add your own extensions to the widget. An easy way to add more input fields and customise those fields in your payment forms.',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/extendable'),
        ),
        HomeItem(
          title: 'Paylike style pay widget example',
          description:
              'A custom made widget with Paylike styling to boost customer trust in your application\'s payment flow. While other widgets can be customised in terms of layout and color, this widget is consistent with the Paylike style.',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/paylike-style'),
        ),
        HomeItem(
          title: 'Override white label widget example',
          description:
              'Showcases how you can completely customise the payment form and extend with your own custom logic based on the original implementation.',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/override'),
        )
      ],
    )));
    if (style == PaylikeWidgetStyles.cupertino) {
      return CupertinoPageScaffold(
        child: Scaffold(body: content),
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Paylike Payment Forms Demo')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Paylike Payment Forms Demo')),
      body: content,
    );
  }
}
