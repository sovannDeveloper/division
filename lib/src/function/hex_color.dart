final RegExp _hexPattern = RegExp(r'^[0-9a-fA-F]+$');

/// Parses `#RGB`, `#ARGB`, `#RRGGBB` or `#AARRGGBB` (the leading `#` optional)
/// into an ARGB integer.
///
/// Throws a [FormatException] naming the offending input rather than letting
/// `int.parse` fail with an opaque message.
int hexToArgb(String hexColor) {
  final String value = hexColor.trim().replaceFirst('#', '');

  if (value.isEmpty || !_hexPattern.hasMatch(value)) {
    throw FormatException(
        'Invalid hex color "$hexColor": only hexadecimal digits are allowed.');
  }

  switch (value.length) {
    case 3: // RGB -> AARRGGBB
      return int.parse('FF${value[0] * 2}${value[1] * 2}${value[2] * 2}',
          radix: 16);
    case 4: // ARGB -> AARRGGBB
      return int.parse(
          '${value[0] * 2}${value[1] * 2}${value[2] * 2}${value[3] * 2}',
          radix: 16);
    case 6: // RRGGBB
      return int.parse('FF$value', radix: 16);
    case 8: // AARRGGBB
      return int.parse(value, radix: 16);
    default:
      throw FormatException(
          'Invalid hex color "$hexColor": expected 3, 4, 6 or 8 hex digits, '
          'got ${value.length}.');
  }
}
