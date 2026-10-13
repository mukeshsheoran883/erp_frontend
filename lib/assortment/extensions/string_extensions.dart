extension StringExtension on String {
  String toFirstLetterUpperCase() {
    if (isEmpty) return this;

    return substring(0, 1).toUpperCase() + (length < 2 ? '' : substring(1, length));
  }

  String toPascalCase() {
    final buffer = StringBuffer();
    bool capitalizeNext = true;

    for (int i = 0; i < length; i++) {
      final char = this[i];

      if (char == '_' || char == '-' || char == ' ') {
        buffer.write(char);
        capitalizeNext = true;
      } else if (capitalizeNext) {
        buffer.write(char.toUpperCase());
        capitalizeNext = false;
      } else {
        buffer.write(char.toLowerCase());
      }
    }

    return buffer.toString();
  }

  String toCamelCase() {
    String input = this;

    if (isNotEmpty) {
      input = input[0].toLowerCase() + input.substring(1);
    }

    List<String> words = input
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}')
        .toLowerCase()
        .split(RegExp(r'[_\s-]+'));

    for (int i = 0; i < words.length; i++) {
      if (i > 0 && words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join();
  }

  String toSnakeCase() {
    String input = this;

    String result = input
        .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) => '${match.group(1)}_${match.group(2)}')
        .replaceAllMapped(RegExp(r'([A-Z])([A-Z][a-z0-9])'), (match) => '${match.group(1)}_${match.group(2)}')
        .replaceAll(RegExp(r'[-\s]+'), '_')
        .toLowerCase();
    return result;
  }

  bool get isValidEmail => _EmailValidator.validate(this);
  bool isValidGST() {
    if (length != 15) return false;
    const String regex = '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}\$';

    return RegExp(regex).hasMatch(this);
  }

  /// [isValidName] can contain alphabets and space
  bool get isValidName {
    final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

    return regex.hasMatch(this);
  }

  /// [isValidUsername] can contain alpha numerics and space
  bool get isValidUsername {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9\s]+$');

    return regex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp('^\\+?[1-9][0-9]{7,14}\$');

    return phoneRegExp.hasMatch(this);
  }
}

/// ------------------------------------------------- OTHER FUNCTIONS ---------------------------------------------

enum _Type { none, alphabetic, numeric }

/// Class for email validation
class _EmailValidator {
  static int _index = 0;

  /// Index used for parsing the email string
  static const String _atomCharacters = "!#\$%&'*+-/=?^_`{|}~";

  /// Valid special characters in the local part of the email
  static _Type _domainType = _Type.none;

  /// Type of characters in the domain part of the email

  /// Method to check if a character is a digit
  static bool _isDigit(String c) {
    return c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  }

  /// Method to check if a character is a letter
  static bool _isLetter(String c) {
    return (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90) || (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122);
  }

  /// Method to check if a character is a letter or digit
  static bool _isLetterOrDigit(String c) {
    return _isLetter(c) || _isDigit(c);
  }

  /// Method to check if a character is a valid atom character
  static bool _isAtom(String c, bool allowInternational) {
    return c.codeUnitAt(0) < 128 ? _isLetterOrDigit(c) || _atomCharacters.contains(c) : allowInternational;
  }

  /// Determine if the provided character c is valid in a domain
  static bool _isDomain(String c, bool allowInternational) {
    if (c.codeUnitAt(0) < 128) {
      /// Check if the character is a letter or a hyphen
      if (_isLetter(c) || c == '-') {
        _domainType = _Type.alphabetic;

        /// Set the domain type to alphabetic
        return true;

        /// Return true if the character is valid in a domain
      }

      /// Check if the character is a digit
      if (_isDigit(c)) {
        _domainType = _Type.numeric;

        /// Set the domain type to numeric
        return true;

        /// Return true if the character is valid in a domain
      }

      return false;

      /// Return false if the character is not valid in a domain
    }

    /// Check if international characters are allowed
    if (allowInternational) {
      _domainType = _Type.alphabetic;

      /// Set the domain type to alphabetic
      return true;

      /// Return true if international characters are allowed
    }

    return false;

    /// Return false if international characters are not allowed
  }

  /// Method to check if a character is a valid domain start character
  static bool _isDomainStart(String c, bool allowInternational) {
    if (c.codeUnitAt(0) < 128) {
      /// Check if the character is a letter
      if (_isLetter(c)) {
        _domainType = _Type.alphabetic;

        /// Set the domain type to alphabetic
        return true;

        /// Return true if the character is a valid domain start
      }

      /// Check if the character is a digit
      if (_isDigit(c)) {
        _domainType = _Type.numeric;

        /// Set the domain type to numeric
        return true;

        /// Return true if the character is a valid domain start
      }

      _domainType = _Type.none;

      /// Set the domain type to none

      return false;

      /// Return false if the character is not a valid domain start
    }

    /// Check if international characters are allowed
    if (allowInternational) {
      _domainType = _Type.alphabetic;

      /// Set the domain type to alphabetic
      return true;

      /// Return true if international characters are allowed as domain start
    }

    _domainType = _Type.none;

    /// Set the domain type to none

    return false;

    /// Return false if international characters are not allowed as domain start
  }

