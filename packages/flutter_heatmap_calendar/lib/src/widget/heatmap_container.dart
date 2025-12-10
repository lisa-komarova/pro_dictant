import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../data/heatmap_color.dart';
import 'package:intl/intl.dart';
import 'package:pro_dictant/core/s.dart';

class HeatMapContainer extends StatelessWidget {
  final DateTime date;
  final double? size;
  final double? fontSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final bool? showText;
  final Function(DateTime dateTime)? onClick;
  final bool isFilled;
  final int? index;

  const HeatMapContainer({
    Key? key,
    required this.date,
    this.margin,
    this.size,
    this.fontSize,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.onClick,
    this.showText,
    this.index,
    required this.isFilled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(2),
      child: Semantics(
        sortKey: index != null ? OrdinalSortKey(index!.toDouble()) : null,
        label: formatDate(date, context) +
            " " +
            (isFilled
                ? S.of(context).goalCompleted
                : S.of(context).goalUncompleted),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? HeatMapColor.defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutQuad,
            width: size,
            height: size,
            alignment: Alignment.center,
            child: (showText ?? true)
                ? Text(
                    date.day.toString(),
                    style: TextStyle(
                        color: textColor ?? const Color(0xFF8A8A8A),
                        fontSize: fontSize),
                    semanticsLabel: "",
                  )
                : null,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 5)),
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date, BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return DateFormat('d MMMM', locale.languageCode).format(date);
  }
}
