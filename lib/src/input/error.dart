/// Describes which field needs to be marked as failed
enum FailedField {
  card,
  expiry,
  cvc,
  custom,
}

/// Utility class for user facing errors
///
/// Holds information about a transaction fail. It also tells our components
/// which fields have to be marked as the cause of the error.
/// This error is user facing but not neccessarily caused by the user.
class TransactionUserError {
  final String title;
  final String description;
  final List<FailedField> places;
  const TransactionUserError(
      {required this.title, required this.description, this.places = const []});
}
