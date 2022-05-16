/// Holds information about a given error scenario
class ErrorScenario {
  /// Title of the error scenario
  final String title;

  /// Testconfig used in the API to trigger the scenario
  final Map<String, dynamic> testConfig;
  const ErrorScenario({required this.title, required this.testConfig});
}

/// Describes the available error scenarios
abstract class ErrorScenarios {
  /// Sets the card scheme to unsupported
  static ErrorScenario unsupportedCardScheme =
      const ErrorScenario(title: 'Unsupported card scheme', testConfig: {
    'card': {
      'scheme': 'unsupported',
    },
  });

  /// Sets the card scheme to unknown
  static ErrorScenario unknownCardScheme =
      const ErrorScenario(title: 'Unknown card scheme', testConfig: {
    'card': {
      'scheme': 'unknown',
    },
  });

  /// Sets the CVC to inalid
  static ErrorScenario invalidCVC =
      const ErrorScenario(title: 'Invalid CVC code', testConfig: {
    'card': {
      'code': 'invalid',
    },
  });

  /// Sets the card to be inalid
  static ErrorScenario invalidCard =
      const ErrorScenario(title: 'Invalid Card', testConfig: {
    'card': {
      'status': 'invalid',
    },
  });

  /// Sets the card to be expired
  static ErrorScenario expiredCard =
      const ErrorScenario(title: 'Expired Card', testConfig: {
    'card': {
      'status': 'expired',
    },
  });

  /// Sets the card to be disabled
  static ErrorScenario disabledCard =
      const ErrorScenario(title: 'Disabled Card', testConfig: {
    'card': {
      'status': 'disabled',
    },
  });

  /// Sets the card to be lost
  static ErrorScenario lostCard =
      const ErrorScenario(title: 'Lost Card', testConfig: {
    'card': {
      'status': 'lost',
    },
  });

  /// Sets the limit to zero
  static ErrorScenario limitTooLow =
      const ErrorScenario(title: 'Not enough limit', testConfig: {
    'card': {
      'limit': {
        'currency': 'EUR',
        'value': 1,
        'exponent': 0,
      },
    },
  });

  /// Sets the available balance to zero
  static ErrorScenario insufficentFunds =
      const ErrorScenario(title: 'Insufficient balance', testConfig: {
    'card': {
      'balance': {
        'currency': 'EUR',
        'value': 0,
        'exponent': 0,
      },
    },
  });

  /// Sets fingerprint to be timed out
  static ErrorScenario fingerprintTimeout = const ErrorScenario(
      title: 'Fingerprint timeout', testConfig: {'fingerprint': 'timeout'});

  /// Sets TDS fingerprint to be timed out
  static ErrorScenario tdsFingerprintTimeout =
      const ErrorScenario(title: '3DS fingerprint timeout', testConfig: {
    'tds': {'fingerprint': 'timeout'}
  });

  /// Sets TDS fingerprint unavailable
  static ErrorScenario tdsFingerprintUnavailable =
      const ErrorScenario(title: '3DS fingerprint unavailable', testConfig: {
    'tds': {'fingerprint': 'unavailable'}
  });

  /// Sets TDS to get rejected status
  static ErrorScenario tdsRejected =
      const ErrorScenario(title: '3DS rejected', testConfig: {
    'tds': {'status': 'rejected'}
  });

  /// Sets TDS to get unavailable status
  static ErrorScenario tdsUnavailable =
      const ErrorScenario(title: '3DS unavailable', testConfig: {
    'tds': {'status': 'unavailable'}
  });

  /// Sets TDS to get attempted status
  static ErrorScenario tdsAttempted =
      const ErrorScenario(title: '3DS attempted', testConfig: {
    'tds': {'status': 'attempted'}
  });

  /// Returns all possible scenarios
  static List<ErrorScenario> getAll() {
    return [
      unsupportedCardScheme,
      unknownCardScheme,
      invalidCVC,
      invalidCard,
      expiredCard,
      disabledCard,
      lostCard,
      limitTooLow,
      insufficentFunds,
    ];
  }
}
