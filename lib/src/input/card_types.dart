import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Supported card types of paylike
enum CardTypes {
  visa,
  mastercard,
  generic,
}

const _visa = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 63 20.3"><g><path fill="#1a1f71" d="M23.9,0.4L15.7,20h-5.4L6.2,4.3C6,3.4,5.8,3,5,2.6C3.8,1.9,1.8,1.3,0,0.9l0.1-0.6h8.7c1.1,0,2.1,0.7,2.3,2 l2.1,11.4l5.3-13.4H23.9z M45,13.6c0-5.2-7.2-5.5-7.1-7.8c0-0.7,0.7-1.5,2.2-1.6C40.8,4.1,42.8,4,45,5l0.9-4.2 C44.7,0.4,43.1,0,41.2,0c-5,0-8.6,2.7-8.6,6.5c0,2.8,2.5,4.4,4.5,5.4c2,1,2.6,1.6,2.6,2.4c0,1.3-1.6,1.9-3,1.9 c-2.6,0-4-0.7-5.2-1.2l-0.9,4.3c1.2,0.5,3.4,1,5.7,1C41.5,20.3,45,17.7,45,13.6 M58.3,20H63L58.9,0.4h-4.3c-1,0-1.8,0.6-2.2,1.4 L44.7,20h5.3l1.1-2.9h6.5L58.3,20z M52.6,13.1l2.7-7.4l1.5,7.4H52.6z M31.2,0.4L27,20h-5.1l4.2-19.7H31.2z"/></g></svg>
''';

const _mastercard = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 131.39 86.9"><rect fill="#ff5f00" x="48.37" y="15.14" width="34.66" height="56.61"/><path fill="#eb001b" d="M51.94,43.45a35.94,35.94,0,0,1,13.75-28.3,36,36,0,1,0,0,56.61A35.94,35.94,0,0,1,51.94,43.45Z"/><path fill="#f79e1b" d="M120.5,65.76V64.6H121v-.24h-1.19v.24h.47v1.16Zm2.31,0v-1.4h-.36l-.42,1-.42-1h-.36v1.4h.26V64.7l.39.91h.27l.39-.91v1.06Z"/><path fill="#f79e1b" d="M123.94,43.45a36,36,0,0,1-58.25,28.3,36,36,0,0,0,0-56.61,36,36,0,0,1,58.25,28.3Z"/></svg>
''';

/// Static class to provide card types widget for card input
class CardIcons {
  /// Returns the appropriate widget based on [type]
  static Widget get(CardTypes type) {
    var children = [];
    switch (type) {
      case CardTypes.visa:
        children = [
          SvgPicture.string(_mastercard, color: Colors.black26),
          SvgPicture.string(_visa)
        ];
        break;
      case CardTypes.mastercard:
        children = [
          SvgPicture.string(_mastercard),
          SvgPicture.string(_visa, color: Colors.black26)
        ];
        break;
      default:
        children = [
          SvgPicture.string(_mastercard),
          SvgPicture.string(_visa),
        ];
    }
    return SizedBox(
        height: 30,
        width: 80,
        child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                children.map((w) => SizedBox(child: w, width: 30)).toList()));
  }
}
