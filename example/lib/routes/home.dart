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
    return ExpansionTile(title: Text(title), children: [
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
  Widget themeChangerButton() {
    if (style == PaylikeWidgetStyles.material) {
      return Center(
          child: ElevatedButton(
        child: const Text('Switch theme'),
        onPressed: changeTheme,
      ));
    }
    return Center(
      child: CupertinoButton(
          child: const Text('Switch theme'), onPressed: changeTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = SafeArea(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        themeChangerButton(),
        HomeItem(
          title: 'Simple whitelabel example',
          description:
              'Example to showcase the most simple functionality of our whitelabel widget',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/minimal'),
        ),
        HomeItem(
          title: 'Error & localisation example',
          description: 'Examples of different error scenarios and languages',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/error-localisation'),
        ),
        HomeItem(
          title: 'Complex whitelabel example',
          description:
              'Example to showcase the capabilities of our form builder',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/complex'),
        ),
        HomeItem(
          title: 'Paylike style Pay widget example',
          description:
              'A custom made widget with Paylike styling to ensure customer trust',
          platforms: const [
            AvailabilityPlatforms.ios,
            AvailabilityPlatforms.android
          ],
          onPressed: _navigateTo(context, '/example/paylike-style'),
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
