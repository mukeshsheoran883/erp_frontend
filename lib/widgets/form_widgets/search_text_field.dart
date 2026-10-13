
import 'package:invently/assortment/extensions/text_editing_controller_extensions.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/utils/custom_timer.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final Duration debounceDuration;
  final Function(String)? onTextSubmit;
  final Function(CommonKeyValueModel) onSearchResultTap;
  final Future<SearchResponseModel> Function(String)? onSearch;
  final bool removeAllProps;
  final String? hint;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onTextSubmit,
    required this.onSearch,
    required this.onSearchResultTap,
    this.width = 279 + 48,
    this.debounceDuration = const Duration(milliseconds: 700),
    this.removeAllProps = false,
    this.hint,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late CustomTimer timer;
  String previousText = '';
  late FocusNode node;

  SearchDropParam? params;
  late ValueNotifier<SearchResponseModel> searchResponse;

  @override
  void initState() {
    searchResponse = ValueNotifier(
      SearchResponseModel(searchResultsFor: '', status: Status.loading, error: '', items: []),
    );
    node = FocusNode();
    timer = CustomTimer(widget.debounceDuration);
    timer.start();
    timer.onTimeout((a) {
      _checkTextChanged();
      timer.reset();
      timer.start();
    });
    widget.controller.addListener(_textListener);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    node.dispose();
    super.dispose();
  }

  void _textListener() {
    timer.reset();
    timer.start();
    if (mounted) setState(() {});
  }

  Future<void> _checkTextChanged() async {
    final newText = widget.controller.trimmedText();
    if ((previousText == newText || widget.onSearch == null) && searchResponse.value.searchResultsFor == newText) {
      return;
    }

    if (newText.isEmpty) return;

    previousText = newText;
    final response = await widget.onSearch!.call(newText);
    searchResponse.value = response;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ApiSearchDropDown(
      onOutSideTap: _clear,
      searchResult: searchResponse,
      onSearchResultTap: (a) {
        _clear();
        widget.onSearchResultTap(a);
      },
      builder: (param) {
        params = param;

        return SizedBox(
          width: widget.width,
          child: Row(
            children: [
              Flexible(
                child: Focus(
                  focusNode: node,
                  onKeyEvent: (a, event) {
                    if (event.physicalKey == PhysicalKeyboardKey.enter) _submit();

                    return KeyEventResult.ignored;
                  },
                  child: TextFieldWithTitle(
                    title: null,
                    key: param.isOpen ? null : param.sizeKey,
                    focusNode: param.isOpen ? param.node : null,
                    hint: widget.hint ?? 'Search',
                    onChanged: (a) async {
                      if (a.trim().isEmpty) {
                        _clear();
                      } else {
                        if (previousText != a.trim()) {
                          searchResponse.value =
                              SearchResponseModel(items: [], error: '', status: Status.loading, searchResultsFor: a);
                        }
                        param.openDropDown();
                      }
                    },
                    prefixIcon: widget.removeAllProps
                        ? null
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: SvgImage(Assets.icons.lens, color: Tm.color(Tc.ipfTxt), width: 16, height: 16),
                          ),
                    suffixIcon: (widget.onTextSubmit == null || widget.controller.trimmedText().isEmpty)
                        ? null
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: HoverGD(
                              onTap: _clear,
                              builder: (context, bState) {
                                return SvgImage(
                                  Assets.icons.close,
                                  height: 16,
                                  color: Tm.color(bState.isHovering ? Tc.closeRed : Tc.tabDefTxt),
                                );
                              },
                            ),
                          ),
                    controller: widget.controller,
                    removeAllProps: true,
                  ),
                ),
              ),
              if (!widget.removeAllProps)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SquareIconButton(
                    model: SquareIconButtonModel(
                      onTap: (widget.onTextSubmit == null || _text().isEmpty) ? null : _submit,
                      buttonIcon: Assets.icons.lensResults,
                      tooltip: 'Search',
                      iconSize: 22,
                      buttonBgColor: Tm.color(Tc.priDefLight),
                      iconColor: (widget.onTextSubmit == null || _text().isEmpty)
                          ? Tm.color(Tc.priIconLight).withValues(alpha: 0.5)
                          : Tm.color(Tc.priIconLight),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _clear() {
    widget.onTextSubmit?.call('');
    widget.controller.clear();
    params?.closeDropDown();
    previousText = '';
    searchResponse.value = SearchResponseModel(items: [], error: '', status: Status.none, searchResultsFor: '');
  }

  void _submit() {
    widget.onTextSubmit?.call(_text());
    params?.closeDropDown();
    searchResponse.value = SearchResponseModel(items: [], error: '', status: Status.none, searchResultsFor: '');
    previousText = '';
  }

  String _text() => widget.controller.trimmedText();
}
