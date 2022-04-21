import 'package:paylike_dart_request/paylike_dart_request.dart';
import 'package:paylike_sdk/src/input/error.dart';
import 'data/bg.g.dart';
import 'data/cs.g.dart';
import 'data/da.g.dart';
import 'data/de.g.dart';
import 'data/en.g.dart';
import 'data/es.g.dart';
import 'data/et.g.dart';
import 'data/fi.g.dart';
import 'data/fr.g.dart';
import 'data/gr.g.dart';
import 'data/hu.g.dart';
import 'data/kl.g.dart';
import 'data/nl.g.dart';
import 'data/no.g.dart';
import 'data/pl.g.dart';
import 'data/ro.g.dart';
import 'data/si.g.dart';
import 'data/sk.g.dart';
import 'data/sv.g.dart';
import 'languages.dart';

/// Holds information about an already localized error
class LocalizedPaylikeError {
  final String name;
  final List<FailedField> places;
  const LocalizedPaylikeError({required this.name, this.places = const []});
}

/// Static class used for localization
class PaylikeLocalizator {
  static Languages current = Languages.en;
  static String getKey(String key, {bool? uppercase, bool? titleOnly}) {
    var map = en;
    switch (current) {
      case Languages.bg:
        map = bg;
        break;
      case Languages.cs:
        map = cs;
        break;
      case Languages.da:
        map = da;
        break;
      case Languages.de:
        map = de;
        break;
      case Languages.en:
        map = en;
        break;
      case Languages.es:
        map = es;
        break;
      case Languages.et:
        map = et;
        break;
      case Languages.fi:
        map = fi;
        break;
      case Languages.fr:
        map = fr;
        break;
      case Languages.gr:
        map = gr;
        break;
      case Languages.hu:
        map = hu;
        break;
      case Languages.kl:
        map = kl;
        break;
      case Languages.nl:
        map = nl;
        break;
      case Languages.no:
        map = no;
        break;
      case Languages.pl:
        map = pl;
        break;
      case Languages.ro:
        map = ro;
        break;
      case Languages.si:
        map = si;
        break;
      case Languages.sk:
        map = sk;
        break;
      case Languages.sv:
        map = sv;
        break;
    }
    var value = map[key];
    value ??= en[key];
    if (value == null) {
      throw Exception("Localization key $key not found");
    }
    if (uppercase != null && uppercase) {
      value = value.toUpperCase();
    }
    if (titleOnly != null && titleOnly) {
      return value.split('\n').first;
    }
    return value;
  }

  static Map<String, LocalizedPaylikeError> exceptionMapper = {
    'PAYMENT_INTEGRATION_KEY_UNKNOWN':
        const LocalizedPaylikeError(name: 'PUBLIC_KEY_UNKNOWN'),
    'PAYMENT_INTEGRATION_DISABLED':
        const LocalizedPaylikeError(name: 'PUBLIC_KEY_PAYMENTS_NOT_ALLOWED'),
    'PAYMENT_CARD_NUMBER_INVALID':
        const LocalizedPaylikeError(name: 'INVALID_CARD_NUMBER', places: [
      FailedField.card,
    ]),
    'PAYMENT_CARD_SCHEME_UNKNOWN':
        const LocalizedPaylikeError(name: 'CARD_SCHEME_UNKNOWN', places: [
      FailedField.card,
      FailedField.cvc,
      FailedField.expiry,
    ]),
    'PAYMENT_CARD_SCHEME_UNSUPPORTED':
        const LocalizedPaylikeError(name: 'CARD_SCHEME_UNSUPPORTED', places: [
      FailedField.card,
      FailedField.cvc,
      FailedField.expiry,
    ]),
    'PAYMENT_CARD_SECURITY_CODE_INVALID': const LocalizedPaylikeError(
        name: 'CARD_SECURITY_CODE_INVALID',
        places: [
          FailedField.cvc,
        ]),
    'PAYMENT_CARD_EXPIRED':
        const LocalizedPaylikeError(name: 'CARD_EXPIRED', places: [
      FailedField.expiry,
    ]),
    'PAYMENT_CARD_DISABLED':
        const LocalizedPaylikeError(name: 'CARD_DISABLED', places: [
      FailedField.card,
      FailedField.cvc,
      FailedField.expiry,
    ]),
    'PAYMENT_CARD_LOST':
        const LocalizedPaylikeError(name: 'CARD_LOST', places: [
      FailedField.card,
      FailedField.cvc,
      FailedField.expiry,
    ]),
    'PAYMENT_AMOUNT_LIMIT': const LocalizedPaylikeError(name: 'AMOUNT_LIMIT'),
    'PAYMENT_INSUFFICIENT_FUNDS':
        const LocalizedPaylikeError(name: 'INSUFFICIENT_FUNDS'),
    'PAYMENT_RECEIVER_BLOCKED':
        const LocalizedPaylikeError(name: 'RECEIVER_BLOCKED'),
    'PAYMENT_REJECTED_BY_ISSUER':
        const LocalizedPaylikeError(name: 'REJECTED_BY_ISSUER', places: [
      FailedField.card,
      FailedField.cvc,
      FailedField.expiry,
    ]),
    'PAYMENT_REJECTED': const LocalizedPaylikeError(name: 'REJECTED'),
    'TDSECURE_REQUIRED': const LocalizedPaylikeError(name: 'TDSECURE_REQUIRED'),
    'TDSECURE_FAILED': const LocalizedPaylikeError(name: 'TDSECURE_FAILED'),
  };

  static TransactionUserError localizeError(PaylikeException e) {
    try {
      if (!PaylikeLocalizator.exceptionMapper.containsKey(e.code)) {
        throw Exception();
      }
      var found =
          PaylikeLocalizator.exceptionMapper[e.code] as LocalizedPaylikeError;
      var errorMsg = PaylikeLocalizator.getKey('ERROR_${found.name}');
      var splitted = errorMsg.split('\n');
      var title = splitted.first;
      var description = splitted.getRange(1, splitted.length).join('\n');
      return TransactionUserError(
          title: title, description: description, places: found.places);
    } catch (_) {
      return TransactionUserError(title: e.code, description: e.cause);
    }
  }
}
