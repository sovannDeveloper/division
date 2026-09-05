import 'package:flutter/material.dart';

import 'hex_color.dart';

/// Returns [Color].
///
/// [r], [g] and [b] must not exceed 255.
///
/// ```dart
/// ..backgroundColor(rgb(34, 29, 189));
/// ```
Color rgb(int r, int g, int b) {
  return Color.fromRGBO(r, g, b, 1.0);
}

/// Returns [Color].
///
/// [r], [g] and [b] must not exceed 255.
///
/// ```dart
/// ..backgroundColor(rgba(34, 29, 189, 0.7));
/// ```
Color rgba(int r, int g, int b, [double opacity = 1.0]) {
  return Color.fromRGBO(r, g, b, opacity);
}

/// Hex color. The leading `#` is optional.
///
/// Accepts `RGB`, `ARGB`, `RRGGBB` and `AARRGGBB`.
/// ```dart
/// hex('f5f5f5') // or
/// hex('#f5f5f5')
/// ```
/// Throws a [FormatException] if [xxxxxx] is not a valid hex color.
Color hex(String xxxxxx) => Color(hexToArgb(xxxxxx));