  /// Method to skip parsing the atom part of the email
  /// Method to skip parsing an atom component in the email
  static bool _skipAtom(String text, bool allowInternational) {
    final startIndex = _index;

    /// Iterate through the characters of the atom until a non-atom character is encountered
    while (_index < text.length && _isAtom(text[_index], allowInternational)) {
      _index++;
    }

    return _index > startIndex;

    /// Return true if characters were skipped, indicating a valid atom
  }

  /// Method to skip parsing a subdomain of the email domain
  static bool _skipSubDomain(String text, bool allowInternational) {
    final startIndex = _index;

    /// Check if the first character is a valid domain start character
    if (!_isDomainStart(text[_index], allowInternational)) {
      return false;

      /// Return false if the subdomain doesn't start with a valid character
    }

    _index++;

    /// Move to the next character

    /// Iterate through the characters of the subdomain until a non-domain character is encountered
    while (_index < text.length && _isDomain(text[_index], allowInternational)) {
      _index++;
    }

    /// Return true if the subdomain length is within the limit and doesn't end with a hyphen
    return (_index - startIndex) < 64 && text[_index - 1] != '-';
  }

  /// Method to skip parsing the domain part of the email
  static bool _skipDomain(String text, bool allowTopLevelDomains, bool allowInternational) {
    /// Skip parsing the first subdomain of the domain
    if (!_skipSubDomain(text, allowInternational)) {
      return false;

      /// Return false if the first subdomain is invalid
    }

    /// Check for additional subdomains separated by dots
    if (_index < text.length && text[_index] == '.') {
      do {
        _index++;

        if (_index == text.length) {
          return false;

          /// Return false if no more characters are available after a dot
        }

        /// Skip parsing subsequent subdomains
        if (!_skipSubDomain(text, allowInternational)) {
          return false;

          /// Return false if a subsequent subdomain is invalid
        }
      } while (_index < text.length && text[_index] == '.');
    } else if (!allowTopLevelDomains) {
      return false;

      /// Return false if top-level domains are not allowed and no dot is found
    }

    /// Return false if the domain type is numeric, as it is invalid
    if (_domainType == _Type.numeric) {
      return false;
    }

    return true;

    /// Return true if the domain is successfully parsed
  }

  /// Method to skip parsing a quoted string in the email
  static bool _skipQuoted(String text, bool allowInternational) {
    var escaped = false;

    /// Flag to track escaped characters
    _index++;

    /// Move to the next character after the opening double quote

    /// Loop through the characters of the quoted string
    while (_index < text.length) {
      /// Check if the character is above 128 and international characters are not allowed
      if (text[_index].codeUnitAt(0) >= 128 && !allowInternational) {
        return false;

        /// Return false if an international character is encountered and not allowed
      }

      /// Check if the character is a backslash for escaping
      if (text[_index] == '\\') {
        escaped = !escaped;

        /// Toggle the escaped flag
      } else if (!escaped) {
        /// Check if the character is an unescaped double quote, indicating the end of the quoted string
        if (text[_index] == '"') {
          break;

          /// Exit the loop if an unescaped double quote is encountered
        }
      } else {
        escaped = false;

        /// Reset the escaped flag after processing an escaped character
      }

      _index++;

      /// Move to the next character
    }

    /// Check if the loop exited prematurely or if the quoted string is not properly closed
    if (_index >= text.length || text[_index] != '"') {
      return false;

      /// Return false if the quoted string is not properly closed
    }

    _index++;

    /// Move to the next character after the closing double quote

    return true;

    /// Return true if the quoted string is successfully parsed
  }

  /// Method to skip parsing an IPv4 literal in the email
  static bool _skipIPv4Literal(String text) {
    var groups = 0;

    /// Count of IPv4 address groups

    /// Loop through the characters of the IPv4 literal
    while (_index < text.length && groups < 4) {
      final startIndex = _index;
      var value = 0;

      /// Placeholder for the numeric value of the group

      /// Skip consecutive digits and calculate the numeric value
      while (_index < text.length && text[_index].codeUnitAt(0) >= 48 && text[_index].codeUnitAt(0) <= 57) {
        value = (value * 10) + (text[_index].codeUnitAt(0) - 48);
        _index++;
      }

      /// If no digits were consumed or group length exceeds 3 or value is above 255, return false
      if (_index == startIndex || _index - startIndex > 3 || value > 255) {
        return false;
      }

      groups++;

      /// Increment the count of IPv4 address groups

      /// If not the final group and a period is present, skip the period
      if (groups < 4 && _index < text.length && text[_index] == '.') {
        _index++;
      }
    }

    /// Return true if the IPv4 address is composed of exactly 4 groups
    return groups == 4;
  }

