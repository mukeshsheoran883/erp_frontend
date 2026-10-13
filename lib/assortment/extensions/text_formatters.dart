import 'package:flutter/services.dart';

class AllCharacterUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}

class StartCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: _formatStartCase(newValue.text),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }

  String _formatStartCase(String text) {
    if (text.isEmpty) return text;

    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    return words.join(' ');
  }
}

class SentenceCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: _formatSentenceCase(newValue.text),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }

  String _formatSentenceCase(String text) {
    if (text.isEmpty) return text;

    // Split the text by periods (.) to identify sentences
    List<String> sentences = text.split('. ');

    // Capitalize the first letter of each sentence
    for (int i = 0; i < sentences.length; i++) {
      if (sentences[i].isNotEmpty) {
        sentences[i] = sentences[i][0].toUpperCase() + sentences[i].substring(1).toLowerCase();
      }
    }

    // Join the sentences back into a single string
    return sentences.join('. ');
  }
}

class NumbersOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    RegExp reg = RegExp(r'^[0-9]+$');
    if (reg.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}

class NumberOrDecimalNumberFormatter extends TextInputFormatter {
  int decimalPoints;

  NumberOrDecimalNumberFormatter({this.decimalPoints = 3});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.trim();
    TextSelection selection = newValue.selection;

    if (newText == '.') {
      newText = '0$newText';
      selection = TextSelection(baseOffset: newText.length, extentOffset: newText.length);
    }
    newValue = newValue.copyWith(text: newText, selection: selection);
    if (newText.isEmpty) return newValue;

    num? number = num.tryParse(newText);

    if (number == null) return oldValue;

    if (newText.contains('.')) {
      String decimalString = newText.split('.').last;
      if (decimalString.length > decimalPoints) return oldValue;
    }

    return newValue;
  }
}
