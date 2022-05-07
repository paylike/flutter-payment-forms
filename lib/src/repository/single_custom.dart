import 'single.dart';

/// Used for custom inputs
class SingleCustomRepository<T> extends SingleRepository<T> {
  /// Serializes the item into the payment request
  final Map<String, dynamic> Function(T) serializer;
  SingleCustomRepository(
      {required bool Function(T) validator, required this.serializer})
      : super(validator: validator);

  /// Use this constructor to set a default value on initialisation
  SingleCustomRepository.withDefaultValue(T value,
      {required bool Function(T) validator, required this.serializer})
      : super.withDefaultValue(value, validator);

  /// Returns the serialized item
  Map<String, dynamic> toJson() => serializer(item);
}
