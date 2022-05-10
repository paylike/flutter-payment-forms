import 'package:flutter/widgets.dart';

/// Describes the available paylike widget styles
enum PaylikeWidgetStyles {
  material,
  cupertino,
}

/// Describes a class that can support material and cupertino styles
abstract class StylablePaylikeWidget {
  /// Builds the given widget in a material style
  Widget material(BuildContext context);

  /// Builds the given widget in a cupertino style
  Widget cupertino(BuildContext context);
}
