import 'package:invently/models/printer/printer_template_model.dart';
import 'package:flutter/material.dart';

class PrinterTemplateProvider extends ChangeNotifier {
  PrinterTemplateModel? currentTemplate;
  TemplateStyleModel currentStyle = const TemplateStyleModel();

  // Template content
  String headerText = '';
  String contentText = '';
  String footerText = '';

  // Dropdown values
  String selectedUserType = 'Customer';
  String selectedPaperSize = 'A4';

  final List<String> userTypes = ['Customer', 'Supplier', 'Employee'];
  final List<String> paperSizes = ['A4', 'A5', 'Letter', 'Legal'];

  // Style methods
  void updateStyle({
    double? fontSize,
    String? fontFamily,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    TextAlignment? alignment,
    double? lineHeight,
    double? letterSpacing,
  }) {
    currentStyle = currentStyle.copyWith(
      fontSize: fontSize,
      fontFamily: fontFamily,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      alignment: alignment,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing,
    );
    notifyListeners();
  }

  void updateUserType(String type) {
    selectedUserType = type;
    notifyListeners();
  }

  void updatePaperSize(String size) {
    selectedPaperSize = size;
    notifyListeners();
  }

  void updateHeaderText(String text) {
    if (text.isEmpty) return;
    headerText = text;
    notifyListeners();
  }

  void clearProvider() {
    currentTemplate = null;
    currentStyle = const TemplateStyleModel();
    headerText = '';
    contentText = '';
    footerText = '';
    notifyListeners();
  }

  // Save/Load methods
  Future<void> saveTemplate() async {
    // API call to save template
    notifyListeners();
  }

  Future<void> loadTemplate(String id) async {
    // API call to load template
    notifyListeners();
  }
}
