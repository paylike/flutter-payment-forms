import 'single.dart';

/// Used for custom inputs
class SingleCustomRepository<T> extends SingleRepository<T> {
  /// Serializes the item into the payment request
  final Map<String, dynamic> Function(T) serializer;
  SingleCustomRepository(
      {required bool Function(T p1) validator, required this.serializer})
      : super(validator: validator);

  /// Returns the serialized item
  Map<String, dynamic> toJson() => serializer(item);
}
