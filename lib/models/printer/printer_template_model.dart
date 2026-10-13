class PrinterTemplateModel {
  final String id;
  final String name;
  final String userType;
  final String paperSize;
  final TemplateStyleModel style;
  final String headerText;
  final String contentText;
  final String footerText;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrinterTemplateModel({
    required this.id,
    required this.name,
    required this.userType,
    required this.paperSize,
    required this.style,
    required this.headerText,
    required this.contentText,
    required this.footerText,
    required this.createdAt,
    required this.updatedAt,
  });
}

class TemplateStyleModel {
  final double fontSize;
  final String fontFamily;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final TextAlignment alignment;
  final double lineHeight;
  final double letterSpacing;

  const TemplateStyleModel({
    this.fontSize = 14,
    this.fontFamily = 'Arial',
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.alignment = TextAlignment.left,
    this.lineHeight = 1.5,
    this.letterSpacing = 0,
  });

  TemplateStyleModel copyWith({
    double? fontSize,
    String? fontFamily,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    TextAlignment? alignment,
    double? lineHeight,
    double? letterSpacing,
  }) {
    return TemplateStyleModel(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      alignment: alignment ?? this.alignment,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }
}

enum TextAlignment { left, center, right, justify }
