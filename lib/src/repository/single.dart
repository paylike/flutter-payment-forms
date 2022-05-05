import 'package:paylike_sdk/src/exceptions.dart';

/// Stores a single item
class SingleRepository<T> {
  /// Validates the item
  final bool Function(T) validator;
  SingleRepository({required this.validator});
  T? _single;
  T get item {
    if (_single != null) {
      return _single as T;
    }
    throw NotFoundException();
  }

  /// Calls the validation
  bool isValid() {
    if (item == null) return false;
    return validator(item);
  }

  /// Returns if the item is available
  bool get isAvailable => _single != null;

  /// Sets the single
  void set(T single) {
    _single = single;
  }

  /// Resets the current state
  void reset() {
    _single = null;
  }
}
