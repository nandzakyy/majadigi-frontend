import 'package:flutter/material.dart';

class CustomTabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CustomTabSelector({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final active = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(
              right: index == tabs.length - 1 ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFE8F2FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    color: active ? const Color(0xFF0D6EFD) : Colors.black87,
                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                  child: Text(tabs[index]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
