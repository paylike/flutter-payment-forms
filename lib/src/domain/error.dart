import 'package:paylike_sdk/paylike_sdk.dart';

/// Describes an error used to store and display information about
/// an exception in the system
///
/// For example, if the user's card number is invalid, we generate this error
/// with the correct properties to show in the view layer
class PaylikeFormsError {
  PaylikeException? apiException;
  PaylikeEngineError? engineError;
  Exception? exception;
  PaylikeFormsError({this.apiException, this.engineError, this.exception})
      : assert(
            apiException != null || engineError != null || exception != null);

  /// Returns the message to display to users
  String get displayMessage {
    return '';
  }
}
