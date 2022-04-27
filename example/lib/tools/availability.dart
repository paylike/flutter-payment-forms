import 'package:flutter/material.dart';

/// Describes the platforms available for a given component
enum AvailabilityPlatforms {
  ios,
  android,
  web,
}

/// Used to show which platforms are supported for a given component
class Availability extends StatelessWidget {
  final List<AvailabilityPlatforms> platforms;
  const Availability({Key? key, this.platforms = const []}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      const Text('Available on:'),
      ...platforms.map((platform) {
        switch (platform) {
          case AvailabilityPlatforms.ios:
            return const Icon(Icons.apple, color: Colors.black45);
          case AvailabilityPlatforms.android:
            return const Icon(Icons.android, color: Colors.green);
          case AvailabilityPlatforms.web:
            return const Icon(Icons.web, color: Colors.blue);
        }
      }).toList()
    ]);
  }
}
