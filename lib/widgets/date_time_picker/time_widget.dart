import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';
import 'package:intl/intl.dart';

class CustomTimeWidget extends StatefulWidget {
  final DateTime initialTime;
  final Function(DateTime) onTimeChange;

  const CustomTimeWidget({required this.initialTime, required this.onTimeChange, super.key});

  @override
  State<CustomTimeWidget> createState() => _CustomTimeWidgetState();
}

class _CustomTimeWidgetState extends State<CustomTimeWidget> {
  late DateTime selectedDateTime;
  final format = DateFormat('hh:mm:ss a');

  @override
  void initState() {
    selectedDateTime = widget.initialTime;
    super.initState();
  }

  String _amPmText() {
    return format.format(selectedDateTime).split(' ').last == 'AM' ? 'AM' : 'PM';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SizedBox(
            height: 240,
            child: AnalogClock(
              dateTime: selectedDateTime,
              isKeepTime: false,
              key: Key(selectedDateTime.toIso8601String()),
              dialColor: Tm.color(Tc.comBg),
              hourHandColor: Tm.color(Tc.tabDefTxt),
              markingColor: Tm.color(Tc.tabDefTxt),
              centerPointColor: Tm.color(Tc.redDef),
              secondHandColor: Tm.color(Tc.redDef),
              minuteHandColor: Tm.color(Tc.grnDef),
              hourNumberColor: Tm.color(Tc.tabDefTxt),
              child: Align(
                alignment: const FractionalOffset(0.5, 0.75),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _amPmText(),
                    style: TsDefined.ts14W400(color: Tm.color(Tc.tabDefTxt)),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        _TileList(
          values: _hours.map((e) => e.toString()).toList(),
          initialValue: DateFormat('h:mm a').format(widget.initialTime).split(':').first,
          title: 'Hour',
          onChange: (p0) => _updateTime(hour: int.tryParse(p0)),
        ),
        const _Colon(),
        _TileList(
          values: _minutes.map((e) => e.toString()).toList(),
          initialValue: widget.initialTime.minute.toString(),
          title: 'Min',
          onChange: (p0) => _updateTime(minute: int.tryParse(p0)),
        ),
        const _Colon(),
        _TileList(
          values: _minutes.map((e) => e.toString()).toList(),
          initialValue: widget.initialTime.second.toString(),
          title: 'Sec',
          onChange: (p0) => _updateTime(seconds: int.tryParse(p0)),
        ),
        const _Colon(),
        _TileList(
          values: _amPm,
          initialValue: _amPmText(),
          title: 'Period',
          showColon: false,
          onChange: (p0) => _updateTime(amPm: p0),
        ),
      ],
    );
  }

  void _updateTime({int? hour, int? minute, int? seconds, String? amPm}) {
    String dateString = format.format(selectedDateTime);

    String period = dateString.split(' ').last;
    dateString = dateString.replaceAll(period, '');
    String parsedHour = (hour?.toString()) ?? dateString.split(':').first;
    String parsedMinute = (minute?.toString()) ?? dateString.split(':')[1];
    String parsedSecond = (seconds?.toString()) ?? dateString.split(':')[2].trim();

    String dateTimeString = '$parsedHour:$parsedMinute:$parsedSecond ${amPm ?? period}';

    DateTime parsedDate;
    try {
      parsedDate = format.parse(dateTimeString);
      selectedDateTime = DateTime(
        widget.initialTime.year,
        widget.initialTime.month,
        widget.initialTime.day,
        parsedDate.hour,
        parsedDate.minute,
        parsedDate.second,
      );
      setState(() {});
      widget.onTimeChange(selectedDateTime);
    } catch (e) {
      //
    }
  }

  final List<int> _hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final List<int> _minutes = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
  ];
  final List<String> _amPm = ['AM', 'PM'];
}

class _TileList extends StatefulWidget {
  final List<String> values;
  final String initialValue;
  final String? title;
  final bool showColon;
  final Function(String) onChange;

  const _TileList({
    required this.values,
    required this.initialValue,
    this.title,
    this.showColon = true,
    required this.onChange,
  });

  @override
  State<_TileList> createState() => _TileListState();
}

class _TileListState extends State<_TileList> {
  late PageController _controller;

  int currentPage = 0;
  bool pressing = false;

  @override
  void initState() {
    int index = widget.values.indexOf(widget.initialValue);
    if (index != -1) currentPage = index;

    _controller = PageController(initialPage: index);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) _Title(text: widget.title!),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            alignment: Alignment.center,
            height: 240,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Icon(
                  icon: Assets.icons.arrowTop,
                  onTap: () => _move(AxisDirection.up),
                  onLongTapping: () => _move(AxisDirection.up, _durationShort),
                  disable: currentPage == 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border.all(color: Tm.color(Tc.tabDefTxt), width: 4),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: PageView.builder(
                      itemCount: widget.values.length,
                      scrollDirection: Axis.vertical,
                      controller: _controller,
                      onPageChanged: (a) => {setState(() => currentPage = a), widget.onChange(widget.values[a])},
                      itemBuilder: (context, index) => Center(
                        child: Text(
                          widget.values[index].toString().padLeft(2, '0'),
                          style: TsDefined.ts26W600(
                            color: Tm.color(Tc.priDef),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _Icon(
                  icon: Assets.icons.arrowDown,
                  onTap: () => _move(AxisDirection.down),
                  onLongTapping: () => _move(AxisDirection.down, _durationShort),
                  disable: currentPage == widget.values.length - 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _move(AxisDirection direction, [Duration? duration]) async {
    if (direction == AxisDirection.up) {
      await _controller.previousPage(duration: duration ?? _duration, curve: Curves.easeIn);
    } else {
      await _controller.nextPage(duration: duration ?? _duration, curve: Curves.easeIn);
    }
  }

  final _duration = const Duration(milliseconds: 250);
  final _durationShort = const Duration(milliseconds: 100);
}

class _Icon extends StatelessWidget {
  final String icon;
  final Function() onTap;
  final Function() onLongTapping;
  final bool disable;

  const _Icon({required this.icon, required this.onTap, required this.onLongTapping, required this.disable});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: disable ? null : onTap,
      shape: BoxShape.circle,
      onLongTapping: () async => await onLongTapping(),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Tm.color(Tc.iconContainerFillPurple)),
        child: Container(
          width: 62,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: SvgImage(
            icon,
            color: disable
                ? Tm.colorSeparate(PC.colorPrimary500, PC.colorPrimary50).withValues(alpha: 0.3)
                : Tm.colorSeparate(PC.colorPrimary500, PC.colorPrimary50),
            height: 10,
          ),
        ),
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      alignment: Alignment.center,
      child: Text(':', style: TsDefined.ts26W600(color: Tm.color(Tc.priDef))),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        text,
        style: TsDefined.ts20W600(color: Tm.color(Tc.tabDefTxt)),
      ),
    );
  }
}
