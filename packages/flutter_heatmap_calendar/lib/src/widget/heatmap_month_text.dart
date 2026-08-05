import 'package:flutter/material.dart';
import '../util/date_util.dart';

class HeatMapMonthText extends StatelessWidget {
  /// List value of every sunday's month information.
  ///
  /// From 1: January to 12: December.
  final List<int>? firstDayInfos;

  /// The double value for space between labels.
  final double? size;

  /// The double value of font size.
  final double? fontSize;

  /// The color value of font color.
  final Color? fontColor;

  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  ///locale for text
  final Locale? locale;

  const HeatMapMonthText(
      {Key? key,
      this.firstDayInfos,
      this.fontSize,
      this.fontColor,
      this.size,
      this.margin,
      this.locale})
      : super(key: key);

  /// The list of every month labels and fitted space.
  List<Widget> _labels() {
    List<Widget> items = [];
    bool _write = false;

    for (int label = 0; label < (firstDayInfos?.length ?? 0); label++) {
      if (label == 0 ||
          (label > 0 && firstDayInfos![label] != firstDayInfos![label - 1])) {
        _write = true;

        // Вычисляем, сколько недель осталось до конца календаря для этого месяца
        int remainingWeeks = 1;
        int scanLabel = label + 1;
        while (scanLabel < firstDayInfos!.length && firstDayInfos![scanLabel] == firstDayInfos![label]) {
          remainingWeeks++;
          scanLabel++;
        }

        // Если это последний месяц и до конца календаря осталась всего 1 неделя,
        // мы берем множитель 1, вместо стандартного 2. Это уберет лишний пустой хвост справа!
        int widthMultiplier = remainingWeeks < 2 ? remainingWeeks : 2;

        items.add(
          firstDayInfos!.length == 1 ||
              (label == 0 &&
                  firstDayInfos![label] != firstDayInfos![label + 1])
              ? ExcludeSemantics(
              child: _renderText(DateUtil.SHORT_MONTH_LABEL[
              locale?.languageCode ?? 'en']![firstDayInfos![label]]))
              : Container(
            // ИСПОЛЬЗУЕМ ДИНАМИЧЕСКИЙ МНОЖИТЕЛЬ widthMultiplier ВМЕСТО ХАРДКОДНОГО * 2
            width: (((size ?? 20) + (margin?.right ?? 2)) * widthMultiplier),
            margin: EdgeInsets.only(
                left: margin?.left ?? 2, right: margin?.right ?? 2),
            child: ExcludeSemantics(
              child: _renderText(DateUtil.SHORT_MONTH_LABEL[
              locale?.languageCode ?? 'en']![firstDayInfos![label]]),
            ),
          ),
        );
      } else if (_write) {
        _write = false;
      } else {
        items.add(Container(
          margin: EdgeInsets.only(
              left: margin?.left ?? 2, right: margin?.right ?? 2),
          width: size ?? 20,
        ));
      }
    }

    return items;
  }


  Widget _renderText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels(),
    );
  }
}
