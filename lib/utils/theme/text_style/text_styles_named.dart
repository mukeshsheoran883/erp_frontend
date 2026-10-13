
part of 'text_styles.dart';

abstract class Ts {
  static String _defaultFontFamily() => FontFamily.rubik.value;
  static Color _defaultColor() => Tm.color(Tc.ipfTitle);
  static double _height() => 1.5;

  static TextStyle smLight({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle smRegular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle smMedium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle smSemibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle smBold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle mdLight({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle mdRegular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle mdMedium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle mdSemibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle mdBold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle rgLight({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle rgSemiRegular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle rgRegular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle rgMedium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle rgSemibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle rgBold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle lgLight({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle lgRegular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle lgMedium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle lgSemibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle lgBold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xlLight({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xlRegular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xlMedium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xlSemibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xlBold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl2Light({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl2Regular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl2Medium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl2Semibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl2Bold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl3Light({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 28,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl3Regular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl3Medium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl3Semibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl3Bold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl4Light({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl4Regular({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl4Medium({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl4Semibold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );

  static TextStyle xl4Bold({Color? color, FontStyle? fontStyle, FontFamily? family}) => GoogleFonts.getFont(
        family?.value ?? _defaultFontFamily(),
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color ?? _defaultColor(),
        height: _height(),
        fontStyle: fontStyle,
      );
}
