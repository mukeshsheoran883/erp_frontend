
import 'dart:convert';

import 'package:invently/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Countries {
  static final List<Country> _codes = [];

  static Future<List<Country>> loadCodesFromFile() async {
    if (_codes.isNotEmpty) return _codes;
    try {
      String data = await rootBundle.loadString(Assets.files.countries);
      final json = jsonDecode(data);
      for (final i in json) {
        Country c = Country.fromJson(i);
        if (c.states.isNotEmpty) _codes.add(c);
      }
    } catch (e) {
      debugPrint('CountryCodes Error ${e.toString()}');
    }

    return _codes;
  }

  static String concatCode({required String countryCode, required String phoneNumber}) {
    if (countryCode.trim().isEmpty) return phoneNumber.trim();

    return '($countryCode)$phoneNumber';
  }

  static String getCodeFromPhoneNumber({required String phoneNumber}) {
    try {
      if (phoneNumber.contains('(') && phoneNumber.contains('(')) {
        return phoneNumber.split(')').first.replaceFirst('(', '');
      }

      return '';
    } catch (_) {}

    return '';
  }

  static String getPhoneFromPhoneNumber({required String phoneNumber}) {
    try {
      return phoneNumber.split(')').last;
    } catch (_) {}

    return '';
  }
}

class Country {
  String name;
  String dialCode;
  List<String> states;

  Country({
    required this.name,
    required this.dialCode,
    required this.states,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: (json['name'] ?? '').toString().trim(),
        dialCode: (json['dial_code'] ?? '').toString().trim().toLowerCase(),
        states: List<String>.from((json['states'] ?? []).map((x) => x)),
      );
}
