import 'package:paylike_sdk/paylike_sdk.dart';
import 'package:paylike_sdk/src/localization/localizator.dart';

/// Describes an error used to store and display information about
/// an exception in the system
///
/// For example, if the user's card number is invalid, we generate this error
/// with the correct properties to show in the view layer
class PaylikeFormsError {
  /// Describes an API exception
  PaylikeException? apiException;

  /// Describes an engine error
  PaylikeEngineError? engineError;

  /// Describes a generic exception
  Exception? exception;

  PaylikeFormsError({this.apiException, this.engineError, this.exception})
      : assert(
            apiException != null || engineError != null || exception != null);

  /// Returns the message to display to users
  String get displayMessage {
    try {
      if (apiException != null) {
        var localised =
            PaylikeLocalizator.localizeError(apiException as PaylikeException);
        return localised.description;
      }
      if (engineError != null) {
        if (engineError!.apiException != null) {
          var localised = PaylikeLocalizator.localizeError(
              engineError!.apiException as PaylikeException);
          return localised.description;
        }
        return engineError!.message;
      }
      if (exception != null) {
        return exception.toString();
      }
    } on Exception catch (e) {
      exception = e;
    }
    return 'Something went wrong';
  }
}
