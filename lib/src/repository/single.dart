import 'package:paylike_sdk/src/exceptions.dart';

/// Stores a single item
class SingleRepository<T> {
  /// Validates the item
  final bool Function(T) validator;

  SingleRepository({required this.validator});

  /// Use this constructor to set a default value on initialisation
  SingleRepository.withDefaultValue(T value, this.validator) {
    _single = value;
  }

  T? _single;

  /// Returns the item if available, throws a [NotFoundException] if not
  T get item {
    if (_single != null) {
      return _single as T;
    }
    throw NotFoundException();
  }

  /// Calls the validation
  /// If the item is null, it will return with false by default
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
