
import 'package:invently/assortment/extensions/text_formatters.dart';
import 'package:invently/utils/common_functions.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? title;
  final String? hint;
  final String? error;
  final List<TextInputFormatter>? inputFormatters;
  final bool removeAllProps;
  final bool readOnly;
  final Function(String?)? onChange;

  const PriceTextField({
    super.key,
    required this.controller,
    required this.title,
    this.hint,
    required this.error,
    this.inputFormatters,
    this.onChange,
    this.removeAllProps = true,
    this.readOnly = false,
  });

  @override
  State<PriceTextField> createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  late FocusNode fNode;

  @override
  void initState() {
    fNode = FocusNode();
    fNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    fNode.dispose();
    super.dispose();
  }

  void _focusListener() {
    CommonFunctions.removeTextSelection(widget.controller);

    double? typedPrice;

    try {
      typedPrice = double.tryParse(widget.controller.text.trim());
    } catch (_) {}

    if (!fNode.hasFocus) {
      if (typedPrice == null) return;
      widget.controller.text = typedPrice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWithTitle(
      title: widget.title,
      controller: widget.controller,
      error: widget.error,
      onChanged: widget.onChange,
      inputFormatters: widget.inputFormatters ?? [NumberOrDecimalNumberFormatter()],
      hint: widget.hint,
      prefixText: StaticValues.currencySymbol(''),
      removeAllProps: widget.removeAllProps,
      showError: true,readOnly: widget.readOnly,
      focusNode: fNode,
    );
  }
}
