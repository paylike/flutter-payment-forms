import 'package:flutter/widgets.dart';

/// Describes an example state that has two different rendering functions
/// based on the style it has
abstract class StyleableExample {
  /// Builds the given widget in a material style
  Widget material(BuildContext context);

  /// Builds the given widget in a cupertino style
  Widget cupertino(BuildContext context);
}
