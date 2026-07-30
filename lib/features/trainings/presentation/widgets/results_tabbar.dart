import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ResultsTabBar extends StatelessWidget {
  final List<String> tabs;
  final PageController pageController;
  final int selectedIndex;
  final List<Color> dotColors;

  const ResultsTabBar({
    super.key,
    required this.tabs,
    required this.pageController,
    required this.selectedIndex,
    required this.dotColors,
  }) : assert(tabs.length == dotColors.length, 'The number of tabs and colors must match');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color:Color(0xFFE8D7C8) ,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            flex: isSelected ? 3 : 1,
            child: GestureDetector(
              onTap: () {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(
                      0xFFD9C3AC) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Center(
                        child: isSelected ? AutoSizeText(
                          maxLines: 2,
                          minFontSize: 12,
                          stepGranularity: 0.5,
                          overflow: TextOverflow.ellipsis,
                          tabs[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 0,
                            color: Colors.black,
                          ),
                        ) : Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: dotColors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
