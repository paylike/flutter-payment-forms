import 'package:paylike_flutter_engine/domain.dart';
import 'package:paylike_sdk/src/repository/single.dart';

/// Defines a repository responsible for the expiry field
class ExpiryRepository extends SingleRepository<String> {
  ExpiryRepository({required bool Function(String) validator})
      : super(validator: validator);
  Expiry get parse {
    var slice = item.split("/");
    if (slice.length != 2) {
      throw Exception("Cannot parse expiry");
    }
    return Expiry(
        month: int.parse(slice[0], radix: 10),
        year: int.parse(slice[1], radix: 10));
  }
}