  /// Method to check if a character is a valid hex digit
  static bool _isHexDigit(String str) {
    final c = str.codeUnitAt(0);

    return (c >= 65 && c <= 70) || (c >= 97 && c <= 102) || (c >= 48 && c <= 57);
  }

  /// Method to skip parsing an IPv6 literal in the email
  static bool _skipIPv6Literal(String text) {
    var compact = false;

    /// Indicates if the IPv6 address is compacted
    var colons = 0;

    /// Count of colons in the IPv6 address

    /// Loop through the characters of the IPv6 address
    while (_index < text.length) {
      var startIndex = _index;

      /// Skip consecutive hex digits
      while (_index < text.length && _isHexDigit(text[_index])) {
        _index++;
      }

      /// If the end of the text is reached, break the loop
      if (_index >= text.length) {
        break;
      }

      /// Check if the colon count and context indicate an IPv6v4 address
      if (_index > startIndex && colons > 2 && text[_index] == '.') {
        /// IPv6v4 address detected, go back to startIndex and validate IPv4 literal
        _index = startIndex;

        /// Validate the embedded IPv4 literal
        if (!_skipIPv4Literal(text)) {
          return false;
        }

        /// Return true if the IPv6v4 address is compacted or has 6 colons, else return false
        return compact ? colons < 6 : colons == 6;
      }

      /// Calculate the count of consecutive hex digits
      var count = _index - startIndex;

      /// Check for consecutive colons
      if (text[_index] != ':') {
        break;

        /// Exit loop if no more colons are found
      }

      startIndex = _index;

      /// Count consecutive colons
      while (_index < text.length && text[_index] == ':') {
        _index++;
      }

      /// Calculate the count of consecutive colons
      count = _index - startIndex;

      /// Validate the count of colons
      if (count > 2) {
        return false;

        /// Return false if more than two consecutive colons are found
      }

      /// Update the compact flag and colons count based on the number of colons added
      if (count == 2) {
        if (compact) {
          return false;

          /// Return false if already compacted
        }

        compact = true;
        colons += 2;
      } else {
        colons++;
      }
    }

    /// Validate the final count of colons
    if (colons < 2) {
      return false;

      /// Return false if less than two colons are present
    }

    /// Return true if the IPv6 address is valid based on compact status and colons count
    return compact ? colons < 7 : colons == 7;
  }

  /// Method to validate the given email
  static bool validate(String email, [bool allowTopLevelDomains = false, bool allowInternational = true]) {
    /// Initialize the parsing index
    _index = 0;

    /// Check if the email is empty or exceeds the maximum length
    if (email.isEmpty || email.length >= 320) {
      return false;
    }

    /// Split the email by periods to check the top-level domain
    final List<String> splitter = email.split('.');
    if (splitter[splitter.length - 1].length < 2) {
      return false;
    }

    /// Check if the email starts with a double quote (quoted string)
    if (email[_index] == '"') {
      /// Validate the quoted string, if invalid or end of email is reached, return false
      if (!_skipQuoted(email, allowInternational) || _index >= email.length) {
        return false;
      }
    } else {
      /// Otherwise, validate the atom part of the email
      if (!_skipAtom(email, allowInternational) || _index >= email.length) {
        return false;
      }

      /// Loop through periods (dots) in the email to validate subdomains
      while (email[_index] == '.') {
        _index++;

        /// If the end of the email is reached, return false
        if (_index >= email.length) {
          return false;
        }

        /// Validate the next atom, if invalid, return false
        if (!_skipAtom(email, allowInternational)) {
          return false;
        }

        /// If the end of the email is reached, return false
        if (_index >= email.length) {
          return false;
        }
      }
    }

    /// Check if '@' symbol is present in the email
    if (_index + 1 >= email.length || _index > 64 || email[_index++] != '@') {
      return false;
    }

    /// Check if the domain is an address literal (enclosed in brackets)
    if (email[_index] != '[') {
      /// Validate the domain, if invalid, return false
      if (!_skipDomain(email, allowTopLevelDomains, allowInternational)) {
        return false;
      }

      /// Return true if the end of the email is reached after validating the domain
      return _index == email.length;
    }

    /// Address literal (IPv4 or IPv6)
    _index++;

    /// Ensure there are enough characters for IPv6 validation
    if (_index + 8 >= email.length) {
      return false;
    }

    /// Convert the remaining portion of the email to lowercase for case-insensitive matching
    final ipv6 = email.substring(_index - 1).toLowerCase();

    /// Check if the IPv6 literal contains 'ipv6:'
    if (ipv6.contains('ipv6:')) {
      _index += 'IPv6:'.length;

      /// Validate IPv6 literal, if invalid, return false
      if (!_skipIPv6Literal(email)) {
        return false;
      }
    } else {
      /// Validate IPv4 literal, if invalid, return false
      if (!_skipIPv4Literal(email)) {
        return false;
      }
    }

    /// Check if the closing ']' is present
    if (_index >= email.length || email[_index++] != ']') {
      return false;
    }

    /// Return true if the end of the email is reached after validating the address literal
    return _index == email.length;
  }
}
