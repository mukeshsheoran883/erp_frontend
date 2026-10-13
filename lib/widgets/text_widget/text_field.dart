
import 'package:invently/utils/common_functions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithTitle extends StatefulWidget {
  final String? title;
  final String? error;
  final TextEditingController controller;
  final bool required;
  final int maxLen;
  final int maxLenTextArea;
  final int maxLines;
  final String? hint;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Color? borderColor;
  final Color? fillColor;
  final double borderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? suffixText;
  final bool autoFocus;
  final bool obfuscate;
  final EdgeInsets errorPadding;
  final bool removeAllProps;
  final bool? enableSelection;
  final double paddingContent;
  final FocusNode? focusNode;
  final bool? showError;
  const TextFieldWithTitle({
    super.key,
    required this.title,
    required this.controller,
    this.required = false,
    this.maxLen = 100,
    this.maxLenTextArea = 350,
    this.error,
    this.hint,
    this.readOnly = false,
    this.autoFocus = false,
    this.inputFormatters = const [],
    this.onChanged,
    this.borderColor,
    this.borderRadius = 12,
    this.fillColor,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.obfuscate = false,
    this.removeAllProps = false,
    this.enableSelection,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
    this.paddingContent = 14.5,
    this.focusNode,
    this.prefixText,
    this.suffixText,
    this.showError,
  });

  @override
  State<TextFieldWithTitle> createState() => _TextFieldWithTitleState();
}

class _TextFieldWithTitleState extends State<TextFieldWithTitle> {
  late FocusNode independentFn;

  @override
  void initState() {
    independentFn = FocusNode();
    if (widget.focusNode == null) {
      independentFn.addListener(() => CommonFunctions.removeTextSelection(widget.controller));
    }
    super.initState();
  }

  @override
  void dispose() {
    independentFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && !widget.removeAllProps)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text.rich(
              TextSpan(
                text: widget.title,
                style: Ts.lgRegular(color: Tm.color(Tc.ipfTitle)),
                children:
                    widget.required ? [TextSpan(text: ' *', style: Ts.lgRegular(color: Tm.color(Tc.redDef)))] : [],
              ),
            ),
          ),
        TextField(
          controller: widget.controller,
          maxLength: widget.maxLines > 1 ? widget.maxLenTextArea : widget.maxLen,
          onTap: widget.onTap,
          obscureText: widget.obfuscate,
          maxLines: widget.maxLines,
          autofocus: widget.autoFocus,
          enableInteractiveSelection: widget.enableSelection,
          readOnly: widget.onTap != null || widget.readOnly,
          mouseCursor: widget.onTap == null ? null : SystemMouseCursors.click,
          style: Ts.lgRegular(color: Tm.color(Tc.ipfTxt)),
          focusNode: widget.focusNode ?? independentFn,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: Ts.lgRegular(color: Tm.color(Tc.ipfHint)),
            counterText: '',
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: widget.maxLines > 1 ? 20 : widget.paddingContent),
            isDense: true,
            fillColor: widget.fillColor ?? Tm.color(Tc.ipfDef),
            focusedBorder: _border(context),
            errorBorder: _border(context),
            enabledBorder: _border(context),
            disabledBorder: _border(context),
            focusedErrorBorder: _border(context),
            border: _border(context),
            filled: true,
            hoverColor: Colors.transparent,
            prefixIcon: widget.prefixText != null ? _PrefixSuffixText(text: widget.prefixText!) : widget.prefixIcon,
            suffixIcon: widget.suffixText != null
                ? _PrefixSuffixText(text: widget.suffixText!, left: false)
                : widget.suffixIcon,
            prefixStyle: Ts.lgRegular(color: Tm.color(Tc.ipfTxt)),
          ),
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
        ),
        if (!widget.removeAllProps || (widget.showError ?? !widget.removeAllProps))
          Padding(
            padding: widget.errorPadding,
            child: Text(widget.error ?? '', style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef))),
          ),
      ],
    );
  }

  OutlineInputBorder _border(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 1.5, color: widget.borderColor ?? Tm.color(Tc.ipfDef)),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    );
  }
}

class _PrefixSuffixText extends StatelessWidget {
  final String text;
  final bool left;

  const _PrefixSuffixText({required this.text, this.left = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(left: left ? 4 : 0, right: left ? 0 : 4),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Ts.lgRegular(color: Tm.color(Tc.ipfTxt)),
          ),
        ),
      ),
    );
  }
}
